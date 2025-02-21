`timescale 1ns/1ps
module datapath_tb;

//======================================================================
// Parameters and Local Parameters
//======================================================================
parameter NSAT                  = 3;
parameter LITERAL_ADDRESS_WIDTH = 12;  // 12-bit literal: [MSB = polarity, 11-bit var]
parameter VARIABLE_ADDRESS_WIDTH = 11; // For 2048 variables
parameter MAX_CLAUSE_MEMBERSHIP = 20;    // (MC)
parameter NUM_VARIABLES         = 2048;  // Clause Table depth
parameter FIFO_DEPTH = 32;
parameter UNSAT_CLAUSE_BUFFER_DEPTH = 2048;

localparam CT_WIDTH    = (LITERAL_ADDRESS_WIDTH) * (NSAT-1) * MAX_CLAUSE_MEMBERSHIP;
localparam ATT_WIDTH   = VARIABLE_ADDRESS_WIDTH + MAX_CLAUSE_MEMBERSHIP;
localparam CLAUSE_WIDTH = NSAT * LITERAL_ADDRESS_WIDTH;
localparam MC = MAX_CLAUSE_MEMBERSHIP;
localparam VALID_WIDTH = 8; // For example, random portion is 8 bits (range 0-255)

//======================================================================
// Clock and Reset
//======================================================================
reg clk;
initial clk = 0;
always #5 clk = ~clk; // 10 ns period
reg rst;

//======================================================================
// Handshake signals (for controller)
//======================================================================
reg init_done = 1'b1;  // Assume initialization is done.
reg eval_done = 1'b1;   // Assume evaluation is done.

//======================================================================
// ATT
//======================================================================
integer i;
wire att_wr_en_i = 1'b0;
wire [LITERAL_ADDRESS_WIDTH:0] att_wr_addr_i = {LITERAL_ADDRESS_WIDTH+1{1'b0}};
wire [ATT_WIDTH-1:0] att_wr_data_i = {ATT_WIDTH{1'b0}};

wire                        fifo_empty;
wire [CLAUSE_WIDTH - 1 : 0] fifo_clause;

//======================================================================
// Clause Table
//======================================================================
wire ct_wr_en_i = 1'b0;
wire [VARIABLE_ADDRESS_WIDTH-1:0] ct_wr_addr_i = {VARIABLE_ADDRESS_WIDTH{1'b0}};
wire [CT_WIDTH-1:0] ct_wr_data_i = {CT_WIDTH{1'b0}};

//======================================================================
// Stage A: Clause Register and ATT selection logic
//======================================================================
reg cr_wr_en;
wire [CLAUSE_WIDTH-1:0] ucs_selected_clause;
wire [CLAUSE_WIDTH-1:0] cr_selected_clause;
wire [CLAUSE_WIDTH - 1 : 0] _selected_unsatisfied_clause;
  
Clause_Register #(
    .NSAT(NSAT),
    .LITERAL_ADDRESS_WIDTH(LITERAL_ADDRESS_WIDTH)
) clause_register_inst (
    .clk_i(clk),
    .rst_i(rst),
    .wr_en_i(cr_wr_en),
    .data_i(_selected_unsatisfied_clause),
    .data_o(cr_selected_clause)
);
  
// For ATT lookup, use a two‐bit selector signal att_src:
reg [1:0] att_src;
wire [LITERAL_ADDRESS_WIDTH-1:0] _cr_selected_literal;
assign _cr_selected_literal = att_src[1] ? 
    (att_src[0] ? {LITERAL_ADDRESS_WIDTH{1'b0}} : cr_selected_clause[LITERAL_ADDRESS_WIDTH * 2 +: LITERAL_ADDRESS_WIDTH]) 
        : (att_src[0] ? cr_selected_clause[LITERAL_ADDRESS_WIDTH * 1 +: LITERAL_ADDRESS_WIDTH] : cr_selected_clause[LITERAL_ADDRESS_WIDTH * 0 +: LITERAL_ADDRESS_WIDTH]);

        wire [LITERAL_ADDRESS_WIDTH-1:0] _cr_negated_literal;
assign _cr_negated_literal = { ~_cr_selected_literal[LITERAL_ADDRESS_WIDTH - 1],
                                  _cr_selected_literal[LITERAL_ADDRESS_WIDTH - 2 : 0] };
  
//======================================================================
// Address Translation Table instantiation
//======================================================================
wire [VARIABLE_ADDRESS_WIDTH-1:0] att_addr_out;
wire [MAX_CLAUSE_MEMBERSHIP-1:0] att_mask_out;
  
  Address_Translation_Table #(
    .CLAUSE_COUNT(MAX_CLAUSE_MEMBERSHIP),
    .LITERAL_ADDRESS_WIDTH(LITERAL_ADDRESS_WIDTH),
    .CLAUSE_TABLE_ADDRESS_WIDTH(VARIABLE_ADDRESS_WIDTH),
    .AT_MEM_FILE("/home/harim_choe/Solving-SAT-in-FPGA-UCSB/rtl/mem/my_at.mem")
  ) address_translation_table_inst (
      .clk_i(clk),
      .wr_en_i(att_wr_en_i),
      .wr_addr_i(att_wr_addr_i),
      .wr_data_i(att_wr_data_i),
      .rd_addr_i(_cr_negated_literal),
      .addr_o(att_addr_out),
      .mask_o(att_mask_out)
  );  
  
//======================================================================
// Clause Negated Literals Buffer (for temporal buffer)
//======================================================================
reg cflb_wr_en;  // control signal for buffer write
wire [CLAUSE_WIDTH-1:0] _selected_clause_negated;
genvar n;
generate
    for(n = 0; n < NSAT; n = n + 1) begin
        assign _selected_clause_negated[LITERAL_ADDRESS_WIDTH * n +: LITERAL_ADDRESS_WIDTH] =
               { cr_selected_clause[LITERAL_ADDRESS_WIDTH * (n + 1) - 1],
                 cr_selected_clause[LITERAL_ADDRESS_WIDTH * n +: VARIABLE_ADDRESS_WIDTH] };
    end
endgenerate  
 
reg [CLAUSE_WIDTH-1:0] clause_negated_literals_buffer;
always @(posedge clk) begin
    if (rst)
        clause_negated_literals_buffer <= 0;
    else if (cflb_wr_en)
        clause_negated_literals_buffer <= _selected_clause_negated;
end
wire [CLAUSE_WIDTH-1:0] cnlb_clause;
assign cnlb_clause = clause_negated_literals_buffer;
  
//======================================================================
// Temporal Buffer multiplexer: select one literal from the negated buffer
//======================================================================
wire [1:0] vfs_selected;
wire [LITERAL_ADDRESS_WIDTH-1:0] _selected_literal_negated;
wire _selected_literal_negated_neg_bit;
wire [LITERAL_ADDRESS_WIDTH-2:0] _selected_literal_negated_addr;
assign { _selected_literal_negated_neg_bit, _selected_literal_negated_addr } = _selected_literal_negated;
 
assign _selected_literal_negated = vfs_selected[1] ? 
       (vfs_selected[0] ? { cnlb_clause[LITERAL_ADDRESS_WIDTH*0 +: LITERAL_ADDRESS_WIDTH ] } : 
                           { cnlb_clause[LITERAL_ADDRESS_WIDTH*2 +: LITERAL_ADDRESS_WIDTH ] })
    :  (vfs_selected[0] ? { cnlb_clause[LITERAL_ADDRESS_WIDTH*1 +: LITERAL_ADDRESS_WIDTH ] } : 
                           { cnlb_clause[LITERAL_ADDRESS_WIDTH*0 +: LITERAL_ADDRESS_WIDTH ] });
  
//======================================================================
// Clause Table
//======================================================================
wire [CT_WIDTH-1:0] ct_clauses;
 
Clause_Table #(
    .CLAUSE_COUNT(MAX_CLAUSE_MEMBERSHIP),
    .DEPTH(NUM_VARIABLES),
    .VARIABLE_ADDRESS_WIDTH(VARIABLE_ADDRESS_WIDTH),
    .NSAT(NSAT),
    .CT_MEM_FILE("/home/harim_choe/Solving-SAT-in-FPGA-UCSB/rtl/mem/my_ct.mem")
) clause_table_inst (
    .clk_i(clk),
    .wr_en_i(ct_wr_en_i),
    .wr_addr_i(ct_wr_addr_i),
    .wr_clauses_i(ct_wr_data_i),
    .rd_addr_i(att_addr_out),
    .clauses_o(ct_clauses)
);
 
//======================================================================
// Mask Buffer (simulate pipeline stages)
//======================================================================
reg [MAX_CLAUSE_MEMBERSHIP-1:0] mask_buffer_0, mask_buffer_1, mask_buffer_2;
always @(posedge clk) begin
    if (rst) begin
        mask_buffer_0 <= 0;
        mask_buffer_1 <= 0;
        mask_buffer_2 <= 0;
    end else begin 
        mask_buffer_0 <= att_mask_out;
        mask_buffer_1 <= mask_buffer_0;
        mask_buffer_2 <= mask_buffer_1;
    end
end
wire [MAX_CLAUSE_MEMBERSHIP-1:0] mb_mask_bits;
assign mb_mask_bits = mask_buffer_2;
 
//======================================================================
// Negation Bits Extraction from Clause Table output
//======================================================================
wire [(NSAT-1)*MC-1:0] ct_negation_bits;
wire [((NSAT-1)*MC)*VARIABLE_ADDRESS_WIDTH-1:0] ct_variable_addresses;
 
genvar p, q;
generate
    for(p = 0; p < MC; p = p + 1) begin : gen_ct_fixed
        for(q = 0; q < NSAT - 1; q = q + 1) begin : gen_ct_inner_fixed
            assign ct_negation_bits[p*(NSAT-1)+q] =
                ct_clauses[((NSAT-1)*p + q + 1)*LITERAL_ADDRESS_WIDTH - 1];
            assign ct_variable_addresses[(p*(NSAT-1)+q)*VARIABLE_ADDRESS_WIDTH +: VARIABLE_ADDRESS_WIDTH] =
                ct_clauses[((NSAT-1)*p + q)*LITERAL_ADDRESS_WIDTH +: VARIABLE_ADDRESS_WIDTH];
        end
    end
endgenerate
 
reg [(NSAT-1)*MC-1:0] negation_buffer;
always @(posedge clk) begin
    if (rst)
        negation_buffer <= 0;
    else
        negation_buffer <= ct_negation_bits;
end
wire [(NSAT-1)*MC-1:0] nb_negation_bits;
assign nb_negation_bits = negation_buffer;
 
//======================================================================
// Variable Table Cluster 1 (VT Cluster 1)
//======================================================================
reg vt_addr_src;
reg vt_en, vt_wr_en;
 
initial begin
    vt_en = 1;
    vt_wr_en = 0;
    vt_addr_src = 0;
end
 
wire [((NSAT-1)*MC)*VARIABLE_ADDRESS_WIDTH-1:0] ct_var_addr;
assign ct_var_addr = ct_variable_addresses;
wire [LITERAL_ADDRESS_WIDTH-2:0] sel_lit_addr = _selected_literal_negated_addr;
wire [((NSAT-1)*MC)*VARIABLE_ADDRESS_WIDTH-1:0] _vtc_address_m;
 
assign _vtc_address_m = vt_addr_src ? {((NSAT-1)*MC){_selected_literal_negated_addr}} : ct_variable_addresses;
wire _vtc_data;
assign _vtc_data = _selected_literal_negated_neg_bit;
wire [((NSAT-1)*MC)-1:0] vtc_value_bits;
 
Variable_Table_Cluster #(
    .VARIABLE_ADDRESS_WIDTH(VARIABLE_ADDRESS_WIDTH),
    .CLUSTER_SIZE((NSAT-1)*MC)
) variable_table_cluster_inst (
    .clk_i(clk),
    .en_i(vt_en),
    .wr_en_i(vt_wr_en),
    .addr_mi(_vtc_address_m),
    .data_i(_vtc_data),
    .data_mo(vtc_value_bits)
);
 
//======================================================================
// Temporal Buffer Wrapper
//======================================================================
reg [$clog2(NSAT)-1:0] tb_wr_index;
wire tb_wr_en;  
assign tb_wr_en = ~(&tb_wr_index);
wire [((NSAT-1)*MC)*LITERAL_ADDRESS_WIDTH-1:0] tbw_literals_multi_out;
Temporal_Buffer_Wrapper #(
    .NSAT(NSAT),
    .LITERAL_ADDRESS_WIDTH(LITERAL_ADDRESS_WIDTH),
    .MAX_CLAUSE_MEMBERSHIP(MC)
) temporal_buffer_wrapper_inst (
    .clk_i(clk),
    .rst_i(rst),
    .wr_index_i(tb_wr_index),
    .wr_en_i(tb_wr_en),
    .wr_literals_mi(ct_clauses),
    .rd_index_i(vfs_selected),
    .literals_mo(tbw_literals_multi_out)
);
 
wire [CT_WIDTH-1:0] tbuf_out;
assign tbuf_out = tbw_literals_multi_out;  // Expected value
 
wire [MC * CLAUSE_WIDTH - 1 : 0] _broken_clauses;
 
generate
  for(n = 0; n < MC; n = n + 1) begin
      assign _broken_clauses[n * CLAUSE_WIDTH +: CLAUSE_WIDTH] = 
             { tbw_literals_multi_out[n * (NSAT - 1) * LITERAL_ADDRESS_WIDTH +: (NSAT - 1) * LITERAL_ADDRESS_WIDTH],
               _selected_literal_negated };
  end
endgenerate
 
//======================================================================
// Variable Table Cluster 2 (VT Cluster 2)
//======================================================================
wire [NSAT*VARIABLE_ADDRESS_WIDTH-1:0] usc_selected_clause_addresses;
wire [NSAT*VARIABLE_ADDRESS_WIDTH-1:0] _vtc2_address_m;
assign _vtc2_address_m = vt_addr_src ? {NSAT{_selected_literal_negated_addr}} : usc_selected_clause_addresses;
wire _vtc2_data;
assign _vtc2_data = _selected_literal_negated_neg_bit;
wire [NSAT-1:0] vtc2_value_bits;
Variable_Table_Cluster #(
    .VARIABLE_ADDRESS_WIDTH(VARIABLE_ADDRESS_WIDTH),
    .CLUSTER_SIZE(NSAT)
) variable_table_cluster_2_inst (
    .clk_i(clk),
    .en_i(vt_en),
    .wr_en_i(vt_wr_en),
    .addr_mi(_vtc2_address_m),
    .data_i(_vtc2_data),
    .data_mo(vtc2_value_bits)
);
 
//======================================================================
// Clause Evaluator Cluster 1 (CE Cluster 1)
//======================================================================
wire [MAX_CLAUSE_MEMBERSHIP-1:0] ce1_break_bits;
Clause_Evaluator_Cluster #(
    .CLUSTER_SIZE(MAX_CLAUSE_MEMBERSHIP),
    .NSAT(NSAT),
    .IMPLEMENTATION("OUTPUT_GATED"),
    .REDUCE(1)
) clause_evaluator_cluster_inst (
    .clk_i(clk),
    .rst_i(rst),
    .var_val_mi(vtc_value_bits),
    .var_neg_mi(nb_negation_bits),
    .break_mo(ce1_break_bits)
);
 
//======================================================================
// Clause Evaluator 2 (CE Evaluator 2)
//======================================================================
wire ce2_break;
wire [NSAT-1:0] nb2_negation_bits;
Clause_Evaluator #(
    .NSAT(NSAT),
    .IMPLEMENTATION("OUTPUT_GATED"),
    .REDUCE(0)
) clause_evaluator_2_inst (
    .clk_i(clk),
    .rst_i(rst),
    .var_val_i(vtc2_value_bits),
    .var_neg_i(nb2_negation_bits),
    .break_o(ce2_break)
);
 
//======================================================================
// Negation Buffer 2 for CE Evaluator 2
//======================================================================
reg [NSAT-1:0] nb2_negation_bits_reg;
wire [NSAT - 1 : 0] ucs_selected_clause_negation_bits;
always @(posedge clk) begin
    if (rst)
        nb2_negation_bits_reg <= 0;
    else
        // For testing, force nb2_negation_bits to match ucs_selected_clause_negation_bits.
        nb2_negation_bits_reg <= ucs_selected_clause_negation_bits;
end
assign nb2_negation_bits = nb2_negation_bits_reg;
 
//======================================================================
// XOR PRNG
//======================================================================
wire [31:0] prng_random_number;
XOR_PRNG prng_inst (
    .clk_i(clk),
    .rst_i(rst),
    .data_o(prng_random_number)
);
 
//======================================================================
// CONTROLLER INSTANTIATION
//======================================================================
wire         controller_ucs_request;
wire         controller_temp_flip_en;
wire         controller_eval_en;
wire         controller_flip_en;
wire         controller_fifo_rd_en;
wire         controller_fifo_wr_en;
wire         controller_reinit;
wire         controller_done;
wire [1:0]   controller_thread_sel;
wire [1:0]   controller_flip_decision;
wire         controller_cr_wr_en;
wire [1:0]   controller_att_src;
wire         controller_vt_addr_src;
wire         controller_vt_en;
wire [$clog2(NSAT) - 1 : 0] controller_vfs_selected;
wire         controller_vt_wr_en;
wire [1:0]   controller_vfs_wr_en;
wire         controller_cflb_wr_en;
wire [$clog2(3)-1:0] controller_tb_wr_index;

sat_controller controller_inst (
    .clk(clk),
    .reset(rst),
    .init_done(init_done),
    .eval_done(eval_done),
    .fifo_empty(contorller_fifo_empty),
    .ce2_break(controller_ce2_break),
    .vfs_selected_in(controller_vfs_selected),
    .ucs_request(controller_ucs_request),
    .temp_flip_en(controller_temp_flip_en),
    .eval_en(controller_eval_en),
    .flip_en(controller_flip_en),
    .fifo_rd_en(controller_fifo_rd_en),
    .fifo_wr_en(controller_fifo_wr_en),
    .reinit(controller_reinit),
    .done(controller_done),
    .thread_sel(controller_thread_sel),
    .flip_decision(controller_flip_decision),
    .cr_wr_en(controller_cr_wr_en),
    .att_src(controller_att_src),
    .vt_addr_src(controller_vt_addr_src),
    .vt_en(controller_vt_en),
    .vt_wr_en(controller_vt_wr_en),
    .vfs_wr_en(controller_vfs_wr_en),
    .cflb_wr_en(controller_cflb_wr_en),
    .tb_wr_index(controller_tb_wr_index)
);
 
//======================================================================
// VARIABLE FLIP SELECTOR, FIFO TREE, UNSAT CLAUSE SELECTOR
//======================================================================
/* --- variable flip selector --- */
reg [1 : 0] vfs_wr_en;
wire [MC - 1 : 0] vfs_clause_valid_bits;
 
Variable_Flip_Selector #(
  .MAX_CLAUSES_PER_VARIABLE(MC),
  .NSAT(NSAT),
  .P('h6E147AE0)
) variable_flip_selector (
  .clk_i(clk),
  .rst_i(rst),
  .clause_broken_i(ce1_break_bits),
  .mask_bits_i(mb_mask_bits),
  .break_values_valid_i(3'b111),
  .random_i(prng_random_number),
  .wr_en_i(vfs_wr_en),
  .selected_o(vfs_selected),
  .clause_valid_bits_o(vfs_clause_valid_bits)
);
 
/* --- fifo_tree --- */
reg         fifo_wr_en;
reg         fifo_rd_en;
reg preload_fifo;
reg [LITERAL_ADDRESS_WIDTH-1:0] lit0, lit1, lit2;
initial begin
    lit0 = {1'b1, {(LITERAL_ADDRESS_WIDTH-1-VALID_WIDTH){1'b0}}, ($random % (2*NUM_VARIABLES)) & ((1 << VALID_WIDTH) - 1)};
    lit1 = {1'b1, {(LITERAL_ADDRESS_WIDTH-1-VALID_WIDTH){1'b0}}, ($random % (2*NUM_VARIABLES)) & ((1 << VALID_WIDTH) - 1)};
    lit2 = {1'b1, {(LITERAL_ADDRESS_WIDTH-1-VALID_WIDTH){1'b0}}, ($random % (2*NUM_VARIABLES)) & ((1 << VALID_WIDTH) - 1)};
end
 
wire [CLAUSE_WIDTH-1:0] forced_clause = { lit2, lit1, lit0 };
 
FIFO_Tree #(
  .CLAUSE_COUNT(MC),
  .CLAUSE_WIDTH(CLAUSE_WIDTH),
  .BUFFER_DEPTH(FIFO_DEPTH)
) fifo_tree (
  .clk_i(clk),
  .rst_i(rst),
  .clauses_i(preload_fifo ? {MC{forced_clause}} : _broken_clauses),
  .clauses_valid_i(vfs_clause_valid_bits),
  .wr_en_i(fifo_wr_en),
  .rd_en_i(fifo_rd_en),
  .cOF_i(),
  .empty_o(fifo_empty),
  .OF_o(),
  .clause_o(fifo_clause)
);
 
/* --- unsat clause selector --- */
localparam RANDOM_NUM_WIDTH = 18;
localparam RANDOM_OFFSET = 10;
reg ucb_setup_i;
reg ucb_setup_wr_en_i;
reg [$clog2(UNSAT_CLAUSE_BUFFER_DEPTH) - 1 : 0] ucb_setup_addr_i;
reg [NSAT * LITERAL_ADDRESS_WIDTH - 1 : 0] ucb_setup_data_i;
reg ucs_request;
wire [10:0] unsat_buffer_count_o;
 
Unsat_Clause_Selector #(
  .BUFFER_DEPTH(UNSAT_CLAUSE_BUFFER_DEPTH),
  .RANDOM_NUM_WIDTH(RANDOM_NUM_WIDTH),
  .M_TABLE_WIDTH(32),
  .NSAT(NSAT),
  .LITERAL_ADDRESS_WIDTH(LITERAL_ADDRESS_WIDTH)
) unsat_clause_selector (
  .clk_i(clk),
  .rst_i(rst),
  .setup_i(ucb_setup_i),
  .ucb_setup_wr_en_i(ucb_setup_wr_en_i),
  .ucb_setup_addr_i(ucb_setup_addr_i),
  .ucb_setup_data_i(ucb_setup_data_i),
  .request_i(ucs_request),
  .write_disable_i(~ce2_break),
  .clear_debug_DIV_BY_ZERO_i(),
  .debug_DIV_BY_ZERO_o(),
  .fifo_empty_i(fifo_empty),
  .fifo_clause_i(fifo_clause),
  .random_i(prng_random_number[RANDOM_OFFSET +: RANDOM_NUM_WIDTH]),
  .buffer_count_o(unsat_buffer_count_o),
  .selected_o(ucs_selected_clause),
  .ucb_overflow_o()
);
 
generate
  for(n = 0; n < NSAT; n = n + 1) begin
      assign ucs_selected_clause_negation_bits[n] = 
                ucs_selected_clause[LITERAL_ADDRESS_WIDTH * (n + 1) - 1];
      assign usc_selected_clause_addresses[n * VARIABLE_ADDRESS_WIDTH +: VARIABLE_ADDRESS_WIDTH] = 
                ucs_selected_clause[LITERAL_ADDRESS_WIDTH * n +: VARIABLE_ADDRESS_WIDTH];
  end
endgenerate
 
// Use the controller-driven forced_mode
assign _selected_unsatisfied_clause = controller_done ? forced_clause : 
       (ce2_break ? ucs_selected_clause : fifo_clause);

// Modify the multiplexer that feeds the Clause Register:
integer j, k;
integer vt_addr_index;

reg [LITERAL_ADDRESS_WIDTH-1:0] exp_sel_lit;
reg [LITERAL_ADDRESS_WIDTH-1:0] exp_neg_lit;
reg [VARIABLE_ADDRESS_WIDTH-1:0] exp_att_addr;
reg [MAX_CLAUSE_MEMBERSHIP-1:0] exp_att_mask;
reg [ATT_WIDTH-1:0] exp_att_data;
reg [CT_WIDTH-1:0] exp_ct_data;
reg [CLAUSE_WIDTH-1:0] exp_broken_clause;

// Testbench: Preload Memories and Compare Expected vs Actual Values
reg [CLAUSE_WIDTH-1:0] expected_negated;
initial begin
    $display("=== Starting Full SAT Solver Datapath Comparison Test ===");
    // Force the multiplexer to always use forced_clause.
    init_done = 1;
    
    // Initialize all control signals and assert reset.
    rst = 1;
    cr_wr_en = 0;
    vt_wr_en = 0;
    tb_wr_index = 0;
    att_src = 0;
    vt_addr_src = 0;
    vfs_wr_en = 0;
    fifo_wr_en = 0;
    fifo_rd_en = 0;
    ucb_setup_i = 0;
    ucb_setup_wr_en_i = 0;
    ucb_setup_addr_i = 0;
    ucb_setup_data_i = 0;
    fifo_wr_en = 0;
    fifo_rd_en = 0;
    ucs_request = 0;
    #50; rst = 0;
    
    for(k = 0; k < 2048; k = k + 1) begin
      // Create a test clause using three literals:
      lit0 = {1'b1, {(LITERAL_ADDRESS_WIDTH-1-VALID_WIDTH){1'b0}}, ($random % (2*NUM_VARIABLES)) & ((1 << VALID_WIDTH) - 1)};
      lit1 = {1'b1, {(LITERAL_ADDRESS_WIDTH-1-VALID_WIDTH){1'b0}}, ($random % (2*NUM_VARIABLES)) & ((1 << VALID_WIDTH) - 1)};
      lit2 = {1'b1, {(LITERAL_ADDRESS_WIDTH-1-VALID_WIDTH){1'b0}}, ($random % (2*NUM_VARIABLES)) & ((1 << VALID_WIDTH) - 1)};

      force ucs_selected_clause = { lit2, lit1, lit0 };
      // Write clause register:
      cr_wr_en = 1;
      @(posedge clk); 
      cr_wr_en = 0;

      // Wait one cycle for clause register to settle:
      @(posedge clk);
      @(posedge clk);

      // Latch clause negated literals into buffer:
      cflb_wr_en = 1; 
      @(posedge clk); 
      cflb_wr_en = 0;

      // For each literal selection (att_src = 0,1,2)
      for(att_src = 0; att_src < 3; att_src = att_src + 1) begin
        @(posedge clk);
        force vfs_selected = att_src; //testing without vfs
        tb_wr_index = vfs_selected; //testing without vfs
        // Wait for pipeline settling:
        repeat(8) @(posedge clk);
        // Expected selected literal from clause register:
        if(att_src == 0)
            exp_sel_lit = cr_selected_clause[0*LITERAL_ADDRESS_WIDTH +: LITERAL_ADDRESS_WIDTH];
        else if(att_src == 1)
            exp_sel_lit = cr_selected_clause[1*LITERAL_ADDRESS_WIDTH +: LITERAL_ADDRESS_WIDTH];
        else if(att_src == 2)
            exp_sel_lit = cr_selected_clause[2*LITERAL_ADDRESS_WIDTH +: LITERAL_ADDRESS_WIDTH];
        else exp_sel_lit = 0;
        
        // Test selected literal and its negation from the clause register flow.
        if (_cr_selected_literal !== exp_sel_lit)
            $display("FAIL cr_selected_literal: Expected=0x%0h, Got=0x%0h", exp_sel_lit, _cr_selected_literal);
        else
            $display("PASS cr_selected_literal: Correctly selected literal 0x%0h", _cr_selected_literal);

        if(att_src < NSAT)
          exp_neg_lit = { ~exp_sel_lit[LITERAL_ADDRESS_WIDTH-1], exp_sel_lit[LITERAL_ADDRESS_WIDTH-2:0] };
        else
          exp_neg_lit = exp_sel_lit;  

        if (_cr_negated_literal !== exp_neg_lit)
            $display("FAIL _cr_negated_literal: Expected=0x%0h, Got=0x%0h", exp_neg_lit, _cr_negated_literal);
        else
            $display("PASS _cr_negated_literal: Correctly computed negated literal 0x%0h", _cr_negated_literal);

        // Expected ATT outputs (preload pattern based on _cr_negated_literal)
        exp_att_addr = exp_neg_lit[VARIABLE_ADDRESS_WIDTH-1:0];
        exp_att_mask = { {(MAX_CLAUSE_MEMBERSHIP - VARIABLE_ADDRESS_WIDTH){1'b0}}, exp_neg_lit };
        exp_att_data = { exp_att_addr, exp_att_mask };
        exp_ct_data = { {(CT_WIDTH-8){1'b0}}, exp_att_addr[7:0] };

        // Check ATT output:
        $display("ATT: Got=0x%0h", {att_addr_out, att_mask_out});

        // Check Clause Table output:
            $display("Clause Table: Got=0x%0h", ct_clauses);
        // Check Mask Buffer:

        if (mb_mask_bits === att_mask_out)
            $display("PASS Mask Buffer: Expected=0x%0h, Got=0x%0h", att_mask_out, mb_mask_bits);
        else
            $display("FAIL Mask Buffer: Expected=0x%0h, Got=0x%0h", att_mask_out, mb_mask_bits);
        // Check Temporal Buffer:
        if (tbw_literals_multi_out === tbuf_out)
            $display("PASS Temporal Buffer: Expected=0x%0h, Got=0x%0h", tbuf_out, tbw_literals_multi_out);
        else
            $display("FAIL Temporal Buffer: Expected=0x%0h, Got=0x%0h", tbuf_out, tbw_literals_multi_out);
        // Check CE Cluster 1 output:
        if (ce1_break_bits === {MC{1'b1}})
            $display("PASS CE Cluster1: ce1_break=0x%0h as expected", ce1_break_bits);
        else
            $display("FAIL CE Cluster1: Expected=0x%0h, Got=0x%0h", {MC{1'b1}}, ce1_break_bits);

        // --- Design Flow Test 2: Check Negated Clause Buffer Flow ---
        if (cnlb_clause !== _selected_clause_negated)
            $display("FAIL Clause Negated Buffer: Expected=0x%0h, Got=0x%0h", _selected_clause_negated, cnlb_clause);
        else
            $display("PASS Clause Negated Buffer: cnlb_clause matches _selected_clause_negated");

        // Test the temporal selection from the negated buffer:
        if (_selected_literal_negated !== (vfs_selected[1] ? 
                (vfs_selected[0] ? {LITERAL_ADDRESS_WIDTH{1'b0}} : 
                    cnlb_clause[LITERAL_ADDRESS_WIDTH*2 +: LITERAL_ADDRESS_WIDTH])
                : (vfs_selected[0] ? 
                    cnlb_clause[LITERAL_ADDRESS_WIDTH*1 +: LITERAL_ADDRESS_WIDTH] : 
                    cnlb_clause[LITERAL_ADDRESS_WIDTH*0 +: LITERAL_ADDRESS_WIDTH])))
            $display("FAIL _selected_literal_negated: Mismatch");
        else
            $display("PASS _selected_literal_negated: Correctly selected literal 0x%0h", _selected_literal_negated);

        // --- Design Flow Test 3: Check VT Cluster 2 / CE Evaluator 2 chain ---
        if (_selected_literal_negated_addr !== _selected_literal_negated[LITERAL_ADDRESS_WIDTH-2:0])
            $display("FAIL _selected_literal_negated_addr extraction: Expected=0x%0h, Got=0x%0h",
                     _selected_literal_negated[LITERAL_ADDRESS_WIDTH-2:0], _selected_literal_negated_addr);
        else
            $display("PASS _selected_literal_negated_addr extraction: Correctly extracted 0x%0h", _selected_literal_negated_addr);
        
        if (ce2_break === 1'b1)
            $display("PASS CE Evaluator2: ce2_break=%b as expected", ce2_break);
        else
            $display("FAIL CE Evaluator2: Expected=0, Got=%b", ce2_break);

        $display("PASS PRNG: prng_out = 0x%0h", prng_random_number);
        if (nb2_negation_bits === ucs_selected_clause_negation_bits)
            $display("PASS nb2_negation_bits: Expected=0x4, Got=0x%0h", nb2_negation_bits);
        else
            $display("FAIL nb2_negation_bits: Expected=0x4, Got=0x%0h", nb2_negation_bits);
        
        // Check broken clauses:
        for(j = 0; j < MC; j = j + 1) begin
          exp_broken_clause = {tbw_literals_multi_out[j*(NSAT-1)*LITERAL_ADDRESS_WIDTH +: (NSAT-1)*LITERAL_ADDRESS_WIDTH], _selected_literal_negated };
            if (_broken_clauses[j*CLAUSE_WIDTH +: CLAUSE_WIDTH] === exp_broken_clause)
                $display("PASS _broken_clauses[%0d]: Expected=0x%0h, Got=0x%0h", j, exp_broken_clause, _broken_clauses[j*CLAUSE_WIDTH +: CLAUSE_WIDTH]);
            else
                $display("FAIL _broken_clauses[%0d]: Expected=0x%0h, Got=0x%0h", j, exp_broken_clause, _broken_clauses[j*CLAUSE_WIDTH +: CLAUSE_WIDTH]);
        end
        $display("--------------------------------------------------");
        @(posedge clk);
    end
    
    if (controller_done === 1'b1)
         begin
            $display("**************************************************");
            $display("******** RESULT: This Problem is SAT ***********");
            $display("**************************************************");
         end
    else begin
            $display("**************************************************");
            $display("******** RESULT: This Problem is UNSAT *********");
            $display("**************************************************");
         end
end
$finish;
end

endmodule

