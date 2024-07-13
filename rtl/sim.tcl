# Adapted from Edalize
# https://github.com/olofk/edalize/blob/4a3f3e87/edalize/modelsim.py

onerror { quit -code 1; }
vlib work
vlog +define+SIM -quiet -work work XOR-PRNG.v
vlog +define+SIM -sv -quiet -work work XOR-PRNG-tb.v
