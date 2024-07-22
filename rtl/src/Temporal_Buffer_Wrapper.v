/*
Temporal_Buffer_Wrapper.v
Author: Zeiler Randall-Reed

Description: 
This module provides a way to procedurally generate temporal buffer modules and interface with 
a parameterizable number of them.

Notes:
- 

Testing:
- testbench created 5/10/24 but is incomplete
- testing started 7/17/24
*/

module Temporal_Buffer_Wrapper #(
    parameter NSAT = 3,
    parameter LITERAL_ADDRESS_WIDTH = 11,
    parameter MAX_CLAUSES_PER_VARIABLE = 20,
    parameter NSAT_BITS = 2
)(
    input                               clk,                    // Clock signal
    input                               reset,                  // Reset signal

    input [NSAT_BITS-1:0]               write_index_i,        // which flip is currently being evaluated
    input [MAX_CLAUSES_PER_VARIABLE*(LITERAL_ADDRESS_WIDTH+1)-1:0] flipped_literal_multi_i,      // flipped input literal to be combined with clause_table literals 
    input [(NSAT-1)*MAX_CLAUSES_PER_VARIABLE*(LITERAL_ADDRESS_WIDTH+1)-1:0] clause_table_literals_multi_i,   // clause_table input bus

    input [NSAT_BITS-1:0]               read_index_i,  // which flip was selected by the heuristic selector
    output [NSAT*MAX_CLAUSES_PER_VARIABLE*(LITERAL_ADDRESS_WIDTH+1)-1:0] clause_multi_o // output clause with selected flip if broken
);

// signals 
genvar index,k;
wire [LITERAL_ADDRESS_WIDTH:0] flipped_literal;
wire [(NSAT-1)*(LITERAL_ADDRESS_WIDTH+1)-1:0] clause_table_literals;
wire [NSAT*(LITERAL_ADDRESS_WIDTH+1)-1:0] output_clause;

generate
    // convert packed inputs to array signals
    for(index = 0; index < MAX_CLAUSES_PER_VARIABLE; index = index + 1) begin : gen_temp_buf
        assign flipped_literal = flipped_literal_multi_i[index*(LITERAL_ADDRESS_WIDTH+1)+:(LITERAL_ADDRESS_WIDTH+1)];
        assign clause_table_literals = clause_table_literals_multi_i[index*(NSAT-1)*(LITERAL_ADDRESS_WIDTH+1)+:(NSAT-1)*(LITERAL_ADDRESS_WIDTH+1)];
        assign clause_multi_o[(index*NSAT)*(LITERAL_ADDRESS_WIDTH+1)+:NSAT*(LITERAL_ADDRESS_WIDTH+1)] = output_clause;
        Temporal_Buffer #(
            .NSAT(NSAT),
            .LITERAL_ADDRESS_WIDTH(LITERAL_ADDRESS_WIDTH),
            .NSAT_BITS(NSAT_BITS)
        ) TB (
            .clk(clk),
            .reset(reset),
            .write_index_i(write_index_i),
            .flipped_literal_i(flipped_literal),
            .clause_table_literals_i(clause_table_literals),
            .read_index_i(read_index_i),
            .clause_o(output_clause)
        );
    end
endgenerate

    
endmodule