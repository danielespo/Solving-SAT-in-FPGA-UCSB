/*
Address_Translation_Table_tb.v
V1.0 Author: Dan Espinosa
V2.0 Author: Harim Choe

Testbench file for Address_Translation_Table.v

Status:
    All tests passed
*/
`timescale 1ns / 1ps

module Address_Translation_Table_tb;

    // Parameters
    parameter CLAUSE_COUNT = 20;
    parameter LITERAL_ADDRESS_WIDTH = 12;
    parameter CLAUSE_TABLE_ADDRESS_WIDTH = 11;
    
    // Local Parameters
    localparam DEPTH = 2 ** LITERAL_ADDRESS_WIDTH;
    localparam WIDTH = CLAUSE_TABLE_ADDRESS_WIDTH + CLAUSE_COUNT;

    // Signals
    reg clk;
    reg axi_wr_en;
    reg [LITERAL_ADDRESS_WIDTH:0] axi_wr_addr;
    reg [WIDTH-1:0] axi_wr_data;
    reg [LITERAL_ADDRESS_WIDTH:0] rd_addr;

    wire [CLAUSE_COUNT-1:0] mask_out;
    wire [CLAUSE_TABLE_ADDRESS_WIDTH-1:0] addr_out;

    // DUT Instantiation
    Address_Translation_Table #(
        .CLAUSE_COUNT(CLAUSE_COUNT),
        .LITERAL_ADDRESS_WIDTH(LITERAL_ADDRESS_WIDTH),
        .CLAUSE_TABLE_ADDRESS_WIDTH(CLAUSE_TABLE_ADDRESS_WIDTH)
    ) dut(
        .clk_i(clk),
        .axi_wr_en_i(axi_wr_en),
        .axi_wr_addr_i(axi_wr_addr),
        .axi_wr_data_i(axi_wr_data),
        .rd_addr_i(rd_addr),
        .addr_o(addr_out),
        .mask_o(mask_out)
    );

    // Clock Generation
    always #5 clk = ~clk; // 100 MHz clock

    // Test Process
    initial begin
        clk = 0;
        axi_wr_en = 0;
        axi_wr_addr = 0;
        axi_wr_data = 0;
        rd_addr = 0;

        // Test 1: Reset behavior
        #10;
        $display("mask_out=%b, addr_out=%b", mask_out, addr_out);
        $display("TEST 1: Checking reset behavior...");
        if (mask_out == 0 && addr_out == 0)
            $display("TEST 1 PASSED: Reset behavior is correct");
        else
            $display("TEST 1 FAILED: Reset behavior is incorrect");

        // Test 2: Write and read back values
        $display("TEST 2: Writing and reading back values...");
        axi_wr_en = 1;
        axi_wr_addr = 12'h001; // Address to write
        axi_wr_data = {11'b10101010101, 20'b11110000111100001111}; // Clause + Mask
        #10;
        axi_wr_en = 0;
        rd_addr = 12'h001; // Address to read
        #10;

        if (addr_out == 11'b10101010101 && mask_out == 20'b11110000111100001111)
            $display("TEST 2 PASSED: Write and read back values are correct");
        else
            $display("TEST 2 FAILED: Write and read back values are incorrect");

        // Test 3: Random access
        $display("TEST 3: Performing random access...");
        axi_wr_en = 1;
        axi_wr_addr = 12'h002; // Address to write
        axi_wr_data = {11'b01010101010, 20'b00001111000011110000}; // Clause + Mask
        #10;
        axi_wr_addr = 12'h003; // Another address
        axi_wr_data = {11'b11111111111, 20'b10101010101010101010}; // Clause + Mask
        #10;
        axi_wr_en = 0;

        // Read back from different addresses
        rd_addr = 12'h002;
        #10;
        if (addr_out == 11'b01010101010 && mask_out == 20'b00001111000011110000)
            $display("TEST 3.1 PASSED: Random access read 1 is correct");
        else
            $display("TEST 3.1 FAILED: Random access read 1 is incorrect");

        rd_addr = 12'h003;
        #10;
        if (addr_out == 11'b11111111111 && mask_out == 20'b10101010101010101010)
            $display("TEST 3.2 PASSED: Random access read 2 is correct");
        else
            $display("TEST 3.2 FAILED: Random access read 2 is incorrect");

        // Test 4: Check correctness of outputs
        $display("TEST 4: Verifying correctness of outputs...");
        rd_addr = 12'h001; // Go back to address 1
        #10;
        if (addr_out == 11'b10101010101 && mask_out == 20'b11110000111100001111)
            $display("TEST 4 PASSED: Outputs are correct for address 1");
        else
            $display("TEST 4 FAILED: Outputs are incorrect for address 1");

        $display("All tests completed.");
        $stop;
    end

endmodule