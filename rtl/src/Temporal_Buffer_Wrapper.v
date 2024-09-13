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
    parameter LITERAL_ADDRESS_WIDTH = 12, 
    parameter MAX_CLAUSE_MEMBERSHIP = 20,
    localparam NSAT_BITS = $clog2(NSAT),
    localparam LAW = LITERAL_ADDRESS_WIDTH,
    localparam MC = MAX_CLAUSE_MEMBERSHIP
)(
    input                                   clk_i,           // Clock signal
    input                                   rst_i,           // Reset signal

    input   [NSAT_BITS - 1 : 0]             wr_index_i,      // which flip is currently being evaluated
    input                                   wr_en_i,         // write enable signal
    input   [(NSAT - 1) * MC * LAW - 1 : 0] wr_literals_mi,  // literals from clause table for each flip

    input   [NSAT_BITS - 1 : 0]             rd_index_i,      // which flip was selected by the heuristic selector
    output  [(NSAT - 1) * MC * LAW - 1 : 0] literals_mo      // literals from clause table for selected flip
);


    // signals 
    genvar n;
    
    generate
        for(n = 0; n < MC; n = n + 1) begin : gen_temp_buf
            Temporal_Buffer #(
                .NSAT(NSAT),
                .LAW(LAW),
                .SIZE(NSAT-1)
            ) TB (
                .clk_i(clk_i),
                .rst_i(rst_i),
                .wr_index_i(wr_index_i),
                .wr_en_i(wr_en_i),
                .wr_literals_i(wr_literals_mi[n * (NSAT-1) * LAW +:(NSAT-1) * LAW]),
                .rd_index_i(rd_index_i),
                .literals_o(literals_mo[n * (NSAT-1) * LAW +: (NSAT-1) * LAW])
            );
        end
    endgenerate

    
endmodule
