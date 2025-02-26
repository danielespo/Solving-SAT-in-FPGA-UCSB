#!/usr/bin/env python3
import sys
import argparse

# --- Helper functions for literal encoding and indexing ---

def decode_literal(encoded):
    """
    Decode a 12-bit encoded literal.
    Returns the integer literal.
    """
    sign = (encoded >> 11) & 1
    var = encoded & 0x7FF
    return var if sign == 1 else -var

def encode_literal(lit, num_vars):
    """
    Encode an integer literal into a 12-bit encoded literal.
    Positive literals have the MSB set; negative literals do not.
    """
    value = abs(lit)
    if value > 0x7FF:
        raise ValueError("Literal value exceeds maximum encoding")
    return ((1 << 11) | value) if lit > 0 else value

def at_index(lit):
    """
    Map a literal to an index in the address table.
    """
    var = abs(lit)
    return (var - 1) * 2 if lit > 0 else (var - 1) * 2 + 1

# --- CNF Parsing and 3-SAT Conversion ---

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
    """
    Returns a canonical (sorted tuple) representation of a clause.
    """
    return tuple(sorted(clause))

# --- Functions for AT/CT mem files ---

def read_mem_file(filename):
    """
    Read a mem file containing hex numbers, one per line.
    """
    entries = []
    with open(filename, 'r') as f:
        for line in f:
            line = line.strip()
            if line:
                entries.append(int(line, 16))
    return entries

