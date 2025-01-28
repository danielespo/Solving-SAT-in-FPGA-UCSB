#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: $0 <rtl.v>"
  exit 1
fi

RTL=$1
RTL_DIR="/home/harim_choe/Solving-SAT-in-FPGA-UCSB/rtl/src"
TB_DIR="/home/harim_choe/Solving-SAT-in-FPGA-UCSB/rtl/tb"
TESTBENCH="${TB_DIR}/$(basename ${RTL%.v})_tb.v"

# Find RTL
if [ ! -f "$RTL" ]; then
  echo "Error: Design file '$RTL' not found."
  exit 1
fi

# Find TB
if [ ! -f "$TESTBENCH" ]; then
  echo "Error: Testbench file '$TESTBENCH' not found."
  exit 1
fi

# TCL for ModelSim
TCL_SCRIPT="simulate.tcl"
cat <<EOT > $TCL_SCRIPT
vlib work
vlog -sv $RTL
vlog -sv $TESTBENCH

vsim -c $(basename ${RTL%.v})_tb -do "run -all; quit"
EOT
vsim -c -do $TCL_SCRIPT

# Clean up
rm -f $TCL_SCRIPT

# Use this code by first making it executable by chmod +x simulate.sh
# Run the script like this: ./simulate.sh /Solving-SAT-in-FPGA-UCSB/rtl/src/your_file.v