`timescale 1ns / 1ps
// SKELETON FILE FOR THE FIFO TREE TESTBENCH
// NEED ZEILERPHONE'S CHECK ON THE DIFFERENT PARTS, change fully
module FIFO_Tree_tb;

// Parameters for the FIFO tree
parameter MAX_CLAUSES_PER_VARIABLE = 20;
parameter DATA_WIDTH = 36;
parameter BUFFER_SIZE = 32;
parameter FIRST_LEVEL_PARALLEL = 5;
parameter TREE_LEAVES = MAX_CLAUSES_PER_VARIABLE / FIRST_LEVEL_PARALLEL;

// Inputs
reg clk;
reg reset;
reg [DATA_WIDTH - 1 : 0] clauses_i [MAX_CLAUSES_PER_VARIABLE-1:0];
reg [MAX_CLAUSES_PER_VARIABLE-1:0] clause_valid_i;
reg write_en_i;

// Output
wire [DATA_WIDTH - 1 : 0] clause_o;

// Instantiate the Unit Under Test (UUT)
FIFO_tree #(
    .MAX_CLAUSES_PER_VARIABLE(MAX_CLAUSES_PER_VARIABLE),
    .DATA_WIDTH(DATA_WIDTH),
    .BUFFER_SIZE(BUFFER_SIZE),
    .FIRST_LEVEL_PARALLEL(FIRST_LEVEL_PARALLEL)
) uut (
    .clk(clk),
    .reset(reset),
    .clauses_i(clauses_i),
    .clause_valid_i(clause_valid_i),
    .write_en_i(write_en_i),
    .clause_o(clause_o)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk; // 100 MHz Clock
end

// Initialize Inputs and apply test cases
initial begin
    // Initialize inputs
    reset = 1;
    write_en_i = 0;
    clause_valid_i = 0;
    
    // Reset the system
    #10;
    reset = 0;
    #10;
    reset = 1;
    #10;
    
    // Example test case
    write_en_i = 1;
    clause_valid_i[0] = 1;
    clauses_i[0] = 36'hA;
    #10;
    
    write_en_i = 0;
    clause_valid_i[0] = 0;
    #10;

    // Add better test cases here
end

endmodule