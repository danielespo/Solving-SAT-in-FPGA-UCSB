/*
Version: 1.0
Unsat_Clause_Selector.v

Author V1.0: Zeiler Randall-Reed
Author V1.1: Zeiler Randall-Reed
Author V1.2: Zeiler Randall-Reed

Description:
This module handles the logic to select which index of the Unsatisfied Clause Buffer to read from.
- Synchronous load of 1/m table (not implemented)
- Asynchronous calculation of selected index

Notes:

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

module Unsat_Clause_Selector # (
    parameter BUFFER_DEPTH = 2048,
    parameter RANDOM_NUM_WIDTH = 18,
    parameter RANDOM_OFFSET = 10,
    parameter M_TABLE_WIDTH = 32
)(
    input clk,
    input reset,

    // loading 1/m table signals
    input setup, output ready, // control signals maybe?
    input [$clog2(BUFFER_DEPTH) - 1 : 0] write_addr_i,
    input [M_TABLE_WIDTH - 1 : 0] mt_data_i,

    // selecting index signals 
    // input [1 : 0] select_stage_i, // 00 = setup, 01 = step 1 (1/m multiplication), 10 = step 2 (mod m), 11 = idle
    input mt_en_i,
    input [$clog2(BUFFER_DEPTH) - 1 : 0] unsat_buffer_count_i,
    input [31 : 0] random_i,
    output reg [$clog2(BUFFER_DEPTH) - 1 : 0] selected_o
);

localparam RAN_WIDTH = RANDOM_NUM_WIDTH;
localparam BUF_ADDR_WIDTH = $clog2(BUFFER_DEPTH);
localparam MT_WIDTH = M_TABLE_WIDTH;

// m table signals
wire mt_en, mt_we;
wire [BUF_ADDR_WIDTH - 1 : 0] mt_addr_i;
wire [MT_WIDTH - 1 : 0] mt_data_o;

assign mt_addr_i = setup ? write_addr_i : unsat_buffer_count_i;
assign mt_en = setup ? 1 : mt_en_i;
assign mt_we = setup;

// 1/m table (fixed point - all 32 bits are fractional, at index i, the value is 1/(i+1))
M_Table #(
    .BUFFER_DEPTH(BUFFER_DEPTH),
    .M_TABLE_WIDTH(MT_WIDTH)
) m_table (
    .clk(clk),
    .en(mt_en),
    .we(mt_we),
    .addr_i(mt_addr_i),
    .data_i(mt_data_i),
    .data_o(mt_data_o)
);

//internal regs
reg [RAN_WIDTH + M_TABLE_WIDTH - 1 : 0] product2;
reg [RAN_WIDTH - 1 : 0] N_R1, N_R2;
reg [BUF_ADDR_WIDTH - 1 : 0] m1, m2;

always @(posedge clk) begin
    if(reset) begin
        product2 <= 0;
        //select_o <= 0;
        N_R1 <= 0;
        N_R2 <= 0;
        m1 <= 0;
        m2 <= 0;
    end else begin
        // a mod b = a - (a/b) * b
        // stage 1
        N_R1 <= random_i[RANDOM_OFFSET +: RANDOM_NUM_WIDTH];
        m1 <= unsat_buffer_count_i;
        // stage 2
        m2 <= m1;
        N_R2 <= N_R1;
        product2 <= N_R1 * mt_data_o;
        // stage 3 
        selected_o <= (m2 == 1) ? 0 : N_R2 - (product2[M_TABLE_WIDTH +: RAN_WIDTH] * m2);


        // case(select_stage_i)
        //     2'b00: begin
        //         // setup / read from table
        //         // mt_en is high during setup
        //         N_R <= random_i[RANDOM_OFFSET +: RANDOM_NUM_WIDTH];
        //         m <= unsat_buffer_count_i;
        //     end
        //     2'b01: begin
        //         // r = N_R * m_table[m]
        //         product2 <= N_R * mt_data_o;
        //     end
        //     2'b10: begin
        //         // r = N_R - (r * m) = N_R mod m
        //         selected_o <= N_R - (quotient * m); 
        //     end
        //     2'b11: begin
        //         // idle / reset
        //         product2 <= 0;
        //         select_o <= 0;
        //         N_R <= 0;
        //         m <= 0;
        //     end
        // endcase
    end
end

endmodule
