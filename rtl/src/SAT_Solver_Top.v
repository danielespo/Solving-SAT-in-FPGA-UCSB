/*
Clause_Processor.v
Author: Zeiler Randall-Reed

Description:
This is the true top module that would have allowed Clause_Processor.v and Clause_Selector.v
to work together. 

Notes:
- This module was created without an understanding of Vivado's block diagram system
- It is likely obsolete given the transition towards block diagrams over written top modules
- It may still be helpful once we get to pipelining
*/
module SAT_Solver_Top #(
    parameter MAX_CLAUSES_PER_VARIABLE = 20,
    parameter NSAT = 3,
    parameter LITERAL_ADDRESS_WIDTH = 11
)
(
    input clk,
    input reset,
)

wire [LITERAL_ADDRESS_WIDTH:0] literal; // with negation bit
wire [LITERAL_ADDRESS_WIDTH:0] clause [NSAT-1:0]; // clause from processing

clause_processor #(
    .MAX_CLAUSES_PER_VARIABLE(MAX_CLAUSES_PER_VARIABLE),
    .NSAT(NSAT),
    .LITERAL_ADDRESS_WIDTH(LITERAL_ADDRESS_WIDTH)
) c_proc (
    .clk(clk),
    .reset(reset),
    .literal_i(literal),
    .clause_o(clause)
)

clause_selector #(
    .MAX_CLAUSES_PER_VARIABLE(MAX_CLAUSES_PER_VARIABLE),
    .NSAT(NSAT),
    .LITERAL_ADDRESS_WIDTH(LITERAL_ADDRESS_WIDTH)
) c_sel (
    .clk(clk),
    .reset(reset),
    .literal_o(literal),
    .clause_i(clause)
)


endmodule