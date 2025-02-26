#!/usr/bin/env python3
import sys
import argparse
import random

# --- Helper functions for literal encoding and address indexing ---

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

# --- New functions for Variable Table and Unsatisfied Clause Buffer ---

def generate_variable_tables(num_vars, threads):
    """
    Generate a variable table for each thread.
    Each variable is assigned a random 0 or 1 for each thread.
    Returns a dictionary mapping thread number to a list of bits (length = num_vars).
    """
    vt = { t: [] for t in range(threads) }
    for i in range(num_vars):
        for t in range(threads):
            vt[t].append(random.choice([0, 1]))
    return vt

def write_variable_tables(vt_dict, vt_prefix):
    """
    Write each thread's variable table to a separate file.
    Each file contains one line per variable (a single hex digit: 0 or 1).
    The files are named as <vt_prefix>0.mem, <vt_prefix>1.mem, etc.
    """
    for t, vt in vt_dict.items():
        filename = f"{vt_prefix}{t}.mem"
        with open(filename, 'w') as f:
            for bit in vt:
                # Write a single hex digit (0 or 1)
                f.write("{:X}\n".format(bit))
        print(f"Wrote Variable Table for thread {t} with {len(vt)} entries to {filename}")

def generate_unsat_clause_buffer(clauses, vt_dict, num_vars):
    """
    For each thread, evaluate every 3-SAT clause using that thread's variable table.
    A clause is unsatisfied if none of its literals evaluates true.
    Each unsatisfied clause is encoded as a 36-bit word (3 literals × 12 bits).
    Returns a dictionary mapping thread number to a list of 36-bit packed integers.
    """
    unsat_buffers = { t: [] for t in vt_dict.keys() }
    for clause in clauses:
        # For each clause, encode its three literals using our 12-bit encoding.
        enc_literals = [encode_literal(lit, num_vars) for lit in clause]
        # Pack them into one 36-bit word:
        # literal0 in bits [35:24], literal1 in bits [23:12], literal2 in bits [11:0]
        packed_clause = (enc_literals[0] << 24) | (enc_literals[1] << 12) | enc_literals[2]
        for t, vt in vt_dict.items():
            satisfied = False
            for lit in clause:
                var_index = abs(lit) - 1
                val = vt[var_index]  # single bit for this thread
                # For a positive literal, clause is satisfied if bit==1; for negative, if bit==0.
                if (lit > 0 and val == 1) or (lit < 0 and val == 0):
                    satisfied = True
                    break
            if not satisfied:
                unsat_buffers[t].append(packed_clause)
    return unsat_buffers

def write_unsat_clause_buffer(unsat_buffers, uc_mem_file):
    """
    Write the unsatisfied clause buffer to file.
    For simplicity, all threads are written to one file with a header for each thread.
    Each clause is written as a 9-digit hexadecimal number (36 bits).
    """
    with open(uc_mem_file, 'w') as f:
        for t in sorted(unsat_buffers.keys()):
            f.write(f"\n")
            for packed in unsat_buffers[t]:
                f.write("{:09X}\n".format(packed))
    total = sum(len(lst) for lst in unsat_buffers.values())
    print(f"Wrote Unsatisfied Clause Buffer mem file with {total} entries (across {len(unsat_buffers)} threads) to {uc_mem_file}")

