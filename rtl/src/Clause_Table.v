/* ----------------------------------------------------
Version: 2.6
Clause_Table.v
V1.0 Author: Zeiler Randall-Reed
V2.0 Author: Barry Wang
V2.5 Author: Harim Choe
V2.6 Author: [Your Name]

Description:
    The clause table holds the information for all of the clauses in the current problem.
    The table now supports loading its memory contents from a mem file (CT_MEM_FILE) via $readmemh.
    
    The table is organized such that each row contains a packed 480-bit word (20 candidate entries × 24 bits).

Notes:
    The Clause Table is implemented with a simple dual port memory. The write port will only be used
    before the accelerator starts running, and the mem will behave as a ROM afterwards.
    
-----------------------------------------------------*/

module Clause_Table #(
    parameter CLAUSE_COUNT = 20,   // Number of candidate entries per literal.
    parameter DEPTH = 2048,        // Number of rows.
    parameter VARIABLE_ADDRESS_WIDTH = 11,
    parameter NSAT = 3,            // Number of literals in each clause (3-SAT)
    // CT_WIDTH is calculated so that each row is 20 entries × 24 bits = 480 bits.
    localparam CT_WIDTH = 24 * CLAUSE_COUNT,
    parameter CT_MEM_FILE = "../../Python-Code/ct.mem"  // mem file for Clause Table initialization
)(
    input clk_i, 
    input                                  wr_en_i,
    input [VARIABLE_ADDRESS_WIDTH - 1 : 0] wr_addr_i, 
    input [CT_WIDTH - 1 : 0]               wr_clauses_i,
    input [VARIABLE_ADDRESS_WIDTH - 1 : 0] rd_addr_i,
    output reg [CT_WIDTH - 1 : 0]          clauses_o
);
    reg [CT_WIDTH - 1 : 0] mem [0 : DEPTH - 1]; // each row is 480 bits.

    integer k;
    initial begin
        // Reset memory to 0 for safety.
        for (k = 0; k < DEPTH; k = k + 1) begin
            mem[k] = {CT_WIDTH{1'b0}};
        end 
        // Load memory contents from file.
        $readmemh(CT_MEM_FILE, mem);
        // $display("Clause Table: Loaded mem file %s at time %0t", CT_MEM_FILE, $time);
    end 

    always @(posedge clk_i) begin
        if (wr_en_i) begin
            mem[wr_addr_i] <= wr_clauses_i;
            // $display("Clause_Table: Written mem[%0d] = 0x%h", wr_addr_i, wr_clauses_i);
        end

        if (wr_en_i && (rd_addr_i == wr_addr_i)) begin
            clauses_o <= wr_clauses_i;
        end else begin
            clauses_o <= mem[rd_addr_i];
        end
        // $display("Clause_Table: Read mem[%0d] = 0x%h", rd_addr_i, clauses_o);
    end

endmodule
