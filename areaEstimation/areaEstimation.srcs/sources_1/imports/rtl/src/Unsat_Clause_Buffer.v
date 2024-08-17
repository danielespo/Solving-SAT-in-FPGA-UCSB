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
    parameter LITERAL_ADDRESS_WIDTH = 11,
    parameter DEPTH = 2048
)(
    input       clk_a, clk_b, en_a, en_b, we_a, we_b,
    input       [$clog2(DEPTH) - 1 : 0]                         addr_a, addr_b,
    input       [(LITERAL_ADDRESS_WIDTH + 1) * NSAT - 1 : 0]    din_a, din_b,
    output reg  [(LITERAL_ADDRESS_WIDTH + 1) * NSAT - 1 : 0]    dout_a, dout_b
);
    localparam CLAUSE_SIZE = (LITERAL_ADDRESS_WIDTH + 1);
    reg [CLAUSE_SIZE * NSAT - 1 : 0] ram [0 : DEPTH - 1];
    
    always @(posedge clk_a)
    begin
        if (en_a)
        begin
            if (we_a) ram[addr_a] <= din_a;
            dout_a <= ram[addr_a];
        end
    end
    
    always @(posedge clk_b)
    begin
        if (en_b)
        begin
            if (we_b) ram[addr_b] <= din_b;
            dout_b <= ram[addr_b];
        end
    end

endmodule
