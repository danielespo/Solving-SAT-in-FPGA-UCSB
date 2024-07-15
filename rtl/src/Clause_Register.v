`timescale 1ns / 1ps
/*
Clause_Register.v
Author: Ben Richardson [confirm?]

Create Date: 04/26/2024 12:40:52 AM

Description: 
A simple clocked register to hold the current candidate clause

Notes:

Testing:
- hopefully no testing needed as this is a simple register
*/

module Clause_Register# (
    parameter NSAT = 3,
    parameter LITERAL_ADDRESS_WIDTH = 11
)(
    input clk,
    input reset,
    input flush,
    input nextClause_i,
    input [LITERAL_ADDRESS_WIDTH:0] clause_i [0: NSAT-1],
    output [LITERAL_ADDRESS_WIDTH-1:0] literal_address_out,
    output literal_negation_bit_out
    );
    
    reg [LITERAL_ADDRESS_WIDTH:0] clauseReg [0:NSAT-1];

    integer i;
    always @(posedge clk) begin
        if (next_clause_i) begin
            for (i = 0; i < NSAT; i = i + 1) begin
                assign clauseReg [i] = clause_in[i]; // fix i values

            end
        end
    end
endmodule
