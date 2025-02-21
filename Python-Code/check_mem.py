#!/usr/bin/env python3
import sys
import argparse

def decode_literal(encoded):
    """
    Decode a 12-bit encoded literal.
    Returns the integer literal.
    """
    sign = (encoded >> 11) & 1
    var = encoded & 0x7FF
    return var if sign == 1 else -var

def at_index(lit):
    """
    Map a literal to an index in the address table.
    """
    var = abs(lit)
    return (var - 1) * 2 if lit > 0 else (var - 1) * 2 + 1

def parse_cnf(filename):
    """
    Parse a DIMACS CNF file.
    Returns (num_vars, clauses)
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
    new_clauses = []
    next_new_var = num_vars + 1
    for clause in clauses:
        k = len(clause)
        if k == 0:
            continue
        elif k == 1:
            new_clauses.append([clause[0], clause[0], clause[0]])
        elif k == 2:
            new_clauses.append([clause[0], clause[1], clause[1]])
        elif k == 3:
            new_clauses.append(clause)
        else:
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

def canonical_clause(clause):
    return tuple(sorted(clause))

def read_mem_file(filename):
    entries = []
    with open(filename, 'r') as f:
        for line in f:
            line = line.strip()
            if line:
                entries.append(int(line, 16))
    return entries

def reconstruct_clauses(at_entries, ct_entries, fixed_slots=20, valid_count=None):
    # valid_count: number of valid literal indices (2*num_vars)
    reconstructed = []
    # We'll reconstruct for indices from 0 up to valid_count.
    if valid_count is None:
        valid_count = len(at_entries)
    for literal_index in range(valid_count):
        at_entry = at_entries[literal_index]
        start_addr = at_entry >> 20
        mask = at_entry & ((1 << 20) - 1)
        count = mask.bit_length() if mask != 0 else 0
        # For the CT mem file, we assume that the row number is the same as literal_index
        candidate_block = ct_entries[literal_index]
        candidates = []
        for slot in range(fixed_slots):
            shift = 24 * (fixed_slots - slot - 1)
            candidate = (candidate_block >> shift) & 0xFFFFFF
            candidates.append(candidate)
        for slot in range(count):
            candidate_word = candidates[slot]
            cand1_enc = candidate_word >> 12
            cand2_enc = candidate_word & 0xFFF
            lit1 = decode_literal(cand1_enc)
            lit2 = decode_literal(cand2_enc)
            # The literal corresponding to literal_index:
            # Use the inverse of at_index: for even index, literal is positive, for odd negative.
            var = (literal_index // 2) + 1
            current_literal = var if (literal_index % 2 == 0) else -var
            clause = [ -current_literal, lit1, lit2 ]
            reconstructed.append(canonical_clause(clause))
    return set(reconstructed)

def check_mem_files(original_cnf, at_mem_file, ct_mem_file):
    orig_num_vars, orig_clauses = parse_cnf(original_cnf)
    clauses_3sat, new_num_vars = convert_to_3sat(orig_clauses, orig_num_vars)
    original_set = set(canonical_clause(clause) for clause in clauses_3sat)
    print("Original 3-SAT CNF has %d unique clauses (from %d total clauses)." %
          (len(original_set), len(clauses_3sat)))
    
    at_entries = read_mem_file(at_mem_file)
    ct_entries = read_mem_file(ct_mem_file)
    print("Read %d AT entries from %s." % (len(at_entries), at_mem_file))
    print("Read %d CT entries from %s." % (len(ct_entries), ct_mem_file))
    
    valid_count = 2 * new_num_vars  # valid literal count
    reconstructed_set = reconstruct_clauses(at_entries, ct_entries, fixed_slots=20, valid_count=valid_count)
    print("Reconstructed %d unique candidate clauses from mem files (for %d valid literals)." %
          (len(reconstructed_set), valid_count))
    
    if original_set == reconstructed_set:
        print("SUCCESS: The reconstructed clauses match the original 3-SAT clauses.")
    else:
        missing = original_set - reconstructed_set
        extra = reconstructed_set - original_set
        if missing:
            print("Missing clauses in reconstruction:")
            for clause in missing:
                print(clause)
        if extra:
            print("Extra clauses reconstructed that are not in the original:")
            for clause in extra:
                print(clause)
        print("FAILURE: The mem file reconstruction does not match the original CNF.")

def main():
    parser = argparse.ArgumentParser(
        description="Reconstruct 3-SAT CNF from ATT and CT mem files and compare with original CNF file."
    )
    parser.add_argument("cnf", help="Original CNF file (DIMACS format).")
    parser.add_argument("--at", default="my_at.mem", help="ATT mem file (default: my_at.mem).")
    parser.add_argument("--ct", default="my_ct.mem", help="CT mem file (default: my_ct.mem).")
    args = parser.parse_args()
    check_mem_files(args.cnf, args.at, args.ct)

if __name__ == '__main__':
    main()
