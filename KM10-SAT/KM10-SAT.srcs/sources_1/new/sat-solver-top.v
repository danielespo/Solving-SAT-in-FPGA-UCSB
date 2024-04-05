module sat_solver_top #(
    parameter NUM_CLAUSES = 20,
    parameter LITERALS_PER_CLAUSE = 3,
    parameter LITERAL_ADDRESS_WIDTH = 11
)
(
    input clk,
    input reset,
)

wire [LITERAL_ADDRESS_WIDTH:0] literal; // with negation bit
wire [LITERAL_ADDRESS_WIDTH:0] clause [LITERALS_PER_CLAUSE-1:0]; // clause from processing

clause_processor #(
    NUM_CLAUSES,
    LITERALS_PER_CLAUSE,
    LITERAL_ADDRESS_WIDTH
) c_proc (
    .clk(clk),
    .reset(reset),
    .literal_i(literal),
    .clause_o(clause)
)

clause_selector #(
    NUM_CLAUSES,
    LITERALS_PER_CLAUSE,
    LITERAL_ADDRESS_WIDTH
) c_sel (
    .clk(clk),
    .reset(reset),
    .literal_o(literal),
    .clause_i(clause)
)


endmodule