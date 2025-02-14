#!/bin/bash

# Source this file to run 
# Define the log file name
LOG_FILE="../logs/kanazawa.txt"

# Compile the Verilog files using ModelSim
vlog ../src/Clause_Register.v ../src/Address_Translation_Table.v ../src/Clause_Table.v ../src/Variable_Table.v ../src/Variable_Table_Cluster.v ../src/Temporal_Buffer.v ../src/XOR_PRNG.v ../src/Clause_Evaluator_Cluster.v ../src/Clause_Evaluator.v ../src/Variable_Flip_Selector.v ../src/FIFO_Tree.v ../src/Unsat_Clause_Selector.v ../src/Temporal_Buffer_Wrapper.v ../src/Break_Value_Counter.v ../src/Heuristic_Selector.v ../src/FIFO_Buffer.v ../src/Unsat_Clause_Buffer.v ../src/M_Table.v ../src/Controller.v ../src/Datapath.v ../src/Overlord.v kanazawa_solver_tb.v

# Run the simulation in command-line mode, save the transcript to the log file
vsim -c kanazawa_solver_tb -do "run -all; quit" | tee $LOG_FILE

# Notify that the log has been saved
echo "Simulation complete. Log saved to $LOG_FILE."