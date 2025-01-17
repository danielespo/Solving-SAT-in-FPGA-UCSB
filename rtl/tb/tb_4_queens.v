`timescale 1ns/1ps

module tb_4_queens();

  // -----------------------------------------------------
  // 1) Clock & Reset
  // -----------------------------------------------------
  reg clk, rst;
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 10 ns period => 100 MHz
  end

  initial begin
    rst = 1;
    #50;
    rst = 0;
  end

  // -----------------------------------------------------
  // 2) Wires to connect to december_top_file
  // -----------------------------------------------------
  wire done_signal;
  reg start_i;
  wire [13:0] control_signal_i; // for your CONTROLLER_SIGNAL_WIDTH=14

  // Since we’re loading .mem files directly, we don’t need active AXI signals.
  // We’ll tie them off to 0 or 1 as needed.
  wire [3:0]  s_axi_awid    = 4'b0;
  wire [31:0] s_axi_awaddr  = 32'b0;
  wire [7:0]  s_axi_awlen   = 8'b0;
  wire [2:0]  s_axi_awsize  = 3'b0;
  wire [1:0]  s_axi_awburst = 2'b0;
  wire        s_axi_awvalid = 1'b0;
  wire        s_axi_wlast   = 1'b0;
  wire [31:0] s_axi_wdata   = 32'b0;
  wire [3:0]  s_axi_wstrb   = 4'b0;
  wire        s_axi_wvalid  = 1'b0;
  wire        s_axi_bready  = 1'b1;
  wire [3:0]  s_axi_arid    = 4'b0;
  wire [31:0] s_axi_araddr  = 32'b0;
  wire [7:0]  s_axi_arlen   = 8'b0;
  wire [2:0]  s_axi_arsize  = 3'b0;
  wire [1:0]  s_axi_arburst = 2'b0;
  wire        s_axi_arvalid = 1'b0;
  wire        s_axi_rready  = 1'b1;

  wire        s_axi_awready;
  wire        s_axi_wready;
  wire [3:0]  s_axi_bid;
  wire [1:0]  s_axi_bresp;
  wire        s_axi_bvalid;
  wire        s_axi_arready;
  wire [3:0]  s_axi_rid;
  wire [31:0] s_axi_rdata;
  wire [1:0]  s_axi_rresp;
  wire        s_axi_rlast;
  wire        s_axi_rvalid;

  // -----------------------------------------------------
  // 3) Instantiate the solver top
  //    We specify .ATT_MEM_FILE and .CT_MEM_FILE so that
  //    Address_Translation_Table / Clause_Table load them
  // -----------------------------------------------------
  december_top_file #(
    .NSAT(3),
    .NUM_VARIABLES(16),
    .MAX_CLAUSE_MEMBERSHIP(20),
    .FIFO_DEPTH(32),
    .UNSAT_CLAUSE_BUFFER_DEPTH(2048),
    .CONTROLLER_SIGNAL_WIDTH(14),

    // AXI
    .AXI_ID_WIDTH(4),
    .AXI_ADDR_WIDTH(32),
    .AXI_DATA_WIDTH(32),
    .AXI_STRB_WIDTH(4),

    // The .mem filenames
    .ATT_MEM_FILE("../mem/att_dummy.mem"),
    .CT_MEM_FILE("../mem/clause_dummy.mem")
  ) dut (
    .clk_i(clk),
    .rst_i(rst),
    .control_signal_i(control_signal_i), // internal ctrl in top_file_controller
    .start_i(start_i),
    .done_signal(done_signal),

    // AXI slave
    .s_axi_awid    (s_axi_awid),
    .s_axi_awaddr  (s_axi_awaddr),
    .s_axi_awlen   (s_axi_awlen),
    .s_axi_awsize  (s_axi_awsize),
    .s_axi_awburst (s_axi_awburst),
    .s_axi_awvalid (s_axi_awvalid),
    .s_axi_awready (s_axi_awready),

    .s_axi_wdata   (s_axi_wdata),
    .s_axi_wstrb   (s_axi_wstrb),
    .s_axi_wlast   (s_axi_wlast),
    .s_axi_wvalid  (s_axi_wvalid),
    .s_axi_wready  (s_axi_wready),

    .s_axi_bid     (s_axi_bid),
    .s_axi_bresp   (s_axi_bresp),
    .s_axi_bvalid  (s_axi_bvalid),
    .s_axi_bready  (s_axi_bready),

    .s_axi_arid    (s_axi_arid),
    .s_axi_araddr  (s_axi_araddr),
    .s_axi_arlen   (s_axi_arlen),
    .s_axi_arsize  (s_axi_arsize),
    .s_axi_arburst (s_axi_arburst),
    .s_axi_arvalid (s_axi_arvalid),
    .s_axi_arready (s_axi_arready),

    .s_axi_rready  (s_axi_rready),
    .s_axi_rid     (s_axi_rid),
    .s_axi_rdata   (s_axi_rdata),
    .s_axi_rresp   (s_axi_rresp),
    .s_axi_rlast   (s_axi_rlast),
    .s_axi_rvalid  (s_axi_rvalid)
  );

  // Drive start
  initial begin
    start_i = 0;
    wait(!rst);
    #100;
    start_i = 1'b1;
    #10;
    start_i = 0;
    $display("[TB] start pulsed at %0t", $time);
  end

  // Wait for done or timeout => pass/fail
  reg x2_value;
  genvar g;
  integer addr;
  initial begin
    wait(!rst);
    wait(done_signal === 1 || $time > 100_000);
    if(done_signal) begin
      $display("[TB] PASS: solver done at %0t", $time);
      x2_value = dut.variable_table_cluster.variable_table_gen[2].vt_inst.ram[2];
      $display("x2_value = %b", x2_value);
    end 
    else            $display("[TB] FAIL: solver TIMEOUT");
    #10;
  end

  generate
      for (g = 0; g < dut.variable_table_cluster.CLUSTER_SIZE; g = g + 1) begin : gen_loop
        initial begin
          $display("[TB] --- Printing variable_table_gen[%0d].vt_inst.ram[] ---", g);
          for (addr = 0; addr < (1 << dut.variable_table_cluster.VARIABLE_ADDRESS_WIDTH); addr = addr + 1) begin
            $display("   ram[%0d] = %b", addr, dut.variable_table_cluster.variable_table_gen[g].vt_inst.ram[addr]);
          end
        end
      end
  endgenerate

  initial begin
    $display("[TB] Done printing entire variable table cluster contents.");
    #50;
    $finish;
  end
endmodule