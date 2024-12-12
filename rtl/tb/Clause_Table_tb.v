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

module Clause_Table_tb;
    parameter CLAUSE_COUNT = 20;
    parameter DEPTH = 2048;
    parameter VARIABLE_ADDRESS_WIDTH = 11;
    parameter NSAT = 3;
    parameter CT_WIDTH = (VARIABLE_ADDRESS_WIDTH + 1) * (NSAT - 1) * CLAUSE_COUNT; // 480

    // IO
    reg clk;
    reg axi_wr_en_input;
    reg [VARIABLE_ADDRESS_WIDTH - 1 : 0] axi_wr_addr_input;
    reg [CT_WIDTH - 1 : 0] axi_wr_clauses_input;
    reg [VARIABLE_ADDRESS_WIDTH - 1 : 0] rd_addr_input;
    wire [CT_WIDTH - 1 : 0] clauses_output;

    // HW
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
    
    // 20 ns period, 50 MHz
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Test
    initial begin
        // IO
        axi_wr_en_input = 0;
        axi_wr_addr_input = {11{1'b0}}; //start as empty
        axi_wr_clauses_input = {480{1'b0}};
        rd_addr_input = {12{1'b0}};

        // Wait 100 ns, no reset in this ROM ?...
        #100;

        // Enable write and load data
        axi_wr_en_input = 1;
        axi_wr_addr_input = 11'd1;
        // One clause example data: 1b negation 11b literal

        axi_wr_clauses_input = 480'd2050; // empty except (x1 x2 x3 at addr 11'h1)
        // ie. 
        // 24 (0 00000000001 0 0000000010)
        // Wait to observe output
        #100;
        axi_wr_en_input = 0;
        #100
        rd_addr_input = 11'd1;

        #2000;
        // Stop the simulation
        $stop;
    end

    // Monitor changes
    initial begin
        $monitor("Time=%0t, axi_wr_en_input=%b, axi_wr_addr_input=%d, axi_wr_clauses_input=%d, clauses_output=%d", 
                 $time, axi_wr_en_input, axi_wr_addr_input, axi_wr_clauses_input, clauses_output);
    end

endmodule
