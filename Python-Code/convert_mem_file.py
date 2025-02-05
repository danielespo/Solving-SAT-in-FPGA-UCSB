def convert_mem_file(input_file, output_file, required_hex_digits):
    """
    Converts a memory file to have a fixed number of hex digits per line.
    - Truncates longer lines to the required length
    - Pads shorter lines with leading zeros
    """
    with open(input_file, 'r') as f_in, open(output_file, 'w') as f_out:
        for line in f_in:
            # Clean the line and convert to uppercase
            clean_line = line.strip().upper()
            
            # Remove any '0x' prefix if present
            if clean_line.startswith('0X'):
                clean_line = clean_line[2:]
                
            # Truncate or pad the line
            if len(clean_line) > required_hex_digits:
                # Keep only the least significant digits
                converted = clean_line[-required_hex_digits:]
            else:
                # Pad with leading zeros
                converted = clean_line.zfill(required_hex_digits)
            
            f_out.write(converted + '\n')

# Convert var_val and var_neg files (40 bits = 10 hex digits)
convert_mem_file('../rtl/mem/Clause_Evaluator_var_val.mem', '../rtl/mem/Clause_Evaluator_var_val_fixed.mem', 10)
convert_mem_file('../rtl/mem/Clause_Evaluator_var_neg.mem', '../rtl/mem/Clause_Evaluator_var_neg_fixed.mem', 10)

# Convert break file (20 bits = 5 hex digits)
convert_mem_file('../rtl/mem/Clause_Evaluator_break.mem', '../rtl/mem/Clause_Evaluator_break_fixed.mem', 5)

print("Conversion complete! Use the *_fixed.mem files in your testbench.")