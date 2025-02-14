/*
Version: 1.0
Unsat_Clause_Selector.v

Author V1.0: Zeiler Randall-Reed
Author V1.1: Zeiler Randall-Reed
Author V1.2: Zeiler Randall-Reed
Author V2.0: Zeiler Randall-Reed
Author V2.1: Zeiler Randall-Reed

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
V2.0
- testbench in progresss
V2.1
- stress test passed
- case tests in progress

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
     - 8/30/2024
    testbench started

V2.1 - 9/10/2024
    changed the way the unsat buffer counter is incremented/decremented
    added a debug signal for division by zero
    fixed write_disable_i logic

    9/11/2024
    naming updates
*/

module Unsat_Clause_Selector # (
    parameter BUFFER_DEPTH = 2048, // must be power of 2
    parameter RANDOM_NUM_WIDTH = 18,
    parameter M_TABLE_WIDTH = 32,
    parameter NSAT = 3,
    parameter LITERAL_ADDRESS_WIDTH = 12,
    localparam BUF_ADDR_WIDTH = $clog2(BUFFER_DEPTH)
)(
    input clk_i,
    input rst_i,

    // control signals maybe?
    input setup_i, 
    // output ready_o, 

    // loading Unsat Buffer Clauses
    input                                        ucb_setup_wr_en_i,
    input [BUF_ADDR_WIDTH - 1 : 0]               ucb_setup_addr_i,
    input [NSAT * LITERAL_ADDRESS_WIDTH - 1 : 0] ucb_setup_data_i,

    // controller signals
    input       request_i, // should be high for one clock cycle before G1 (first E1)
    input       write_disable_i, // should be high if FIFO_last is written to clause register
    input       clear_debug_DIV_BY_ZERO_i, 
    output wire debug_DIV_BY_ZERO_o,

    // fifo signals
    input fifo_empty_i,
    input [NSAT * LITERAL_ADDRESS_WIDTH - 1 : 0] fifo_clause_i,

    // prng signal
    input [RANDOM_NUM_WIDTH - 1 : 0] random_i,

    // outputs
    output wire [BUF_ADDR_WIDTH - 1 : 0]               buffer_count_o,
    output wire [NSAT * LITERAL_ADDRESS_WIDTH - 1 : 0] selected_o,
    output wire                                        ucb_overflow_o
);

localparam RAN_WIDTH = RANDOM_NUM_WIDTH;
localparam MT_WIDTH = M_TABLE_WIDTH;
localparam LIT_ADDR_WIDTH = LITERAL_ADDRESS_WIDTH;
localparam CLAUSE_WIDTH = NSAT * LIT_ADDR_WIDTH;

// unsat buffer signals
    reg [BUF_ADDR_WIDTH : 0] ucb_count;
    assign buffer_count_o = ucb_count[BUF_ADDR_WIDTH - 1 : 0];
    assign ucb_overflow_o = ucb_count[BUF_ADDR_WIDTH];

    wire ucb_en, ucb_wr_en;
    wire [BUF_ADDR_WIDTH - 1 : 0] ucb_addr;
    wire [CLAUSE_WIDTH - 1 : 0] ucb_data_in;
    wire [CLAUSE_WIDTH - 1 : 0] ucb_data_out;

    wire [BUF_ADDR_WIDTH - 1 : 0] ucb_last_addr;
    wire [CLAUSE_WIDTH - 1 : 0] ucb_last_data;

// selection internal signals
    reg [RAN_WIDTH + M_TABLE_WIDTH - 1 : 0] product_q2;
    reg [RAN_WIDTH - 1 : 0] random_number_q1, random_number_q2;
    reg [BUF_ADDR_WIDTH - 1 : 0] buf_count_q1, buf_count_q2;
    reg [BUF_ADDR_WIDTH - 1 : 0] selection_q3;
    reg request_q1, request_q2, request_q3, request_q4;

// m table signals
    wire mt_en;
    wire [BUF_ADDR_WIDTH - 1 : 0] mt_addr;
    wire mt_clear_debug_DIV_BY_ZERO;
    wire [MT_WIDTH - 1 : 0] mt_data_o;
    wire mt_debug_DIV_BY_ZERO;

