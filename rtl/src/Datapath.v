/*
Version: 0.0
Datapath.v

V0.0 Author: Zeiler Randall-Reed

Description:
This is the top module for the datapath. It instantiates all of the modules that are needed for the
SAT solver and connects them together. It has I/O for interaction with the controller and for 
loading the problem data into the solver.

Notes:
- This module is a work in progress

Change Log:
8/19/2024 - Zeiler Randall-Reed
    Created Datapath.v
    
*/
module Datapath #(
    parameter NSAT = 3,
    parameter NUM_VARIABLES = 2048,
    parameter MAX_CLAUSE_MEMBERSHIP = 20,
    parameter FIFO_DEPTH = 32,
    parameter UNSAT_CLAUSE_BUFFER_DEPTH = 2048,
    parameter CONTROLLER_SIGNAL_WIDTH = 20
) (
    input clk, reset,
    input [CONTROLLER_SIGNAL_WIDTH - 1 : 0] control_signal_i,
    // in progress
    
)

// local parameters
localparam VARIABLE_ADDRESS_WIDTH = $clog2(NUM_VARIABLES);      // naming change
localparam LITERAL_ADDRESS_WIDTH = VARIABLE_ADDRESS_WIDTH + 1;  // naming change
localparam CLAUSE_WIDTH = NSAT * LITERAL_ADDRESS_WIDTH;

localparam MC = MAX_CLAUSE_MEMBERSHIP;
localparam MC_BITS = $clog2(MC);
localparam NSAT_BITS = $clog2(NSAT);



endmodule