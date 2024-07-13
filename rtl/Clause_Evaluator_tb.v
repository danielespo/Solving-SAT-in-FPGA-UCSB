/* 
Clause_Evaluator_tb.v
Author: Dan Espinosa

Description:
Testbench file for Clause_Evaluator.v

Status:
*/
`timescale 1ns / 1ps
// Note, this still needs to interface with the Variable Table somehow and I have no idea currently (5/02/24) how to do this, help later
// thanks, -Dan
module Clause_Evaluator_tb;
parameter MAX_CLAUSES_PER_VARIABLE = 20;
parameter NSAT = 3;
parameter LITERAL_ADDRESS_WIDTH = 11;

// Inputs
reg clk;
reg reset;
reg [LITERAL_ADDRESS_WIDTH:0] clause_table_i [MAX_CLAUSES_PER_VARIABLE-1:0][NSAT-2:0];
reg [LITERAL_ADDRESS_WIDTH-1:0] var_table_data_i [0:MAX_CLAUSES_PER_VARIABLE - 1] [0:NSAT-2];

// Outputs
wire [MAX_CLAUSES_PER_VARIABLE-1:0] isBroken;

// Start
Clause_Evaluator #(
    .MAX_CLAUSES_PER_VARIABLE(MAX_CLAUSES_PER_VARIABLE),
    .NSAT(NSAT),
    .LITERAL_ADDRESS_WIDTH(LITERAL_ADDRESS_WIDTH)
) uut (
    .clk(clk),
    .reset(reset),
    .clause_table_i(clause_table_i),
    .var_table_data_i(var_table_data_i),
    .isBroken(isBroken)
);

// Clock
initial begin
    clk = 0;
    forever #5 clk = ~clk; // 100 MHz Clock
end

// Ins and test cases
initial begin
    // Ins
    reset = 1;
    clause_table_i = 0;
    var_table_data_i = 0;
    
    // Reset test
    #10;
    reset = 0;
    #10;
    reset = 1;
    #10;
    reset = 0;
    #10;
    // Test cases
    clause_table_i[0][0] = 'h1A; // Example address for first clause
    clause_table_i[0][1] = 'h1B; // Example address for second clause

    var_table_data_i[0][0] = 'h3; // Example data for first variable
    var_table_data_i[0][1] = 'h4; // Example data for second variable

    // More initialization and test cases can be added here
    
    #100;
    reset = 1;
    
    // Monitor output
    $monitor("Time = %t, isBroken = %b", $time, isBroken);
end

endmodule