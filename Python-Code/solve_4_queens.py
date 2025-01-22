#!/usr/bin/env python3

from pysat.formula import CNF
from pysat.solvers import Glucose4

def main():
    raw_clauses = """
-1 -2 0
-1 -3 0
-1 -4 0
-2 -3 0
-2 -4 0
-3 -4 0
1 2 3 4 0
-5 -6 0
-5 -7 0
-5 -8 0
-6 -7 0
-6 -8 0
-7 -8 0
5 6 7 8 0
-9 -10 0
-9 -11 0
-9 -12 0
-10 -11 0
-10 -12 0
-11 -12 0
9 10 11 12 0
-13 -14 0
-13 -15 0
-13 -16 0
-14 -15 0
-14 -16 0
-15 -16 0
13 14 15 16 0
-1 -5 0
-1 -9 0
-1 -13 0
-5 -9 0
-5 -13 0
-9 -13 0
1 5 9 13 0
-2 -6 0
-2 -10 0
-2 -14 0
-6 -10 0
-6 -14 0
-10 -14 0
2 6 10 14 0
-3 -7 0
-3 -11 0
-3 -15 0
-7 -11 0
-7 -15 0
-11 -15 0
3 7 11 15 0
-4 -8 0
-4 -12 0
-4 -16 0
-8 -12 0
-8 -16 0
-12 -16 0
4 8 12 16 0
-3 -8 0
-2 -7 0
-2 -12 0
-7 -12 0
-1 -6 0
-1 -11 0
-1 -16 0
-6 -11 0
-6 -16 0
-11 -16 0
-5 -10 0
-5 -15 0
-10 -15 0
-9 -14 0
-2 -5 0
-3 -6 0
-3 -9 0
-6 -9 0
-4 -7 0
-4 -10 0
-4 -13 0
-7 -10 0
-7 -13 0
-10 -13 0
-8 -11 0
-8 -14 0
-11 -14 0
-12 -15 0
""".strip().splitlines()

    cnf = CNF()

    for line in raw_clauses:
        if line.strip() == "":
            continue
        parts = line.strip().split()
        clause = [int(x) for x in parts if int(x) != 0]
        cnf.append(clause)

    solver = Glucose4(bootstrap_with=cnf)

    sat = solver.solve()
    if sat:
        print("[INFO] The formula is SATISFIABLE.")
        model = solver.get_model()
        # Model is a list of integers: positive for true, negative for false.
        # if 3 is in model => variable x3 = TRUE, if -3 => x3 = FALSE.

        sorted_model = sorted(model, key=lambda x: abs(x))
        print("[INFO] A satisfying assignment (in sorted order):")
        print(sorted_model)

        print("\n[INFO] Interpreting solution for variables 1..16:")
        for var in range(1, 17):
            if var in model:
                print(f" x{var} = TRUE", end="; ")
            elif -var in model:
                print(f" x{var} = FALSE", end="; ")
            else:
                print(f" x{var} is not in the model??", end="; ")
        print()
    else:
        print("[INFO] The formula is UNSATISFIABLE or solver returned unknown.")

    solver.delete()


if __name__ == "__main__":
    main()