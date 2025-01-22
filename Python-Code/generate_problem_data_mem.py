#!/usr/bin/env python3
"""
generate_problem_data_mem.py

Usage:
  python generate_problem_data_mem.py <cnf_file> <output_mem_file>

Description:
  1. Reads a CNF file via parsecnf (read_dimacs).
  2. Creates literal memberships with create_literal_memberships.
  3. Packs them with packing_algorithm_20_as_max (or any other).
  4. Converts the result to a list of 32-bit words.
  5. Writes those 32-bit words in hex to problem_data.mem for $readmemh.

Note:
  - The actual structure of each 32-bit word depends on your solver design.
  - Check/adjust 'convert_to_uint32_list' if you need a different data format.

"""
import sys
import parsecnf as rd
from packing import (
    create_literal_memberships,
    packing_algorithm_20_as_max,
    convert_to_uint32_list,
)

def generate_problem_data_mem(cnf_filename, output_filename):
    literal_memberships = create_literal_memberships(cnf_filename)
    
    packed_literal_array, masks = packing_algorithm_20_as_max(literal_memberships)
    uint32_list = convert_to_uint32_list(packed_literal_array, masks, depth=4096)

    # Each line is an 8-digit hex, e.g. '03A1F00C'
    with open(output_filename, 'w') as f:
        for value in uint32_list:
            # Print in uppercase hex, zero-padded to 8 digits
            f.write(f"{value:08X}\n")

    print(f"[INFO] Generated {output_filename} with {len(uint32_list)} lines of 32-bit data.")

def main():
    if len(sys.argv) < 3:
        print("Usage: python generate_problem_data_mem.py <cnf_file> <output_mem_file>")
        sys.exit(1)
    cnf_file = sys.argv[1]
    output_file = sys.argv[2]
    generate_problem_data_mem(cnf_file, output_file)

if __name__ == "__main__":
    main()