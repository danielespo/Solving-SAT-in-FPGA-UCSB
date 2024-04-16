// SKELETON FILE FOR FIFO_TREE MODULE

module FIFO_tree #(
    parameter MAX_CLAUSES_PER_VARIABLE = 20,
    parameter LITERAL_ADDRESS_WIDTH = 11,
    parameter NSAT = 3
)(
    input                                       clk,
    input                                       reset,
    input [(LITERAL_ADDRESS_WIDTH+1)*NSAT - 1:0]   clauses_i [MAX_CLAUSES_PER_VARIABLE-1:0],

    output [(LITERAL_ADDRESS_WIDTH+1)*NSAT - 1:0]  clause_o,
);



endmodule