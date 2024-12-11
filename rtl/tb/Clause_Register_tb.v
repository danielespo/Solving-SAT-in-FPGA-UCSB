/* 
Version: 1.0
Clause_Register_tb.v

V1.0 Author: Dan Espinosa

Description:
    This is the test bench for one clause register
    
Notes:

Change Log:

*/

module Clause_Register_tb;
    parameter NSAT = 3;
    parameter LITERAL_ADDRESS_WIDTH = 12; // 12 bits per literal, total 36 bits

    // IO
    reg clk;
    reg reset;
    reg wr_en;
    reg [LITERAL_ADDRESS_WIDTH * NSAT - 1 : 0] data_in;
    wire [LITERAL_ADDRESS_WIDTH * NSAT - 1 : 0] data_out;

    // HW
    Clause_Register #(
        .NSAT(3),
        .LITERAL_ADDRESS_WIDTH(LITERAL_ADDRESS_WIDTH)
    ) clause_register (
        .clk_i(clk),
        .rst_i(reset),
        .wr_en_i(wr_en),
        .data_i(data_in),
        .data_o(data_out)
    );

    // 20 ns period, 50 MHz
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Test
    initial begin
        // Inputs
        reset = 1;
        wr_en = 0;
        data_in = {36{1'b0}}; // start all 3 clauses as empty

        // Wait 100 ns, then release reset
        #100;
        reset = 0;

        // Enable write and load data
        wr_en = 1;
        // One clause example data: 1b negation 11b literal
        data_in = {1'b0, 11'h003, 1'b0, 11'h002, 1'b0, 11'h001};
        
        // Wait to observe output
        #2000;

        // Stop the simulation
        $stop;
    end

    // Monitor changes
    initial begin
        $monitor("Time=%0t, Reset=%b, wr_en=%b, data_in=%h, data_out=%h", 
                 $time, reset, wr_en, data_in, data_out);
    end

endmodule
