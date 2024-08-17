/*
Version: 1.0
Break_Counter_Selector_tb.v

Author V1.0: Zeiler Randall-Reed

Description:
This module is where the break value counter and heuristic selector are combined. There is also an
included register to hold the break values for the first two cycles. This helps to ensure that all
of the data that is needed for the heuristic selector is available.

Status:
- V1.0: testbench in progress.
*/

`timescale 1ns / 1ps
`define SIM

module Break_Counter_Selector_tb;

// Break_Counter_Selector params
parameter MAX_CLAUSES_PER_VARIABLE = 20;
parameter NSAT = 3;
parameter MAX_CLAUSES_PER_VARIABLE_BITS = 5;
parameter NSAT_BITS = 2;
parameter P = 32'h6E147AE0;

// localparms
localparam MC = MAX_CLAUSES_PER_VARIABLE;
localparam MCB = MAX_CLAUSES_PER_VARIABLE_BITS;

// test params
parameter NUM_TESTS = 20;

// integer vars
integer i, j;

/* I/O */
// clock and reset
reg clk;
always #5 clk = ~clk;
reg reset;

// data inputs
reg [NUM_CLAUSES - 1 : 0] clause_broken_i;
reg [NUM_CLAUSES - 1 : 0] mask_bits_i;
reg [NSAT - 1 : 0] break_values_valid_i;
reg [31:0] random_i;

// control inputs
reg [NSAT_BITS - 1 : 0] wren_i;

// data outputs
wire [NSAT_BITS - 1 : 0] select_o;
wire [MC - 1 : 0] clause_broken_bits_o;

// instantiate the unit under test (UUT)
Break_Counter_Selector #(
    .MAX_CLAUSES_PER_VARIABLE(MAX_CLAUSES_PER_VARIABLE),
    .NSAT(NSAT),
    .MAX_CLAUSES_PER_VARIABLE_BITS(MAX_CLAUSES_PER_VARIABLE_BITS),
    .NSAT_BITS(NSAT_BITS),
    .P(P)
) uut (
    .clk(clk),
    .reset(reset),
    .clause_broken_i(clause_broken_i),
    .mask_bits_i(mask_bits_i),
    .break_values_valid_i(break_values_valid_i),
    .random_i(random_i),
    .wren_i(wren_i),
    .select_o(select_o),
    .clause_broken_bits_o(clause_broken_bits_o)
);

/* Testing Plan:
- basic cases
    select_o
    - 3 all zero (trivial case)
    - zero override no duplicates
    - zero override w/ duplicates
    - deterministic selection no duplicates
    - deterministic selection w/ duplicates (deprioritize first flip)
    - random selection 
    clause_broken_bits_o
    - mask bit check 
    - break bit check
    - random assignment check
*/

// testing data
reg [MC - 1 : 0] break_bits [NSAT - 1 : 0]  [NUM_TESTS - 1 : 0];
reg [MC - 1 : 0] mask_bits  [NSAT - 1 : 0]  [NUM_TESTS - 1 : 0];
reg [NSAT - 1]   break_valid                [NUM_TESTS - 1 : 0];
reg [31:0]       random_num                 [NUM_TESTS - 1 : 0];

// expected results
reg [NSAT_BITS - 1 : 0] select              [NUM_TESTS - 1 : 0];
reg [MC - 1 : 0] clause_broken_bits         [NUM_TESTS - 1 : 0];

initial begin
$display("Break Counter Selector Testbench: Begin Simulation");
// generate test data
    $display("Generating test data...");
    // test 0: 3 all zero (trivial)
    for(i = 0; i < NSAT; i = i + 1) begin
        break_bits[i][0] = 20'b0;
        mask_bits[i][0] = 20'b0;
    end
    break_valid[0] = 3'b111;
    random_num[0] = 32'b0;
    select[0] = 2'b01;
    clause_broken_bits[0] = break_bits[select[0]] & mask_bits[select[0]];






end



endmodule