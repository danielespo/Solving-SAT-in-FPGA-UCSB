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
    parameter M_TABLE_WIDTH = 32,
    parameter M_TABLE_NAME = "M_table_roundup.mem"
)(
    input clk,
    input en,
    input [$clog2(BUFFER_DEPTH) : 0] addr_i,
    input clear_debug_DIV_BY_ZERO,
    output reg [M_TABLE_WIDTH - 1 : 0] data_o,
    output reg debug_DIV_BY_ZERO
);
    //(* rom_style = "block" *) reg [M_TABLE_WIDTH - 1 : 0] data;
    localparam BUFFER_ADDR_WIDTH = $clog2(BUFFER_DEPTH);
    
    // 1/m table (fixed point - all 32 bits are fractional, at index i, the value is 1/(i))
    reg [M_TABLE_WIDTH - 1 : 0] m_table [0 : BUFFER_DEPTH - 1];

    // initial register data and loading 1/M-table
    initial begin
        debug_DIV_BY_ZERO = 0;
        data_o = 0;
        $readmemh(M_TABLE_NAME, m_table);
    end

    wire [BUFFER_ADDR_WIDTH - 1 : 0] addr_adjusted;
    assign addr_adjusted = addr_i - 1; 

    // 1/m table (fixed point)
    always @(posedge clk) begin
        if(en) begin
            data_o <= |addr_i ? m_table[addr_i - 1] : {M_TABLE_WIDTH{1'bx}};
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