// unsat buffer instantiation
    assign ucb_en = setup_i ? 
                        1'b1: 
                        ~write_disable_i;
    assign ucb_wr_en = setup_i ? 
                        ucb_setup_wr_en_i: 
                        fifo_empty_i ?
                            request_q3 ?
                                !(selection_q3 == ucb_last_addr): 
                                0 :  
                            1;
    assign ucb_addr = setup_i ? 
                        ucb_setup_addr_i: 
                        request_q3 ? 
                            selection_q3: 
                            ucb_count;
    assign ucb_data_in = setup_i ? 
                        ucb_setup_data_i: 
                        fifo_empty_i ? 
                            ucb_last_data: 
                            fifo_clause_i;
    assign ucb_last_addr = ucb_count - 1;

    Unsat_Clause_Buffer #(
        .NSAT(NSAT),
        .LITERAL_ADDRESS_WIDTH(LIT_ADDR_WIDTH),
        .DEPTH(BUFFER_DEPTH)
    ) unsat_buffer (
        .clk_i(clk_i),
        .a_en_i(ucb_en),
        .b_en_i(1'b1),
        .a_wr_en_i(ucb_wr_en),
        .b_wr_en_i(1'b0),
        .a_addr_i(ucb_addr),
        .b_addr_i(ucb_last_addr),
        .a_data_i(ucb_data_in),
        .b_data_i(),
        .a_data_o(ucb_data_out),
        .b_data_o(ucb_last_data)
    );

    assign selected_o = request_q4 ? ucb_data_out : {CLAUSE_WIDTH{1'bx}};

// unsat buffer counter logic
    always @(posedge clk_i) begin
        if(rst_i) begin
            ucb_count <= 0;
        end else begin
            if (setup_i & ucb_setup_wr_en_i)     ucb_count <= ucb_count + 1; // increment counter during setup
            else if(~ucb_en)                     ucb_count <= ucb_count;     // if buffer is not enabled, do nothing
            else if(~fifo_empty_i & ~request_q3) ucb_count <= ucb_count + 1; // if fifo not empty and no selection (0R 1W)
            else if(fifo_empty_i & request_q3)   ucb_count <= ucb_count - 1; // if fifo empty and selection is last address (1R 0W)
            else if(fifo_empty_i & ~request_q3)  ucb_count <= ucb_count;     // if fifo not empty and we're selecting (1R 1W)
            else if(~fifo_empty_i & request_q3)  ucb_count <= ucb_count;     // if fifo empty and no selection (0R 0W)
        end
    end

// 1/m table instantiation
    assign mt_addr = ucb_count;
    assign mt_en = 1; //setup_i ? 1 : mt_en_i;
    assign mt_clear_debug_DIV_BY_ZERO = clear_debug_DIV_BY_ZERO_i;
    assign debug_DIV_BY_ZERO_o = mt_debug_DIV_BY_ZERO;

    // 1/m table (fixed point - all 32 bits are fractional, at index i, the value is 1/(i+1))
    M_Table #(
        .BUFFER_DEPTH(BUFFER_DEPTH),
        .M_TABLE_WIDTH(MT_WIDTH),
        .M_TABLE_NAME("/home/dae/Solving-SAT-in-FPGA-UCSB/rtl/mem/M_table_roundup.mem")
    ) m_table (
        .clk_i(clk_i),
        .en_i(mt_en),
        .addr_i(mt_addr),
        .data_o(mt_data_o),
        .clear_debug_DIV_BY_ZERO_i(mt_clear_debug_DIV_BY_ZERO),
        .debug_DIV_BY_ZERO_o(mt_debug_DIV_BY_ZERO)
    );

// selection registers and mod calculation     
    always @(posedge clk_i) begin
        if(rst_i) begin
            random_number_q1 <= 0;
            random_number_q2 <= 0;
            buf_count_q1 <= 0;
            buf_count_q2 <= 0;
            product_q2 <= 0;
            selection_q3 <= 0;
            request_q1 <= 0;
            request_q2 <= 0;
            request_q3 <= 0;
            request_q4 <= 0;
        end else begin // NR mod m = NR - (NR/m) * m
            // stage 1 (E1)
            random_number_q1 <= random_i;
            buf_count_q1 <= ucb_count;
            request_q1 <= request_i;
            // stage 2
            random_number_q2 <= random_number_q1;
            buf_count_q2 <= buf_count_q1;
            product_q2 <= random_number_q1 * mt_data_o;
            request_q2 <= request_q1;
            // stage 3 
            selection_q3 <= (buf_count_q2 == 1) ? 0 : random_number_q2 - ((product_q2 >> MT_WIDTH) * buf_count_q2); // changed from vector range to bitshift
            request_q3 <= request_q2;
            // stage 4
            request_q4 <= request_q3;
        end
    end

endmodule