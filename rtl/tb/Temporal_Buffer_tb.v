`timescale 1ns / 1ps

module Temporal_Buffer_tb;

    // Parameters
    parameter NSAT = 3;
    parameter LAW = 12; // LITERAL_ADDRESS_WIDTH
    parameter SIZE = 2; // (NSAT-1)
    localparam DATA_WIDTH = SIZE * LAW;
    localparam NSAT_BITS = $clog2(NSAT);
    reg clk;
    reg rst;
    reg [NSAT_BITS-1:0] wr_index;
    reg wr_en;
    reg [DATA_WIDTH-1:0] wr_literals;
    reg [NSAT_BITS-1:0] rd_index;
    wire [DATA_WIDTH-1:0] literals_out;

    Temporal_Buffer #(
        .NSAT(NSAT),
        .LAW(LAW),
        .SIZE(SIZE)
    ) dut(
        .clk_i(clk),
        .rst_i(rst),
        .wr_index_i(wr_index),
        .wr_en_i(wr_en),
        .wr_literals_i(wr_literals),
        .rd_index_i(rd_index),
        .literals_o(literals_out)
    );

    always #5 clk = ~clk; // 10 ns clock period (50 MHz)

    // Test process
    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        wr_index = 0;
        wr_en = 0;
        wr_literals = 0;
        rd_index = 0;

        $display("TEST 1: Applying reset...");
        #10;
        rst = 1;
        #10;
        rst = 0;

        #10;
        rd_index = 0;
        #10;
        if (literals_out == 0)
            $display("TEST 1 PASSED: literals_out initialized to 0 at index 0.");
        else
            $display("TEST 1 FAILED: literals_out not initialized to 0 at index 0. Found: %h", literals_out);

        // Test write and read
        $display("TEST 2: Writing and reading values...");
        wr_index = 1;
        wr_en = 1;
        wr_literals = 24'hABCDEF;
        #10;
        wr_en = 0;
        rd_index = 1;
        #10;
        if (literals_out == 24'hABCDEF)
            $display("TEST 2 PASSED: Correct value read from index 1.");
        else
            $display("TEST 2 FAILED: Incorrect value read from index 1. Found: %h", literals_out);

        // Test bypass read (rd_index == 2)
        $display("TEST 3: Bypass read with rd_index == 2...");
        rd_index = 2;
        wr_literals = 24'h123456;
        #10;
        if (literals_out == 24'h123456)
            $display("TEST 3 PASSED: Bypass read value is correct.");
        else
            $display("TEST 3 FAILED: Bypass read value is incorrect. Found: %h", literals_out);

        // Reset again
        $display("TEST 4: Checking reset after write...");
        rst = 1;
        #10;
        rst = 0;
        rd_index = 1; // Check index 1 after reset
        #10;
        if (literals_out == 0)
            $display("TEST 4 PASSED: literals_out reset to 0 at index 1.");
        else
            $display("TEST 4 FAILED: literals_out not reset to 0 at index 1. Found: %h", literals_out);

        // End simulation
        $display("All tests completed.");
        $stop;
    end

    // Monitor signal changes
    initial begin
        $monitor("Time=%0t | rst=%b | wr_en=%b | wr_index=%d | wr_literals=%h | rd_index=%d | literals_out=%h", 
                 $time, rst, wr_en, wr_index, wr_literals, rd_index, literals_out);
    end

endmodule