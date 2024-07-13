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
    parameter NSAT_BITS = $clog2(NSAT)
)(
    input                               clk,                    // Clock signal
    input                               reset,                  // Reset signal
    input [LITERAL_ADDRESS_WIDTH:0]     flipped_literal_i,      // flipped input literal to be combined with clause_table literals 
    input [LITERAL_ADDRESS_WIDTH:0]     clause_table_literals_i [NSAT-2:0], // clause_table literals input by literals because need to put selected literal together with clause_table literals
    input                               isBroken_i,             // is the clause broken

    input [NSAT_BITS-1:0]               current_flip_i,        // which flip is currently being evaluated

    input [NSAT_BITS-1:0]               heuristic_selection_i,  // which flip was selected by the heuristic selector

    output reg [LITERAL_ADDRESS_WIDTH:0] clause_o [NSAT-1:0]    // output clause with selected flip if broken
);

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
        if(isBroken_i) begin
            stored_clauses[current_flip_i][0] <= flipped_literal_i;
            for(integer i = 1; i < NSAT; i = i + 1) begin
                stored_clauses[current_flip_i][i] <= clause_table_literals_i[i-1];
            end
        end
    end
end

/* Output Assignment */
always @(heuristic_selection_i) begin
    for(integer i = 0; i < NSAT; i = i + 1) begin
        clause_o[i] = stored_clauses[heuristic_selection_i][i];
    end
end

endmodule