# --- Main conversion function ---
# Extended to also generate memory files for the Variable Table (one file per thread)
# and for the Unsatisfied Clause Buffer.
def convert_cnf_to_mem(cnf_file, at_mem_file, ct_mem_file,
                       vt_prefix=None, uc_mem_file=None,
                       at_mem_depth=4096, ct_mem_depth=None, threads=4):
    orig_num_vars, orig_clauses = parse_cnf(cnf_file)
    clauses_3sat, num_vars = convert_to_3sat(orig_clauses, orig_num_vars)
    print(f"Converted CNF: original variables = {orig_num_vars}, new total variables = {num_vars}")
    print(f"Number of 3-SAT clauses: {len(clauses_3sat)}")
    
    # Generate Variable Tables (one per thread) and Unsatisfied Clause Buffer if requested.
    vt_dict = generate_variable_tables(num_vars, threads)
    if vt_prefix:
        write_variable_tables(vt_dict, vt_prefix)
    if uc_mem_file:
        unsat_buffers = generate_unsat_clause_buffer(clauses_3sat, vt_dict, num_vars)
        write_unsat_clause_buffer(unsat_buffers, uc_mem_file)
    
    # --- Build AT and CT memory contents ---
    valid_literal_count = 2 * num_vars
    if ct_mem_depth is None:
        ct_mem_depth = valid_literal_count  # default for CT mem file
    
    FIXED_SLOTS = 20  # Number of candidate entries per literal (should match CLAUSE_COUNT)
    
    # Build candidate lists for each valid literal index.
    candidate_dict = { i: [] for i in range(valid_literal_count) }
    for clause in clauses_3sat:
        if len(clause) != 3:
            raise ValueError(f"Clause does not have 3 literals: {clause}")
        for i in range(3):
            lit = clause[i]
            comp = complement(lit)
            other_literals = [clause[j] for j in range(3) if j != i]
            encoded1 = encode_literal(other_literals[0], num_vars)
            encoded2 = encode_literal(other_literals[1], num_vars)
            candidate_word = (encoded1 << 12) | encoded2  # 24-bit candidate word
            idx = at_index(comp)
            if idx < valid_literal_count:
                candidate_dict[idx].append(candidate_word)
    
    # Build AT and CT entries.
    at_entries = []
    ct_entries = []
    current_ct_addr = 0
    for literal_index in range(at_mem_depth):
        if literal_index < valid_literal_count:
            candidates = candidate_dict[literal_index]
            count = len(candidates)
            if count > FIXED_SLOTS:
                print(f"Warning: literal index {literal_index} has {count} candidate entries (truncating to {FIXED_SLOTS})")
                candidates = candidates[:FIXED_SLOTS]
                count = FIXED_SLOTS
            mask = (1 << count) - 1  # lower 'count' bits set
            # Form AT entry: upper bits hold the current CT address, lower 20 bits the mask.
            at_entry = (current_ct_addr << 20) | mask
            at_entries.append(at_entry)
            # Pack FIXED_SLOTS candidate entries into one 480-bit word.
            packed = 0
            for slot in range(FIXED_SLOTS):
                candidate = candidates[slot] & 0xFFFFFF if slot < count else 0
                shift = 24 * (FIXED_SLOTS - slot - 1)
                packed |= (candidate << shift)
            if literal_index < ct_mem_depth:
                ct_entries.append(packed)
            current_ct_addr += FIXED_SLOTS
        else:
            at_entries.append(0)
            if literal_index < ct_mem_depth:
                ct_entries.append(0)
    
    # Write AT mem file (each entry as an 8-digit hex word = 32 bits).
    with open(at_mem_file, 'w') as f_at:
        for entry in at_entries:
            f_at.write("{:08X}\n".format(entry))
    print(f"Wrote AT mem file with {len(at_entries)} entries to {at_mem_file}")
    
    # Write CT mem file (each entry as a 120-digit hex word = 480 bits).
    with open(ct_mem_file, 'w') as f_ct:
        for entry in ct_entries:
            f_ct.write("{:0{width}X}\n".format(entry, width=120))
    print(f"Wrote CT mem file with {len(ct_entries)} entries to {ct_mem_file}")

def main():
    parser = argparse.ArgumentParser(
        description="Convert a CNF file in DIMACS format to memory files for AT, CT, Variable Table, and Unsatisfied Clause Buffer. Converts to 3-SAT if needed."
    )
    parser.add_argument("cnf", help="Input CNF file in DIMACS format.")
    parser.add_argument("--at", default="my_at.mem", help="Output mem file for the Address Translation Table.")
    parser.add_argument("--ct", default="my_ct.mem", help="Output mem file for the Clause Table.")
    parser.add_argument("--vt_prefix", default="vt", help="Output file prefix for Variable Table(s) (one file per thread).")
    parser.add_argument("--uc", default="my_uc.mem", help="Output mem file for the Unsatisfied Clause Buffer.")
    parser.add_argument("--at_depth", type=int, default=4096, help="Total number of AT entries (default: 4096).")
    parser.add_argument("--ct_depth", type=int, default=None, help="Total number of CT entries (default: 2*num_vars).")
    parser.add_argument("--threads", type=int, default=1, help="Number of threads (default: 1).")
    args = parser.parse_args()
    convert_cnf_to_mem(args.cnf, args.at, args.ct,
                       vt_prefix=args.vt_prefix, uc_mem_file=args.uc,
                       at_mem_depth=args.at_depth, ct_mem_depth=args.ct_depth,
                       threads=args.threads)

if __name__ == '__main__':
    main()
