/*
Version: 1.0
Unsat_Clause_Selector.v

Author V1.0: Zeiler Randall-Reed
Author V1.1: Zeiler Randall-Reed
Author V1.2: Zeiler Randall-Reed
Author V2.0: Zeiler Randall-Reed

Description:
This module handles the data being written to and from the Unsatisfied Clause Buffer. This includes
the calculation of which address to read from (NR mod m) and how to fill the index read in this 
process. It also handles the following:
- Synchronous load of 1/m table (if this needs to be loaded, ideally it should be ROM that is 
  loaded during synthesis)
- Synchronous load of the unsat buffer (while the problem is being loaded)
- Calculation of the index to read from the unsat buffer
- A register to keep track of the number of unsat clauses
- Exception handling for when the number of unsat clauses is 0 or 1
- Data I/O for the unsat buffer

Notes:
- if unexpected selection occurs, there may be very rare rounding error cases that were missed in 
testing

Testing:
V1.0
- testbench in progress
V1.1
- most tests passed, rounding issues
V1.2
- all tests passed, rounding issues fixed

Change Log:
V1.0 - 8/22/2024
    Created file Unsat_Clause_Selector.v
    Added 1/m table module
    Logic to calculate index
    Added potential control signals
V1.1 - 8/23/2024
    fixed m-table size issue
    fixed naming problem
    fixed integer division algorithm issue (incorrect range)
V1.2 - 8/26/2024
    added exception for when unsat_buffer_count_i = 1 because of unexpected behavior
    m table must be populated with fixed point values rounded UP instead of down or to nearest

V2.0 - 8/29/2024
    added counter logic to keep track of the number of unsat clauses
    added unsat buffer signals and instantiation
    modified selection pipeline to keep track of requests to read the buffer
*/

module Unsat_Clause_Selector # (
    parameter BUFFER_DEPTH = 2048,
    parameter RANDOM_NUM_WIDTH = 18,
    parameter RANDOM_OFFSET = 10,
    parameter M_TABLE_WIDTH = 32,
    parameter NSAT = 3,
    parameter LITERAL_ADDRESS_WIDTH = 12
)(
    input clk,
    input reset,

    input setup, output ready, // control signals maybe?
    // loading 1/m table signals
    input [$clog2(BUFFER_DEPTH) - 1 : 0]            mt_setup_addr_i,
    input [M_TABLE_WIDTH - 1 : 0]                   mt_setup_data_i,
    // loading Unsat Buffer Clauses
    input [$clog2(BUFFER_DEPTH) - 1 : 0]            ucb_setup_addr_i,
    input [NSAT * LITERAL_ADDRESS_WIDTH - 1 : 0]    ucb_setup_data_i,

    // controller signals
    input request_i, // should be high for one clock cycle before G1 (first E1)
    input write_disable_i, // should be high if FIFO_last is written to clause register

    // fifo signals
    input fifo_empty_i,
    input [NSAT * LITERAL_ADDRESS_WIDTH - 1 : 0] fifo_clause_i,

    // prng signal
    input [31 : 0] random_i,

    output reg [NSAT * LITERAL_ADDRESS_WIDTH - 1 : 0] selected_o
);

localparam RAN_WIDTH = RANDOM_NUM_WIDTH;
localparam BUF_ADDR_WIDTH = $clog2(BUFFER_DEPTH);
localparam MT_WIDTH = M_TABLE_WIDTH;
localparam LIT_ADDR_WIDTH = LITERAL_ADDRESS_WIDTH;
localparam CLAUSE_WIDTH = NSAT * LIT_ADDR_WIDTH;

// unsat buffer signals
    reg [BUF_ADDR_WIDTH - 1 : 0] ucb_count;

    wire ucb_en, ucb_we;
    wire [BUF_ADDR_WIDTH - 1 : 0] ucb_addr;
    wire [CLAUSE_WIDTH - 1 : 0] ucb_data_in;
    wire [CLAUSE_WIDTH - 1 : 0] ucb_data_out;

    wire [BUF_ADDR_WIDTH - 1 : 0] ucb_last_addr;
    wire [CLAUSE_WIDTH - 1 : 0] ucb_last_data;