def reconstruct_clauses(at_entries, ct_entries, fixed_slots=20, valid_count=None):
    """
    Reconstruct candidate clauses from AT and CT mem files.
    For each literal (index), extract the candidate words and then form the clause:
         clause = [ -current_literal, cand_literal1, cand_literal2 ]
    The negative of current_literal is taken because AT/CT are generated from complement.
    """
    reconstructed = []
    if valid_count is None:
        valid_count = len(at_entries)
    for literal_index in range(valid_count):
        at_entry = at_entries[literal_index]
        mask = at_entry & ((1 << 20) - 1)
        # Number of candidate entries is determined by the number of lower bits set.
        count = mask.bit_length() if mask != 0 else 0
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
            var = (literal_index // 2) + 1
            current_literal = var if (literal_index % 2 == 0) else -var
            clause = [ -current_literal, lit1, lit2 ]
            reconstructed.append(canonical_clause(clause))
    return set(reconstructed)

def check_at_ct(original_cnf, at_mem_file, ct_mem_file):
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
        print("SUCCESS: The reconstructed AT/CT clauses match the original 3-SAT clauses.")
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
        print("FAILURE: The AT/CT mem file reconstruction does not match the original CNF.")

# --- Functions for Variable Table (VT) ---

def read_vt_files(vt_prefix, threads):
    """
    Read variable table files produced by cnf2mem.py.
    Files are assumed to be named as <vt_prefix>0.mem, <vt_prefix>1.mem, etc.
    Returns a dictionary mapping thread index to a list of integers (0 or 1).
    """
    vt_dict = {}
    for t in range(threads):
        filename = f"{vt_prefix}.mem"
        with open(filename, 'r') as f:
            lines = [line.strip() for line in f if line.strip()]
            vt_list = [int(line, 16) for line in lines]
            vt_dict[t] = vt_list
            print(f"VT file {filename}: {len(vt_list)} entries.")
    return vt_dict

def check_vt(vt_dict, expected_num_vars):
    """
    Check that each variable table has the expected number of entries and that each entry is 0 or 1.
    """
    success = True
    for t, vt in vt_dict.items():
        if len(vt) != expected_num_vars:
            print(f"ERROR: VT for thread {t} has {len(vt)} entries; expected {expected_num_vars}.")
            success = False
        for idx, bit in enumerate(vt):
            if bit not in (0, 1):
                print(f"ERROR: VT for thread {t} at index {idx} has invalid value {bit}.")
                success = False
    if success:
        print("SUCCESS: All VT files have the correct number of entries and valid values (0 or 1).")
    return success

# --- Functions for Unsatisfied Clause Buffer (UC) ---

def read_uc_file(uc_mem_file):
    """
    Read the unsatisfied clause buffer file.
    The file is expected to have headers in the form "# Thread X"
    followed by lines containing a 9-digit hex number (36-bit value).
    Returns a dictionary mapping thread index to a list of integers.
    """
    uc_dict = {}
    current_thread = None
    with open(uc_mem_file, 'r') as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            if line.startswith("# Thread"):
                parts = line.split()
                try:
                    current_thread = int(parts[2])
                    uc_dict[current_thread] = []
                except (IndexError, ValueError):
                    print("ERROR: Invalid thread header in UC file:", line)
            else:
                if current_thread is None:
                    print("ERROR: UC file format error; data without thread header.")
                    continue
                try:
                    uc_dict[current_thread].append(int(line, 16))
                except ValueError:
                    print("ERROR: Invalid UC data line:", line)
    for t in uc_dict:
        print(f"UC file: Thread {t} has {len(uc_dict[t])} unsatisfied clauses.")
    return uc_dict

def generate_unsat_clause_buffer(clauses, vt_dict, num_vars):
    """
    For each thread, evaluate every 3-SAT clause using that thread's variable table.
    A clause is unsatisfied if none of its literals evaluates true.
    Each unsatisfied clause is encoded as a 36-bit word:
         literal0 in bits [35:24], literal1 in bits [23:12], literal2 in bits [11:0]
    Returns a dictionary mapping thread index to a set of encoded unsatisfied clauses.
    """
    uc = { t: set() for t in vt_dict.keys() }
    for clause in clauses:
        # Encode each literal into 12 bits.
        enc_clause = [encode_literal(lit, num_vars) for lit in clause]
        packed_clause = (enc_clause[0] << 24) | (enc_clause[1] << 12) | enc_clause[2]
        for t, vt in vt_dict.items():
            satisfied = False
            for lit in clause:
                var_index = abs(lit) - 1
                val = vt[var_index]  # 0 or 1 from VT for thread t
                if (lit > 0 and val == 1) or (lit < 0 and val == 0):
                    satisfied = True
                    break
            if not satisfied:
                uc[t].add(packed_clause)
    return uc

def check_uc(original_cnf, vt_dict, uc_mem_file):
    """
    Check the Unsatisfied Clause Buffer by regenerating the unsatisfied clauses
    from the original CNF (converted to 3-SAT) and comparing with the UC mem file.
    """
    orig_num_vars, orig_clauses = parse_cnf(original_cnf)
    clauses_3sat, new_num_vars = convert_to_3sat(orig_clauses, orig_num_vars)
    num_vars = new_num_vars  # use the new num_vars (includes introduced ones)
    uc_expected = generate_unsat_clause_buffer(clauses_3sat, vt_dict, num_vars)
    uc_actual = read_uc_file(uc_mem_file)
    success = True
    for t in vt_dict.keys():
        expected_set = uc_expected.get(t, set())
        actual_set = set(uc_actual.get(t, []))
        if expected_set != actual_set:
            success = False
            missing = expected_set - actual_set
            extra = actual_set - expected_set
            print(f"Thread {t}:")
            if missing:
                print("  Missing unsatisfied clauses:")
                for clause in missing:
                    print("    0x{:09X}".format(clause))
            if extra:
                print("  Extra unsatisfied clauses:")
                for clause in extra:
                    print("    0x{:09X}".format(clause))
        else:
            print(f"SUCCESS: Thread {t} UC mem file matches expected unsatisfied clauses.")
    if success:
        print("SUCCESS: All Unsatisfied Clause Buffer entries match the expected values.")
    else:
        print("FAILURE: Discrepancies found in Unsatisfied Clause Buffer entries.")
    return success

# --- Combined check function ---

def check_all(original_cnf, at_mem_file, ct_mem_file, vt_prefix, uc_mem_file, threads):
    # Check AT and CT mem files
    print("=== Checking Address Translation Table and Clause Table mem files ===")
    check_at_ct(original_cnf, at_mem_file, ct_mem_file)
    
    # Parse original CNF and convert to 3-SAT to get number of variables (new_num_vars)
    orig_num_vars, orig_clauses = parse_cnf(original_cnf)
    _, new_num_vars = convert_to_3sat(orig_clauses, orig_num_vars)
    expected_vars = new_num_vars

    # Check Variable Table files
    print("\n=== Checking Variable Table mem files ===")
    vt_dict = read_vt_files(vt_prefix, threads)
    check_vt(vt_dict, expected_vars)
    
    # Check Unsatisfied Clause Buffer mem file
    print("\n=== Checking Unsatisfied Clause Buffer mem file ===")
    check_uc(original_cnf, vt_dict, uc_mem_file)

# --- Main function ---

def main():
    parser = argparse.ArgumentParser(
        description="Check mem files: AT, CT, Variable Table, and Unsatisfied Clause Buffer."
    )
    parser.add_argument("cnf", help="Original CNF file (DIMACS format).")
    parser.add_argument("--at", default="my_at.mem", help="Address Translation Table mem file.")
    parser.add_argument("--ct", default="my_ct.mem", help="Clause Table mem file.")
    parser.add_argument("--vt_prefix", default="vt", help="Prefix for Variable Table mem files (e.g. vt0.mem, vt1.mem, ...).")
    parser.add_argument("--uc", default="my_uc.mem", help="Unsatisfied Clause Buffer mem file.")
    parser.add_argument("--threads", type=int, default=1, help="Number of threads (default: 4).")
    args = parser.parse_args()
    check_all(args.cnf, args.at, args.ct, args.vt_prefix, args.uc, args.threads)

if __name__ == '__main__':
    main()
