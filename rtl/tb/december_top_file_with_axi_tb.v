`timescale 1ns / 1ps

module december_top_file_with_axi_tb;
    // Basic clock
    parameter CLK_PERIOD = 10;
    reg clk_i = 0;
    always #(CLK_PERIOD/2) clk_i = ~clk_i;

    reg rst_i;
    reg start_i;

    // AXI signals
    localparam AXI_ID_WIDTH   = 4;
    localparam AXI_ADDR_WIDTH = 32;
    localparam AXI_DATA_WIDTH = 32;
    localparam AXI_STRB_WIDTH = AXI_DATA_WIDTH/8;

    // Master -> DUT
    reg  [AXI_ID_WIDTH-1:0]  s_axi_awid;
    reg  [AXI_ADDR_WIDTH-1:0] s_axi_awaddr;
    reg  [7:0]                s_axi_awlen;
    reg  [2:0]                s_axi_awsize;
    reg  [1:0]                s_axi_awburst;
    reg                       s_axi_awvalid;
    wire                      s_axi_awready;

    reg  [AXI_DATA_WIDTH-1:0] s_axi_wdata;
    reg  [AXI_STRB_WIDTH-1:0] s_axi_wstrb;
    reg                       s_axi_wlast;
    reg                       s_axi_wvalid;
    wire                      s_axi_wready;

    wire [AXI_ID_WIDTH-1:0]   s_axi_bid;
    wire [1:0]                s_axi_bresp;
    wire                      s_axi_bvalid;
    reg                       s_axi_bready;

    reg  [AXI_ID_WIDTH-1:0]   s_axi_arid;
    reg  [AXI_ADDR_WIDTH-1:0] s_axi_araddr;
    reg  [7:0]                s_axi_arlen;
    reg  [2:0]                s_axi_arsize;
    reg  [1:0]                s_axi_arburst;
    reg                       s_axi_arvalid;
    wire                      s_axi_arready;

    reg                       s_axi_rready;
    wire [AXI_ID_WIDTH-1:0]   s_axi_rid;
    wire [AXI_DATA_WIDTH-1:0] s_axi_rdata;
    wire [1:0]                s_axi_rresp;
    wire                      s_axi_rlast;
    wire                      s_axi_rvalid;

    // The solver-done signal from the DUT
    wire done_signal;

    // Internally driven control signals from the datapath's controller
    wire [13:0] control_signal_i;

    december_top_file #(
       .AXI_ID_WIDTH   (AXI_ID_WIDTH),
       .AXI_ADDR_WIDTH (AXI_ADDR_WIDTH),
       .AXI_DATA_WIDTH (AXI_DATA_WIDTH),
       .AXI_STRB_WIDTH (AXI_STRB_WIDTH)
       // plus other parameters
    ) 
    dut (
        .clk_i          (clk_i),
        .rst_i          (rst_i),
        .start_i        (start_i),
        .done_signal    (done_signal),
        .control_signal_i(control_signal_i),

        // Hook up all AXI lines
        .s_axi_awid     (s_axi_awid),
        .s_axi_awaddr   (s_axi_awaddr),
        .s_axi_awlen    (s_axi_awlen),
        .s_axi_awsize   (s_axi_awsize),
        .s_axi_awburst  (s_axi_awburst),
        .s_axi_awvalid  (s_axi_awvalid),
        .s_axi_awready  (s_axi_awready),

        .s_axi_wdata    (s_axi_wdata),
        .s_axi_wstrb    (s_axi_wstrb),
        .s_axi_wlast    (s_axi_wlast),
        .s_axi_wvalid   (s_axi_wvalid),
        .s_axi_wready   (s_axi_wready),

        .s_axi_bid      (s_axi_bid),
        .s_axi_bresp    (s_axi_bresp),
        .s_axi_bvalid   (s_axi_bvalid),
        .s_axi_bready   (s_axi_bready),

        .s_axi_arid     (s_axi_arid),
        .s_axi_araddr   (s_axi_araddr),
        .s_axi_arlen    (s_axi_arlen),
        .s_axi_arsize   (s_axi_arsize),
        .s_axi_arburst  (s_axi_arburst),
        .s_axi_arvalid  (s_axi_arvalid),
        .s_axi_arready  (s_axi_arready),

        .s_axi_rready   (s_axi_rready),
        .s_axi_rid      (s_axi_rid),
        .s_axi_rdata    (s_axi_rdata),
        .s_axi_rresp    (s_axi_rresp),
        .s_axi_rlast    (s_axi_rlast),
        .s_axi_rvalid   (s_axi_rvalid)
    );

    // Simple clock
    initial begin
        rst_i = 1'b1;
        #50;
        rst_i = 1'b0;
    end

    task axi_write_single(
    input [AXI_ADDR_WIDTH-1:0] addr,
    input [AXI_DATA_WIDTH-1:0] data
    );
    begin
        // AW channel handshake
        s_axi_awvalid <= 1'b1;
        s_axi_awaddr  <= addr;
        s_axi_awid    <= 4'h1;
        s_axi_awlen   <= 0;       // single-beat
        s_axi_awburst <= 2'b01;   // INCR
        s_axi_awsize  <= 3'd2;    // 4 bytes
        @(posedge clk_i);
        while (!s_axi_awready) begin
            @(posedge clk_i);
        end
        s_axi_awvalid <= 1'b0;

        // W channel handshake
        s_axi_wdata  <= data;
        s_axi_wstrb  <= 4'hF;
        s_axi_wlast  <= 1'b1;
        s_axi_wvalid <= 1'b1;

        // Wait for WREADY
        @(posedge clk_i);
        while (!s_axi_wready) begin
            @(posedge clk_i);
        end

        @(posedge clk_i);

        // Now deassert
        s_axi_wvalid <= 1'b0;
        s_axi_wlast  <= 1'b0;

        // B channel handshake
        s_axi_bready <= 1'b1;
        @(posedge clk_i);
        while (!s_axi_bvalid) begin
            @(posedge clk_i);
        end

        @(posedge clk_i);
        s_axi_bready <= 1'b0;
    end
    endtask

    // Single-beat AXI Read Task
    task axi_read_single(
        input  [AXI_ADDR_WIDTH-1:0] addr,
        output [AXI_DATA_WIDTH-1:0] data_out
    );
    begin
        $display("\n==== Single-Beat Read: addr=0x%08h @time=%t ====", addr, $time);

        s_axi_arid    <= 4'h2;
        s_axi_araddr  <= addr;
        s_axi_arlen   <= 8'd0;   // single beat
        s_axi_arsize  <= 3'd2;   // 4 bytes
        s_axi_arburst <= 2'b01;  // INCR
        s_axi_arvalid <= 1'b1;

        // Wait for ARREADY
        @(posedge clk_i);
        while(!s_axi_arready) begin
            $display("    [axi_read_single] Waiting for ARREADY... t=%t", $time);
            @(posedge clk_i);
        end
        $display("    [axi_read_single] AR handshake done at t=%t", $time);
        s_axi_arvalid <= 1'b0;

        // Wait for RVALID
        s_axi_rready  <= 1'b1;
        while(!s_axi_rvalid) begin
            $display("    [axi_read_single] Waiting for RVALID... t=%t", $time);
            @(posedge clk_i);
        end
        data_out = s_axi_rdata;
        $display("    [axi_read_single] Got RVALID, rdata=0x%08h, rresp=%b, time=%t",
                 data_out, s_axi_rresp, $time);
        @(posedge clk_i);
        s_axi_rready <= 1'b0;
        $display("==== Single-Beat Read Complete from addr=0x%08h, data=0x%08h @time=%t ====\n",
                 addr, data_out, $time);
    end
    endtask

    // We’ll just do one single write, one single read, for demonstration
    localparam [31:0] EXAMPLE_ADDR = 32'h00004000;
    localparam [31:0] EXAMPLE_DATA = 32'hDEADBEEF;

    reg [31:0] readback;

    // Optional monitoring of key signals each clock
    initial begin
        forever begin
            @(posedge clk_i);
            $display("T=%0t: done_signal=%b, AWV=%b, AWR=%b, WV=%b, WR=%b, BV=%b, ARV=%b, ARR=%b, RV=%b, RL=%b",
                $time, done_signal, 
                s_axi_awvalid, s_axi_awready, 
                s_axi_wvalid, s_axi_wready, 
                s_axi_bvalid,
                s_axi_arvalid, s_axi_arready,
                s_axi_rvalid, s_axi_rlast);
        end
    end

    // Main test stimulus
    initial begin
        // Initialize AXI signals
        s_axi_awid    = 0; 
        s_axi_awaddr  = 0; 
        s_axi_awlen   = 0; 
        s_axi_awsize  = 0; 
        s_axi_awburst = 0; 
        s_axi_awvalid = 0;

        s_axi_wdata   = 0; 
        s_axi_wstrb   = 0; 
        s_axi_wlast   = 0; 
        s_axi_wvalid  = 0; 
        s_axi_bready  = 0;

        s_axi_arid    = 0; 
        s_axi_araddr  = 0; 
        s_axi_arlen   = 0; 
        s_axi_arsize  = 0; 
        s_axi_arburst = 0; 
        s_axi_arvalid = 0; 
        s_axi_rready  = 0;

        start_i = 1'b0;

        // Wait for reset deassert
        @(negedge rst_i);
        $display("=== TB: Reset de-asserted at T=%0t ===", $time);

        #50;
        // Single AXI write to one address
        axi_write_single(EXAMPLE_ADDR, EXAMPLE_DATA);

        // Optionally read it back
        axi_read_single(EXAMPLE_ADDR, readback);
        $display("TB: readback=0x%08h (expected=0x%08h)", readback, EXAMPLE_DATA);

        // Start solver or other logic
        #100;
        $display("=== TB: Asserting start_i @T=%0t ===", $time);
        start_i = 1'b1;
        @(posedge clk_i);
        start_i = 1'b0;

        // Wait for solver or time out
        repeat(2000) @(posedge clk_i);
        if(done_signal) 
            $display("TB: done_signal=1 => solver done @T=%0t", $time);
        else
            $display("TB: Timeout - solver not done @T=%0t", $time);

        $display("TB: Simulation complete @T=%0t => calling $stop", $time);
        $stop;
    end

endmodule