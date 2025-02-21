`timescale 1ns / 1ps

module Temporal_Buffer_Wrapper_tb;
  parameter NSAT = 3;
  parameter LITERAL_ADDRESS_WIDTH = 12;
  parameter MAX_CLAUSES_PER_VARIABLE = 20;
  parameter NSAT_BITS = 2;

  // -------------------------------------------------------------------------
  // Fix #1: Use consistent bit width for the data we pass to the module.
  // If your RTL truly stores (NSAT-1)*MAX_CLAUSES_PER_VARIABLE*LITERAL_ADDRESS_WIDTH bits,
  // that is 2 * 20 * 12 = 480 bits total.
  // So let's call that TB_WIDTH:
  // -------------------------------------------------------------------------
  localparam TB_WIDTH = (NSAT-1)*MAX_CLAUSES_PER_VARIABLE*LITERAL_ADDRESS_WIDTH; // = 480

  // We'll keep the same NUM_TESTS
  parameter NUM_TESTS = 31;

  // Inputs
  reg clk = 0;
  always #5 clk = ~clk;
  reg reset;

  reg [NSAT_BITS-1:0] wr_index;
  reg                 wr_en;
  // We'll store only TB_WIDTH bits now (480)
  reg [TB_WIDTH-1:0]  literals_in;

  reg [NSAT_BITS-1:0] re_index;

  // Output
  wire [TB_WIDTH-1:0] literals_out;

  // Instantiate the UUT
  Temporal_Buffer_Wrapper #(
      .NSAT(NSAT),
      .LITERAL_ADDRESS_WIDTH(LITERAL_ADDRESS_WIDTH),
      .MAX_CLAUSE_MEMBERSHIP(MAX_CLAUSES_PER_VARIABLE)
  ) uut (
      .clk_i(clk),
      .rst_i(reset),
      .wr_index_i(wr_index),
      .wr_en_i(wr_en),
      .wr_literals_mi(literals_in),
      .rd_index_i(re_index),
      .literals_mo(literals_out)
  );

  // We'll keep 3 arrays (flips_0..2) for each test, each sized TB_WIDTH=480
  reg [TB_WIDTH-1:0] flips_0 [0:NUM_TESTS-1];
  reg [TB_WIDTH-1:0] flips_1 [0:NUM_TESTS-1];
  reg [TB_WIDTH-1:0] flips_2 [0:NUM_TESTS-1];

  integer i, j, test_i;
  reg passed;
  reg [31:0] tests_passed;

  initial begin
    passed       = 1'b0;
    tests_passed = 32'b0;

    // -----------------------------------------------------------------------
    // 2) Generate random test data: we have 480 bits per flip, i.e. 15 32-bit randoms
    //    Because 480/32 = 15 exactly, no leftover remainder bits now.
    // -----------------------------------------------------------------------
    for(i = 0; i < NUM_TESTS; i = i + 1) begin
      for(j = 0; j < (TB_WIDTH/32); j = j + 1) begin
        flips_0[i][32*j +: 32] = $random;
        flips_1[i][32*j +: 32] = $random;
        flips_2[i][32*j +: 32] = $random;
      end
    end

    $display("Temporal Buffer Wrapper: Begin Simulation (Using %0d bits per flip).", TB_WIDTH);

    // Reset
    wr_index    = 0;
    wr_en       = 0;
    re_index    = 0;
    literals_in = 0;

    reset = 1;
    @(posedge clk);
    @(posedge clk);
    reset = 0;

    // 3) The main test loop
    for(test_i = 0; test_i < NUM_TESTS; test_i = test_i + 1) begin
      $display("* Beginning test #%0d at time %0t", test_i, $time);

      // Write flip0
      $display("| * writing clauses from flip 0");
      wr_en     = 1;
      wr_index  = 0;
      literals_in = flips_0[test_i];
      @(posedge clk);

      // Write flip1
      $display("| * writing clauses from flip 1");
      wr_index  = 1;
      literals_in = flips_1[test_i];
      @(posedge clk);

      // Write flip2
      $display("| * writing clauses from flip 2");
      wr_index  = 2;
      literals_in = flips_2[test_i];
      @(posedge clk);

      // ---------------------------------------------------------------------
      // 4) Wait at least one cycle to ensure the last write is safely stored
      //    in the temporal buffer's array, so we can read it reliably.
      // ---------------------------------------------------------------------
      wr_en = 0;
      @(posedge clk);

      // 5) Now pick a random re_index for reading
      re_index = $urandom % 3;
      $display("| * reading data from flip %d", re_index);

      // Wait 2 cycles to let the read settle. 
      @(posedge clk);
      @(posedge clk);

      // 6) Compare
      passed = 1'b0;
      case (re_index)
        0 : if(literals_out == flips_0[test_i]) passed = 1'b1;
        1 : if(literals_out == flips_1[test_i]) passed = 1'b1;
        2 : if(literals_out == flips_2[test_i]) passed = 1'b1;
        default: $display("    read index invalid (should never happen).");
      endcase

      if(passed == 1'b1) begin
        $display("| * test passed!");
        tests_passed = tests_passed + 1;
      end
      else begin
        $display("| * test failed: expected=oneOf{flip0,flip1,flip2}, got=0x%h", literals_out);
      end

      // Let a cycle or two pass
      @(posedge clk);
    end

    $display("Temporal Buffer Wrapper: End Simulation");
    $display("Passed %0d/%0d tests", tests_passed, NUM_TESTS);
    $finish;
  end

endmodule