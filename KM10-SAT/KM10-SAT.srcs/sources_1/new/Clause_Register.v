`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UCSB
// Engineer: Ben Richardson
// 
// Create Date: 04/18/2024 08:51:22 PM
// Design Name: 
// Module Name: Clause_Register
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Clause_Register # (
    parameter NSAT = 3,
    parameter LITERAL_ADDRESS_WIDTH = 11
)(
    input clk,
    input reset,
    input flush,
    input next_clause_i,
    input [LITERAL_ADDRESS_WIDTH:0] clause_in [0: NSAT-1],
    output wire [LITERAL_ADDRESS_WIDTH-1:0] literal_address_out,
    output wire literal_negation_bit_out
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
