// Skeleton file of the UNSAT buffer

module UNSAT_Clause_Buffer # (
    parameter NSAT = 3,
    parameter LITERAL_ADDRESS_WIDTH = 11
)(
    input clk,
    input reset,
    input [(LITERAL_ADDRESS_WIDTH+1)*NSAT - 1:0] clause_i,
    
    output [(LITERAL_ADDRESS_WIDTH+1)*NSAT - 1:0] clause_o
);

endmodule