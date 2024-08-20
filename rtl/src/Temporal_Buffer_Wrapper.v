/*
Temporal_Buffer_Wrapper.v
Author: Zeiler Randall-Reed

Description: 
This module provides a way to procedurally generate temporal buffer modules and interface with 
a parameterizable number of them.

Notes:
- 

Testing:
- testbench created 5/10/24 but is incomplete
- testing started 7/17/24
- testbench pass 7/21/24 (CHANGES MADE SINCE)
- testbench pass 8/05/24
*/

module Temporal_Buffer_Wrapper #(
    parameter NSAT = 3,
    parameter LAW = 11, // LAW - LITERAL_ADDRESS_WIDTH
    parameter MCPV = 20 // MCPV - MAX_CLAUSES_PER_VARIABLE
)(
    input                                   clk,                // Clock signal
    input                                   reset,              // Reset signal

    input   [$clog2(NSAT)-1:0]              write_index_i,      // which flip is currently being evaluated
    input                                   write_en_i,         // write enable signal
    input   [(NSAT-1)*MCPV*(LAW+1)-1:0]     literals_multi_i,   // literals from clause table for each flip

    input   [$clog2(NSAT)-1:0]              read_index_i,       // which flip was selected by the heuristic selector
    output  [(NSAT-1)*MCPV*(LAW+1)-1:0]     literals_multi_o    // literals from clause table for selected flip
);

    localparam NSAT_BITS = $clog2(NSAT);

    // signals 
    genvar index;
    
    generate
        for(index = 0; index < MCPV; index = index + 1) begin : gen_temp_buf
            Temporal_Buffer #(
                .NSAT(NSAT),
                .LAW(LAW),
                .SIZE(NSAT-1)
            ) TB (
                .clk(clk),
                .reset(reset),
                .write_index_i(write_index_i),
                .write_en_i(write_en_i),
                .literals_i(literals_multi_i[index*(NSAT-1)*(LAW+1)+:(NSAT-1)*(LAW+1)]),
                .read_index_i(read_index_i),
                .literals_o(literals_multi_o[index*(NSAT-1)*(LAW+1)+:(NSAT-1)*(LAW+1)])
            );
        end
    endgenerate

    
endmodule
