`timescale 1ns/1ps

module AXI_FullSystem_tb;

// -----------------------------------------------------------------------------
// PARAMETERS
// -----------------------------------------------------------------------------
localparam AXI_ID_WIDTH    = 4;
localparam AXI_ADDR_WIDTH  = 32;
localparam AXI_DATA_WIDTH  = 32;
localparam AXI_STRB_WIDTH  = AXI_DATA_WIDTH/8;
localparam MAX_BURST_LEN   = 8;

localparam ATT_BASE_ADDR    = 32'h0000_0000;
localparam ATT_SIZE_BYTES   = 32'h0000_1000;

localparam CLAUSE_BASE_ADDR = 32'h0001_0000;
localparam CLAUSE_SIZE_BYTES= 32'h0000_4000;

localparam VARCL1_BASE_ADDR = 32'h0002_0000;
localparam VARCL1_SIZE_BYTES= 32'h0000_2000;

localparam VARCL2_BASE_ADDR = 32'h0003_0000;
localparam VARCL2_SIZE_BYTES= 32'h0000_2000;

// -----------------------------------------------------------------------------
// CLOCK/RESET
// -----------------------------------------------------------------------------
reg clk;
reg rst;
always #5 clk = ~clk;

initial begin
  clk = 0;
  rst = 1;
  #50 rst = 0;
end

// -----------------------------------------------------------------------------
// AXI signals
// -----------------------------------------------------------------------------
reg [AXI_ID_WIDTH-1:0]   s_axi_awid;
reg [AXI_ADDR_WIDTH-1:0] s_axi_awaddr;
reg [7:0]                s_axi_awlen;
reg [2:0]                s_axi_awsize;
reg [1:0]                s_axi_awburst;
reg                      s_axi_awvalid;
wire                     s_axi_awready;

reg  [AXI_DATA_WIDTH-1:0] s_axi_wdata;
reg  [AXI_STRB_WIDTH-1:0] s_axi_wstrb;
reg                       s_axi_wlast;
reg                       s_axi_wvalid;
wire                      s_axi_wready;

wire [AXI_ID_WIDTH-1:0]   s_axi_bid;
wire [1:0]                s_axi_bresp;
wire                      s_axi_bvalid;
reg                       s_axi_bready;

reg [AXI_ID_WIDTH-1:0]    s_axi_arid;
reg [AXI_ADDR_WIDTH-1:0]  s_axi_araddr;
reg [7:0]                 s_axi_arlen;
reg [2:0]                 s_axi_arsize;
reg [1:0]                 s_axi_arburst;
reg                       s_axi_arvalid;
wire                      s_axi_arready;

wire [AXI_ID_WIDTH-1:0]   s_axi_rid;
wire [AXI_DATA_WIDTH-1:0] s_axi_rdata;
wire [1:0]                s_axi_rresp;
wire                      s_axi_rlast;
wire                      s_axi_rvalid;
reg                       s_axi_rready;

// -----------------------------------------------------------------------------
// SUBMODULE SIGNALS
// -----------------------------------------------------------------------------
wire                       att_axi_wr_en_o;
wire [12:0]                att_axi_wr_addr_o;
wire [30:0]                att_axi_wr_data_o;
wire                       att_axi_rd_en_o;
wire [12:0]                att_axi_rd_addr_o;
reg  [30:0]                att_axi_rd_data_i;

wire                       clause_axi_wr_en_o;
wire [10:0]                clause_axi_wr_addr_o;
wire [((11+1)*(3-1)*20)-1:0] clause_axi_wr_clauses_o;
wire                       clause_axi_rd_en_o;
wire [10:0]                clause_axi_rd_addr_o;
reg  [((11+1)*(3-1)*20)-1:0] clause_axi_rd_clauses_i;

wire                       varcl1_axi_en_o;
wire                       varcl1_axi_wr_en_o;
wire [10:0]                varcl1_axi_addr_o;
wire                       varcl1_axi_data_o;
reg                        varcl1_axi_data_read_i;

wire                       varcl2_axi_en_o;
wire                       varcl2_axi_wr_en_o;
wire [10:0]                varcl2_axi_addr_o;
wire                       varcl2_axi_data_o;
reg                        varcl2_axi_data_read_i;

// -----------------------------------------------------------------------------
// INSTANTIATE AXI4 MEMORY CONTROLLER (DUT)
// -----------------------------------------------------------------------------
AXI4_Memory_Controller #(
  .AXI_ID_WIDTH   (AXI_ID_WIDTH),
  .AXI_ADDR_WIDTH (AXI_ADDR_WIDTH),
  .AXI_DATA_WIDTH (AXI_DATA_WIDTH),
  .AXI_STRB_WIDTH (AXI_STRB_WIDTH),
  .MAX_BURST_LEN  (MAX_BURST_LEN),

  .ATT_BASE_ADDR  (ATT_BASE_ADDR),
  .ATT_SIZE_BYTES (ATT_SIZE_BYTES),

  .CLAUSE_BASE_ADDR (CLAUSE_BASE_ADDR),
  .CLAUSE_SIZE_BYTES(CLAUSE_SIZE_BYTES),

  .VARCL1_BASE_ADDR(VARCL1_BASE_ADDR),
  .VARCL1_SIZE_BYTES(VARCL1_SIZE_BYTES),

  .VARCL2_BASE_ADDR(VARCL2_BASE_ADDR),
  .VARCL2_SIZE_BYTES(VARCL2_SIZE_BYTES)
) dut (
  .clk_i      (clk),
  .rst_i      (rst),

  // AXI Write Address
  .s_axi_awid     (s_axi_awid),
  .s_axi_awaddr   (s_axi_awaddr),
  .s_axi_awlen    (s_axi_awlen),
  .s_axi_awsize   (s_axi_awsize),
  .s_axi_awburst  (s_axi_awburst),
  .s_axi_awvalid  (s_axi_awvalid),
  .s_axi_awready  (s_axi_awready),

  // AXI Write Data
  .s_axi_wdata    (s_axi_wdata),
  .s_axi_wstrb    (s_axi_wstrb),
  .s_axi_wlast    (s_axi_wlast),
  .s_axi_wvalid   (s_axi_wvalid),
  .s_axi_wready   (s_axi_wready),

  // AXI Write Response
  .s_axi_bid      (s_axi_bid),
  .s_axi_bresp    (s_axi_bresp),
  .s_axi_bvalid   (s_axi_bvalid),
  .s_axi_bready   (s_axi_bready),

  // AXI Read Address
  .s_axi_arid     (s_axi_arid),
  .s_axi_araddr   (s_axi_araddr),
  .s_axi_arlen    (s_axi_arlen),
  .s_axi_arsize   (s_axi_arsize),
  .s_axi_arburst  (s_axi_arburst),
  .s_axi_arvalid  (s_axi_arvalid),
  .s_axi_arready  (s_axi_arready),

  // AXI Read Data
  .s_axi_rid      (s_axi_rid),
  .s_axi_rdata    (s_axi_rdata),
  .s_axi_rresp    (s_axi_rresp),
  .s_axi_rlast    (s_axi_rlast),
  .s_axi_rvalid   (s_axi_rvalid),
  .s_axi_rready   (s_axi_rready),

  // Submodules
  .att_axi_wr_en_o    (att_axi_wr_en_o),
  .att_axi_wr_addr_o  (att_axi_wr_addr_o),
  .att_axi_wr_data_o  (att_axi_wr_data_o),
  .att_axi_rd_en_o    (att_axi_rd_en_o),
  .att_axi_rd_addr_o  (att_axi_rd_addr_o),
  .att_axi_rd_data_i  (att_axi_rd_data_i),

  .clause_axi_wr_en_o      (clause_axi_wr_en_o),
  .clause_axi_wr_addr_o    (clause_axi_wr_addr_o),
  .clause_axi_wr_clauses_o (clause_axi_wr_clauses_o),
  .clause_axi_rd_en_o      (clause_axi_rd_en_o),
  .clause_axi_rd_addr_o    (clause_axi_rd_addr_o),
  .clause_axi_rd_clauses_i (clause_axi_rd_clauses_i),

  .varcl1_axi_en_o    (varcl1_axi_en_o),
  .varcl1_axi_wr_en_o (varcl1_axi_wr_en_o),
  .varcl1_axi_addr_o  (varcl1_axi_addr_o),
  .varcl1_axi_data_o  (varcl1_axi_data_o),
  .varcl1_axi_data_read_i (varcl1_axi_data_read_i),

  .varcl2_axi_en_o    (varcl2_axi_en_o),
  .varcl2_axi_wr_en_o (varcl2_axi_wr_en_o),
  .varcl2_axi_addr_o  (varcl2_axi_addr_o),
  .varcl2_axi_data_o  (varcl2_axi_data_o),
  .varcl2_axi_data_read_i (varcl2_axi_data_read_i)
);

// -----------------------------------------------------------------------------
// INSTANTIATE SUBMODULES (as an example)
// -----------------------------------------------------------------------------
Address_Translation_Table #(
  .CLAUSE_COUNT(20),
  .LITERAL_ADDRESS_WIDTH(12),
  .CLAUSE_TABLE_ADDRESS_WIDTH(11)
) address_translation_table_inst (
  .clk_i       (clk),
  .axi_wr_en_i (att_axi_wr_en_o),
  .axi_wr_addr_i(att_axi_wr_addr_o),
  .axi_wr_data_i(att_axi_wr_data_o),
  .rd_addr_i   (att_axi_rd_addr_o),
  .addr_o      (),
  .mask_o      ()
);

Clause_Table #(
  .CLAUSE_COUNT(20),
  .DEPTH(2048),
  .VARIABLE_ADDRESS_WIDTH(11),
  .NSAT(3)
) clause_table_inst (
  .clk_i          (clk),
  .axi_wr_en_i    (clause_axi_wr_en_o),
  .axi_wr_addr_i  (clause_axi_wr_addr_o),
  .axi_wr_clauses_i (clause_axi_wr_clauses_o),
  .rd_addr_i      (clause_axi_rd_addr_o),
  .clauses_o      ()
);

Variable_Table_Cluster #(
  .VARIABLE_ADDRESS_WIDTH(11),
  .CLUSTER_SIZE(40)
) varcl1_inst (
  .clk_i       (clk),
  .axi_en_i    (varcl1_axi_en_o),
  .axi_wr_en_i (varcl1_axi_wr_en_o),
  .axi_addr_i  (varcl1_axi_addr_o),
  .axi_data_i  (varcl1_axi_data_o),
  .en_i        (1'b0),
  .wr_en_i     (1'b0),
  .addr_mi     ({40*11{1'b0}}),
  .data_i      (1'b0),
  .data_mo     ()
);

Variable_Table_Cluster #(
  .VARIABLE_ADDRESS_WIDTH(11),
  .CLUSTER_SIZE(40)
) varcl2_inst (
  .clk_i       (clk),
  .axi_en_i    (varcl2_axi_en_o),
  .axi_wr_en_i (varcl2_axi_wr_en_o),
  .axi_addr_i  (varcl2_axi_addr_o),
  .axi_data_i  (varcl2_axi_data_o),
  .en_i        (1'b0),
  .wr_en_i     (1'b0),
  .addr_mi     ({40*11{1'b0}}),
  .data_i      (1'b0),
  .data_mo     ()
);

// -----------------------------------------------------------------------------
// CAPTURE SUBMODULE SIGNALS ON THE SAME CLOCK THEY PULSE
// -----------------------------------------------------------------------------
//
// Instead of waiting #10, we watch the signals every clock.
// We store them in "captured" regs if they go high.
//
reg        att_wr_en_captured;
reg [12:0] att_wr_addr_captured;
reg [30:0] att_wr_data_captured;

reg        clause_wr_en_captured;
reg [10:0] clause_wr_addr_captured;

reg        varcl1_wr_en_captured;
reg [10:0] varcl1_wr_addr_captured;
reg        varcl1_wr_data_captured;

reg        varcl2_en_captured;
reg [10:0] varcl2_addr_captured;

always @(posedge clk) begin
  // Default to 'no new capture' each clock,
  // but if we see a pulse, we store it so the test can check after the handshake.
  att_wr_en_captured <= 1'b0;
  clause_wr_en_captured <= 1'b0;
  varcl1_wr_en_captured <= 1'b0;
  varcl2_en_captured    <= 1'b0;

  if (att_axi_wr_en_o) begin
    att_wr_en_captured   <= 1'b1;
    att_wr_addr_captured <= att_axi_wr_addr_o;
    att_wr_data_captured <= att_axi_wr_data_o;
  end

  if (clause_axi_wr_en_o) begin
    clause_wr_en_captured   <= 1'b1;
    clause_wr_addr_captured <= clause_axi_wr_addr_o;
  end

  if (varcl1_axi_wr_en_o) begin
    varcl1_wr_en_captured   <= 1'b1;
    varcl1_wr_addr_captured <= varcl1_axi_addr_o;
    varcl1_wr_data_captured <= varcl1_axi_data_o;
  end

  if (varcl2_axi_en_o) begin
    varcl2_en_captured   <= 1'b1;
    varcl2_addr_captured <= varcl2_axi_addr_o;
  end
end

// -----------------------------------------------------------------------------
// TEST INFRASTRUCTURE
// -----------------------------------------------------------------------------
integer test_passed, test_failed;
initial begin
  test_passed = 0;
  test_failed = 0;

  // Wait for reset de-assert
  @(negedge rst);
  #50;

  // Let's run some testcases
  testcase_single_beat_write_att();
  testcase_single_beat_write_clause();
  testcase_single_beat_write_varcl1();
  testcase_single_beat_read_varcl2();
  
  #100;
  $display("=============================================");
  $display("TEST SUMMARY => test_passed=%0d, test_failed=%0d", test_passed, test_failed);
  if(test_failed==0) $display("ALL TESTS PASSED!");
  else               $display("SOME TESTS FAILED!");
  $stop;
end

// -----------------------------------------------------------------------------
// AXI WRITE/READ HELPER TASKS
// -----------------------------------------------------------------------------
task axi_write_single(
  input [AXI_ADDR_WIDTH-1:0] addr,
  input [AXI_DATA_WIDTH-1:0] data,
  output reg [1:0]           resp
);
begin
  // AW
  s_axi_awid    = 4'h1;
  s_axi_awaddr  = addr;
  s_axi_awlen   = 8'd0;       // single beat
  s_axi_awsize  = 3'd2;       // 4 bytes
  s_axi_awburst = 2'b01;      // INCR
  s_axi_awvalid = 1'b1;
  @(posedge clk);
  while(!s_axi_awready) @(posedge clk);
  s_axi_awvalid = 1'b0;

  // W
  s_axi_wdata  = data;
  s_axi_wstrb  = 4'hF;
  s_axi_wlast  = 1'b1;
  s_axi_wvalid = 1'b1;
  @(posedge clk);
  while(!s_axi_wready) @(posedge clk);
  @(posedge clk);
  s_axi_wvalid=0;
  s_axi_wlast =0;

  // B
  s_axi_bready=1;
  while(!s_axi_bvalid) @(posedge clk);
  resp = s_axi_bresp;
  @(posedge clk);
  s_axi_bready=0;
end
endtask

task axi_read_single(
  input [AXI_ADDR_WIDTH-1:0] addr,
  output reg [AXI_DATA_WIDTH-1:0] data_out,
  output reg [1:0]                resp_out
);
begin
  s_axi_arid   = 4'h2;
  s_axi_araddr = addr;
  s_axi_arlen  = 8'd0;   // single beat
  s_axi_arsize = 3'd2;   // 4 bytes
  s_axi_arburst= 2'b01;  // INCR
  s_axi_arvalid= 1'b1;
  @(posedge clk);
  while(!s_axi_arready) @(posedge clk);
  s_axi_arvalid=0;

  s_axi_rready=1;
  @(posedge clk);
  while(!s_axi_rvalid) @(posedge clk);

  data_out = s_axi_rdata;
  resp_out = s_axi_rresp;
  @(posedge clk);
  s_axi_rready=0;
end
endtask

// -----------------------------------------------------------------------------
// TESTCASES
// -----------------------------------------------------------------------------
reg [1:0] local_resp;

// 1) Single beat write => ATT region
task testcase_single_beat_write_att;
begin
  $display("===========================================");
  $display("TESTCASE: SINGLE-BEAT WRITE => ATT region");

  // Clear our captured signals first
  att_wr_en_captured   = 0;
  att_wr_addr_captured = 0;
  att_wr_data_captured = 0;

  axi_write_single(ATT_BASE_ADDR + 32'h4, 32'hABCD_0001, local_resp);

  if(local_resp==2'b00) begin
    // Immediately after the write transaction finishes,
    // check what we captured during the cycle submodule was pulsed
    if(att_wr_en_captured==1'b1 &&
       att_wr_addr_captured==13'h0004 &&
       att_wr_data_captured==31'hABCD_0001) begin
      $display("  => PASS: att submodule => addr=0x%04h, data=0x%08h",
                att_wr_addr_captured, att_wr_data_captured);
      test_passed = test_passed + 1;
    end else begin
      $display("  => FAIL: att submodule mismatch => en=%b, addr=0x%h, data=0x%h",
               att_wr_en_captured, att_wr_addr_captured, att_wr_data_captured);
      test_failed = test_failed + 1;
    end
  end else begin
    $display("  => FAIL: Write resp=%b (expected OKAY)", local_resp);
    test_failed = test_failed + 1;
  end
end
endtask

// 2) Single beat write => Clause region
task testcase_single_beat_write_clause;
begin
  $display("===========================================");
  $display("TESTCASE: SINGLE-BEAT WRITE => Clause region");

  clause_wr_en_captured   = 0;
  clause_wr_addr_captured = 0;

  axi_write_single(CLAUSE_BASE_ADDR + 32'h8, 32'hDEAD_BEEF, local_resp);

  if(local_resp==2'b00) begin
    if(clause_wr_en_captured==1'b1 &&
       clause_wr_addr_captured==11'h008) begin
      $display("  => PASS: clause => wr_addr=0x%03h", clause_wr_addr_captured);
      test_passed = test_passed + 1;
    end else begin
      $display("  => FAIL: clause mismatch => en=%b, addr=0x%03h",
               clause_wr_en_captured, clause_wr_addr_captured);
      test_failed = test_failed + 1;
    end
  end else begin
    $display("  => FAIL: Write resp=%b (expected OKAY)", local_resp);
    test_failed = test_failed + 1;
  end
end
endtask

// 3) Single beat write => varcl1 region
task testcase_single_beat_write_varcl1;
begin
  $display("===========================================");
  $display("TESTCASE: SINGLE-BEAT WRITE => varcl1 region");

  varcl1_wr_en_captured   = 0;
  varcl1_wr_addr_captured = 0;
  varcl1_wr_data_captured = 0;

  axi_write_single(VARCL1_BASE_ADDR + 32'h0, 32'h1234_0001, local_resp);

  if(local_resp==2'b00) begin
    if(varcl1_wr_en_captured==1'b1 &&
       varcl1_wr_addr_captured==11'h000 &&
       varcl1_wr_data_captured==1'b1) begin
      $display("  => PASS: varcl1 => addr=0x%03h, data_bit=%b",
               varcl1_wr_addr_captured, varcl1_wr_data_captured);
      test_passed = test_passed + 1;
    end else begin
      $display("  => FAIL: varcl1 mismatch => en=%b, addr=0x%03h, data_bit=%b",
               varcl1_wr_en_captured, varcl1_wr_addr_captured, varcl1_wr_data_captured);
      test_failed = test_failed + 1;
    end
  end else begin
    $display("  => FAIL: Write resp=%b (expected OKAY)", local_resp);
    test_failed = test_failed + 1;
  end
end
endtask

// 4) Single beat read => varcl2 region
task testcase_single_beat_read_varcl2;
  reg [AXI_DATA_WIDTH-1:0] local_rdata;
begin
  $display("===========================================");
  $display("TESTCASE: SINGLE-BEAT READ => varcl2 region");

  // We'll set varcl2_axi_data_read_i = 1'b1 => the data bit from varcl2
  varcl2_axi_data_read_i = 1'b1;

  varcl2_en_captured = 1'b0;
  varcl2_addr_captured = 0;

  axi_read_single(VARCL2_BASE_ADDR + 32'h10, local_rdata, local_resp);

  if(local_resp==2'b00) begin
    // Check the captured signals
    if(varcl2_en_captured==1'b1 && varcl2_addr_captured==11'h010) begin
      $display("  => PASS: varcl2 read => rdata=0x%08h, bit=1, addr=0x%03h",
               local_rdata, varcl2_addr_captured);
      test_passed = test_passed + 1;
    end else begin
      $display("  => FAIL: varcl2 read mismatch => en=%b, addr=0x%03h, rdata=0x%08h",
               varcl2_en_captured, varcl2_addr_captured, local_rdata);
      test_failed = test_failed + 1;
    end
  end else begin
    $display("  => FAIL: read resp=%b (expected OKAY)", local_resp);
    test_failed = test_failed + 1;
  end
end
endtask

endmodule