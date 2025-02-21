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
    input a_en_i,    b_en_i,
    input a_wr_en_i, b_wr_en_i,
    input [$clog2(DEPTH) - 1 : 0] a_addr_i, b_addr_i,
    input [NSAT * LITERAL_ADDRESS_WIDTH - 1 : 0] a_data_i, b_data_i,
    output reg [NSAT * LITERAL_ADDRESS_WIDTH - 1 : 0] a_data_o, b_data_o
);
    localparam CLAUSE_WIDTH = NSAT * LITERAL_ADDRESS_WIDTH;
    reg [CLAUSE_WIDTH - 1 : 0] ram [0 : DEPTH - 1];

    integer k;
    initial begin
        for (k = 0; k < DEPTH; k = k + 1) begin
            ram[k] = 0;
        end
        $display("Unsat_Clause_Buffer: Initialized at time %0t", $time);
    end 
    
    always @(posedge clk_i) begin
        if (a_en_i) begin
            if (a_wr_en_i) begin
                ram[a_addr_i] <= a_data_i;
                $display("Unsat_Clause_Buffer A WRITE: addr=%0d, data=0x%0h at time %0t", a_addr_i, a_data_i, $time);
            end
            a_data_o <= ram[a_addr_i];
            $display("Unsat_Clause_Buffer A READ: addr=%0d, data=0x%0h at time %0t", a_addr_i, a_data_o, $time);
        end
    end
    
    always @(posedge clk_i) begin
        if (b_en_i) begin
            if (b_wr_en_i) begin
                ram[b_addr_i] <= b_data_i;
                $display("Unsat_Clause_Buffer B WRITE: addr=%0d, data=0x%0h at time %0t", b_addr_i, b_data_i, $time);
            end
            b_data_o <= ram[b_addr_i];
            $display("Unsat_Clause_Buffer B READ: addr=%0d, data=0x%0h at time %0t", b_addr_i, b_data_o, $time);
        end
    end

endmodule

