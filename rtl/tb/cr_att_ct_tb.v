`timescale 1ns/1ps
module cr_att_ct_tb;

  // -------------------------------------------------------------------------
  // Parameters from the design
  // -------------------------------------------------------------------------
  parameter NSAT                  = 3;
  parameter LITERAL_ADDRESS_WIDTH = 12; 
  parameter VARIABLE_ADDRESS_WIDTH = 11;
  parameter MAX_CLAUSE_MEMBERSHIP = 20;
  parameter NUM_VARIABLES         = 2048;          

  // Derived parameters
  localparam CT_WIDTH     = (VARIABLE_ADDRESS_WIDTH+1) * (NSAT-1) * MAX_CLAUSE_MEMBERSHIP;
  localparam ATT_WIDTH    = VARIABLE_ADDRESS_WIDTH + MAX_CLAUSE_MEMBERSHIP;
  localparam CLAUSE_WIDTH = NSAT * LITERAL_ADDRESS_WIDTH;
  localparam ATT_DEPTH    = (1 << LITERAL_ADDRESS_WIDTH); // 4096 entries

  // -------------------------------------------------------------------------
  // Restrict the random literals to a safe range
  // -------------------------------------------------------------------------
  parameter VALID_LIT_WIDTH = 8; // For example, random portion is 8 bits (range 0-255)

  // -------------------------------------------------------------------------
  // Clock/Reset
  // -------------------------------------------------------------------------
  reg clk;
  reg rst;
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10 ns period
  end

  // -------------------------------------------------------------------------
  // Clause Register
  // -------------------------------------------------------------------------
  reg                         cr_wr_en;
  reg [CLAUSE_WIDTH - 1 : 0]    ucs_selected_clause;
  wire [CLAUSE_WIDTH - 1 : 0]   cr_selected_clause;

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

  // -------------------------------------------------------------------------
  // Stage A: Negate top bit in each literal (simulate temporary flip)
  // -------------------------------------------------------------------------
  wire [CLAUSE_WIDTH - 1 : 0] _selected_clause_negated;
  genvar n;
  generate
    for(n = 0; n < NSAT; n = n + 1) begin : gen_negate
      assign _selected_clause_negated[LITERAL_ADDRESS_WIDTH*n +: LITERAL_ADDRESS_WIDTH] =
        { ~cr_selected_clause[LITERAL_ADDRESS_WIDTH*(n+1)-1],
          cr_selected_clause[LITERAL_ADDRESS_WIDTH*n +: (LITERAL_ADDRESS_WIDTH-1)] };
    end
  endgenerate

  // Pipeline register for the negated clause (Stage A output)
  reg [CLAUSE_WIDTH - 1 : 0] clause_negated_literals_buffer;
  reg                        cflb_wr_en;
  always @(posedge clk) begin
    if (rst)
      clause_negated_literals_buffer <= 0;
    else if (cflb_wr_en)
      clause_negated_literals_buffer <= _selected_clause_negated;
  end

  wire [CLAUSE_WIDTH - 1 : 0] cnlb_clause;
  assign cnlb_clause = clause_negated_literals_buffer;

  // -------------------------------------------------------------------------
  // MUX to pick one of the three negated literals
  // -------------------------------------------------------------------------
  reg [1:0] vfs_selected;
  // _selected_literal_negated is one 12-bit literal selected from the negated clause.
  wire [LITERAL_ADDRESS_WIDTH - 1 : 0] _selected_literal_negated;
  assign _selected_literal_negated =
    (vfs_selected == 2'b00) ? cnlb_clause[0 +: LITERAL_ADDRESS_WIDTH] :
    (vfs_selected == 2'b01) ? cnlb_clause[LITERAL_ADDRESS_WIDTH +: LITERAL_ADDRESS_WIDTH] :
    (vfs_selected == 2'b10) ? cnlb_clause[2*LITERAL_ADDRESS_WIDTH +: LITERAL_ADDRESS_WIDTH] :
                              {LITERAL_ADDRESS_WIDTH{1'bx}};

  // -------------------------------------------------------------------------
  // Address Translation Table
  // -------------------------------------------------------------------------
  wire [VARIABLE_ADDRESS_WIDTH - 1 : 0] att_addr_out;
  wire [MAX_CLAUSE_MEMBERSHIP - 1 : 0]  att_mask_out;
  Address_Translation_Table #(
    .CLAUSE_COUNT(MAX_CLAUSE_MEMBERSHIP),
    .LITERAL_ADDRESS_WIDTH(LITERAL_ADDRESS_WIDTH),
    .CLAUSE_TABLE_ADDRESS_WIDTH(VARIABLE_ADDRESS_WIDTH),
    .AT_MEM_FILE("/home/harim_choe/Solving-SAT-in-FPGA-UCSB/rtl/mem/my_at.mem")
  ) att_inst (
    .clk_i   (clk),
    .wr_en_i (1'b0),
    .wr_addr_i({LITERAL_ADDRESS_WIDTH+1{1'b0}}),
    .wr_data_i({ATT_WIDTH{1'b0}}),
    .rd_addr_i(_selected_literal_negated),
    .addr_o  (att_addr_out),
    .mask_o  (att_mask_out)
  );

  // -------------------------------------------------------------------------
  // Clause Table
  // -------------------------------------------------------------------------
  wire [CT_WIDTH - 1 : 0] ct_clauses;
  Clause_Table #(
    .CLAUSE_COUNT(MAX_CLAUSE_MEMBERSHIP),
    .DEPTH(NUM_VARIABLES),
    .VARIABLE_ADDRESS_WIDTH(VARIABLE_ADDRESS_WIDTH),
    .NSAT(NSAT),
    .CT_MEM_FILE("/home/harim_choe/Solving-SAT-in-FPGA-UCSB/rtl/mem/my_ct.mem")
  ) clause_table_inst (
    .clk_i      (clk),
    .wr_en_i    (1'b0),
    .wr_addr_i  ({VARIABLE_ADDRESS_WIDTH{1'b0}}),
    .wr_clauses_i({CT_WIDTH{1'b0}}),
    .rd_addr_i  (att_addr_out),
    .clauses_o  (ct_clauses)
  );

  // -------------------------------------------------------------------------
  // Mask Buffer (simulate pipeline delay between ATT and clause evaluator)
  // -------------------------------------------------------------------------
  reg [MAX_CLAUSE_MEMBERSHIP-1:0] mask_buffer_0;
  reg [MAX_CLAUSE_MEMBERSHIP-1:0] mask_buffer_1;
  reg [MAX_CLAUSE_MEMBERSHIP-1:0] mask_buffer_2;
  wire [MAX_CLAUSE_MEMBERSHIP-1:0] mb_mask_bits;
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
  assign mb_mask_bits = mask_buffer_2;

  // -------------------------------------------------------------------------
  // Drive a clause into the Clause Register and read the outputs
  // -------------------------------------------------------------------------
  integer test_iter, lit_idx;
  reg [LITERAL_ADDRESS_WIDTH-1:0] original_lit;
  reg [LITERAL_ADDRESS_WIDTH-1:0] neg_lit;
  reg [LITERAL_ADDRESS_WIDTH-1:0] gen_lit0, gen_lit1, gen_lit2;

  initial begin
    $display("=== Starting CR -> ATT -> CT Flow Test using mem files ===");
    rst = 1;
    cr_wr_en = 0;
    ucs_selected_clause = 0;
    cflb_wr_en = 0;
    vfs_selected = 0;
    #20;
    rst = 0;
    
    for(test_iter = 0; test_iter < 64; test_iter = test_iter + 1) begin
      gen_lit0 = {1'b1, {(LITERAL_ADDRESS_WIDTH-1-VALID_LIT_WIDTH){1'b0}}, ($random % (1 << VALID_LIT_WIDTH))};
      gen_lit1 = {1'b1, {(LITERAL_ADDRESS_WIDTH-1-VALID_LIT_WIDTH){1'b0}}, ($random % (1 << VALID_LIT_WIDTH))};
      gen_lit2 = {1'b1, {(LITERAL_ADDRESS_WIDTH-1-VALID_LIT_WIDTH){1'b0}}, ($random % (1 << VALID_LIT_WIDTH))};
      
      // Form the 3-SAT clause (concatenate literals for NSAT=3)
      ucs_selected_clause = {gen_lit2, gen_lit1, gen_lit0};

      cr_wr_en = 1;
      @(posedge clk);
      cr_wr_en = 0;
      @(posedge clk);
      
      cflb_wr_en = 1;
      @(posedge clk);
      cflb_wr_en = 0;
      @(posedge clk);
      
      for(lit_idx = 0; lit_idx < NSAT; lit_idx = lit_idx + 1) begin
        vfs_selected = lit_idx[1:0];
        repeat (4) @(posedge clk);
        
        case(lit_idx)
          0: original_lit = ucs_selected_clause[0 +: LITERAL_ADDRESS_WIDTH];
          1: original_lit = ucs_selected_clause[LITERAL_ADDRESS_WIDTH +: LITERAL_ADDRESS_WIDTH];
          2: original_lit = ucs_selected_clause[2*LITERAL_ADDRESS_WIDTH +: LITERAL_ADDRESS_WIDTH];
          default: original_lit = 0;
        endcase
        neg_lit = { ~original_lit[11], original_lit[10:0] };
        
        $display("Test %0d, Literal %0d:", test_iter, lit_idx);
        $display("Original Literal = 0x%03h, Negated = 0x%03h", original_lit, neg_lit);
        $display("ATT Output: addr = 0x%0h, mask = 0x%0h", att_addr_out, att_mask_out);
        $display("CT Output: 0x%0h", ct_clauses);
        $display("Mask Buffer Final Stage: 0x%0h", mb_mask_bits);
        @(posedge clk);
      end
      $display("---- Completed test iteration %0d ----\n", test_iter);
    end

    $display("=== Finished CR -> ATT -> CT Pipeline Test ===");
    $finish;
  end

endmodule
