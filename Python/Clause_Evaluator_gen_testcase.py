import sys
import os
import numpy as np

def read_file(file_path):
    try:
        with open(file_path, 'r') as file:
            contents = file.read()
            print(contents)
    except FileNotFoundError:
        print(f"The file {file_path} does not exist.")
    except Exception as e:
        print(f"An error occurred: {e}")

def write_file(file_path, content):
    try:
        with open(file_path, 'w') as file:
            file.write(content)
            print(f"File {file_path} has been overwritten.")
    except Exception as e:
        print(f"An error occurred: {e}")

def gen_test(NSAT = 3, CLUSTER_SIZE = 20, test_size = 20):
    var_val = np.random.randint(0, 2 ** (CLUSTER_SIZE * NSAT), size=test_size, dtype=np.uint64)
    var_neg = np.random.randint(0, 2 ** (CLUSTER_SIZE * NSAT), size=test_size, dtype=np.uint64)

    break_o = np.zeros((test_size,), dtype=np.uint64)
    
    for case in range(test_size):
        negated = var_val ^ var_neg
        for unit in range(CLUSTER_SIZE):
            mask = np.uint64(0b111 << (unit * 3))
            break_unit = (negated[case] & mask)
            break_o[case] |= np.uint64((break_unit == 0) << unit)
    
    return var_val, var_neg, break_o

def write_data(dir, filename, data):
    
    try:
        filepath = os.path.join(dir, filename)
        with open(filepath, 'w') as file:
            file.write(data)
        print(f"Created {filepath}")

    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    NSAT = 3
    CLUSTER_SIZE = 20
    
    if len(sys.argv) != 3:
        print("Usage: python Clause_Evaluator_gen_testcase.py <test_size> <mem directory path>")
    else:
        test_size = sys.argv[1]
        path = sys.argv[2]
        if os.path.isdir(path):
            pass
        else:
            raise FileNotFoundError(f"\"{path}\" is not a valid directory")
        try:
            test_size = int(test_size)
        except:
            raise ValueError("Test size must be an integer")
        
        var_val, var_neg, break_o = gen_test()
        print(f"Values   {var_val[0]:>060b}")
        print(f"Negation {var_neg[0]:>060b}")
        print(f"Broken   {break_o[0]:>020b}")

        val_str = ""
        neg_str = ""
        break_str = ""

        for case in range(test_size):
            val_str += hex(var_val[case])[2:] + '\n'
            neg_str += hex(var_neg[case])[2:] + '\n'
            break_str += hex(break_o[case])[2:] + '\n'
        
        write_data(path, "Clause_Evaluator_var_val.mem", val_str)
        write_data(path, "Clause_Evaluator_var_neg.mem", neg_str)
        write_data(path, "Clause_Evaluator_break.mem", break_str)