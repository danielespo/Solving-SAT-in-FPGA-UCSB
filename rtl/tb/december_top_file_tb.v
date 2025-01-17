`timescale 1ns/1ps

module december_top_file_tb;

    parameter CLK_PERIOD                = 10;
    parameter NSAT                      = 3;
    parameter NUM_VARIABLES            = 2048;
    parameter MAX_CLAUSE_MEMBERSHIP    = 20;
    parameter FIFO_DEPTH               = 32;
    parameter UNSAT_CLAUSE_BUFFER_DEPTH= 2048;
    parameter CONTROLLER_SIGNAL_WIDTH  = 14;

    localparam VARIABLE_ADDRESS_WIDTH  = $clog2(NUM_VARIABLES);
    localparam LITERAL_ADDRESS_WIDTH   = VARIABLE_ADDRESS_WIDTH + 1;
    localparam CLAUSE_WIDTH            = NSAT * 8; // 24 bits (3 * 8)

    // AXI parameters
    localparam AXI_ID_WIDTH   = 4;
    localparam AXI_ADDR_WIDTH = 32;
    localparam AXI_DATA_WIDTH = 32;
    localparam AXI_STRB_WIDTH = AXI_DATA_WIDTH/8;

    // Base addresses from the AXI4_Memory_Controller parameters
    localparam ATT_BASE_ADDR    = 32'h00000000;  
    localparam CLAUSE_BASE_ADDR = 32'h00004000;  // Clause Table region starts here
    localparam VARCL1_BASE_ADDR = 32'h00022000;  // Variable Table #1 region
    localparam VARCL2_BASE_ADDR = 32'h00024000;  // Variable Table #2 region

    // Signals
    reg  clk_i;
    reg  rst_i;
    reg  start_i;
    wire [CONTROLLER_SIGNAL_WIDTH-1:0] control_signal_i;
    wire done_signal;

    // AXI Master -> DUT signals
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

    // Hardcoded clauses (24 bits each, but stored in 32 bits)
    // (We put the 24-bit clause in bits [23:0] of the 32-bit word.)
    reg [31:0] hardcoded_clauses [0:2];

    december_top_file #(
        .NSAT(NSAT),
        .NUM_VARIABLES(NUM_VARIABLES),
        .MAX_CLAUSE_MEMBERSHIP(MAX_CLAUSE_MEMBERSHIP),
        .FIFO_DEPTH(FIFO_DEPTH),
        .UNSAT_CLAUSE_BUFFER_DEPTH(UNSAT_CLAUSE_BUFFER_DEPTH),
        .CONTROLLER_SIGNAL_WIDTH(CONTROLLER_SIGNAL_WIDTH),
        .AXI_ID_WIDTH   (AXI_ID_WIDTH),
        .AXI_ADDR_WIDTH (AXI_ADDR_WIDTH),
        .AXI_DATA_WIDTH (AXI_DATA_WIDTH),
        .AXI_STRB_WIDTH (AXI_STRB_WIDTH)
    )
    dut (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .start_i(start_i),
        .control_signal_i(control_signal_i),
        .done_signal(done_signal),

        // AXI slave interface
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

    // Clock generation
    always #(CLK_PERIOD/2) clk_i = ~clk_i;

    // Single-beat AXI write: writes one 32-bit word
    task axi_write_single;
        input [AXI_ADDR_WIDTH-1:0] addr;
        input [AXI_DATA_WIDTH-1:0] data;
        begin
            // Send AW
            s_axi_awvalid <= 1'b1;
            s_axi_awaddr  <= addr;
            s_axi_awid    <= 4'h1;
            s_axi_awlen   <= 0;        // single beat
            s_axi_awburst <= 2'b01;    // INCR
            s_axi_awsize  <= 3'd2;     // 2 => 4 bytes per beat (32 bits)

            // Wait for AWREADY
            @(posedge clk_i);
            while(!s_axi_awready) @(posedge clk_i);
            // De-assert AWVALID
            s_axi_awvalid <= 1'b0;

            // Send W
            s_axi_wdata  <= data;
            s_axi_wstrb  <= 4'hF;   // All bytes valid
            s_axi_wlast  <= 1'b1;
            s_axi_wvalid <= 1'b1;

            // Wait for WREADY
            @(posedge clk_i);
            while(!s_axi_wready) @(posedge clk_i);
            // De-assert WVALID
            @(posedge clk_i);
            s_axi_wvalid <= 1'b0;
            s_axi_wlast  <= 1'b0;

            // Wait for BVALID
            s_axi_bready <= 1'b1;
            @(posedge clk_i);
            while(!s_axi_bvalid) @(posedge clk_i);

            // De-assert BREADY
            s_axi_bready <= 1'b0;
        end
    endtask

    // Multi-beat AXI write burst
    task axi_write_burst;
        input [AXI_ADDR_WIDTH-1:0] start_addr;
        input [7:0] burst_len;  // #beats - 1
        input [AXI_DATA_WIDTH*256-1:0] burst_data; 
               // Just big enough array to hold up to 256 words if you want
        integer i;
        reg [31:0] word;
        begin
            // Send AW
            s_axi_awid    <= 'h2;
            s_axi_awaddr  <= start_addr;
            s_axi_awlen   <= burst_len;   // number_of_beats - 1
            s_axi_awsize  <= 3'd2;        // 4 bytes
            s_axi_awburst <= 2'b01;       // INCR
            s_axi_awvalid <= 1'b1;

            // Wait for AWREADY
            @(posedge clk_i);
            while(!s_axi_awready) @(posedge clk_i);
            s_axi_awvalid <= 1'b0;

            // Write each beat
            for(i=0; i<=burst_len; i=i+1) begin
                word = burst_data[i*32 +: 32];
                s_axi_wdata  <= word;
                s_axi_wstrb  <= 4'b1111;
                s_axi_wlast  <= (i==burst_len); // last beat
                s_axi_wvalid <= 1'b1;

                @(posedge clk_i);
                while(!s_axi_wready) @(posedge clk_i);
                
                s_axi_wvalid <= 1'b0;
            end

            // Wait for BVALID
            s_axi_bready <= 1'b1;
            @(posedge clk_i);
            while(!s_axi_bvalid) @(posedge clk_i);
            // De-assert BREADY
            s_axi_bready <= 1'b0;
        end
    endtask

    task axi_read_single;
        input  [AXI_ADDR_WIDTH-1:0] addr;
        output [AXI_DATA_WIDTH-1:0] data;
        begin
            // Send AR
            s_axi_arid    <= 'h3;
            s_axi_araddr  <= addr;
            s_axi_arlen   <= 0;         // single beat
            s_axi_arsize  <= 3'd2;      // 4 bytes
            s_axi_arburst <= 2'b01;     // INCR
            s_axi_arvalid <= 1'b1;

            @(posedge clk_i);
            while(!s_axi_arready) @(posedge clk_i);
            s_axi_arvalid <= 1'b0;

            // Now wait for RVALID
            s_axi_rready <= 1'b1;
            @(posedge clk_i);
            while(!s_axi_rvalid) @(posedge clk_i);

            data = s_axi_rdata;  // latch the returned data

            // De-assert RREADY
            s_axi_rready <= 1'b0;

            // Wait for RLAST if it’s not the same cycle
            while(!s_axi_rlast) @(posedge clk_i);
        end
    endtask

    // AXI read burst
    task axi_read_burst;
        input [AXI_ADDR_WIDTH-1:0] start_addr;
        input [7:0] burst_len;
        output reg [AXI_DATA_WIDTH*256-1:0] read_data;
        integer i;
        begin
            // Send AR
            s_axi_arid    <= 'h3;
            s_axi_araddr  <= start_addr;
            s_axi_arlen   <= burst_len;
            s_axi_arsize  <= 3'd2;      // 4 bytes
            s_axi_arburst <= 2'b01;     // INCR
            s_axi_arvalid <= 1'b1;

            @(posedge clk_i);
            while(!s_axi_arready) @(posedge clk_i);
            s_axi_arvalid <= 1'b0;

            i = 0;
            s_axi_rready <= 1'b1;
            while(i <= burst_len) begin
                @(posedge clk_i);
                if(s_axi_rvalid) begin
                    read_data[i*32 +: 32] = s_axi_rdata;
                    i = i+1;
                end
            end
            // De-assert RREADY
            s_axi_rready <= 1'b0;
        end
    endtask

    // Clock / Reset
    initial begin
        clk_i = 0;
        rst_i = 1;
        start_i = 0;

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

        // Wait a couple cycles, then deassert reset
        #(CLK_PERIOD*5);
        rst_i = 0;
        #(CLK_PERIOD*2);
        $display("Reset de-asserted");
    end

    // Hardcode clauses as 32-bit words (lowest 24 bits are the clause)
    // (x5 OR NOT x2 OR x7) = bits: [23:16] = literal1, [15:8] = literal2, [7:0] = literal3
    initial begin
        // (x5 OR NOT x2 OR x7)
        hardcoded_clauses[0] = {8'h00, 8'b00000101, 8'b10000010, 8'b00000111};
        // (NOT x1 OR x3 OR NOT x6)
        hardcoded_clauses[1] = {8'h00, 8'b10000110, 8'b00000011, 8'b10000001};
        // (x4 OR NOT x7 OR x2)
        hardcoded_clauses[2] = {8'h00, 8'b00000010, 8'b10000111, 8'b00000100};
    end

    reg [AXI_DATA_WIDTH*256-1:0] burst_data;
    reg [31:0] var_data;
    integer i;  

    initial begin
        // Wait for end of reset
        @(negedge rst_i);
        #(CLK_PERIOD);
        
        // Initialize variable table memory if desired
        $display("\n--- Initializing first 4 variables to 0 in varcl1 region ---");
        axi_write_single(VARCL1_BASE_ADDR + 0, 32'h00000000); 
        axi_write_single(VARCL1_BASE_ADDR + 4, 32'h00000000);
        axi_write_single(VARCL1_BASE_ADDR + 8, 32'h00000000);
        axi_write_single(VARCL1_BASE_ADDR + 12,32'h00000000);

        // Load 3 clauses into the Clause Table region via a single burst
        burst_data[ 0 +: 32] = hardcoded_clauses[0];
        burst_data[32 +: 32] = hardcoded_clauses[1];
        burst_data[64 +: 32] = hardcoded_clauses[2];

        $display("\n--- Writing 3 clauses via AXI burst to clause table region ---");
        axi_write_burst(CLAUSE_BASE_ADDR, 8'd2 /*3 beats*/, burst_data);

        // Start the solver
        $display("\n--- Starting solver ---");
        start_i <= 1'b1;
        @(posedge clk_i);
        start_i <= 1'b0;

        // Wait for done or time out
        repeat(10000) begin
            @(posedge clk_i);
            if (done_signal) begin
                $display("\n--- Solver finished. Reading back first 8 variables from VARCL1 ---");
                for (i = 0; i < 8; i = i + 1) begin
                    axi_read_single(VARCL1_BASE_ADDR + (i*4), var_data);
                    $display("x%d = %b", i+1, var_data[0]);
                end
                #(CLK_PERIOD*10);
                $finish;
            end
        end

        $display("\n--- Solver timed out ---");
        #(CLK_PERIOD*10);
        $finish;
    end

    initial begin
        $dumpfile("december_top_file_tb.vcd");
        $dumpvars(0, december_top_file_tb);
    end

endmodule