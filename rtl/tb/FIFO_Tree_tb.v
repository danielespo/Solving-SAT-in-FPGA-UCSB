/*
Version: 2.0
FIFO_Tree_tb.v

V0.0 Author: Dan Espinosa
V1.0 Author: Zeiler Randall-Reed
V2.0 Author: Zeiler Randall-Reed 

Description:
Testbench file for FIFO_Tree.v

Status: 
    V1.0 - Test passed
    V2.0 - Test in progress 

Change Log:
2024/08/05 - Zeiler Randall-Reed 
    Started V2.0
*/

`timescale 1ns / 1ps
`define SIM
`define ASSERT(CONDITION, MESSAGE) if ((CONDITION)==1'b1); else begin $error($sformatf MESSAGE); end

module FIFO_Tree_tb;

// Parameters for the FIFO tree
parameter CLAUSE_COUNT = 20;
parameter CLAUSE_WIDTH = 36;
parameter BUFFER_DEPTH = 32;

parameter NUM_TESTS = 30;

// Inputs
reg clk = 1;
always #5 clk <= ~clk;
reg reset;

reg [CLAUSE_WIDTH * CLAUSE_COUNT - 1 : 0] clauses_i;
reg [CLAUSE_COUNT - 1 : 0] clause_valid_i;
reg wren;
reg rden;
reg cOF;

// Output
wire empty;
wire OF;
wire [CLAUSE_WIDTH - 1 : 0] clause_o;

// Instantiate the Unit Under Test (UUT)
FIFO_tree #(
    .CLAUSE_COUNT(CLAUSE_COUNT),
    .CLAUSE_WIDTH(CLAUSE_WIDTH),
    .BUFFER_DEPTH(BUFFER_DEPTH),
) uut (
    .clk(clk),
    .reset(reset),
    .clauses_i(clauses_i),
    .clause_valid_i(clause_valid_i),
    .wren(wren),
    .rden(rden),
    .cOF(cOF),
    .empty(empty),
    .OF(OF),
    .clause_o(clause_o)
);

integer clauses[12];
integer matched[12];
integer index, i, j;

// Initialize Inputs and apply test cases
initial begin

// Read test data from files
// note: the paper says that there will be a max of 12 valid clauses per FIFO input
$display("FIFO Tree Testbench: Begin Simulation");

// load the clauses into the test array


// Reset the system
reset = 1;
@(negedge clk);
@(negedge clk);
reset = 0;

// Test


$display("FIFO Tree Testbench: End Simulation");

end

endmodule