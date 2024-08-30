/*
Version: 0.0
Datapath.v

V0.0 Author: Zeiler Randall-Reed

Description:
This is the top module for the datapath. It instantiates all of the modules that are needed for the
SAT solver and connects them together. It has I/O for interaction with the controller and for 
loading the problem data into the solver.

Notes:
- This module is a work in progress and is missing UNSAT Clause Buffer and Selector, and more

Change Log:
8/19/2024 - Zeiler Randall-Reed
    Created Datapath.v
    Skeleton of the module created
    
*/
module Datapath #(
    parameter NSAT = 3,
    parameter NUM_VARIABLES = 2048,
    parameter MAX_CLAUSE_MEMBERSHIP = 20,
    parameter FIFO_DEPTH = 32,
    parameter UNSAT_CLAUSE_BUFFER_DEPTH = 2048,
    parameter CONTROLLER_SIGNAL_WIDTH = 13 // will change
) (
    input clk, reset,
    // controller signal : [x_xx_x_x_x_xx_x_xx_x_x]
    // CR_wren, ATT_src(2), VT_rden, VT_addr_src, VT_wren, VFS_wren(2), CFLB_wren, TB_wr_index(2), FIFO_wren, FIFO_rden 
    input [CONTROLLER_SIGNAL_WIDTH - 1 : 0] control_signal_i,
    // in progress
    
)

// local parameters
localparam VARIABLE_ADDRESS_WIDTH = $clog2(NUM_VARIABLES);      // naming change
localparam LITERAL_ADDRESS_WIDTH = VARIABLE_ADDRESS_WIDTH + 1;  // naming change
localparam CLAUSE_WIDTH = NSAT * LITERAL_ADDRESS_WIDTH;

localparam MC = MAX_CLAUSE_MEMBERSHIP;
localparam MC_BITS = $clog2(MC);
localparam NSAT_BITS = $clog2(NSAT);

// integer vars
integer i, j;
genvar n, m;

/* --- control signals --- */
wire            CR_wren;
wire [1 : 0]    ATT_src;
wire            VT_rden;
wire            VT_addr_src;
wire            VT_wren;
wire [1 : 0]    VFS_wren;
wire            CFLB_wren;
wire [1 : 0]    TB_wr_index;
wire            FIFO_wren;
wire            FIFO_rden;

assign {CR_wren, ATT_src, VT_rden, VT_addr_src, VT_wren, VFS_wren, CFLB_wren, TB_wr_index, FIFO_wren, FIFO_rden} = control_signal_i;

/* --- internal wires --- */
wire [LITERAL_ADDRESS_WIDTH - 1 : 0]    selected_literal;
wire [LITERAL_ADDRESS_WIDTH - 1 : 0]    negated_literal;

wire [VARIABLE_ADDRESS_WIDTH - 1 : 0]   att_addr_out;
wire [MC - 1 : 0]                       att_mask_out;

wire [CLAUSE_WIDTH - 1 : 0] cnlb_clause_negated;

wire [LITERAL_ADDRESS_WIDTH * (NSAT - 1) * MC - 1 : 0]  ct_clauses_out;
wire [(NSAT - 1) * MC - 1 : 0]                          ct_negation_bits;
wire [(NSAT - 1) * MC * VARIABLE_ADDRESS_WIDTH - 1 : 0] ct_variable_addresses;

wire [LITERAL_ADDRESS_WIDTH - 1 : 0]    selected_literal_flipped;
wire                                    selected_literal_flipped_neg_bit;
wire [VARIABLE_ADDRESS_WIDTH - 1 : 0]   selected_literal_flipped_addr;
assign {selected_literal_flipped_neg_bit, selected_literal_flipped_addr} = selected_literal_flipped;

wire [(NSAT - 1) * MC - 1 : 0] nb_negation_bits;

wire [(NSAT - 1) * MC - 1 : 0] vtc_value_bits

wire [(NSAT - 1) * MC * VARIABLE_ADDRESS_WIDTH - 1 : 0] tbw_literals_multi_out;

wire [MC - 1 : 0] ce1_break_bits;

wire [MC - 1 : 0] mb_mask_bits;

wire [31 : 0] random_number;

wire [MC * CLAUSE_WIDTH - 1 : 0] broken_clauses;

wire [NSAT_BITS - 1 : 0] vfs_selected;
wire [MC - 1 : 0] vfs_clause_valid_bits;


/* --- clause register --- */
wire [CLAUSE_WIDTH - 1 : 0] cr_selected_clause;

Clause_Register #(
    .NSAT(NSAT),
    .LITERAL_ADDRESS_WIDTH(LITERAL_ADDRESS_WIDTH)
) clause_register (
    .clk(clk),
    .reset(reset),
    .we(control_signal_i[0]),
    .din(),
    .dout(cr_selected_clause)
);

