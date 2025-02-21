#!/usr/bin/env python3
import sys
import argparse

def encode_literal(lit, num_vars):
    """
    Encode a literal as a 12-bit value:
      - Bit 11 (MSB) is the sign: 1 for positive, 0 for negative.
      - Bits [10:0] hold the variable number.
    Assumes num_vars <= 2047.
    """
    var = abs(lit)
    sign = 1 if lit > 0 else 0
    if var > 0x7FF:
        raise ValueError("Variable number exceeds 11 bits")
    return (sign << 11) | var

def complement(lit):
    """Return the complement of literal lit."""
    return -lit

def at_index(lit):
    """
    Map a literal to an index in the address table.
    For each variable, we have two entries:
       index = (var-1)*2 for positive literal,
       index = (var-1)*2 + 1 for negative literal.
    """
    var = abs(lit)
    return (var - 1) * 2 if lit > 0 else (var - 1) * 2 + 1

# --- CNF Parsing and 3-SAT Conversion ---

def parse_cnf(filename):
    """
    Parse a DIMACS CNF file.
    Returns (num_vars, clauses)
      - num_vars: number of variables (int)
      - clauses: list of lists, each clause is a list of integers.
    Ignores lines starting with "c" or "%" and tokens that are not numbers.
    """
    clauses = []
    num_vars = None
    with open(filename, 'r') as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("c") or line.startswith("%"):
                continue
            if line.startswith("p"):
                parts = line.split()
                if len(parts) < 4:
                    raise ValueError("Invalid problem line in CNF file")
                num_vars = int(parts[2])
            else:
                parts = line.split()
                tokens = []
                for x in parts:
                    try:
                        tokens.append(int(x))
                    except ValueError:
                        continue
                clause = [lit for lit in tokens if lit != 0]
                if clause:
                    clauses.append(clause)
    if num_vars is None:
        raise ValueError("CNF file missing problem line")
    return num_vars, clauses

def convert_to_3sat(clauses, num_vars):
    """
    Convert any CNF (list of clauses) to an equivalent 3-SAT CNF.
    For clauses with:
      - 1 literal: duplicate it twice.
      - 2 literals: duplicate one literal.
      - 3 literals: leave it unchanged.
      - >3 literals: use standard transformation introducing new variables.
    Returns (new_clauses, new_num_vars)
    """
    new_clauses = []
    next_new_var = num_vars + 1

    for clause in clauses:
        k = len(clause)
        if k == 0:
            continue  # skip empty clauses
        elif k == 1:
            new_clauses.append([clause[0], clause[0], clause[0]])
        elif k == 2:
            new_clauses.append([clause[0], clause[1], clause[1]])
        elif k == 3:
            new_clauses.append(clause)
        else:
            # For clause [l1, l2, l3, ..., lk], introduce new variables y1...y_{k-3}
            y_vars = []
            num_new = k - 3
            for i in range(num_new):
                y_vars.append(next_new_var)
                next_new_var += 1
            new_clauses.append([clause[0], clause[1], y_vars[0]])
            for i in range(1, num_new):
                new_clauses.append([-y_vars[i-1], clause[i+1], y_vars[i]])
            new_clauses.append([-y_vars[-1], clause[-2], clause[-1]])
    new_num_vars = next_new_var - 1
    return new_clauses, new_num_vars

