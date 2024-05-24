/*
Temporal_Buffer_Wrapper.v
*/

module Temporal_Buffer_Wrapper #(
    parameter NSAT = 3,
    parameter LITERAL_ADDRESS_WIDTH = 11,
    parameter MAX_CLAUSES_PER_VARIABLE = 20,
    parameter NSAT_BITS = $clog2(NSAT)
)(
    input                               clk,                    // Clock signal
    input                               reset,                  // Reset signal
    input [LITERAL_ADDRESS_WIDTH:0]     flipped_literal_multi_i [MAX_CLAUSES_PER_VARIABLE-1:0],      // flipped input literal to be combined with clause_table literals 
    input [LITERAL_ADDRESS_WIDTH:0]     clause_table_literals_multi_i [NSAT-2:0] [MAX_CLAUSES_PER_VARIABLE-1:0],   // clause_table input bus
    input                               isBroken_multi_i [MAX_CLAUSES_PER_VARIABLE-1:0],  // is the clause broken

    input [NSAT_BITS-1:0]               current_flip_i,        // which flip is currently being evaluated

    input [NSAT_BITS-1:0]               heuristic_selection_i,  // which flip was selected by the heuristic selector

    output reg [LITERAL_ADDRESS_WIDTH:0] clause_multi_o [NSAT-1:0] [MAX_CLAUSES_PER_VARIABLE-1:0] // output clause with selected flip if broken
);

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
            .flipped_literal_i(flipped_literal_i),
            .clause_table_literals_i(flipped_literal_multi_i[i], clause_table_literals_multi_i[0][i], clause_table_literals_multi_i[1][i]),
            .isBroken_i(isBroken_multi_i[i]),
            .current_flip_i(current_flip_i),
            .heuristic_selection_i(heuristic_selection_i),
            .clause_o(clause_multi_o[0][i], clause_multi_o[1][i], clause_multi_o[2][i])
        );
    end
endgenerate

    
endmodule