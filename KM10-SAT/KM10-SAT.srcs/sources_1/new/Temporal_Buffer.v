// SKELETON FILE FOR TEMPORAL_BUFFER MODULE

module Temporal_Buffer #(
    parameter NSAT = 3,
    parameter LITERAL_ADDRESS_WIDTH = 11,
    parameter NSAT_BITS = $clog2(NSAT)
)(
    input                               clk,        // Clock signal
    input                               reset,      // Reset signal
    input [LITERAL_ADDRESS_WIDTH:0]     literals_i [NSAT-1:0], // clause input by literals because need to put selected literal together with clause_table literals
    input                               isBroken_i, // is the clause broken

    input [NSAT_BITS-1:0] heuristic_selection_i, // which flip was selected by the heuristic selector

    output reg [(LITERAL_ADDRESS_WIDTH+1)*NSAT - 1:0] clause_o   // output clause with selected flip if broken
);

endmodule