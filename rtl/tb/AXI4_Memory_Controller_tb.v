`timescale 1ns/1ps

module AXI4_Memory_Controller_tb;

// PARAMETERS
localparam AXI_ID_WIDTH    = 4;
localparam AXI_ADDR_WIDTH  = 32;
localparam AXI_DATA_WIDTH  = 32;
localparam AXI_STRB_WIDTH  = AXI_DATA_WIDTH/8;
localparam MAX_BURST_LEN   = 8;

// Submodule address ranges
localparam ATT_BASE_ADDR    = 32'h0000_0000;
localparam ATT_SIZE_BYTES   = 32'h0000_1000;
localparam CLAUSE_BASE_ADDR = 32'h0001_0000;
localparam CLAUSE_SIZE_BYTES= 32'h0000_4000;
localparam VARCL1_BASE_ADDR = 32'h0002_0000;
localparam VARCL1_SIZE_BYTES= 32'h0000_2000;
localparam VARCL2_BASE_ADDR = 32'h0003_0000;
localparam VARCL2_SIZE_BYTES= 32'h0000_2000;

// Clock and reset
reg clk;
reg rst;
always #5 clk = ~clk;

initial begin
  clk = 0;
  rst = 1;
  #50 rst = 0;
end

// Write address
reg [AXI_ID_WIDTH-1:0]   s_axi_awid;
reg [AXI_ADDR_WIDTH-1:0] s_axi_awaddr;
reg [7:0]                s_axi_awlen;
reg [2:0]                s_axi_awsize;
reg [1:0]                s_axi_awburst;
reg                      s_axi_awvalid;
wire                     s_axi_awready;

// Write data
reg  [AXI_DATA_WIDTH-1:0] s_axi_wdata;
reg  [AXI_STRB_WIDTH-1:0] s_axi_wstrb;
reg                       s_axi_wlast;
reg                       s_axi_wvalid;
wire                      s_axi_wready;

// Write response
wire [AXI_ID_WIDTH-1:0]   s_axi_bid;
wire [1:0]                s_axi_bresp;
wire                      s_axi_bvalid;
reg                       s_axi_bready;

// Read address
reg [AXI_ID_WIDTH-1:0]    s_axi_arid;
reg [AXI_ADDR_WIDTH-1:0]  s_axi_araddr;
reg [7:0]                 s_axi_arlen;
reg [2:0]                 s_axi_arsize;
reg [1:0]                 s_axi_arburst;
reg                       s_axi_arvalid;
wire                      s_axi_arready;

// Read data
wire [AXI_ID_WIDTH-1:0]   s_axi_rid;
wire [AXI_DATA_WIDTH-1:0] s_axi_rdata;
wire [1:0]                s_axi_rresp;
wire                      s_axi_rlast;
wire                      s_axi_rvalid;
reg                       s_axi_rready;

// Submodule signals
wire                       att_axi_wr_en_o;
wire [12:0]                att_axi_wr_addr_o;
wire [30:0]                att_axi_wr_data_o;
wire                       att_axi_rd_en_o;
wire [12:0]                att_axi_rd_addr_o;
reg  [30:0]                att_axi_rd_data_i;
wire                       clause_axi_wr_en_o;
wire [11:0]                clause_axi_wr_addr_o;
wire [((11+1)*(3-1)*20)-1:0] clause_axi_wr_clauses_o;
wire                       clause_axi_rd_en_o;
wire [11:0]                clause_axi_rd_addr_o;
reg  [((11+1)*(3-1)*20)-1:0] clause_axi_rd_clauses_i;
wire                       varcl1_axi_en_o;
wire                       varcl1_axi_wr_en_o;
wire [11:0]                varcl1_axi_addr_o;
wire                       varcl1_axi_data_o;
reg                        varcl1_axi_data_read_i;
wire                       varcl2_axi_en_o;
wire                       varcl2_axi_wr_en_o;
wire [11:0]                varcl2_axi_addr_o;
wire                       varcl2_axi_data_o;
reg                        varcl2_axi_data_read_i;

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

  // Write address
  .s_axi_awid     (s_axi_awid),
  .s_axi_awaddr   (s_axi_awaddr),
  .s_axi_awlen    (s_axi_awlen),
  .s_axi_awsize   (s_axi_awsize),
  .s_axi_awburst  (s_axi_awburst),
  .s_axi_awvalid  (s_axi_awvalid),
  .s_axi_awready  (s_axi_awready),

  // Write data
  .s_axi_wdata    (s_axi_wdata),
  .s_axi_wstrb    (s_axi_wstrb),
  .s_axi_wlast    (s_axi_wlast),
  .s_axi_wvalid   (s_axi_wvalid),
  .s_axi_wready   (s_axi_wready),

  // Write response
  .s_axi_bid      (s_axi_bid),
  .s_axi_bresp    (s_axi_bresp),
  .s_axi_bvalid   (s_axi_bvalid),
  .s_axi_bready   (s_axi_bready),

  // Read address
  .s_axi_arid     (s_axi_arid),
  .s_axi_araddr   (s_axi_araddr),
  .s_axi_arlen    (s_axi_arlen),
  .s_axi_arsize   (s_axi_arsize),
  .s_axi_arburst  (s_axi_arburst),
  .s_axi_arvalid  (s_axi_arvalid),
  .s_axi_arready  (s_axi_arready),

  // Read data
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

// Testing
integer test_passed, test_failed;
initial begin
  test_passed = 0;
  test_failed = 0;

  @(negedge rst);
  #50;

  // All testcases
  testcase_single_beat_write();
  testcase_multi_beat_write();
  testcase_wait_state();
  testcase_out_of_range();
  testcase_invalid_burst();
  testcase_multi_beat_read_pipelined();
  // testcase_submodule_checks();

  #200;
  $display("====================================================");
  $display("TEST SUMMARY => test_passed=%0d, test_failed=%0d", test_passed, test_failed);
  
  if(test_failed==0) 
    $display("ALL PASSED!");
  else
    $display("SOME FAILED!");
  
  $stop; // stop the simulation
end

// Single-beat write
task do_single_beat_write(
  input [AXI_ADDR_WIDTH-1:0] addr,
  input [AXI_DATA_WIDTH-1:0] wdata,
  output [1:0]               resp
);
begin
  $display("[%0t] TB: SINGLE BEAT WRITE => addr=0x%08h, data=0x%08h", $time, addr, wdata);
  
  // AW
  s_axi_awid    = 4'h1;
  s_axi_awaddr  = addr;
  s_axi_awlen   = 0;
  s_axi_awsize  = 3'd2; // 4 bytes
  s_axi_awburst = 2'b01;// INCR
  s_axi_awvalid = 1'b1;
  @(posedge clk);
  
  while(!s_axi_awready) 
  @(posedge clk);
  
  s_axi_awvalid = 1'b0;

  // Write
  s_axi_wdata  = wdata;
  s_axi_wstrb  = 4'hF;
  s_axi_wlast  = 1'b1;
  s_axi_wvalid = 1'b1;

  @(posedge clk);

  while(!s_axi_wready) 
  @(posedge clk);

  $display("** single-beat handshake done");

  // handshake done
  @(posedge clk);
  s_axi_wvalid=0;
  s_axi_wlast =0;

  // Beat write
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
begin
  $display("[%0t] TB: MULTI-BEAT WRITE => base=0x%08h, beats=%0d", $time, base_addr, beats);

  // AW
  s_axi_awid    = 4'h2;
  s_axi_awaddr  = base_addr;
  s_axi_awlen   = beats-1;
  s_axi_awsize  = 3'd2;
  s_axi_awburst = 2'b01; // INCR
  s_axi_awvalid = 1'b1;
  @(posedge clk);

  while(!s_axi_awready) 
  @(posedge clk);

  $display("[%0t] TB: AW handshake => base=0x%08h, len=%0d", $time, base_addr, beats-1);
  s_axi_awvalid=0;

  // Write
  for (i=0;i<beats;i=i+1) begin
    s_axi_wdata  = 32'hC000_0000 + i;
    s_axi_wstrb  = 4'hF;
    s_axi_wlast  = (i==(beats-1));
    s_axi_wvalid = 1'b1;

    $display("[%0t] TB:  Writing beat %0d => wdata=0x%08h, wlast=%b", $time, i, s_axi_wdata, s_axi_wlast);
    @(posedge clk);

    while(!s_axi_wready) 
    @(posedge clk);

    $display("[%0t] TB:   => W handshake done for beat %0d", $time, i);
    @(posedge clk);

    s_axi_wvalid=0;
    s_axi_wlast =0;
  end

  // Beat write
  s_axi_bready=1;
  while(!s_axi_bvalid) 
  @(posedge clk);

  final_resp = s_axi_bresp;
  $display("[%0t] TB:  => BVALID handshake => bresp=0x%02b", $time, final_resp);
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

  // Read
  s_axi_rready=1;
  @(posedge clk);

  while(!s_axi_rvalid) 
  @(posedge clk);

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
begin
  $display("[%0t] TB: MULTI-BEAT READ => base=0x%08h, beats=%0d", $time, base_addr, beats);
  
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
    
    $display("[%0t] TB: READ beat %0d => rdata=0x%08h, rresp=%b, rlast=%b",
             $time, i, s_axi_rdata, s_axi_rresp, s_axi_rlast);
    final_rresp = s_axi_rresp;

    @(posedge clk);
  end

  s_axi_rready=0;
end
endtask

// task random_wait( input integer max_cycles );
// integer w;
// begin
//   w = $random % max_cycles;
//   repeat(w) @(posedge clk);
// end
// endtask

// Testcases
task testcase_single_beat_write;
  reg [1:0] resp;
begin
  $display("========================================");
  $display("TESTCASE: SINGLE BEAT WRITE (BURST HANDLING)");
  do_single_beat_write(ATT_BASE_ADDR+32'h04, 32'hDEAD_BEEF, resp);

  if(resp==2'b00) begin
    $display("  => PASS: BRESP=OKAY");
    test_passed = test_passed + 1;
  end else begin
    $display("  => FAIL: BRESP=%b expected 00(OKAY)", resp);
    test_failed = test_failed + 1;
  end
end
endtask

task testcase_multi_beat_write;
  reg [1:0] final_resp;
begin
  $display("========================================");
  $display("TESTCASE: MULTI-BEAT WRITE (4 beats) => Clause Table");
  do_multi_beat_write(CLAUSE_BASE_ADDR+32'h00, 4, final_resp);

  if(final_resp==2'b00) begin
    $display("  => PASS: multi-beat write => OKAY");
    test_passed = test_passed + 1;
  end else begin
    $display("  => FAIL: multi-beat => resp=%b", final_resp);
    test_failed = test_failed + 1;
  end
end
endtask

// task testcase_wait_state;
//   reg [1:0] resp;
// begin
//   $display("========================================");
//   $display("TESTCASE: WAIT-STATE HANDLING => single write w/random stall");
  
//   // Randomly stall AWVALID or WVALID
//   s_axi_awvalid=1'b0;
//   random_wait(5);
  
//   s_axi_awid   = 4'h5;
//   s_axi_awaddr = VARCL1_BASE_ADDR + 32'h100;
//   s_axi_awlen  = 0;
//   s_axi_awsize = 3'd2;
//   s_axi_awburst= 2'b01;
  
//   s_axi_awvalid=1'b1;
//   random_wait(5);
  
//   @(posedge clk);
//   while(!s_axi_awready) @(posedge clk);
//   s_axi_awvalid=1'b0;

//   // W
//   s_axi_wdata  = 32'hABC0_1234;
//   s_axi_wstrb  = 4'hF;
//   s_axi_wlast  = 1'b1;
//   random_wait(5);
//   s_axi_wvalid = 1'b1;

//   @(posedge clk);
//   while(!s_axi_wready) @(posedge clk);
//   @(posedge clk);
//   s_axi_wvalid=0;
//   s_axi_wlast=0;

//   // B
//   s_axi_bready=1;
//   while(!s_axi_bvalid) @(posedge clk);
//   resp=s_axi_bresp;
//   @(posedge clk);
//   s_axi_bready=0;

//   if(resp==2'b00) begin
//     $display("  => PASS: Wait-state single write => OKAY");
//     test_passed = test_passed + 1;
//   end else begin
//     $display("  => FAIL: Wait-state => resp=%b", resp);
//     test_failed = test_failed + 1;
//   end
// end
// endtask


task testcase_wait_state;
  reg [1:0] resp;
begin
  $display("========================================");
  $display("TESTCASE: WAIT-STATE HANDLING => single write with manual stall");

  // AW handshake with forced stall pattern
  s_axi_awvalid = 1'b1;
  s_axi_awid    = 4'h5;
  s_axi_awaddr  = VARCL1_BASE_ADDR + 32'h100;
  s_axi_awlen   = 0;
  s_axi_awsize  = 3'd2;
  s_axi_awburst = 2'b01;

  // Stall AW handshake for 3 cycles
  // (If the DUT is providing s_axi_awready internally, you might do this in a bus functional model)
  @(posedge clk);  // let AWVALID=1 for 1 cycle
  // For example, if you can do:
  // force s_axi_awready = 1'b0;
  // repeat(3) @(posedge clk);
  // release s_axi_awready;
  // The main idea is to hold the handshake off for a known number of cycles

  // Let the handshake finish
  while (!s_axi_awready) @(posedge clk);
  @(posedge clk);
  s_axi_awvalid = 1'b0;

  // Now do W handshake with a short manual stall
  s_axi_wdata  = 32'hABC0_1234;
  s_axi_wstrb  = 4'hF;
  s_axi_wlast  = 1'b1;
  s_axi_wvalid = 1'b1;

  @(posedge clk);
  // e.g., force s_axi_wready = 1'b0 for 2 cycles, then release
  while(!s_axi_wready) @(posedge clk);
  @(posedge clk);
  s_axi_wvalid=0;
  s_axi_wlast=0;

  // B response
  s_axi_bready=1;
  while(!s_axi_bvalid) @(posedge clk);
  resp=s_axi_bresp;
  @(posedge clk);
  s_axi_bready=0;

  if(resp==2'b00) begin
    $display("  => PASS: Wait-state single write => OKAY");
    test_passed = test_passed + 1;
  end else begin
    $display("  => FAIL: Wait-state => resp=%b", resp);
    test_failed = test_failed + 1;
  end
end
endtask

task testcase_out_of_range;
  reg [1:0] resp;
begin
  $display("========================================");
  $display("TESTCASE: OUT-OF-RANGE ADDRESS => Expect SLVERR");
  do_single_beat_write(32'hFFFF_F000, 32'hBAD0_BEEF, resp);
  if(resp==2'b10) begin
    $display("  => PASS: SLVERR as expected");
    test_passed = test_passed + 1;
  end else begin
    $display("  => FAIL: resp=%b, expected SLVERR(10)", resp);
    test_failed = test_failed + 1;
  end
end
endtask

task testcase_invalid_burst;
  reg [1:0] resp;
begin
  $display("========================================");
  $display("TESTCASE: INVALID BURST (FIXED=00) => Expect SLVERR");
  
  // AW
  s_axi_awid    = 4'h6;
  s_axi_awaddr  = ATT_BASE_ADDR;
  s_axi_awlen   = 0;
  s_axi_awsize  = 3'd2;
  s_axi_awburst = 2'b00; // FIXED -> invalid
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
    $display("  => PASS: invalid burst => SLVERR");
    test_passed = test_passed + 1;
  end else begin
    $display("  => FAIL: resp=%b, expected SLVERR(10)", resp);
    test_failed = test_failed + 1;
  end
end
endtask

task testcase_multi_beat_read_pipelined;
  reg [1:0] rresp;
begin
  $display("========================================");
  $display("TESTCASE: MULTI-BEAT READ => pipelined => varcl2 region");
  
  varcl2_axi_data_read_i = 1'b1;
  do_multi_beat_read(VARCL2_BASE_ADDR+32'h200, 3, rresp);

  if (rresp==2'b00) begin
    $display("  => PASS: multi-beat read => OKAY");
    test_passed = test_passed + 1;
  end else begin
    $display("  => FAIL: multi-beat read => rresp=%b", rresp);
    test_failed = test_failed + 1;
  end
end
endtask

// task testcase_submodule_checks;
//     reg [1:0] resp;
//     begin
//     $display("========================================");
//     $display("TESTCASE: SUBMODULE OUTPUT CHECK");
    
//     do_single_beat_write(CLAUSE_BASE_ADDR + 32'h8, 32'hAABBCCDD, resp);
//     #10;
//     if (clause_axi_wr_en_o == 1'b1 && clause_axi_wr_addr_o == 12'h008) begin
//         $display("  => PASS: Clause table signals toggled => wr_addr=0x%03h", clause_axi_wr_addr_o);
//         test_passed = test_passed + 1;
//     end 
//     else begin
//         $display("  => FAIL: Clause table signals mismatch => en=%b, addr=0x%03h",
//                 clause_axi_wr_en_o, clause_axi_wr_addr_o);
//         test_failed = test_failed + 1;
//     end
//     end
// endtask

endmodule