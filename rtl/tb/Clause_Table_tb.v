`timescale 1ns/1ps
module Clause_Table_tb;

  parameter CLAUSE_COUNT           = 20;
  parameter DEPTH                  = 2048;
  parameter VARIABLE_ADDRESS_WIDTH = 11;
  parameter NSAT                   = 3;
  // Each candidate is 24 bits; with CLAUSE_COUNT candidates per literal, total width = 480 bits.
  localparam CT_WIDTH = 24 * CLAUSE_COUNT;

  // Clock generation: 10 ns period
  reg clk;
  initial clk = 0;
  always #5 clk = ~clk;

  // DUT signals
  reg [VARIABLE_ADDRESS_WIDTH-1:0] rd_addr;
  wire [CT_WIDTH-1:0]              clauses_o;

  // Instantiate the DUT with mem file "my_ct.mem"
  Clause_Table #(
      .CLAUSE_COUNT(CLAUSE_COUNT),
      .DEPTH(DEPTH),
      .VARIABLE_ADDRESS_WIDTH(VARIABLE_ADDRESS_WIDTH),
      .NSAT(NSAT),
      .CT_MEM_FILE("/home/harim_choe/Z_KSAT/Python-Code/my_ct.mem")
  ) dut (
      .clk_i(clk),
      .wr_en_i(1'b0), // No writes during this test.
      .wr_addr_i({VARIABLE_ADDRESS_WIDTH{1'b0}}),
      .wr_clauses_i({CT_WIDTH{1'b0}}),
      .rd_addr_i(rd_addr),
      .clauses_o(clauses_o)
  );

  // Test: Read a few predetermined addresses from the loaded mem file.
  integer i;
  initial begin
    $display("----- CT Memory Initialization Test -----");
    // Wait for mem file to load
    @(posedge clk); @(posedge clk); @(posedge clk);
    
    // Read and display the first 8 entries.
    for (i = 0; i < 49; i = i + 1) begin
      rd_addr = i[VARIABLE_ADDRESS_WIDTH-1:0];
      @(posedge clk);
      $display("CT[%0d] => clauses_o = %0h", i, clauses_o);
    end
    
    $display("----- CT Memory Test Completed -----");
    $finish;
  end

endmodule
