`timescale 1ns/1ps

module AXI4_Memory_Controller_tb;

localparam AXI_ID_WIDTH    = 4;
localparam AXI_ADDR_WIDTH  = 32;
localparam AXI_DATA_WIDTH  = 32;
localparam AXI_STRB_WIDTH  = AXI_DATA_WIDTH/8;
localparam MAX_BURST_LEN   = 16;

// Regions
localparam ATT_BASE_ADDR     = 32'h0000_0000;
localparam ATT_SIZE_BYTES    = 32'h0000_4000;  // 16 KB
localparam CLAUSE_BASE_ADDR  = 32'h0000_4000;
localparam CLAUSE_SIZE_BYTES = 32'h0001_e000;  // 120 KB
localparam VARCL1_BASE_ADDR  = 32'h0002_2000;
localparam VARCL1_SIZE_BYTES = 32'h0000_2000;  // 8 KB
localparam VARCL2_BASE_ADDR  = 32'h0002_4000;
localparam VARCL2_SIZE_BYTES = 32'h0000_2000;  // 8 KB

reg clk;
reg rst;
always #5 clk = ~clk;

initial begin
  clk = 0;
  rst = 1;
  #50 rst = 0;
end

// AXI signals
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

// Submodule I/O
wire                       att_axi_wr_en_o;
wire [12:0]               att_axi_wr_addr_o;
wire [30:0]               att_axi_wr_data_o;
wire                       att_axi_rd_en_o;
wire [12:0]               att_axi_rd_addr_o;
reg  [30:0]               att_axi_rd_data_i;

wire                       clause_axi_wr_en_o;
wire [10:0]               clause_axi_wr_addr_o;
wire [((11+1)*(3-1)*20)-1:0] clause_axi_wr_clauses_o;
wire                       clause_axi_rd_en_o;
wire [10:0]               clause_axi_rd_addr_o;
reg  [((11+1)*(3-1)*20)-1:0] clause_axi_rd_clauses_i;

wire                       varcl1_axi_en_o;
wire                       varcl1_axi_wr_en_o;
wire [10:0]               varcl1_axi_addr_o;
wire                       varcl1_axi_data_o;
reg                        varcl1_axi_data_read_i;

wire                       varcl2_axi_en_o;
wire                       varcl2_axi_wr_en_o;
wire [10:0]               varcl2_axi_addr_o;
wire                       varcl2_axi_data_o;
reg                        varcl2_axi_data_read_i;

// DUT instantiation
AXI4_Memory_Controller #(
  .AXI_ID_WIDTH   (AXI_ID_WIDTH),
  .AXI_ADDR_WIDTH (AXI_ADDR_WIDTH),
  .AXI_DATA_WIDTH (AXI_DATA_WIDTH),
  .AXI_STRB_WIDTH (AXI_STRB_WIDTH),
  .MAX_BURST_LEN  (MAX_BURST_LEN),

  .ATT_BASE_ADDR     (ATT_BASE_ADDR),
  .ATT_SIZE_BYTES    (ATT_SIZE_BYTES),

  .CLAUSE_BASE_ADDR  (CLAUSE_BASE_ADDR),
  .CLAUSE_SIZE_BYTES (CLAUSE_SIZE_BYTES),

  .VARCL1_BASE_ADDR  (VARCL1_BASE_ADDR),
  .VARCL1_SIZE_BYTES (VARCL1_SIZE_BYTES),

  .VARCL2_BASE_ADDR  (VARCL2_BASE_ADDR),
  .VARCL2_SIZE_BYTES (VARCL2_SIZE_BYTES)
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

// Counters for pass/fail
integer test_passed, test_failed;

initial begin
  test_passed = 0;
  test_failed = 0;

  @(negedge rst);
  #50;

  // Testcases
  testcase_single_beat_write();
  testcase_multi_beat_write();
  testcase_wait_state();
  testcase_out_of_range();
  testcase_invalid_burst();
  testcase_multi_beat_read_pipelined();
  
  testcase_multi_beat_write_varcl1();
  testcase_multi_beat_read_att();
  testcase_single_beat_read_clause();
  testcase_multi_beat_write_read_varcl2();

  testcase_burst_across_boundary();
  testcase_max_burst_write();
  testcase_unaligned_write();
  testcase_back_to_back_read_write();
  testcase_incomplete_burst();

  #200;
  $display("====================================================");
  $display("TEST SUMMARY => test_passed=%0d, test_failed=%0d", test_passed, test_failed);
  
  if(test_failed==0) 
    $display("ALL PASSED!");
  else
    $display("SOME FAILED!");
  
  $finish;
end

// Single-beat write
task do_single_beat_write(
  input [AXI_ADDR_WIDTH-1:0] addr,
  input [AXI_DATA_WIDTH-1:0] wdata,
  output [1:0]               resp
);
begin
  $display("[%0t] TB: SINGLE BEAT WRITE => addr=0x%08h, data=0x%08h",
           $time, addr, wdata);
  
  // AW
  s_axi_awid    = 4'h1;
  s_axi_awaddr  = addr;
  s_axi_awlen   = 0;        // single beat
  s_axi_awsize  = 3'd2;     // each beat = 4 bytes
  s_axi_awburst = 2'b01;    // INCR
  s_axi_awvalid = 1'b1;
  @(posedge clk);
  
  while(!s_axi_awready)
    @(posedge clk);
  
  s_axi_awvalid = 1'b0;

  // Write data
  s_axi_wdata  = wdata;
  s_axi_wstrb  = 4'hF;      
  s_axi_wlast  = 1'b1;
  s_axi_wvalid = 1'b1;

  @(posedge clk);
  while(!s_axi_wready)
    @(posedge clk);

  $display("  => Single-beat W handshake done");

  // handshake done
  @(posedge clk);
  s_axi_wvalid=0;
  s_axi_wlast =0;

  // Response
  s_axi_bready=1;
  while(!s_axi_bvalid)
    @(posedge clk);

  resp = s_axi_bresp;
  @(posedge clk);

  s_axi_bready=0;
end
endtask

// Multi-beat write
task do_multi_beat_write(
  input [AXI_ADDR_WIDTH-1:0] base_addr,
  input integer beats,
  output [1:0] final_resp
);
integer i;
reg [AXI_ADDR_WIDTH-1:0] curr_addr;
begin
  $display("[%0t] TB: MULTI-BEAT WRITE => base=0x%08h, beats=%0d",
           $time, base_addr, beats);

  // AW
  s_axi_awid    = 4'h2;
  s_axi_awaddr  = base_addr;
  s_axi_awlen   = beats-1;  
  s_axi_awsize  = 3'd2;     
  s_axi_awburst = 2'b01;    // INCR
  s_axi_awvalid = 1'b1;

  @(posedge clk);
  while(!s_axi_awready)
    @(posedge clk);

  $display("[%0t] TB: AW handshake => base=0x%08h, len=%0d",
           $time, base_addr, beats-1);
  s_axi_awvalid=0;

  // W for each beat
  for (i=0; i<beats; i=i+1) begin
    curr_addr = base_addr + (i * 4);
    s_axi_wdata  = 32'hC000_0000 + i;
    s_axi_wstrb  = 4'hF;
    s_axi_wlast  = (i==(beats-1));
    s_axi_wvalid = 1'b1;

    $display("[%0t] TB:  Writing beat %0d => addr=0x%08h, wdata=0x%08h, wlast=%b",
             $time, i, curr_addr, s_axi_wdata, s_axi_wlast);
    @(posedge clk);

    while(!s_axi_wready)
      @(posedge clk);

    $display("[%0t] TB:   => W handshake done for beat %0d", $time, i);
    @(posedge clk);

    s_axi_wvalid=0;
    s_axi_wlast =0;
  end

  // B
  s_axi_bready=1;
  while(!s_axi_bvalid)
    @(posedge clk);

  final_resp = s_axi_bresp;
  $display("[%0t] TB:  => BVALID handshake => bresp=0x%02b",
           $time, final_resp);
  @(posedge clk);

  s_axi_bready=0;
end
endtask

// Single-beat read
task do_single_beat_read(
  input [AXI_ADDR_WIDTH-1:0] addr,
  output [AXI_DATA_WIDTH-1:0] rdata,
  output [1:0]               rresp
);
begin
  $display("[%0t] TB: SINGLE BEAT READ => addr=0x%08h", $time, addr);

  // AR
  s_axi_arid    = 4'h3;
  s_axi_araddr  = addr;
  s_axi_arlen   = 0;        
  s_axi_arsize  = 3'd2;     
  s_axi_arburst = 2'b01;    
  s_axi_arvalid = 1'b1;
  @(posedge clk);

  while(!s_axi_arready)
    @(posedge clk);

  s_axi_arvalid=0;

  // R
  s_axi_rready=1;
  @(posedge clk);

  while(!s_axi_rvalid)
    @(posedge clk);

  $display("  => Single-beat R handshake done");
  $display("  => RDATA=0x%08h", s_axi_rdata);

  rdata = s_axi_rdata;
  rresp = s_axi_rresp;

  @(posedge clk);
  s_axi_rready=0;
end
endtask

// Multi-beat read
task do_multi_beat_read(
  input [AXI_ADDR_WIDTH-1:0] base_addr,
  input integer beats,
  output reg [1:0] final_rresp
);
integer i;
reg [AXI_ADDR_WIDTH-1:0] curr_addr;
begin
  $display("[%0t] TB: MULTI-BEAT READ => base=0x%08h, beats=%0d",
           $time, base_addr, beats);
  
  s_axi_arid    = 4'h4;
  s_axi_araddr  = base_addr;
  s_axi_arlen   = beats-1;
  s_axi_arsize  = 3'd2;
  s_axi_arburst = 2'b01;
  s_axi_arvalid = 1'b1;

  @(posedge clk);
  while(!s_axi_arready)
    @(posedge clk);

  s_axi_arvalid=0;
  s_axi_rready=1;

  for(i=0; i<beats; i=i+1) begin
    while(!s_axi_rvalid)
      @(posedge clk);

    curr_addr = base_addr + (i * 4);
    $display("[%0t] TB: READ beat %0d => addr=0x%08h, rdata=0x%08h, rresp=%b, rlast=%b",
             $time, i, curr_addr, s_axi_rdata, s_axi_rresp, s_axi_rlast);

    final_rresp = s_axi_rresp;
    @(posedge clk);
  end

  s_axi_rready=0;
end
endtask

// Single-beat write -> to ATT region
task testcase_single_beat_write;
  reg [1:0] resp;
begin
  $display("========================================");
  $display("TESTCASE: SINGLE BEAT WRITE (BURST HANDLING)");

  do_single_beat_write(ATT_BASE_ADDR + 32'h4, 32'hDEAD_BEEF, resp);

  if(resp==2'b00) begin
    $display("  => PASS: Expected=OKAY(00), Actual=%b", resp);
    test_passed = test_passed + 1;
  end else begin
    $display("  => FAIL: Expected=OKAY(00), Actual=%b", resp);
    test_failed = test_failed + 1;
  end
end
endtask

// Multi-beat write -> Clause Table
task testcase_multi_beat_write;
  reg [1:0] final_resp;
begin
  $display("========================================");
  $display("TESTCASE: MULTI-BEAT WRITE (4 beats) => Clause Table");

  do_multi_beat_write(CLAUSE_BASE_ADDR + 32'h0, 4, final_resp);

  if(final_resp==2'b00) begin
    $display("  => PASS: Expected=OKAY(00), Actual=%b", final_resp);
    test_passed = test_passed + 1;
  end else begin
    $display("  => FAIL: Expected=OKAY(00), Actual=%b", final_resp);
    test_failed = test_failed + 1;
  end
end
endtask

// Wait-state handling -> single write with manual stall
task testcase_wait_state;
  reg [1:0] resp;
begin
  $display("========================================");
  $display("TESTCASE: WAIT-STATE HANDLING => single write with manual stall");

  s_axi_awvalid = 1'b1;
  s_axi_awid    = 4'h5;
  s_axi_awaddr  = VARCL1_BASE_ADDR + 32'h100;
  s_axi_awlen   = 0;
  s_axi_awsize  = 3'd2;
  s_axi_awburst = 2'b01;

  while(!s_axi_awready) @(posedge clk);
  @(posedge clk);
  s_axi_awvalid = 1'b0;

  // W handshake
  s_axi_wdata  = 32'hABC0_1234;
  s_axi_wstrb  = 4'hF;
  s_axi_wlast  = 1'b1;
  s_axi_wvalid = 1'b1;

  while(!s_axi_wready) @(posedge clk);
  @(posedge clk);
  s_axi_wvalid=0;
  s_axi_wlast=0;

  // B
  s_axi_bready=1;
  while(!s_axi_bvalid) @(posedge clk);
  resp=s_axi_bresp;
  @(posedge clk);
  s_axi_bready=0;

  if(resp==2'b00) begin
    $display("  => PASS: Expected=OKAY(00), Actual=%b", resp);
    test_passed = test_passed + 1;
  end else begin
    $display("  => FAIL: Expected=OKAY(00), Actual=%b", resp);
    test_failed = test_failed + 1;
  end
end
endtask

// Out-of-range address -> expect SLVERR
task testcase_out_of_range;
  reg [1:0] resp;
begin
  $display("========================================");
  $display("TESTCASE: OUT-OF-RANGE ADDRESS => Expect SLVERR");

  do_single_beat_write(32'hFFFF_F000, 32'hBAD0_BEEF, resp);

  if(resp==2'b10) begin
    $display("  => PASS: Expected=SLVERR(10), Actual=%b", resp);
    test_passed = test_passed + 1;
  end else begin
    $display("  => FAIL: Expected=SLVERR(10), Actual=%b", resp);
    test_failed = test_failed + 1;
  end
end
endtask

// Invalid burst -> FIXED=00 -> expect SLVERR
task testcase_invalid_burst;
  reg [1:0] resp;
begin
  $display("========================================");
  $display("TESTCASE: INVALID BURST (FIXED=00) => Expect SLVERR");
  
  s_axi_awid    = 4'h6;
  s_axi_awaddr  = ATT_BASE_ADDR;  // valid range
  s_axi_awlen   = 0;
  s_axi_awsize  = 3'd2;
  s_axi_awburst = 2'b00; // invalid
  s_axi_awvalid = 1'b1;

  @(posedge clk);
  while(!s_axi_awready) @(posedge clk);
  s_axi_awvalid=0;

  // W
  s_axi_wdata  = 32'hF00D_D00D;
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
  resp=s_axi_bresp;
  @(posedge clk);
  s_axi_bready=0;

  if(resp==2'b10) begin
    $display("  => PASS: Expected=SLVERR(10), Actual=%b", resp);
    test_passed = test_passed + 1;
  end else begin
    $display("  => FAIL: Expected=SLVERR(10), Actual=%b", resp);
    test_failed = test_failed + 1;
  end
end
endtask

// Multi-beat read from varcl2 region
task testcase_multi_beat_read_pipelined;
  reg [1:0] rresp;
begin
  $display("========================================");
  $display("TESTCASE: MULTI-BEAT READ => pipelined => varcl2 region");

  varcl2_axi_data_read_i = 1'b1;

  do_multi_beat_read(VARCL2_BASE_ADDR + 32'h200, 3, rresp);

  if (rresp==2'b00) begin
    $display("  => PASS: Expected=OKAY(00), Actual=%b", rresp);
    test_passed = test_passed + 1;
  end else begin
    $display("  => FAIL: Expected=OKAY(00), Actual=%b", rresp);
    test_failed = test_failed + 1;
  end
end
endtask

// Multi-beat write to varcl1 region
task testcase_multi_beat_write_varcl1;
  reg [1:0] final_resp;
begin
  $display("========================================");
  $display("TESTCASE: MULTI-BEAT WRITE => varcl1 region (5 beats)");

  do_multi_beat_write(VARCL1_BASE_ADDR + 32'h10, 5, final_resp);

  if(final_resp==2'b00) begin
    $display("  => PASS: Expected=OKAY(00), Actual=%b", final_resp);
    test_passed = test_passed + 1;
  end else begin
    $display("  => FAIL: Expected=OKAY(00), Actual=%b", final_resp);
    test_failed = test_failed + 1;
  end
end
endtask

// Multi-beat read from ATT region
task testcase_multi_beat_read_att;
  reg [1:0] rresp;
begin
  $display("========================================");
  $display("TESTCASE: MULTI-BEAT READ => ATT region (4 beats)");

  do_multi_beat_read(ATT_BASE_ADDR + 32'h8, 4, rresp);

  if(rresp==2'b00) begin
    $display("  => PASS: Expected=OKAY(00), Actual=%b", rresp);
    test_passed = test_passed + 1;
  end else begin
    $display("  => FAIL: Expected=OKAY(00), Actual=%b", rresp);
    test_failed = test_failed + 1;
  end
end
endtask

// Single-beat read from Clause region
task testcase_single_beat_read_clause;
  reg [1:0] rresp;
  reg [AXI_DATA_WIDTH-1:0] rdata;
begin
  $display("========================================");
  $display("TESTCASE: SINGLE BEAT READ => Clause region");

  do_single_beat_read(CLAUSE_BASE_ADDR + 32'h4, rdata, rresp);

  if(rresp==2'b00) begin
    $display("  => PASS: Expected=OKAY(00), Actual=%b, RDATA=0x%08h", rresp, rdata);
    test_passed = test_passed + 1;
  end else begin
    $display("  => FAIL: Expected=OKAY(00), Actual=%b, RDATA=0x%08h", rresp, rdata);
    test_failed = test_failed + 1;
  end
end
endtask

// Combined multi-beat write and read in varcl2
task testcase_multi_beat_write_read_varcl2;
  reg [1:0] wresp, rresp;
begin
  $display("========================================");
  $display("TESTCASE: MULTI-BEAT WRITE & READ => varcl2 region");
  
  // Write 3 beats to varcl2
  do_multi_beat_write(VARCL2_BASE_ADDR + 32'h300, 3, wresp);
  if(wresp==2'b00) begin
    $display("  => PASS: Multi-beat write => Expected=OKAY(00), Actual=%b", wresp);
  end else begin
    $display("  => FAIL: Multi-beat write => Expected=OKAY(00), Actual=%b", wresp);
    test_failed = test_failed + 1;
  end

  // Then read 3 beats from varcl2
  do_multi_beat_read(VARCL2_BASE_ADDR + 32'h300, 3, rresp);
  if(rresp==2'b00) begin
    $display("  => PASS: Multi-beat read => Expected=OKAY(00), Actual=%b", rresp);
    test_passed = test_passed + 1;
  end else begin
    $display("  => FAIL: Multi-beat read => Expected=OKAY(00), Actual=%b", rresp);
    test_failed = test_failed + 1;
  end
end
endtask

task testcase_submodule_checks;
  reg [1:0] resp;
begin
  $display("========================================");
  $display("TESTCASE: SUBMODULE OUTPUT CHECK");
  
  do_single_beat_write(CLAUSE_BASE_ADDR + 32'h8, 32'hAABBCCDD, resp);
  #10;

  if (clause_axi_wr_en_o == 1'b1 && clause_axi_wr_addr_o == 11'h008) begin
      $display("  => PASS: Clause table signals toggled correctly ");
      $display("     Expected=en_o=1'b1 & addr_o=0x008");
      $display("     Actual=en_o=%b & addr_o=0x%03h", clause_axi_wr_en_o, clause_axi_wr_addr_o);
      test_passed = test_passed + 1;
  end 
  else begin
      $display("  => FAIL: Clause table signals mismatch ");
      $display("     Expected=en_o=1'b1 & addr_o=0x008");
      $display("     Actual=en_o=%b & addr_o=0x%03h", clause_axi_wr_en_o, clause_axi_wr_addr_o);
      test_failed = test_failed + 1;
  end
end
endtask

task testcase_burst_across_boundary;
  reg [1:0] resp;
  integer nbeats;
  integer i;
begin
  $display("========================================");
  $display("TESTCASE: BURST ACROSS BOUNDARY => Expect SLVERR on crossing");

  nbeats = 3;
  s_axi_awid    = 4'h7;
  // s_axi_awaddr  = CLAUSE_BASE_ADDR + CLAUSE_SIZE_BYTES - 4;
  // s_axi_awlen   = nbeats - 1; // 3 beats total
  s_axi_awaddr = 32'h0002_5FFC; // last 4 bytes of varcl2
  s_axi_awlen  = 2;             // 3 beats total
  s_axi_awsize  = 3'd2;       // 4 bytes per beat
  s_axi_awburst = 2'b01;      // INCR
  s_axi_awvalid = 1'b1;

  @(posedge clk);
  while(!s_axi_awready) @(posedge clk);
  s_axi_awvalid = 1'b0;

  for (i = 0; i < nbeats; i = i + 1) begin
    s_axi_wdata  = 32'hC0DE_0000 + i;
    s_axi_wstrb  = 4'hF;
    s_axi_wlast  = (i == (nbeats - 1));
    s_axi_wvalid = 1'b1;
    
    @(posedge clk);
    while(!s_axi_wready) @(posedge clk);
    @(posedge clk);

    s_axi_wvalid = 1'b0;
    s_axi_wlast  = 1'b0;
  end
  
  // B channel handshake
  s_axi_bready = 1'b1;
  while(!s_axi_bvalid) @(posedge clk);
  resp = s_axi_bresp;
  @(posedge clk);
  s_axi_bready = 1'b0;

  if(resp == 2'b10) begin
    $display("  => PASS: Expected=SLVERR(10), Actual=%b", resp);
    test_passed = test_passed + 1;
  end else begin
    $display("  => FAIL: Expected=SLVERR(10), Actual=%b", resp);
    test_failed = test_failed + 1;
  end
end
endtask

task testcase_max_burst_write;
  reg [1:0] wresp;
  integer   nbeats;
begin
  $display("========================================");
  $display("TESTCASE: MAX BURST WRITE => AWLEN=15 => 16 beats");

  nbeats = 16; // AWLEN=15 means 16 beats
  do_multi_beat_write(ATT_BASE_ADDR + 32'h0, nbeats, wresp);

  if(wresp == 2'b00) begin
    $display("  => PASS: Expected=OKAY(00), Actual=%b", wresp);
    test_passed = test_passed + 1;
  end else if(wresp == 2'b10) begin
    $display("  => Possible SLVERR if design rejects 16 beats. Actual=%b", wresp);
    test_failed = test_failed + 1;
  end else begin
    $display("  => FAIL: Unexpected bresp=%b", wresp);
    test_failed = test_failed + 1;
  end
end
endtask

task testcase_exceed_max_burst_write;
  reg [1:0] wresp;
  integer   nbeats;
begin
  $display("========================================");
  $display("TESTCASE: EXCEED MAX BURST => AWLEN=16 => expect SLVERR");

  nbeats = 17; // AWLEN=16 -> 17 beats
  do_multi_beat_write(ATT_BASE_ADDR + 32'h0, nbeats, wresp);

  if(wresp == 2'b10) begin
    $display("  => PASS: Expected=SLVERR(10), Actual=%b", wresp);
    test_passed = test_passed + 1;
  end else begin
    $display("  => FAIL: Expected=SLVERR(10), Actual=%b", wresp);
    test_failed = test_failed + 1;
  end
end
endtask

task testcase_unaligned_write;
  reg [1:0] wresp;
begin
  $display("========================================");
  $display("TESTCASE: UNALIGNED WRITE => addr=0x0000_0002 (2 bytes offset)");
  
  s_axi_awid    = 4'h8;
  s_axi_awaddr  = ATT_BASE_ADDR + 32'h2;
  s_axi_awlen   = 1;  
  s_axi_awsize  = 3'd2;  
  s_axi_awburst = 2'b01;
  s_axi_awvalid = 1'b1;
  @(posedge clk);
  while(!s_axi_awready) @(posedge clk);
  s_axi_awvalid=1'b0;

  // Write beat 0
  s_axi_wdata  = 32'hFACE_0000;
  s_axi_wstrb  = 4'hF;
  s_axi_wlast  = 1'b0;
  s_axi_wvalid = 1'b1;
  @(posedge clk);
  while(!s_axi_wready) @(posedge clk);
  @(posedge clk);
  s_axi_wvalid=0;

  // Write beat 1
  s_axi_wdata  = 32'hFACE_1111;
  s_axi_wstrb  = 4'hF;
  s_axi_wlast  = 1'b1;
  s_axi_wvalid = 1'b1;
  @(posedge clk);
  while(!s_axi_wready) @(posedge clk);
  @(posedge clk);
  s_axi_wvalid=0;
  s_axi_wlast=0;

  // Get response
  s_axi_bready=1;
  while(!s_axi_bvalid) @(posedge clk);
  wresp = s_axi_bresp;
  @(posedge clk);
  s_axi_bready=0;

  if(wresp==2'b00) begin
    $display("  => PASS: Unaligned writes accepted => bresp=OKAY(00)");
    test_passed = test_passed + 1;
  end
  else if(wresp==2'b10)
    $display("  => SLVERR indicates design may not support unaligned");
  else
    $display("  => Unexpected bresp=%b", wresp);
end
endtask

task testcase_back_to_back_read_write;
  reg [1:0] wresp, rresp;
  reg [31:0] read_data;
  integer j;
  integer k;

begin
  $display("========================================");
  $display("TESTCASE: BACK-TO-BACK READ & WRITE => pipeline AW/AR phases");

  // wresp = 2'b00;  // Will be overwritten by actual
  // rresp = 2'b00;  // Will be overwritten by actual

  fork
    begin
      // Issue AW
      s_axi_awid    = 4'h9;
      s_axi_awaddr  = CLAUSE_BASE_ADDR;
      s_axi_awlen   = 3;       // 4 beats
      s_axi_awsize  = 3'd2;
      s_axi_awburst = 2'b01;
      s_axi_awvalid = 1'b1;
      @(posedge clk);
      while(!s_axi_awready) @(posedge clk);
      s_axi_awvalid=0;

      // Write 4 beats
      for (j = 0; j < 4; j = j + 1) begin
        s_axi_wdata  = 32'hF0F0_0000 + j;
        s_axi_wstrb  = 4'hF;
        s_axi_wlast  = (j == 3);
        s_axi_wvalid = 1'b1;

        @(posedge clk);
        while(!s_axi_wready) @(posedge clk);
        @(posedge clk);

        s_axi_wvalid=0;
        s_axi_wlast=0;
      end

      // B
      s_axi_bready=1;
      while(!s_axi_bvalid) @(posedge clk);
      wresp = s_axi_bresp;
      @(posedge clk);
      s_axi_bready=0;
      $display("  => WRITE completed, bresp=%b", wresp);

      // Pass/fail check for write response
      if (wresp == 2'b00) begin
        $display("  => WRITE PASS: Expected=OKAY(00), Actual=%b", wresp);
        test_passed = test_passed + 1;
      end else begin
        $display("  => WRITE FAIL: Expected=OKAY(00), Actual=%b", wresp);
        test_failed = test_failed + 1;
      end
    end

    begin
      #15; // small delay to overlap the write
      s_axi_arid    = 4'hA;
      s_axi_araddr  = VARCL1_BASE_ADDR;
      s_axi_arlen   = 1;  // 2-beat read
      s_axi_arsize  = 3'd2;
      s_axi_arburst = 2'b01;
      s_axi_arvalid = 1'b1;

      @(posedge clk);
      while(!s_axi_arready) @(posedge clk);
      s_axi_arvalid=0;

      // R
      s_axi_rready=1;
      for (k = 0; k < 2; k = k + 1) begin
        while(!s_axi_rvalid) @(posedge clk);
        $display("  => READ beat %0d: rdata=0x%08h, rresp=%b, rlast=%b",
                 k, s_axi_rdata, s_axi_rresp, s_axi_rlast);
        rresp = s_axi_rresp;

        @(posedge clk);
      end
      s_axi_rready=0;

      // Pass/fail check for read response
      if (rresp == 2'b00) begin
        $display("  => READ PASS: Expected=OKAY(00), Actual=%b", rresp);
        test_passed = test_passed + 1;
      end else begin
        $display("  => READ FAIL: Expected=OKAY(00), Actual=%b", rresp);
        test_failed = test_failed + 1;
      end
    end
  join
end
endtask

// integer wait_count;
task testcase_incomplete_burst;
  reg [1:0] resp;
begin
  $display("========================================");
  $display("TESTCASE: INCOMPLETE BURST => AW handshake, partial W beats, no WLAST");

  s_axi_awid    = 4'hB;
  s_axi_awaddr  = ATT_BASE_ADDR;
  s_axi_awlen   = 3;       
  s_axi_awsize  = 3'd2;    
  s_axi_awburst = 2'b01;
  s_axi_awvalid = 1'b1;

  @(posedge clk);
  while(!s_axi_awready) @(posedge clk);
  s_axi_awvalid = 0;

  // Beat 0
  s_axi_wdata  = 32'hAAAA_0000;
  s_axi_wstrb  = 4'hF;
  s_axi_wlast  = 1'b0; // not last
  s_axi_wvalid = 1'b1;
  @(posedge clk);
  while(!s_axi_wready) @(posedge clk);
  @(posedge clk);
  s_axi_wvalid = 0;

  // Beat 1
  s_axi_wdata  = 32'hAAAA_1111;
  s_axi_wstrb  = 4'hF;
  s_axi_wlast  = 1'b0; // still not last
  s_axi_wvalid = 1'b1;
  @(posedge clk);
  while(!s_axi_wready) @(posedge clk);
  @(posedge clk);
  s_axi_wvalid = 0;
  s_axi_wlast  = 0;

  repeat(20) @(posedge clk);

  // Check if the controller produced BVALID unexpectedly
  if (s_axi_bvalid) begin
    $display("  => FAIL: Unexpected BVALID => bresp=%b", s_axi_bresp);
    test_failed = test_failed + 1;
  end else begin
    $display("  => NO BVALID seen yet. Possibly PASS if design is waiting for WLAST/remaining beats.");
  end

  // // Try a follow-up single-beat write to see if the slave recovers or stays stuck
  // $display("  => Attempting follow-up single-beat write to test recovery...");
  // s_axi_awid    = 4'hC;
  // s_axi_awaddr  = ATT_BASE_ADDR + 32'h100; // some valid address
  // s_axi_awlen   = 0;        // single beat
  // s_axi_awsize  = 3'd2;     // 4 bytes/beat
  // s_axi_awburst = 2'b01;    // INCR
  // s_axi_awvalid = 1'b1;
  // @(posedge clk);
  // while(!s_axi_awready) @(posedge clk);
  // s_axi_awvalid = 0;

  // // W
  // s_axi_wdata  = 32'hFACE_CAFE;
  // s_axi_wstrb  = 4'hF;
  // s_axi_wlast  = 1'b1;
  // s_axi_wvalid = 1'b1;
  // @(posedge clk);
  // while(!s_axi_wready) @(posedge clk);
  // @(posedge clk);
  // s_axi_wvalid = 0;
  // s_axi_wlast  = 0;

  // // B
  // s_axi_bready = 1;
  // // Wait up to some cycles for BVALID
  // wait_count = 0;
  // while(!s_axi_bvalid && (wait_count < 20)) begin
  //   wait_count = wait_count + 1;
  //   @(posedge clk);
  // end
  // // We can turn off bready now or after handshake
  // if(s_axi_bvalid) begin
  //   resp = s_axi_bresp;
  //   @(posedge clk);
  //   s_axi_bready = 0;

  //   if(resp==2'b00) begin
  //     $display("  => Follow-up write PASS: bresp=OKAY(00). Slave recovered from incomplete burst.");
  //     test_passed = test_passed + 1;
  //   end else begin
  //     $display("  => Follow-up write FAIL: bresp=%b (expected=OKAY(00)?)", resp);
  //     test_failed = test_failed + 1;
  //   end
  // end else begin
  //   s_axi_bready = 0;
  //   $display("  => Follow-up write FAILED to get BVALID in time. Possibly stuck in incomplete burst!");
  //   test_failed = test_failed + 1;
  // end

end
endtask

endmodule