/* --- address translation table --- */
assign selected_literal = ATT_src[1] ? 
    (ATT_src[0] ? 
        {LITERAL_ADDRESS_WIDTH{1'bx}} : 
        cr_selected_clause[LITERAL_ADDRESS_WIDTH * 2 +: LITERAL_ADDRESS_WIDTH]) 
    : 
    (ATT_src[0] ? 
        cr_selected_clause[LITERAL_ADDRESS_WIDTH * 1 +: LITERAL_ADDRESS_WIDTH] : 
        cr_selected_clause[LITERAL_ADDRESS_WIDTH * 0 +: LITERAL_ADDRESS_WIDTH]);

assign negated_literal = {~selected_literal[LITERAL_ADDRESS_WIDTH - 1], selected_literal[LITERAL_ADDRESS_WIDTH - 2 : 0]};

Address_Translation_Table #(
    .CLAUSE_COUNT(MAX_CLAUSE_MEMBERSHIP),
    .VARIABLE_ADDRESS_WIDTH(VARIABLE_ADDRESS_WIDTH),
    .CLAUSE_TABLE_ADDRESS_WIDTH(VARIABLE_ADDRESS_WIDTH)
) address_translation_table (
    .clk(clk),
    .wr_en(),
    .wr_addr_i(),
    .data_i(),
    .rd_addr_i(negated_literal),
    .addr_o(att_addr_out),
    .mask_o(att_mask_out)
);

/* --- clause table --- */
wire [LITERAL_ADDRESS_WIDTH - 1 : 0] ct_clauses_packed [NSAT - 2 : 0][MC - 1 : 0];
generate
    for(n = 0; n < MC; n = n + 1) for(m = 0; m < NSAT - 1; m = m + 1) begin
        assign ct_clauses_packed[m][n] = ct_clauses_out[((NSAT - 1) * n + m) * LITERAL_ADDRESS_WIDTH +: LITERAL_ADDRESS_WIDTH];
    end
endgenerate

Clause_Table #(
    .CLAUSE_COUNT(MAX_CLAUSE_MEMBERSHIP),
    .DEPTH(2048),
    .VARIABLE_ADDRESS_WIDTH(VARIABLE_ADDRESS_WIDTH),
    .NSAT(NSAT)
) clause_table (
    .clk(clk),
    .we(),
    .waddr(),
    .clauses_i(),
    .raddr(att_addr_out),
    .clauses_o(ct_clauses_out)
);

generate
    for(n = 0; n < MC - 1; n = n + 1) begin
        for(m = 0; m < NSAT - 1; m = m + 1) begin
            assign ct_negation_bits[n * (NSAT - 1) + m] = ct_clauses_packed[n][m][LITERAL_ADDRESS_WIDTH - 1];
            assign ct_variable_addresses[(n * (NSAT - 1) + m) * LITERAL_ADDRESS_WIDTH +: VARIABLE_ADDRESS_WIDTH] = ct_clauses_packed[n][m][VARIABLE_ADDRESS_WIDTH - 1 : 0];
        end
    end
endgenerate

/* --- mask buffer --- */
reg [MC - 1 : 0] mask_buffer_0;
reg [MC - 1 : 0] mask_buffer_1;
reg [MC - 1 : 0] mask_buffer_2;
always @ (posedge clk) begin
    if (reset) begin
        mask_buffer_0 <= 0;
        mask_buffer_1 <= 0;
        mask_buffer_2 <= 0;
    end else begin 
        mask_buffer_0 <= att_mask_out;
        mask_buffer_1 <= mask_buffer_0;
        mask_buffer_2 <= mask_buffer_1;
    end
end
assign mb_mask_bits = mask_buffer_2;

/* --- clause negated literals buffer --- */
reg [CLAUSE_WIDTH - 1 : 0] clause_negated_literals_buffer;
always @ (posedge clk) begin
    if (reset) begin
        clause_negated_literals_buffer <= 0;
    end else begin
        if(CFLB_wren) for(i = 0; i < NSAT; i = i + 1) clause_negated_literals_buffer[LITERAL_ADDRESS_WIDTH * i +: LITERAL_ADDRESS_WIDTH] <= {cr_selected_clause[LITERAL_ADDRESS_WIDTH * (i + 1) - 1], cr_selected_clause[LITERAL_ADDRESS_WIDTH * i +: VARIABLE_ADDRESS_WIDTH]};
    end
