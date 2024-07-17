/*
Temporal_Buffer.v
Author: Zeiler Randall-Reed

Description:
For each variable in the SAT problem (3), there is a row of the temporal buffer. Each row stores 
the clauses that are affected by one of the literal flips. One of the flips is determined by the
heuristic selector, and the corresponding clause is sent to the output. 
This module works interfaces with the rest of the design through the temporal buffer wrapper.

Notes:
- [TODO] figure out how the data about whether there is a clause, if it is broken or not, and more
    is stored and transfered. This will likely mean changes to either the temporal buffer wrapper 
    or the FIFO tree (probably the former).

Testing:
- This module will be tested with the Temporal Buffer Wrapper
*/

module Temporal_Buffer #(
    parameter NSAT = 3,
    parameter LITERAL_ADDRESS_WIDTH = 11,
    parameter NSAT_BITS = 2
)(
    input                               clk,                    // Clock signal
    input                               reset,                  // Reset signal

    input [NSAT_BITS-1:0]               write_index_i,        // which flip is currently being evaluated
    input [LITERAL_ADDRESS_WIDTH:0]     flipped_literal_i,      // flipped input literal to be combined with clause_table literals 
    input [(NSAT-1)*(LITERAL_ADDRESS_WIDTH+1)-1:0] clause_table_literals_i, // clause_table literals input by literals because need to put selected literal together with clause_table literals

    input [NSAT_BITS-1:0]               read_index_i,  // which flip was selected by the heuristic selector
    output reg [NSAT*(LITERAL_ADDRESS_WIDTH+1)-1:0] clause_o    // output clause with selected flip if broken
);

// convert inputs to packed arrays
integer i;
wire [LITERAL_ADDRESS_WIDTH:0] clause_table_literals_packed [NSAT-2:0]
for(i = 0; i < NSAT-1; i++) begin
    clause_table_literals_packed[i] = clause_table_literals_i[(i+1)*(LITERAL_ADDRESS_WIDTH+1)-1:i*(LITERAL_ADDRESS_WIDTH+1)];
end

/* Internal Signals 
 * stored_clauses: register to store the clauses
 * * stored_clauses[i][j] can be used to access the jth literal of the ith flip
*/
reg [LITERAL_ADDRESS_WIDTH:0] stored_clauses [NSAT-1:0][NSAT-1:0]; 

/* Logic */
always @(posedge clk) begin
    if(reset) begin
        for(integer i = 0; i < NSAT; i = i + 1) begin
            stored_clauses[i] <= 0;
        end
    end else begin
        stored_clauses[write_index_i][0] <= flipped_literal_i;
        for(integer i = 1; i < NSAT; i = i + 1) begin
            stored_clauses[write_index_i][i] <= clause_table_literals_packed[i-1];
        end
        for(integer i = 0; i < NSAT; i = i + 1) begin
        clause_o[(i+1)*(LITERAL_ADDRESS_WIDTH+1)-1:i*(LITERAL_ADDRESS_WIDTH+1)] = stored_clauses[read_index_i][i];
        end
    end
end

endmodule