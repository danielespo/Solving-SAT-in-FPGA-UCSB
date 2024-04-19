module UNSAT_Clause_Buffer # (
    parameter NSAT = 3,
    parameter LITERAL_ADDRESS_WIDTH = 11
)(
    input clk,
    input reset,
    input [LITERAL_ADDRESS_WIDTH:0] clause_i [0: NSAT-1],
    
    output [LITERAL_ADDRESS_WIDTH:0] clause_o [0: NSAT-1]
);


endmodule