end
assign cnlb_clause_negated = clause_negated_literals_buffer;
assign selected_literal_flipped = vfs_selected[1] ? 
    (vfs_selected[0] ? 
        {LITERAL_ADDRESS_WIDTH{1'bx}} : 
        {cnlb_clause_negated[LITERAL_ADDRESS_WIDTH * 2 +: LITERAL_ADDRESS_WIDTH]}) 
    : 
    (vfs_selected[0] ? 
        {cnlb_clause_negated[LITERAL_ADDRESS_WIDTH * 1 +: LITERAL_ADDRESS_WIDTH]} : 
        {cnlb_clause_negated[LITERAL_ADDRESS_WIDTH * 0 +: LITERAL_ADDRESS_WIDTH]});

/* --- negation buffer --- */
reg [(NSAT - 1) * MC - 1 : 0] negation_buffer;
always @ (posedge clk) begin
    if (reset) begin
        negation_buffer <= 0;
    end else begin
        negation_buffer <= ct_negation_bits;
    end
end
assign nb_negation_bits = negation_buffer;

/* --- variable table cluster --- */
wire [(NSAT - 1) * MC * VARIABLE_ADDRESS_WIDTH - 1 : 0] vtc_addresses_in;
wire [(NSAT - 1) * MC - 1 : 0] vtc_data_in;
assign vtc_addresses_in = VT_addr_src ? {(NSAT - 1) * MC{selected_literal_flipped_addr}} : ct_variable_addresses;
assign vtc_data_in = {(NSAT - 1) * MC{selected_literal_flipped_neg_bit}}

//needs to be worked out - are we utilizing dual port memory or not, etc
Variable_Table_Cluster #(
    .NSAT(NSAT),
    .MAX_CLAUSE_MEMBERSHIP(MAX_CLAUSE_MEMBERSHIP),
    .VARIABLE_ADDRESS_WIDTH(VARIABLE_ADDRESS_WIDTH)
) variable_table_cluster (
    .clk(clk),
    .en_a(VT)
    .wren(VT_wren),
    .rden(VT_rden),
    .addr_i(vtc_addresses_in),
    .data_i(vtc_data_in),
    .data_o(vtc_value_bits)
);

/* --- temporal buffer wrapper --- */
Temporal_Buffer_Wrapper #(
    .NSAT(NSAT),
    .MAX_CLAUSE_MEMBERSHIP(MAX_CLAUSE_MEMBERSHIP),
    .VARIABLE_ADDRESS_WIDTH(VARIABLE_ADDRESS_WIDTH)
) temporal_buffer_wrapper (
    .clk(clk),
    .reset(reset),
    .write_index_i(TB_wr_index),
    .write_en_i(~(&TB_wr_index)),
    .literals_multi_i(ct_clauses_out),
    .read_index_i(vfs_selected),
    .literals_multi_o(tbw_literals_multi_out)
);

generate
    for(n = 0; n < MC; n = n + 1) begin
        assign broken_clauses[n * CLAUSE_WIDTH +: CLAUSE_WIDTH] = {tbw_literals_multi_out[n * (NSAT - 1) * LITERAL_ADDRESS_WIDTH +: (NSAT - 1) * LITERAL_ADDRESS_WIDTH], selected_literal_flipped};
    end
endgenerate

/* --- clause evaluator cluster --- */
Clause_Evaluator_Cluster #(
    .CLUSTER_SIZE(MAX_CLAUSE_MEMBERSHIP),
    .NSAT(NSAT),
    .IMPLEMENTATION("OUTPUT_GATED"),
    .REDUCE(1)
) clause_evaluator_cluster (
    .clk(clk),
    .reset(reset),
    .var_val_i(vtc_value_bits),
    .var_neg_i(nb_negation_bits),
    .break_o(ce1_break_bits)
);

/* --- variable flip selector --- */
Variable_Flip_Selector #(
    .MAX_CLAUSES_PER_VARIABLE(MC),
    .NSAT(NSAT),
    .P('h6E147AE0)
) variable_flip_selector (
    .clk(clk),
    .reset(reset),
    .clause_broken_i(ce1_break_bits),
    .mask_bits_i(mb_mask_bits),
    .break_values_valid_i(),
    .random_i(random_number),
    .wren_i(vfs_wren),
    .selected_o(vfs_selected),
    .clause_valid_bits_o(vfs_clause_valid_bits)
);

/* --- fifo_tree --- */
FIFO_Tree #(
    .CLAUSE_COUNT(MC),
    .CLAUSE_WIDTH(CLAUSE_WIDTH),
    .DEPTH(FIFO_DEPTH)
) fifo_tree (
    .clk(clk),
    .reset(reset),
    .clauses_i(broken_clauses),
    .clauses_valid_i(vfs_clause_valid_bits),
    .wren(FIFO_wren),
    .rden(FIFO_rden),
    .cOF(),
    .empty(),
    .OF(),
    .clause_o()
);

/*
NOTE : missing UNSAT clause buffer, selector, and other logic/muxs
 - need to add the rest of the modules and understand control signals better
 - need to provide easy rw interface for loading a problem
*/

endmodule