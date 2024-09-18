/* ----------------------------------------------------
Version: 1.0
Unsat_Clause_Buffer.v

V1.0 Author: Barry Wang

Description:
    This is a width configurable true dual port read first
    clause buffer

Notes: 

Testing:
    None

Change Log:

2024/07/24 - Barry Wang
    Created file Unsat_Clause_Buffer.v

-----------------------------------------------------*/

module Unsat_Clause_Buffer # (
    parameter NSAT = 3, 
    parameter LITERAL_ADDRESS_WIDTH = 12,
    parameter DEPTH = 2048
)(
    input clk_i, 

    // control signals
    input a_en_i,    b_en_i,
    input a_wr_en_i, b_wr_en_i,

    // data signals
    input      [$clog2(DEPTH) - 1 : 0]                a_addr_i, b_addr_i,
    input      [LITERAL_ADDRESS_WIDTH * NSAT - 1 : 0] a_data_i, b_data_i,
    output reg [LITERAL_ADDRESS_WIDTH * NSAT - 1 : 0] a_data_o, b_data_o
);
    localparam CLAUSE_WIDTH = LITERAL_ADDRESS_WIDTH * NSAT;
    reg [CLAUSE_WIDTH - 1 : 0] ram [0 : DEPTH - 1];
    
    always @(posedge clk_i)
    begin
        if (a_en_i)
        begin
            if (a_wr_en_i) ram[a_addr_i] <= a_data_i;
            a_data_o <= ram[a_addr_i];
        end
    end
    
    always @(posedge clk_i)
    begin
        if (b_en_i)
        begin
            if (b_wr_en_i) ram[b_addr_i] <= b_data_i;
            b_data_o <= ram[b_addr_i];
        end
    end

endmodule
