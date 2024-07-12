/* 
Clause_Evaluator_tb.v
Author: Dan Espinosa

Description:
Testbench file for Clause_Evaluator.v

Status:
*/
`timescale 1ns / 1ps

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

// Instantiate the Unit Under Test (UUT)
Clause_Evaluator #(
    .MAX_CLAUSES_PER_VARIABLE(MAX_CLAUSES_PER_VARIABLE),
    .NSAT(NSAT),
    .LITERAL_ADDRESS_WIDTH(LITERAL_ADDRESS_WIDTH)
) UUT (
    .clk(clk),
    .reset(reset),
    .clause_table_i(clause_table_i),
    .var_table_data_i(var_table_data_i),
    .isBroken(isBroken)
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
    clause_table_i = 0;
    var_table_data_i = 0;
    
    // Reset the system
    #10;
    reset = 0;
    #10;
    reset = 1;
    #10;
    
    // Example test case
    // Define your clause_table_i and var_table_data_i based on specific test cases
    clause_table_i[0][0] = 'h1A; // Example address for first clause
    clause_table_i[0][1] = 'h1B; // Example address for second clause

    var_table_data_i[0][0] = 'h3; // Example data for first variable
    var_table_data_i[0][1] = 'h4; // Example data for second variable

    // More initialization and test cases can be added here
    
    #100;
    
    // Monitor output
    $monitor("Time = %t, isBroken = %b", $time, isBroken);
end

endmodule