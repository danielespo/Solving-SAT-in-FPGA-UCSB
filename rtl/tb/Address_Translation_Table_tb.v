`timescale 1ns/1ps
module Address_Translation_Table_tb;

  // Parameters
  parameter CLAUSE_COUNT               = 20;
  parameter LITERAL_ADDRESS_WIDTH      = 12; // 2^12 = 4096 addresses
  parameter CLAUSE_TABLE_ADDRESS_WIDTH = 11; // Address field width
  parameter MEM_DEPTH = (1 << LITERAL_ADDRESS_WIDTH);
  localparam WIDTH = CLAUSE_TABLE_ADDRESS_WIDTH + CLAUSE_COUNT; // Total data width

  // DUT signals
  reg                             clk_i;
  reg [LITERAL_ADDRESS_WIDTH-1:0] rd_addr_i; // Read address
  wire [CLAUSE_TABLE_ADDRESS_WIDTH-1:0] addr_o; // Address output from AT
  wire [CLAUSE_COUNT-1:0]         mask_o;         // Mask output from AT

  // Instantiate the DUT with mem file "my_at.mem"
  Address_Translation_Table #(
    .CLAUSE_COUNT(CLAUSE_COUNT),
    .LITERAL_ADDRESS_WIDTH(LITERAL_ADDRESS_WIDTH),
    .CLAUSE_TABLE_ADDRESS_WIDTH(CLAUSE_TABLE_ADDRESS_WIDTH),
    .MEM_DEPTH(MEM_DEPTH),
    .AT_MEM_FILE("/home/harim_choe/Z_KSAT/Python-Code/my_at.mem")
  ) dut (
    .clk_i(clk_i),
    .wr_en_i(1'b0),  // No write during this test.
    .wr_addr_i({(LITERAL_ADDRESS_WIDTH+1){1'b0}}),
    .wr_data_i({WIDTH{1'b0}}),
    .rd_addr_i(rd_addr_i),
    .addr_o(addr_o),
    .mask_o(mask_o)
  );

  // Clock generation: 10 ns period (100 MHz)
  initial begin
    clk_i = 0;
    forever #5 clk_i = ~clk_i;
  end

  integer i;
  // Test: Read a few predetermined addresses from the loaded mem file.
  initial begin
    $display("----- AT Memory Initialization Test -----");
    // Wait a few cycles for mem file to load
    @(posedge clk_i); @(posedge clk_i); @(posedge clk_i);
    
    // Read and display the first 16 entries.
    for (i = 0; i < 49; i = i + 1) begin
      rd_addr_i = i[LITERAL_ADDRESS_WIDTH-1:0];
      @(posedge clk_i);
      $display("AT[%0d] => addr_o = 0x%0h, mask_o = 0x%0h", i, addr_o, mask_o);
    end
    
    $display("----- AT Memory Test Completed -----");
    $finish;
  end

endmodule