# --- Main conversion function ---
def convert_cnf_to_mem(cnf_file, at_mem_file, ct_mem_file, at_mem_depth=4096, ct_mem_depth=None):
    orig_num_vars, orig_clauses = parse_cnf(cnf_file)
    clauses_3sat, num_vars = convert_to_3sat(orig_clauses, orig_num_vars)
    print("Converted CNF: original variables = %d, new total variables = %d" % (orig_num_vars, num_vars))
    print("Number of 3-SAT clauses: %d" % len(clauses_3sat))
    
    # The number of valid literal entries is 2*num_vars.
    valid_literal_count = 2 * num_vars
    if ct_mem_depth is None:
        ct_mem_depth = valid_literal_count  # default for CT mem file
    
    FIXED_SLOTS = 20

    # Build candidate lists for valid literal indices.
    candidate_dict = { i: [] for i in range(valid_literal_count) }
    for clause in clauses_3sat:
        if len(clause) != 3:
            raise ValueError("Clause does not have 3 literals: %s" % clause)
        for i in range(3):
            lit = clause[i]
            comp = complement(lit)
            other_literals = [clause[j] for j in range(3) if j != i]
            encoded1 = encode_literal(other_literals[0], num_vars)
            encoded2 = encode_literal(other_literals[1], num_vars)
            candidate_word = (encoded1 << 12) | encoded2  # 24-bit word
            idx = at_index(comp)
            if idx < valid_literal_count:
                candidate_dict[idx].append(candidate_word)
            # If idx is outside valid range, ignore.
    
    # Build AT and CT entries over the full memory depths.
    at_entries = []
    ct_entries = []
    current_ct_addr = 0
    for literal_index in range(at_mem_depth):
        if literal_index < valid_literal_count:
            candidates = candidate_dict[literal_index]
            count = len(candidates)
            if count > FIXED_SLOTS:
                print("Warning: literal index %d has %d candidate entries (truncating to %d)" %
                      (literal_index, count, FIXED_SLOTS))
                candidates = candidates[:FIXED_SLOTS]
                count = FIXED_SLOTS
            mask = (1 << count) - 1  # lower 'count' bits set
            at_entry = (current_ct_addr << 20) | mask
            at_entries.append(at_entry)
            # Pack FIXED_SLOTS candidate entries into one 480-bit word.
            packed = 0
            for slot in range(FIXED_SLOTS):
                if slot < count:
                    candidate = candidates[slot] & 0xFFFFFF
                else:
                    candidate = 0
                shift = 24 * (FIXED_SLOTS - slot - 1)
                packed |= (candidate << shift)
            # Only add a CT entry if within the desired CT mem depth.
            if literal_index < ct_mem_depth:
                ct_entries.append(packed)
            current_ct_addr += FIXED_SLOTS
        else:
            # For indices beyond valid_literal_count, output 0.
            at_entries.append(0)
            if literal_index < ct_mem_depth:
                ct_entries.append(0)
    # Write the AT mem file: exactly at_mem_depth lines (each a 32-bit word)
    with open(at_mem_file, 'w') as f_at:
        for entry in at_entries:
            f_at.write("{:08X}\n".format(entry))
    print("Wrote AT mem file with %d entries to %s" % (len(at_entries), at_mem_file))
    # Write the CT mem file: exactly ct_mem_depth lines (each a 480-bit word = 120 hex digits)
    with open(ct_mem_file, 'w') as f_ct:
        for entry in ct_entries:
            f_ct.write("{:0{width}X}\n".format(entry, width=120))
    print("Wrote CT mem file with %d entries to %s" % (len(ct_entries), ct_mem_file))

def main():
    parser = argparse.ArgumentParser(description="Convert any CNF file to mem files for ATT and CT, converting to 3-SAT if needed.")
    parser.add_argument("cnf", help="Input CNF file in DIMACS format.")
    parser.add_argument("--at", default="my_at.mem", help="Output mem file for the Address Translation Table.")
    parser.add_argument("--ct", default="my_ct.mem", help="Output mem file for the Clause Table.")
    parser.add_argument("--at_depth", type=int, default=4096, help="Total number of AT entries (default: 4096).")
    parser.add_argument("--ct_depth", type=int, default=None, help="Total number of CT entries (default: 2*num_vars).")
    args = parser.parse_args()
    convert_cnf_to_mem(args.cnf, args.at, args.ct, at_mem_depth=args.at_depth, ct_mem_depth=args.ct_depth)

if __name__ == '__main__':
    main()
