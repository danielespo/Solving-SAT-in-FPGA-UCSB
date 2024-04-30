`timescale 1ns / 1ps

module Clause_Table_tb;
    
    // Parameters
    parameter MAX_CLAUSES_PER_VARIABLE = 20;
    parameter NUM_ROWS = 2048;
    parameter LITERAL_ADDRESS_WIDTH = 11;
    parameter NSAT = 3;

    // Testbench Signals
    reg clk;
    reg reset;
    reg [LITERAL_ADDRESS_WIDTH-1:0] address_i;
    wire [LITERAL_ADDRESS_WIDTH:0] clauses_o[MAX_CLAUSES_PER_VARIABLE-1:0][NSAT-2:0];

    // Instantiate the Module
    Clause_Table #(
        .MAX_CLAUSES_PER_VARIABLE(MAX_CLAUSES_PER_VARIABLE),
        .NUM_ROWS(NUM_ROWS),
        .LITERAL_ADDRESS_WIDTH(LITERAL_ADDRESS_WIDTH),
        .NSAT(NSAT)
    ) uut (
        .clk(clk),
        .reset(reset),
        .address_i(address_i),
        .clauses_o(clauses_o)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Generate a clock with a period of 10ns
    end

    // Test cases
    initial begin
        reset = 1;
        address_i = 0;
        #10; // Wait for the reset to take effect

        reset = 0;
        address_i = 0;
        #10; // Test the first address

        address_i = 1;
        #10; // Test the second address

        address_i = 2;
        #10; // Test the third address

        // Additional test cases can be added here

        $finish; // End simulation
    end

    // Optional: Display output values
    initial begin
        $monitor("Time = %t, Address = %h, Clauses Output = %h",
                 $time, address_i, clauses_o);
    end

endmodule