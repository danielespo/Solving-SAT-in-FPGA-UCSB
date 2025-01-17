/* 
Version: 1.0
Clause_Table_tb.v

V1.0 Author: Dan Espinosa

Description:
    This is the test bench for one Clause Table
    
    This table only has 2048 entries by default, despite there being 4096 address + negation 
    bit pairs (12^2).

    The Clause Table is implemented with a simple dual port memory to acommodate the zynq 7000
    native. The write port will only be used before the accelerator starts running and the mem
    will behave as a rom afterwards. 

Notes:

Currently clause output not working?..

Change Log:

*/

`timescale 1ns / 1ps

module Clause_Table_tb;
    parameter CLAUSE_COUNT = 20;
    parameter DEPTH = 2048;
    parameter VARIABLE_ADDRESS_WIDTH = 11;
    parameter NSAT = 3;
    parameter CT_WIDTH = (VARIABLE_ADDRESS_WIDTH + 1) * (NSAT - 1) * CLAUSE_COUNT; // 480

    // IO signals
    reg clk;
    reg axi_wr_en_input;
    reg [VARIABLE_ADDRESS_WIDTH - 1 : 0] axi_wr_addr_input;
    reg [CT_WIDTH - 1 : 0] axi_wr_clauses_input;
    reg [VARIABLE_ADDRESS_WIDTH - 1 : 0] rd_addr_input;
    wire [CT_WIDTH - 1 : 0] clauses_output;

    // Clause Table instantiation
    Clause_Table #(
        .CLAUSE_COUNT(CLAUSE_COUNT),
        .DEPTH(DEPTH),
        .VARIABLE_ADDRESS_WIDTH(VARIABLE_ADDRESS_WIDTH),
        .NSAT(NSAT)
    ) clause_table (
        .clk_i(clk),
        .axi_wr_en_i(axi_wr_en_input),
        .axi_wr_addr_i(axi_wr_addr_input),
        .axi_wr_clauses_i(axi_wr_clauses_input),
        .rd_addr_i(rd_addr_input),
        .clauses_o(clauses_output)
    );
    
    // Clock generation: 20 ns period (50 MHz)
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Test Process
    initial begin
        // Initialize inputs
        axi_wr_en_input = 0;
        axi_wr_addr_input = 0;
        axi_wr_clauses_input = 0;
        rd_addr_input = 0;
        #100;
        
        // Test 1: Write a Clause and Read It Back
        $display("TEST 1: Writing and reading a clause at address 1...");

        axi_wr_en_input = 1;
        axi_wr_addr_input = 11'd1;
        axi_wr_clauses_input = 480'hAABBCCDDEEFF00112233445566778899AABBCCDDEEFF00112233445566778899;
        #20; // Wait (2 clock cycles)
        axi_wr_en_input = 0;

        #10;
        rd_addr_input = 11'd1;
        #20;
        if (clauses_output == 480'hAABBCCDDEEFF00112233445566778899AABBCCDDEEFF00112233445566778899) begin
            $display("TEST 1 PASSED: Correct data read from address 1.");
        end else begin
            $display("TEST 1 FAILED: Incorrect data read from address 1. Read: 0x%h", clauses_output);
        end

        // Test 2: Write and Read Another Clause
        $display("TEST 2: Writing and reading a clause at address 100...");

        axi_wr_en_input = 1;
        axi_wr_addr_input = 11'd100;
        axi_wr_clauses_input = 480'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        #20; // Wait (2 clock cycles)
        axi_wr_en_input = 0;

        #10;
        rd_addr_input = 11'd100;
        #20; 
        if (clauses_output == 480'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF) begin
            $display("TEST 2 PASSED: Correct data read from address 100.");
        end else begin
            $display("TEST 2 FAILED: Incorrect data read from address 100. Read: 0x%h", clauses_output);
        end

        // Test 3: Attempt to Read from an Unwritten Address
        $display("TEST 3: Reading from an unwritten address (address 500)...");

        rd_addr_input = 11'd500;
        #20;
        if (clauses_output == 480'd0) begin
            $display("TEST 3 PASSED: Correct data (all zeros) read from unwritten address 500.");
        end else begin
            $display("TEST 3 FAILED: Incorrect data read from address 500. Read: 0x%h", clauses_output);
        end

        // End of tests
        $display("All tests completed.");
        $stop;
    end

    // Monitor signal changes
    initial begin
        $monitor("Time=%0t | axi_wr_en_input=%b | axi_wr_addr_input=%d | axi_wr_clauses_input=0x%h | rd_addr_input=%d | clauses_output=0x%h", 
                 $time, axi_wr_en_input, axi_wr_addr_input, axi_wr_clauses_input, rd_addr_input, clauses_output);
    end

endmodule