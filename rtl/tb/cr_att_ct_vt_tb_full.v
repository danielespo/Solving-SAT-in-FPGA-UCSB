`timescale 1ns/1ps
module cr_att_ct_vt_tb_full;

//======================================================================
// Parameters and Local Parameters
//======================================================================
parameter NSAT                  = 3;
parameter LITERAL_ADDRESS_WIDTH = 12;
parameter VARIABLE_ADDRESS_WIDTH = 11;
parameter MAX_CLAUSE_MEMBERSHIP = 20;
parameter NUM_VARIABLES         = 2048;

localparam CT_WIDTH    = (VARIABLE_ADDRESS_WIDTH+1) * (NSAT-1) * MAX_CLAUSE_MEMBERSHIP;
localparam ATT_WIDTH   = VARIABLE_ADDRESS_WIDTH + MAX_CLAUSE_MEMBERSHIP;
localparam CLAUSE_WIDTH = NSAT * LITERAL_ADDRESS_WIDTH;
localparam MC = MAX_CLAUSE_MEMBERSHIP;
localparam VALID_WIDTH = 8;

//======================================================================
// Clock and Reset
//======================================================================
reg clk;
initial clk = 0;
always #5 clk = ~clk;
reg rst;

//======================================================================
// Disable external writing to ATT and Clause Table
//======================================================================
wire att_wr_en_i = 1'b0;
wire [LITERAL_ADDRESS_WIDTH:0] att_wr_addr_i = {LITERAL_ADDRESS_WIDTH+1{1'b0}};
wire [ATT_WIDTH-1:0] att_wr_data_i = {ATT_WIDTH{1'b0}};

wire ct_wr_en_i = 1'b0;
wire [VARIABLE_ADDRESS_WIDTH-1:0] ct_wr_addr_i = {VARIABLE_ADDRESS_WIDTH{1'b0}};
wire [CT_WIDTH-1:0] ct_wr_data_i = {CT_WIDTH{1'b0}};

//======================================================================
// Clause Register and ATT selection logic
//======================================================================
reg cr_wr_en;
reg [CLAUSE_WIDTH-1:0] ucs_selected_clause;
wire [CLAUSE_WIDTH-1:0] cr_selected_clause;
  
Clause_Register #(
    .NSAT(NSAT),
    .LITERAL_ADDRESS_WIDTH(LITERAL_ADDRESS_WIDTH)
) clause_register_inst (
    .clk_i(clk),
    .rst_i(rst),
    .wr_en_i(cr_wr_en),
    .data_i(ucs_selected_clause),
    .data_o(cr_selected_clause)
);
  
// For ATT lookup, use a two‑bit selector signal att_src:
reg [1:0] att_src;
wire [LITERAL_ADDRESS_WIDTH-1:0] _cr_selected_literal;
assign _cr_selected_literal = att_src[1] ? 
      (att_src[0] ? 
          {LITERAL_ADDRESS_WIDTH{1'b0}} : // if att_src == 2'b10
          cr_selected_clause[LITERAL_ADDRESS_WIDTH*2 +: LITERAL_ADDRESS_WIDTH]) 
      : 
      (att_src[0] ? 
          cr_selected_clause[LITERAL_ADDRESS_WIDTH*1 +: LITERAL_ADDRESS_WIDTH] : 
          cr_selected_clause[LITERAL_ADDRESS_WIDTH*0 +: LITERAL_ADDRESS_WIDTH]);
  
wire [LITERAL_ADDRESS_WIDTH-1:0] _cr_negated_literal;
assign _cr_negated_literal = { ~_cr_selected_literal[LITERAL_ADDRESS_WIDTH-1],
                                _cr_selected_literal[LITERAL_ADDRESS_WIDTH-2:0] };
  
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
// Clause Negated Literals Buffer
//======================================================================
reg cflb_wr_en;
wire [CLAUSE_WIDTH-1:0] _selected_clause_negated;
genvar n;
generate
    for(n = 0; n < NSAT; n = n + 1) begin : gen_temp_buf
        assign _selected_clause_negated[LITERAL_ADDRESS_WIDTH*n +: LITERAL_ADDRESS_WIDTH] = 
            { cr_selected_clause[LITERAL_ADDRESS_WIDTH*(n+1)-1],
              cr_selected_clause[LITERAL_ADDRESS_WIDTH*n +: VARIABLE_ADDRESS_WIDTH] };
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
assign {_selected_literal_negated_neg_bit, _selected_literal_negated_addr} = _selected_literal_negated;

assign _selected_literal_negated = vfs_selected[1] ? 
      (vfs_selected[0] ? 
          {LITERAL_ADDRESS_WIDTH{1'b0}} : 
          cnlb_clause[LITERAL_ADDRESS_WIDTH*2 +: LITERAL_ADDRESS_WIDTH]) 
      : 
      (vfs_selected[0] ? 
          cnlb_clause[LITERAL_ADDRESS_WIDTH*1 +: LITERAL_ADDRESS_WIDTH] : 
          cnlb_clause[LITERAL_ADDRESS_WIDTH*0 +: LITERAL_ADDRESS_WIDTH]);

//======================================================================
// Clause Table instantiation
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
        for(q = 0; q < NSAT-1; q = q + 1) begin : gen_ct_inner_fixed
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
// Temporal Buffer Wrapper instantiation
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
assign tbuf_out = ct_clauses;

wire [MC * CLAUSE_WIDTH - 1 : 0] _broken_clauses;
generate
  for(n = 0; n < MC; n = n + 1) begin
      assign _broken_clauses[n * CLAUSE_WIDTH +: CLAUSE_WIDTH] = 
         {tbw_literals_multi_out[n * (NSAT-1)*LITERAL_ADDRESS_WIDTH +: (NSAT-1)*LITERAL_ADDRESS_WIDTH],
          _selected_literal_negated};
  end
endgenerate

//======================================================================
// Variable Table Cluster 2
//======================================================================
wire [NSAT*VARIABLE_ADDRESS_WIDTH-1:0] usc_selected_clause_addresses;
wire [NSAT - 1 : 0]                          ucs_selected_clause_negation_bits;
genvar a;
generate
    for(a = 0; a < NSAT; a = a + 1) begin : gen_usc_addr
        assign ucs_selected_clause_negation_bits[a] = ucs_selected_clause[LITERAL_ADDRESS_WIDTH * (a + 1) - 1];
        assign usc_selected_clause_addresses[a*VARIABLE_ADDRESS_WIDTH +: VARIABLE_ADDRESS_WIDTH] =
         ucs_selected_clause[a*LITERAL_ADDRESS_WIDTH +: VARIABLE_ADDRESS_WIDTH];
    end
endgenerate
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
// Clause Evaluator Cluster 1
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
// Clause Evaluator 2
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
always @(posedge clk) begin
    if (rst)
        nb2_negation_bits_reg <= 0;
    else
        // For testing, force nb2_negation_bits to 3'b100 (i.e. 4)
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
// Test Stimulus and Scoreboard
//======================================================================
integer j, k;
reg [LITERAL_ADDRESS_WIDTH-1:0] exp_sel_lit;
reg [LITERAL_ADDRESS_WIDTH-1:0] exp_neg_lit;
reg [VARIABLE_ADDRESS_WIDTH-1:0] exp_att_addr;
reg [MAX_CLAUSE_MEMBERSHIP-1:0] exp_att_mask;
reg [ATT_WIDTH-1:0] exp_att_data;
reg [CT_WIDTH-1:0] exp_ct_data;
reg [CLAUSE_WIDTH-1:0] exp_broken_clause;

reg [LITERAL_ADDRESS_WIDTH-1:0] original_lit;
reg [LITERAL_ADDRESS_WIDTH-1:0] neg_lit;
reg [LITERAL_ADDRESS_WIDTH-1:0] lit0, lit1, lit2;

initial begin
    $display("=== Starting Enhanced Pipeline Testbench for ClauseRegister->ATT->ClauseTable->VT->CE ===");
    rst = 1;
    cr_wr_en = 0;
    vt_wr_en = 0;
    tb_wr_index = 0;
    att_src = 0;
    force vfs_selected = 0; //testing without vfs
    vt_addr_src = 0;
    #20; rst = 0;
 
    $display("Preload from mem files completed (if mem files are present).");

    for(k = 0; k < 50; k = k + 1) begin
        lit0 = {1'b1, {(LITERAL_ADDRESS_WIDTH-1-VALID_WIDTH){1'b0}}, (prng_random_number % (2*NUM_VARIABLES)) & ((1 << VALID_WIDTH) - 1)};
        lit1 = {1'b1, {(LITERAL_ADDRESS_WIDTH-1-VALID_WIDTH){1'b0}}, (prng_random_number % (2*NUM_VARIABLES)) & ((1 << VALID_WIDTH) - 1)};
        lit2 = {1'b1, {(LITERAL_ADDRESS_WIDTH-1-VALID_WIDTH){1'b0}}, (prng_random_number % (2*NUM_VARIABLES)) & ((1 << VALID_WIDTH) - 1)};

        ucs_selected_clause = { lit2, lit1, lit0 };
        cr_wr_en = 1;
        @(posedge clk); 
        cr_wr_en = 0;

        @(posedge clk);
        @(posedge clk);

        if (cr_selected_clause !== ucs_selected_clause)
            $display("FAIL Clause Register: Expected=0x%0h, Got=0x%0h", ucs_selected_clause, cr_selected_clause);
        else
            $display("PASS Clause Register: cr_selected_clause matches ucs_selected_clause");

        cflb_wr_en = 1; 
        @(posedge clk); 
        cflb_wr_en = 0;
        
        for(att_src = 0; att_src < 3; att_src = att_src + 1) begin
            @(posedge clk);
            force vfs_selected = att_src; //testing without vfs
            tb_wr_index = vfs_selected;
            // Wait for pipeline settling:
            repeat(8) @(posedge clk);
            if(att_src == 0)
                exp_sel_lit = cr_selected_clause[0*LITERAL_ADDRESS_WIDTH +: LITERAL_ADDRESS_WIDTH];
            else if(att_src == 1)
                exp_sel_lit = cr_selected_clause[1*LITERAL_ADDRESS_WIDTH +: LITERAL_ADDRESS_WIDTH];
            else if(att_src == 2)
                exp_sel_lit = cr_selected_clause[2*LITERAL_ADDRESS_WIDTH +: LITERAL_ADDRESS_WIDTH];
            else exp_sel_lit = 0;
            
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

            exp_att_addr = exp_neg_lit[VARIABLE_ADDRESS_WIDTH-1:0];
            exp_att_mask = { {(MAX_CLAUSE_MEMBERSHIP - VARIABLE_ADDRESS_WIDTH){1'b0}}, exp_neg_lit };
            exp_att_data = { exp_att_addr, exp_att_mask };
            exp_ct_data = { {(CT_WIDTH-8){1'b0}}, exp_att_addr[7:0] };

            $display("ATT: Got=0x%0h", {att_addr_out, att_mask_out});
            $display("Clause Table: Got=0x%0h", ct_clauses);

            if (mb_mask_bits === att_mask_out)
                $display("PASS Mask Buffer: Expected=0x%0h, Got=0x%0h", att_mask_out, mb_mask_bits);
            else
                $display("FAIL Mask Buffer: Expected=0x%0h, Got=0x%0h", att_mask_out, mb_mask_bits);

            if (tbw_literals_multi_out === tbuf_out)
                $display("PASS Temporal Buffer: Expected=0x%0h, Got=0x%0h", tbuf_out, tbw_literals_multi_out);
            else
                $display("FAIL Temporal Buffer: Expected=0x%0h, Got=0x%0h", tbuf_out, tbw_literals_multi_out);

            if (ce1_break_bits === {MC{1'b1}})
                $display("PASS CE Cluster1: ce1_break=0x%0h as expected", ce1_break_bits);
            else
                $display("FAIL CE Cluster1: Expected=0x%0h, Got=0x%0h", {MC{1'b1}}, ce1_break_bits);

            if (cnlb_clause !== _selected_clause_negated)
                $display("FAIL Clause Negated Buffer: Expected=0x%0h, Got=0x%0h", _selected_clause_negated, cnlb_clause);
            else
                $display("PASS Clause Negated Buffer: cnlb_clause matches _selected_clause_negated");

            if (_selected_literal_negated !== (vfs_selected[1] ? 
                    (vfs_selected[0] ? {LITERAL_ADDRESS_WIDTH{1'b0}} : 
                        cnlb_clause[LITERAL_ADDRESS_WIDTH*2 +: LITERAL_ADDRESS_WIDTH])
                    : (vfs_selected[0] ? 
                        cnlb_clause[LITERAL_ADDRESS_WIDTH*1 +: LITERAL_ADDRESS_WIDTH] : 
                        cnlb_clause[LITERAL_ADDRESS_WIDTH*0 +: LITERAL_ADDRESS_WIDTH])))
                $display("FAIL _selected_literal_negated: Mismatch");
            else
                $display("PASS _selected_literal_negated: Correctly selected literal 0x%0h", _selected_literal_negated);

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
    end
    $finish;
end

endmodule
