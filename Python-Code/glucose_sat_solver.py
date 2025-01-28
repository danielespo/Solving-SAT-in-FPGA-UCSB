#!/usr/bin/env python3
# 2025 UC Santa Barbara
"""
batch_glucose_sat_solver.py

Usage:
  python batch_glucose_sat_solver.py

Description:
  Iterates over 1000 CNF files (named uf50-0001.cnf to uf50-1000.cnf), each with 50 variables
  and 218 clauses. Uses the PySAT Glucose4 solver to check satisfiability.

Note:
  - This script stores results in a log file: glucose_sat_solver.log
  - Adjust the directory (cnf_dir) and naming pattern as needed.
"""

import os
from pysat.formula import CNF
from pysat.solvers import Glucose4

# Define log file
log_file = "glucose_sat_solver.log"

def log_message(message):
    with open(log_file, "a") as f:
        f.write(message + "\n")

def preprocess_file(filepath):
    with open(filepath, 'r') as f:
        lines = f.readlines()
        
    clean_lines = [line for line in lines if not line.strip().startswith('%') and line.strip() != '0']
    
    temp_filepath = filepath + ".tmp"
    with open(temp_filepath, 'w') as f:
        f.writelines(clean_lines)
    
    return temp_filepath

def main():
    cnf_dir = "/home/harim_choe/Solving-SAT-in-FPGA-UCSB/Python-Code/uf50-218"
    prefix = "uf50-"
    extension = ".cnf"

    if os.path.exists(log_file):
        os.remove(log_file)

    for i in range(1, 1001):
        if i < 10:
            filename = f"{prefix}0{i}{extension}"
        elif i < 100:
            filename = f"{prefix}0{i}{extension}"
        elif i < 1000:
            filename = f"{prefix}0{i}{extension}"
        else:
            filename = f"{prefix}{i}{extension}"

        filepath = os.path.join(cnf_dir, filename)
        log_message(f"[INFO] Solving {filename}")
        temp_filepath = preprocess_file(filepath)

        try:
            cnf = CNF(from_file=temp_filepath, comment_lead='c')
        finally:
            os.remove(temp_filepath)

        with Glucose4(bootstrap_with=cnf) as solver:
            is_sat = solver.solve()
            if is_sat:
                log_message("  -> SATISFIABLE")
                model = solver.get_model()
                
                for var in range(1, 51):
                    if var in model:
                        log_message(f" x{var} = TRUE; ")
                    elif -var in model:
                        log_message(f" x{var} = FALSE; ")
                    else:
                        log_message(f" x{var} is not in the model??; ")
            else:
                log_message("  -> UNSATISFIABLE (or UNKNOWN)")
                
if __name__ == "__main__":
    main()