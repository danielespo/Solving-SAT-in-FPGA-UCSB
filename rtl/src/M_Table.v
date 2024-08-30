/*
Version 1.0
M_Table.v

V0.0 Author: Zeiler Randall-Reed

Description: This module is a function table used to store the reciprocal of all possible values
  for the number of unsatisfied clauses. This is used in the modulo calculation that maps a 
  random input to an index in the unsat clause buffer. 

Notes: 
  - This module is copied from the original Unsat_Clause_Selector.v file

Testing: N/A

Change Log:
2024/08/29 - Zeiler Randall-Reed
    Created M_Table.v
    Copied from Unsat_Clause_Selector.v
*/

module M_Table #(
    parameter BUFFER_DEPTH = 2048,
    parameter M_TABLE_WIDTH = 32
)(
    input clk,
    input en, we,
    input [$clog2(BUFFER_DEPTH) - 1 : 0] addr_i,
    input [M_TABLE_WIDTH - 1 : 0] data_i,
    input clear_debug_DIV_BY_ZERO,
    output reg [M_TABLE_WIDTH : 0] data_o,
    output reg debug_DIV_BY_ZERO
);
    //(* rom_style = "block" *) reg [M_TABLE_WIDTH - 1 : 0] data;
    
    // 1/m table (fixed point - all 32 bits are fractional, at index i, the value is 1/(i))
    reg [M_TABLE_WIDTH - 1 : 0] m_table [0 : BUFFER_DEPTH];
    reg debug_DIV_BY_ZERO;
    // 1/m table (fixed point)
    always @(posedge clk) begin
        if(en) begin
            if(we) m_table[addr_i] <= data_i;
            data_o <= m_table[addr_i];
        end
    end
    // debug signal to indicate division by zero
    always @(posedge clk) begin
        if(en) begin
            if(addr_i == 0) begin
                debug_DIV_BY_ZERO <= 1;
            end else if(clear_debug_DIV_BY_ZERO) begin
                debug_DIV_BY_ZERO <= 0;
            end
        end
    end
endmodule
