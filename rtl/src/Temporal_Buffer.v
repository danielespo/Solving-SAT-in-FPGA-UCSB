/*
Temporal_Buffer.v
Author: Zeiler Randall-Reed

Description:
To remove redundency, this module only needs to store the two literals from the clause table for 
each flip. The other literal is common to all the temporal buffers and can therefore be stored in 
the temporal buffer wrapper. 

Generally, this module stores an (NSAT-1) column by NSAT row table of literals. The rows correspond
to each flip, and the columns to the (NSAT-1) literals from the clause table. The (NSAT-1) clause 
table literals in this table can be accessed by writing the index of the flip to the read_index_i 
port.

OPTIONAL IMPLEMENTATION:
 *  The literal that was chosen to be flipped is common to all of the clauses for a given flip. 
 *  Within the temporal buffer wrapper, the set of NSAT flipped literals is stored in a special 
 *  instance of this module where SIZE = 1 instead of NSAT-1

Notes:
- this module only deals with data. controller will set valid flags.
- this module only handles the literals from the clause table

Testing:
- This module will be tested with the Temporal Buffer Wrapper
*/

module Temporal_Buffer #(
    parameter NSAT = 3,
    parameter LAW = 11,  // LAW = LITERAL_ADDRESS_WIDTH
    parameter NSAT_BITS = 2,
    parameter SIZE = 2
)(
    input                           clk,            // Clock signal
    input                           reset,          // Reset signal

    input [NSAT_BITS-1:0]           write_index_i,  // which flip is currently being evaluated
    input                           write_en_i,     // write enable signal
    input [SIZE*(LAW+1)-1:0]        literals_i,     // clause_table literals input by literals because need to put selected literal together with clause_table literals

    input [NSAT_BITS-1:0]           read_index_i,   // which flip was selected by the heuristic selector
    output reg [SIZE*(LAW+1)-1:0]   literals_o      // output clause with selected flip if broken
);

integer i,j;

/* Internal Signals */
reg [SIZE*(LAW+1)-1:0] stored_literals [NSAT-1:0]; 

/* Logic */
always @(posedge clk) begin
    if(reset) begin
        for(i = 0; i < NSAT; i = i + 1) begin
            stored_literals[i] <= 0;
        end
    end else begin
        if(write_en_i) stored_literals[write_index_i] <= literals_i;
        if(read_index_i == 2) literals_o <= literals_i; 
        if(read_index_i != 2) literals_o <= stored_literals[read_index_i];
    end
end


endmodule