#!/bin/bash

# Source this file to run 
# Define the log file name
LOG_FILE="../logs/cr_att_ct_vt_tb_full.txt"

# Compile the Verilog files using ModelSim
vlog ../src/Clause_Register.v ../src/Address_Translation_Table.v ../src/Clause_Table.v ../src/Variable_Table.v ../src/Variable_Table_Cluster.v ../src/Temporal_Buffer.v ../src/XOR_PRNG.v ../src/Clause_Evaluator_Cluster.v ../src/Clause_Evaluator.v ../src/Temporal_Buffer_Wrapper.v cr_att_ct_vt_tb_full.v

# Run the simulation in command-line mode and redirect output to the log file (no terminal output)
vsim -c cr_att_ct_vt_tb_full -do "run -all; quit" > "$LOG_FILE" 2>&1

# Notify that the log has been saved
echo "Simulation complete. Log saved to $LOG_FILE."