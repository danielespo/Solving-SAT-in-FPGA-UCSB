`timescale 1ns/1ps

module december_top_file_tb;

    parameter CLK_PERIOD                = 10;
    parameter NSAT                      = 3;
    parameter NUM_VARIABLES             = 2048;
    parameter MAX_CLAUSE_MEMBERSHIP     = 20;
    parameter FIFO_DEPTH                = 32;
    parameter UNSAT_CLAUSE_BUFFER_DEPTH = 2048;
    parameter CONTROLLER_SIGNAL_WIDTH   = 14;

    localparam VARIABLE_ADDRESS_WIDTH  = $clog2(NUM_VARIABLES);
    localparam LITERAL_ADDRESS_WIDTH   = VARIABLE_ADDRESS_WIDTH + 1;
    localparam CLAUSE_WIDTH            = NSAT * 8; // Not strictly needed for .mem usage

    // AXI parameters
    localparam AXI_ID_WIDTH   = 4;
    localparam AXI_ADDR_WIDTH = 32;
    localparam AXI_DATA_WIDTH = 32;
    localparam AXI_STRB_WIDTH = AXI_DATA_WIDTH/8;

    // Base addresses
    localparam ATT_BASE_ADDR    = 32'h0000_0000;  
    localparam CLAUSE_BASE_ADDR = 32'h0000_4000;  
    localparam VARCL1_BASE_ADDR = 32'h0002_2000;  
    localparam VARCL2_BASE_ADDR = 32'h0002_4000;  

    // Testbench signals
    reg  clk_i;
    reg  rst_i;
    reg  start_i;
    wire [CONTROLLER_SIGNAL_WIDTH-1:0] control_signal_i; // Driven internally by top_file_controller
    wire done_signal;

    // AXI signals
    reg  [AXI_ID_WIDTH-1:0]   s_axi_awid;
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

    wire [1 : 0] att_src;

    // Problem data from .mem
    reg [31:0] problem_data_mem [0:4095]; // 4096 lines

    // Instantiate your solver
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
    ) dut (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .start_i(start_i),
        .control_signal_i(control_signal_i),
        .done_signal(done_signal),

        // AXI
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

    always #(CLK_PERIOD/2) clk_i = ~clk_i;

    // Single-beat write
    task axi_write_single;
        input [AXI_ADDR_WIDTH-1:0] addr;
        input [AXI_DATA_WIDTH-1:0] data;
        begin
            s_axi_awvalid <= 1'b1;
            s_axi_awaddr  <= addr;
            s_axi_awid    <= 4'h1;
            s_axi_awlen   <= 0;        
            s_axi_awburst <= 2'b01;    
            s_axi_awsize  <= 3'd2;     // 4 bytes

            @(posedge clk_i);
            while(!s_axi_awready) @(posedge clk_i);
            s_axi_awvalid <= 1'b0;

            s_axi_wdata  <= data;
            s_axi_wstrb  <= 4'hF;
            s_axi_wlast  <= 1'b1;
            s_axi_wvalid <= 1'b1;

            @(posedge clk_i);
            while(!s_axi_wready) @(posedge clk_i);
            s_axi_wvalid <= 1'b0;
            s_axi_wlast  <= 1'b0;

            // B
            s_axi_bready <= 1'b1;
            @(posedge clk_i);
            while(!s_axi_bvalid) @(posedge clk_i);
            s_axi_bready <= 1'b0;
        end
    endtask

    // 4096 lines -> 256 bursts of 16 beats
    task axi_write_4096_clauses;
        input [AXI_ADDR_WIDTH-1:0] start_addr;
        integer i, j;
        reg [31:0] word;
        begin
            for(i=0; i<256; i=i+1) begin
                // AW
                s_axi_awid    <= 'h2;
                s_axi_awaddr  <= start_addr + i*16*4;
                s_axi_awlen   <= 15;  // 16 beats
                s_axi_awsize  <= 3'd2;
                s_axi_awburst <= 2'b01;
                s_axi_awvalid <= 1'b1;
                
                @(posedge clk_i);
                while(!s_axi_awready) @(posedge clk_i);
                s_axi_awvalid <= 1'b0;

                // W data
                for(j=0; j<16; j=j+1) begin
                    word = problem_data_mem[i*16 + j];
                    s_axi_wdata  <= word;
                    s_axi_wstrb  <= 4'b1111;
                    s_axi_wlast  <= (j==15);
                    s_axi_wvalid <= 1'b1;

                    @(posedge clk_i);
                    while(!s_axi_wready) @(posedge clk_i);
                    s_axi_wvalid <= 1'b0;
                end

                // B
                s_axi_bready <= 1'b1;
                @(posedge clk_i);
                while(!s_axi_bvalid) @(posedge clk_i);
                s_axi_bready <= 1'b0;
            end
        end
    endtask

    // Single-beat read
    task axi_read_single;
        input  [AXI_ADDR_WIDTH-1:0] addr;
        output [AXI_DATA_WIDTH-1:0] data;
        begin
            s_axi_arid    <= 'h3;
            s_axi_araddr  <= addr;
            s_axi_arlen   <= 0;
            s_axi_arsize  <= 3'd2;
            s_axi_arburst <= 2'b01;
            s_axi_arvalid <= 1'b1;

            @(posedge clk_i);
            while(!s_axi_arready) @(posedge clk_i);
            s_axi_arvalid <= 1'b0;

            s_axi_rready <= 1'b1;
            @(posedge clk_i);
            while(!s_axi_rvalid) @(posedge clk_i);

            data = s_axi_rdata;
            s_axi_rready <= 1'b0;

            while(!s_axi_rlast) @(posedge clk_i);
        end
    endtask

    initial begin
        clk_i   = 1'b0;
        rst_i   = 1'b1;
        start_i = 1'b0;

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

        #(CLK_PERIOD*5);
        rst_i = 1'b0;
        #(CLK_PERIOD*2);
        $display("[TB] Reset de-asserted at time %0t", $time);
    end

    // The target solution:
    // x1=FALSE, x2=FALSE, x3=TRUE, x4=FALSE,
    // x5=TRUE,  x6=FALSE, x7=FALSE, x8=FALSE,
    // x9=FALSE, x10=FALSE,x11=FALSE,x12=TRUE,
    // x13=FALSE,x14=TRUE, x15=FALSE,x16=FALSE
    reg expected_solution[1:16]; // index 1..16

    integer idx;
    initial begin
        expected_solution[1]  = 1'b0;
        expected_solution[2]  = 1'b0;
        expected_solution[3]  = 1'b1;
        expected_solution[4]  = 1'b0;
        expected_solution[5]  = 1'b1;
        expected_solution[6]  = 1'b0;
        expected_solution[7]  = 1'b0;
        expected_solution[8]  = 1'b0;
        expected_solution[9]  = 1'b0;
        expected_solution[10] = 1'b0;
        expected_solution[11] = 1'b0;
        expected_solution[12] = 1'b1;
        expected_solution[13] = 1'b0;
        expected_solution[14] = 1'b1;
        expected_solution[15] = 1'b0;
        expected_solution[16] = 1'b0;
    end

    integer i;
    reg [31:0] read_word;
    reg pass;

    initial begin
        @(negedge rst_i);
        #(CLK_PERIOD);

        $display("[TB] Reading problem_data.mem...");
        $readmemh("../mem/problem_data.mem", problem_data_mem);
        $display("[TB] Writing 4096 lines to Clause Table region...");
        axi_write_4096_clauses(CLAUSE_BASE_ADDR);

        for(i=0; i<4; i=i+1) begin
            axi_read_single(CLAUSE_BASE_ADDR + i*4, read_word);
            $display("[TB] ClauseTable[%0d] = 0x%08X", i, read_word);
        end

        $display("[TB] Start solver...");
        start_i <= 1'b1;
        @(posedge clk_i);
        start_i <= 1'b0;

        pass = 1'b1; // assume pass until proven otherwise

        repeat(20000) begin
            @(posedge clk_i);
            if(done_signal) begin
                $display("[TB] Solver done at time %0t!", $time);

                // Read back x1..x16 from var table #1
                for(i=1; i<=16; i=i+1) begin
                    axi_read_single(VARCL1_BASE_ADDR + (i-1)*4, read_word);
                    $display("  x%0d = %b (expected %b)", i, read_word[0], expected_solution[i]);
                    if(read_word[0] !== expected_solution[i]) begin
                        $display("[TB] Mismatch! x%0d was %b but expected %b", i, read_word[0], expected_solution[i]);
                        pass = 1'b0;
                    end
                end

                if(pass) begin
                    $display("[TB] All matches found! The solver produced the expected solution.");
                end else begin
                    $display("[TB] Some mismatches found - solution differs from expected!");
                end

                #(CLK_PERIOD*10);
                $finish;
            end
        end

        $display("[TB] Timed out waiting for solver done_signal!");
        $finish;
    end

    // Check waveform through here
    initial begin
        $dumpfile("december_top_file_tb.vcd");
        $dumpvars(0, december_top_file_tb);
    end

endmodule