// selection internal signals
    reg [RAN_WIDTH + M_TABLE_WIDTH - 1 : 0] product2;
    reg [RAN_WIDTH - 1 : 0] N_R1, N_R2;
    reg [BUF_ADDR_WIDTH - 1 : 0] m1, m2;
    reg [BUF_ADDR_WIDTH - 1 : 0] selection;
    reg request1, request2, request3;

// m table signals
    wire mt_en, mt_we;
    wire [BUF_ADDR_WIDTH - 1 : 0] mt_addr;
    wire [MT_WIDTH - 1 : 0] mt_data_o;

// unsat buffer instantiation
    assign ucb_en = setup ? 1 : ~write_disable_i;
    assign ucb_we = setup ? 1 : (fifo_empty_i ? (selection != ucb_last_addr) : 1);
    assign ucb_addr = setup ? ucb_setup_addr_i : (request3 ? selection : ucb_count);
    assign ucb_data_in = setup ? ucb_setup_data_i : (fifo_empty_i ? ucb_last_data : fifo_clause_i);
    assign ucb_last_addr = ucb_count - 1;

    Unsat_Clause_Buffer #(
        .NSAT(NSAT),
        .VARIABLE_ADDRESS_(LIT_ADDR_WIDTH),
        .DEPTH(BUFFER_DEPTH)
    ) unsat_buffer (
        .clk_a(clk),
        .clk_b(clk),
        .en_a(ucb_en),
        .en_b(1),
        .we_a(ucb_we),
        .we_b(0),
        .addr_a(ucb_addr),
        .addr_b(ucb_last_addr),
        .din_a(ucb_data_in),
        .din_b(),
        .dout_a(ucb_data_out),
        .dout_b(ucb_last_data)
    );

// 1/m table instantiation
    assign mt_addr = setup ? mt_setup_addr_i : ucb_count;
    assign mt_en = 1; //setup ? 1 : mt_en_i;
    assign mt_we = setup;

    // 1/m table (fixed point - all 32 bits are fractional, at index i, the value is 1/(i+1))
    M_Table #(
        .BUFFER_DEPTH(BUFFER_DEPTH),
        .M_TABLE_WIDTH(MT_WIDTH)
    ) m_table (
        .clk(clk),
        .en(mt_en),
        .we(mt_we),
        .addr_i(mt_addr),
        .data_i(mt_setup_data_i),
        .data_o(mt_data_o)
    );

// unsat buffer counter logic
    always @(posedge clk) begin
        if(reset) begin
            ucb_count <= 0;
        end else begin
            if(ucb_we & ~request3) ucb_count <= ucb_count + 1;
            else if(~ucb_we & request3) ucb_count <= ucb_count - 1;
            else if(ucb_we & request3) ucb_count <= ucb_count;
        end
    end

// selection logic     
    always @(posedge clk) begin
        if(reset) begin
            N_R1 <= 0;
            m1 <= 0;
            request1 <= 0;
            N_R2 <= 0;
            m2 <= 0;
            product2 <= 0;
            request2 <= 0;
            selection <= 0;
            request3 <= 0;
        end else begin // a mod b = a - (a/b) * b
            // stage 1 (E1)
            N_R1 <= random_i[RANDOM_OFFSET +: RANDOM_NUM_WIDTH];
            m1 <= ucb_count;
            request1 <= request_i;
            // stage 2
            N_R2 <= N_R1;
            m2 <= m1;
            product2 <= N_R1 * mt_data_o;
            request2 <= request1;
            // stage 3 
            selection <= (m2 == 1) ? 0 : N_R2 - (product2[M_TABLE_WIDTH +: RAN_WIDTH] * m2);
            request3 <= request2;
        end
    end

endmodule
