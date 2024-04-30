`timescale 1ns / 1ps

module UNSAT_Clause_Buffer_tb;

    // Parameters
    parameter NSAT = 3;
    parameter LITERAL_ADDRESS_WIDTH = 11;
    parameter DATA_WIDTH = (LITERAL_ADDRESS_WIDTH + 1) * NSAT;

    // Inputs
    reg clk;
    reg reset;
    reg [DATA_WIDTH-1:0] clause_i;

    // Outputs
    wire [DATA_WIDTH-1:0] clause_o;

    // Instantiate the Unit Under Test (UUT)
    UNSAT_Clause_Buffer #(
        .NSAT(NSAT),
        .LITERAL_ADDRESS_WIDTH(LITERAL_ADDRESS_WIDTH)
    ) uut (
        .clk(clk),
        .reset(reset),
        .clause_i(clause_i),
        .clause_o(clause_o)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk;  // Clock with a period of 20ns
    end

    // Test procedure
    initial begin
        // Initialize Inputs
        reset = 1;
        clause_i = 0;

        // Wait for the reset
        #100;
        reset = 0;

        // Test 1: Normal operation
        clause_i = 123;  // Example value
        #20;
        clause_i = 456;  // Another example value
        #20;
        clause_i = 789;  // Another example value

        // Test 2: Reset during operation
        #20;
        reset = 1;
        #30;
        reset = 0;
        clause_i = 321;  // Example value after reset

        // End of testing
        #50;
        $finish;  // Terminate simulation
    end

    // Display changes in output
    initial begin
        $monitor("At time %t, reset = %b, input = %h, output = %h", $time, reset, clause_i, clause_o);
    end

endmodule