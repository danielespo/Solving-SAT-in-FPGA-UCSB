`timescale 1ns/1ps

module cr_att_tb;

  //---------------------------------------------------------------------------
  // Parameters
  //---------------------------------------------------------------------------
  parameter NSAT                       = 3;
  parameter LITERAL_ADDRESS_WIDTH      = 12; 
  parameter CLAUSE_COUNT               = 20; // mask width
  parameter CLAUSE_TABLE_ADDRESS_WIDTH = 11; // address bits
  parameter WIDTH                      = CLAUSE_TABLE_ADDRESS_WIDTH + CLAUSE_COUNT;

  parameter N_WRITES = 4096;  
  parameter N_TESTS  = 16;     

  //---------------------------------------------------------------------------
  // Clock / Reset
  //---------------------------------------------------------------------------
  reg clk;
  reg rst;
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10ns period
  end

  //---------------------------------------------------------------------------
  // Clause Register signals
  //---------------------------------------------------------------------------
  reg  cr_wr_en;
  reg  [NSAT * LITERAL_ADDRESS_WIDTH - 1:0] ucs_selected_clause;
  wire [NSAT * LITERAL_ADDRESS_WIDTH - 1:0] cr_selected_clause;

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

  //---------------------------------------------------------------------------
  // MUX + Negate Logic
  //---------------------------------------------------------------------------
  // att_src = 0, use literal 0 (bits [11:0])
  // att_src = 1, use literal 1 (bits [23:12])
  // att_src = 2, use literal 2 (bits [35:24])
  reg [1:0] att_src;
  wire [LITERAL_ADDRESS_WIDTH-1:0] selected_literal;
  wire [LITERAL_ADDRESS_WIDTH-1:0] negated_literal;

  assign selected_literal =
    att_src[1]
      ? (att_src[0]
         ? {LITERAL_ADDRESS_WIDTH{1'bx}} // not used
         : cr_selected_clause[LITERAL_ADDRESS_WIDTH*2 +: LITERAL_ADDRESS_WIDTH])
      : (att_src[0]
         ? cr_selected_clause[LITERAL_ADDRESS_WIDTH*1 +: LITERAL_ADDRESS_WIDTH]
         : cr_selected_clause[LITERAL_ADDRESS_WIDTH*0 +: LITERAL_ADDRESS_WIDTH]);

  // Negate by flipping the top (sign) bit.
  assign negated_literal = {
    ~selected_literal[LITERAL_ADDRESS_WIDTH-1],
     selected_literal[LITERAL_ADDRESS_WIDTH-2:0]
  };

  //---------------------------------------------------------------------------
  // Address Translation Table signals
  //---------------------------------------------------------------------------
  reg  att_wr_en;
  reg  [LITERAL_ADDRESS_WIDTH : 0]   att_wr_addr; // Write address (13 bits)
  reg  [WIDTH - 1 : 0]              att_wr_data;
  wire [CLAUSE_TABLE_ADDRESS_WIDTH-1:0] att_addr_out;
  wire [CLAUSE_COUNT-1:0]               att_mask_out;

  Address_Translation_Table #(
    .CLAUSE_COUNT(CLAUSE_COUNT),
    .LITERAL_ADDRESS_WIDTH(LITERAL_ADDRESS_WIDTH),
    .CLAUSE_TABLE_ADDRESS_WIDTH(CLAUSE_TABLE_ADDRESS_WIDTH)
  ) att_inst (
    .clk_i    (clk),
    .wr_en_i  (att_wr_en),
    .wr_addr_i(att_wr_addr),
    .wr_data_i(att_wr_data),
    .rd_addr_i(negated_literal),
    .addr_o   (att_addr_out),
    .mask_o   (att_mask_out)
  );

  //---------------------------------------------------------------------------
  // Main Testbench: Hardcoded Large 3-SAT Problem Integration Test
  //---------------------------------------------------------------------------
  integer i, j;
  // Array of 16 hardcoded clauses; each clause is 3 literals (12 bits each)
  // For positive literals, MSB = 0; for negative literals, MSB = 1.
  reg [NSAT * LITERAL_ADDRESS_WIDTH - 1:0] test_clause [0:N_TESTS-1];
  reg [LITERAL_ADDRESS_WIDTH-1:0] expected_literal;
  reg [CLAUSE_TABLE_ADDRESS_WIDTH-1:0] expected_att_addr;
  reg [CLAUSE_COUNT-1:0] expected_att_mask;
  reg [LITERAL_ADDRESS_WIDTH-1:0] temp_literal;

  reg [CLAUSE_TABLE_ADDRESS_WIDTH-1:0] exp_addr;
  reg [CLAUSE_COUNT-1:0]               exp_mask;

  initial begin
    $display("----- Starting cr_att_tb Simulation with Large 3-SAT Problem -----");

    rst = 1;
    cr_wr_en = 0;
    att_wr_en = 0;
    att_wr_addr = 0;
    att_wr_data = 0;
    att_src = 0;
    ucs_selected_clause = 0;
    @(posedge clk);
    rst = 0;
    @(posedge clk);

    //--------------------------------------------------------------------------
    // Preload the Address Translation Table (AT)
    //--------------------------------------------------------------------------
    $display("Loading Address Translation Table with deterministic pattern...");
    for (i = 0; i < N_WRITES; i = i + 1) begin
      @(posedge clk);
      att_wr_en   = 1;
      att_wr_addr = i;
      exp_addr = (i * 3) % (1 << CLAUSE_TABLE_ADDRESS_WIDTH);
      exp_mask = (i * 7) % (1 << CLAUSE_COUNT);
      att_wr_data = {exp_addr, exp_mask};
      $display("  Written AT entry at address %0d", i);
    end
    @(posedge clk);
    att_wr_en = 0;
    $display("Completed loading Address Translation Table.");

    //--------------------------------------------------------------------------
    // Hardcode a Set of Clauses (representative of a real large 3-SAT problem)
    //--------------------------------------------------------------------------
    test_clause[0]  = {12'h003, 12'h802, 12'h001};  // Clause 0: (x1, ¬x2, x3)
    test_clause[1]  = {12'h806, 12'h005, 12'h804};  // Clause 1: (¬x4, x5, ¬x6)
    test_clause[2]  = {12'h809, 12'h008, 12'h007};  // Clause 2: (x7, x8, ¬x9)
    test_clause[3]  = {12'h00C, 12'h80B, 12'h80A};  // Clause 3: (¬x10, ¬x11, x12)
    test_clause[4]  = {12'h00F, 12'h80E, 12'h00D};  // Clause 4: (x13, ¬x14, x15)
    test_clause[5]  = {12'h012, 12'h011, 12'h010};  // Clause 5: (x16, x17, x18)
    test_clause[6]  = {12'h815, 12'h814, 12'h813};  // Clause 6: (¬x19, ¬x20, ¬x21)
    test_clause[7]  = {12'h818, 12'h817, 12'h016};  // Clause 7: (x22, ¬x23, ¬x24)
    test_clause[8]  = {12'h81B, 12'h01A, 12'h019};  // Clause 8: (x25, x26, ¬x27)
    test_clause[9]  = {12'h01E, 12'h01D, 12'h81C};  // Clause 9: (¬x28, x29, x30)
    test_clause[10] = {12'h021, 12'h820, 12'h01F};  // Clause 10: (x31, ¬x32, x33)
    test_clause[11] = {12'h824, 12'h023, 12'h822};  // Clause 11: (¬x34, x35, ¬x36)
    test_clause[12] = {12'h027, 12'h026, 12'h025};  // Clause 12: (x37, x38, x39)
    test_clause[13] = {12'h82B, 12'h82A, 12'h829};  // Clause 13: (¬x40, ¬x41, ¬x42)
    test_clause[14] = {12'h02E, 12'h82D, 12'h02C};  // Clause 14: (x43, ¬x44, x45)
    test_clause[15] = {12'h831, 12'h030, 12'h02F};  // Clause 15: (x46, x47, ¬x48)

    //--------------------------------------------------------------------------
    // For each test clause, load it into the Clause Register and then
    // iterate through each literal selection (att_src = 0, 1, 2)
    // to verify the AT outputs.
    //--------------------------------------------------------------------------
    for (i = 0; i < N_TESTS; i = i + 1) begin
      // Load current clause into Clause Register
      @(posedge clk);
      cr_wr_en = 1;
      ucs_selected_clause = test_clause[i];
      @(posedge clk);
      cr_wr_en = 0;
      $display("Loaded Clause %0d into Clause Register: %h", i, test_clause[i]);
      
      // Test each literal from the clause
      for (j = 0; j < 3; j = j + 1) begin
        @(posedge clk);
        att_src = j[1:0];
        @(posedge clk); // Allow selected_literal and negated_literal to settle
        @(posedge clk);
        
        // expected AT address = (negated_literal * 3) mod 2^(CLAUSE_TABLE_ADDRESS_WIDTH)
        // expected AT mask    = (negated_literal * 7) mod 2^(CLAUSE_COUNT)
        temp_literal      = negated_literal;
        expected_att_addr = (temp_literal * 3) % (1 << CLAUSE_TABLE_ADDRESS_WIDTH);
        expected_att_mask = (temp_literal * 7) % (1 << CLAUSE_COUNT);
        
        $display("Test Clause %0d, Literal %0d:", i, j);
        $display("Selected literal      = %h", selected_literal);
        $display("Negated literal       = %h", negated_literal);
        $display("Expected AT output    = {addr: %h, mask: %h}",
                  expected_att_addr, expected_att_mask);
        $display("Actual AT output      = {addr: %h, mask: %h}",
                  att_addr_out, att_mask_out);
        
        if ((att_addr_out !== expected_att_addr) || (att_mask_out !== expected_att_mask)) begin
          $display("ERROR: Mismatch detected!");
        end else begin
          $display("PASSED: Output matches expected values.");
        end
      end
      @(posedge clk);
      @(posedge clk);
      $display("---------------------------------------------------------");
    end

    $display("----- All Test Cases Completed Successfully -----");
    $finish;
  end

endmodule
