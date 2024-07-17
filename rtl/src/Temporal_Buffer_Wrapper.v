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

// convert packed inputs to array signals
integer j,k;
wire [LITERAL_ADDRESS_WIDTH:0] flipped_literal_array [MAX_CLAUSES_PER_VARIABLE-1:0];
wire [LITERAL_ADDRESS_WIDTH:0] clause_table_literals_array [MAX_CLAUSES_PER_VARIABLE-1:0][NSAT-2:0];
wire [LITERAL_ADDRESS_WIDTH:0] output_clause_array [MAX_CLAUSES_PER_VARIABLE-1:0][NSAT-1:0];
for(j = 0; j < MAX_CLAUSES_PER_VARIABLE; j = j + 1) begin
    flipped_literal_array[j] = flipped_literal_multi_i[(j+1)*(LITERAL_ADDRESS_WIDTH+1)-1:j*(LITERAL_ADDRESS_WIDTH+1)]
    for(k = 0; k < NSAT-1; j++)begin
        clause_table_literals_array[j][k] = [((j+1)*(NSAT-1)+k+1)*(LITERAL_ADDRESS_WIDTH+1)-1:(j*(NSAT-1)+k)*(LITERAL_ADDRESS_WIDTH+1)]
    end
    for(k = 0; k < NSAT; k++) begin
        output_clause_array[j][k] = [((j+1)*NSAT+k+1)*(LITERAL_ADDRESS_WIDTH+1)-1:(j*NSAT+k)*(LITERAL_ADDRESS_WIDTH+1)]
    end
end

genvar i;
generate
    for(i = 0; i < MAX_CLAUSES_PER_VARIABLE; i = i + 1) begin: clause_generate
        Temporal_Buffer #(
            .NSAT,
            .LITERAL_ADDRESS_WIDTH,
            .NSAT_BITS
        ) TB (
            .clk(clk),
            .reset(reset),
            .write_index_i(write_index_i),
            .flipped_literal_i(flipped_literal_array[i]),
            .clause_table_literals_i({clause_table_literals_array[i][0], clause_table_literals_array[i][0]}),
            .read_index_i(read_index_i),
            .clause_o({output_clause_array[i][0], output_clause_array[i][1], output_clause_array[i][2]})
        );
    end
endgenerate

    
endmodule