// SKELETON FILE FOR HEURISTIC_SELECTOR MODULE

module Heuristic_Selector #(
    parameter MAX_CLAUSES_PER_VARIABLE = 20,
    parameter NSAT = 3,
    parameter MAX_CLAUSES_PER_VARIABLE_BITS = 5,
    parameter NSAT_BITS = 2
)(
    input clk,
    input reset,
    input [MAX_CLAUSES_PER_VARIABLE_BITS-1:0] break_value_i,

    output reg [NSAT_BITS-1:0] selected_flip_o
);

endmodule