/*
Version: 2.5
Clause_Table.v

V1.0 Author: Zeiler Randall-Reed
V2.0 Author: Barry Wang
V2.5 Author: Harim Choe

Description:
    The clause table holds the information for all of the clauses in the current problem. The 
    address and negation bit of a literal is sent to the address translation table which returns
    an index and mask. The index is used to access this table by its row, which returns the 
    addresses and negation bits of the other literals in every clause that the initial literal 
    is in.
    
    This table only has 2048 entries by default, despite there being 4096 address + negation 
    bit pairs (12^2). This is because multiple clauses can be packed into the same row of the 
    table, and must be to minimize space impact. The mask from the address translation table is
    used as an enable bit for the subsequent clause evaluators so that only the two literals  
    with negation bits associated with the initially requested literal and negation bit are 
    checked.

Notes:
    The Clause Table is implemented with a simple dual port memory to acommodate the zynq 7000
    native. The write port will only be used before the accelerator starts running and the mem
    will behave as a rom afterwards. 
XI
Testing:
    None
    
Change Log:

2024/07/24 - Barry Wang
    Remake Clause_Register

2024/09/11 - Zeiler Randall-Reed
    naming changes

2025/01/13 - Harim Choe
    reset memory of clause table to 0 and added display for debugging (use it for axi simulation)
*/

module Clause_Table #(
    // Number of clauses in the clause table
    parameter CLAUSE_COUNT = 20,
    parameter DEPTH = 2048,
    parameter VARIABLE_ADDRESS_WIDTH = 11,
    parameter NSAT = 3,
    localparam CT_WIDTH = (VARIABLE_ADDRESS_WIDTH + 1) * (NSAT - 1) * CLAUSE_COUNT
)(
    input clk_i, 
    
    input                                  axi_wr_en_i,
    input [VARIABLE_ADDRESS_WIDTH - 1 : 0] axi_wr_addr_i, 
    input [CT_WIDTH - 1 : 0]               axi_wr_clauses_i,

    input [VARIABLE_ADDRESS_WIDTH - 1 : 0] rd_addr_i,
    output reg [CT_WIDTH - 1 : 0]          clauses_o
);
    reg [CT_WIDTH - 1 : 0] mem [0 : DEPTH - 1]; // reg [479:0] mem [0:2047]

    integer k;

    // reset memory to 0
    initial begin
        for (k = 0; k < DEPTH; k = k + 1) begin
            mem[k] = 0;
        end
    end

    always @ (posedge clk_i) begin
        if (axi_wr_en_i) begin
            mem[axi_wr_addr_i] <= axi_wr_clauses_i;
            $display("Clause_Table: Written mem[%0d] = 0x%h", axi_wr_addr_i, axi_wr_clauses_i);
        end
        clauses_o <= mem[rd_addr_i];
        $display("Clause_Table: Read mem[%0d] = 0x%h", rd_addr_i, mem[rd_addr_i]);
    end
    
endmodule
