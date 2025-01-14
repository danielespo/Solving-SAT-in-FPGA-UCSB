/*
Version: 0.0
AXI4_Memory_Controller.v

V0.0 Author: Harim Choe

Description:
This module implements a basic AXI4 slave memory controller. It handles both 
write and read transactions on the AXI bus and maps them to corresponding 
submodules (Clause_Table, Address_Translation_Table, Variable_Table_Clusters).

Write operation (AW/W/B channels):
1) The controller waits for a valid write address (AWVALID) and sets AWREADY 
   when it is ready to accept. Once the address handshake completes, 
   the controller transitions to receive write data (WVALID).
2) For each beat of WDATA, the controller decodes the address (incremented 
   per beat, if it is a burst) and writes to the appropriate submodule. It 
   tracks the number of beats using the AWLEN field and AWSIZE for address 
   incrementing. 
3) When the final beat (WLAST) is received, the controller completes the 
   burst by issuing a write response (BVALID) and sets the appropriate response 
   code (OKAY, SLVERR, etc.). After the master accepts the response (BREADY), 
   the controller returns to idle.

Read operation (AR/R channels):
1) The controller waits for a valid read address (ARVALID) and sets ARREADY 
   when it is ready to accept. It latches the address and ARLEN/ARSIZE 
   burst parameters.
2) On each read beat, the controller increments the address (for INCR-type 
   bursts) and fetches data from the relevant submodule. That data is driven 
   onto the RDATA lines alongside RVALID. The controller also sets RRESP 
   appropriately.
3) The last read beat is signaled by RLAST once the burst is complete. After 
   the master asserts RREADY to accept this final beat, the controller 
   returns to idle.

Change Log:
01/04/2024:
    Started working on the controller

01/08/2024:
    Finished testing out the controller

01/10/2024:
    Fixed parameter lengths to match datapath

01/11/2024:
    Modified max burst length from 8 to 16
*/

module AXI4_Memory_Controller #(

parameter AXI_ID_WIDTH    = 4,
          AXI_ADDR_WIDTH  = 32,
          AXI_DATA_WIDTH  = 32,
          AXI_STRB_WIDTH  = AXI_DATA_WIDTH/8,
          MAX_BURST_LEN   = 16,
          ATT_BASE_ADDR     = 32'h0000_0000,
          ATT_SIZE_BYTES    = 32'h0000_4000,
          CLAUSE_BASE_ADDR  = 32'h0000_4000,
          CLAUSE_SIZE_BYTES = 32'h0001_e000,
          VARCL1_BASE_ADDR  = 32'h0002_2000,
          VARCL1_SIZE_BYTES = 32'h0000_2000,
          VARCL2_BASE_ADDR  = 32'h0002_4000,
          VARCL2_SIZE_BYTES = 32'h0000_2000
)(   
    // Clock and reset
    input wire                       clk_i,
    input wire                       rst_i,
  
    // Write address
    input  wire [AXI_ID_WIDTH-1:0]   s_axi_awid,
    input  wire [AXI_ADDR_WIDTH-1:0] s_axi_awaddr,
    input  wire [7:0]                s_axi_awlen,    // Burst length (beats-1)
    input  wire [2:0]                s_axi_awsize,   // Size of each beat, in bytes log2
    input  wire [1:0]                s_axi_awburst,  // Burst type: 0: FIXED, 1: INCR, 2: WRAP
    input  wire                      s_axi_awvalid,
    output reg                       s_axi_awready,

    // Write data
    input  wire [AXI_DATA_WIDTH-1:0] s_axi_wdata,
    input  wire [AXI_STRB_WIDTH-1:0] s_axi_wstrb,
    input  wire                      s_axi_wlast,
    input  wire                      s_axi_wvalid,
    output reg                       s_axi_wready,

    // Write response
    output reg  [AXI_ID_WIDTH-1:0]   s_axi_bid,
    output reg  [1:0]                s_axi_bresp,    // OKAY=2'b00, SLVERR=2'b10, DECERR=2'b11
    output reg                       s_axi_bvalid,
    input  wire                      s_axi_bready,

    // Read address
    input  wire [AXI_ID_WIDTH-1:0]   s_axi_arid,
    input  wire [AXI_ADDR_WIDTH-1:0] s_axi_araddr,
    input  wire [7:0]                s_axi_arlen,
    input  wire [2:0]                s_axi_arsize,
    input  wire [1:0]                s_axi_arburst,
    input  wire                      s_axi_arvalid,
    output reg                       s_axi_arready,

    // Read data
    input  wire                      s_axi_rready,
    output reg  [AXI_ID_WIDTH-1:0]   s_axi_rid,
    output reg  [AXI_DATA_WIDTH-1:0] s_axi_rdata,
    output reg  [1:0]                s_axi_rresp,   // OKAY=2'b00, SLVERR=2'b10, DECERR=2'b11
    output reg                       s_axi_rlast,
    output reg                       s_axi_rvalid,

    // Address translation table outputs
    input  wire [(11 + 20) - 1 : 0]  att_axi_rd_data_i,
    output reg                       att_axi_wr_en_o,
    output reg [12:0]               att_axi_wr_addr_o,
    output reg [(11 + 20) - 1 : 0]   att_axi_wr_data_o,
    output reg                       att_axi_rd_en_o,
    output reg [12:0]               att_axi_rd_addr_o,

    // Clause table outputs
    input  wire [((11+1)*(3-1)*20)-1:0] clause_axi_rd_clauses_i,
    output reg                       clause_axi_wr_en_o,
    output reg [10:0]               clause_axi_wr_addr_o,
    output reg [((11+1)*(3-1)*20)-1:0] clause_axi_wr_clauses_o,
    output reg                       clause_axi_rd_en_o,
    output reg [10:0]               clause_axi_rd_addr_o,

    // Variable table cluster outputs
    input  wire                      varcl1_axi_data_read_i,
    output reg                       varcl1_axi_en_o,
    output reg                       varcl1_axi_wr_en_o,
    output reg [10:0]               varcl1_axi_addr_o,
    output reg                       varcl1_axi_data_o,
    input  wire                      varcl2_axi_data_read_i,
    output reg                       varcl2_axi_en_o,
    output reg                       varcl2_axi_wr_en_o,
    output reg [10:0]               varcl2_axi_addr_o,
    output reg                       varcl2_axi_data_o
);

// AXI response localparams
localparam RESP_OKAY   = 2'b00;
localparam RESP_SLVERR = 2'b10;
localparam RESP_DECERR = 2'b11;

// Write FSM states
localparam WIDLE  = 2'd0, WADDR  = 2'd1, WDATA  = 2'd2, WRESP  = 2'd3;
reg [1:0] wstate, wnext;

// Latch AW signals
reg [AXI_ID_WIDTH-1:0]   awid_reg;
reg [AXI_ADDR_WIDTH-1:0] awaddr_reg;
reg [7:0]                awlen_reg;
reg [2:0]                awsize_reg;
reg [1:0]                awburst_reg;
reg [7:0]                awbeat_count;
reg [1:0]                wburst_resp;

// Write FSM
always @(posedge clk_i or posedge rst_i) begin
    if (rst_i) 
        wstate <= WIDLE;
    else      
        wstate <= wnext;
end

always @(*) begin
    wnext = wstate;
    s_axi_awready = 1'b0;
    s_axi_wready  = 1'b0;

    case (wstate)
        WIDLE: begin
            $display("[MC W-FSM] In WIDLE");
            if (s_axi_awvalid) begin
                s_axi_awready = 1'b1;
                wnext         = WADDR;
            end
        end
        WADDR: begin
            $display("[MC W-FSM] In WADDR");
            if (s_axi_wvalid) begin
                s_axi_wready = 1'b1;
                wnext = WDATA;
            end
        end
        WDATA: begin
            s_axi_wready = 1'b1;
            $display("[MC W-FSM] In WDATA");
            if (s_axi_wvalid && s_axi_wready) begin
                $display("[%0t] AXI4_Memory_Controller: WDATA handshake => beat_count=%0d, waddr_beat=0x%08h, wlast=%b",
                         $time, awbeat_count, waddr_beat, s_axi_wlast);
                if(s_axi_wlast) begin
                    wnext = WRESP;
                end
            end
        end
        WRESP: begin
            // Provide BVALID. Wait for BREADY.
            $display("[MC W-FSM] In WRESP");
            if (s_axi_bready) begin
                $display("[%0t] AXI4_Memory_Controller: WRESP done => returning to WIDLE", $time);
                wnext = WIDLE;
            end
        end
    endcase
end

// Latch AW + handle beat_count
always @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        awid_reg     <= {AXI_ID_WIDTH{1'b0}};
        awaddr_reg   <= {AXI_ADDR_WIDTH{1'b0}};
        awlen_reg    <= 8'd0;
        awsize_reg   <= 3'd0;
        awburst_reg  <= 2'b00;
        awbeat_count <= 8'd0;
        wburst_resp  <= RESP_OKAY;
    end else begin
        $display("[MC W-FSM] state=%d, time=%t, wburst_resp=%b, wstate=%b, s_axi_wvalid=%b, s_axi_wready=%b, s_axi_bvalid=%b",
                 wstate, $time, wburst_resp, wstate, s_axi_wvalid, s_axi_wready, s_axi_bvalid);

        case(wstate)
            WIDLE: begin
                if(s_axi_awvalid && s_axi_awready) begin
                    awid_reg    <= s_axi_awid; // latch AW
                    awaddr_reg  <= s_axi_awaddr;
                    awlen_reg   <= s_axi_awlen;
                    awsize_reg  <= s_axi_awsize;
                    awburst_reg <= s_axi_awburst;
                    awbeat_count<= 8'd0;
                    wburst_resp <= RESP_OKAY;
                end
            end
            WADDR: begin
                // No logical change
            end
            WDATA: begin
                // No logical change
            end
        endcase
    end
end

// Write Response
always @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        s_axi_bvalid <= 1'b0;
        s_axi_bresp  <= RESP_OKAY;
        s_axi_bid    <= {AXI_ID_WIDTH{1'b0}};
    end else begin
        if(wstate==WRESP) begin
            s_axi_bvalid <= 1'b1;
            s_axi_bresp  <= wburst_resp;
            s_axi_bid    <= awid_reg;
        end
        else if(s_axi_bvalid && s_axi_bready) begin
            s_axi_bvalid <= 1'b0;
        end
    end
end

// Next-beat address logic
wire [AXI_ADDR_WIDTH-1:0] waddr_beat = awaddr_reg + (awbeat_count << awsize_reg);

// Check invalid burst type or length
wire [1:0] burst_type_err = (awburst_reg==2'b01) ? 2'b00 : RESP_SLVERR;
wire [1:0] burst_len_err = (awlen_reg >= MAX_BURST_LEN) ? RESP_SLVERR : 2'b00;
wire [1:0] wresp_error = (burst_type_err != 2'b00) ? burst_type_err : (burst_len_err  != 2'b00) ? burst_len_err : 2'b00;

// Accumulate error
always @(posedge clk_i or posedge rst_i) begin
    if(rst_i) begin
        wburst_resp <= RESP_OKAY;
    end else if(wresp_error != 2'b00 && wstate != WIDLE) begin
        wburst_resp <= wresp_error;
    end
end

// Decoding submodules
always @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        att_axi_wr_en_o    <= 1'b0;
        att_axi_wr_addr_o  <= 13'b0;
        att_axi_wr_data_o  <= {(31){1'b0}};
        clause_axi_wr_en_o <= 1'b0;
        clause_axi_wr_addr_o <= 1'b0;
        clause_axi_wr_clauses_o <= {( (11+1)*(3-1)*20 ){1'b0}};
        varcl1_axi_en_o    <= 1'b0;
        varcl1_axi_wr_en_o <= 1'b0;
        varcl1_axi_addr_o  <= 11'b0;
        varcl1_axi_data_o  <= 1'b0;
        varcl2_axi_en_o    <= 1'b0;
        varcl2_axi_wr_en_o <= 1'b0;
        varcl2_axi_addr_o  <= 11'b0;
        varcl2_axi_data_o  <= 1'b0;
    end else begin
        att_axi_wr_en_o    <= 1'b0;
        clause_axi_wr_en_o <= 1'b0;
        varcl1_axi_en_o    <= 1'b0;
        varcl1_axi_wr_en_o <= 1'b0;
        varcl2_axi_en_o    <= 1'b0;
        varcl2_axi_wr_en_o <= 1'b0;

        if(wstate==WDATA && s_axi_wvalid && s_axi_wready) begin
            $display("[%0t] AXI4_Memory_Controller: submodule decode => waddr_beat=0x%08h",
                     $time, waddr_beat);
            
            if(waddr_beat >= ATT_BASE_ADDR && waddr_beat < (ATT_BASE_ADDR + ATT_SIZE_BYTES)) begin
                att_axi_wr_en_o   <= 1'b1;
                att_axi_wr_addr_o <= waddr_beat[12:0];
                att_axi_wr_data_o <= s_axi_wdata[(11+20)-1:0];
                $display("  => ATT write: addr=0x%04h, data=0x%08h",
                         att_axi_wr_addr_o, att_axi_wr_data_o);
            end
            else if(waddr_beat >= CLAUSE_BASE_ADDR && waddr_beat < (CLAUSE_BASE_ADDR + CLAUSE_SIZE_BYTES)) begin
                clause_axi_wr_en_o      <= 1'b1;
                clause_axi_wr_addr_o    <= waddr_beat[10:0];
                // clause_axi_wr_clauses_o <= {( (11+1)*(3-1)*20 ){1'b0}};
                clause_axi_wr_clauses_o <= {448'd0, s_axi_wdata};
                $display("  => CLAUSE write: sub-addr=0x%03h, data=0x%08h", clause_axi_wr_addr_o, s_axi_wdata);
            end
            else if(waddr_beat >= VARCL1_BASE_ADDR && waddr_beat < (VARCL1_BASE_ADDR+VARCL1_SIZE_BYTES)) begin
                varcl1_axi_en_o    <= 1'b1;
                varcl1_axi_wr_en_o <= 1'b1;
                varcl1_axi_addr_o  <= waddr_beat[10:0];
                varcl1_axi_data_o  <= s_axi_wdata[0];
                $display("  => VARCL1 write: addr=0x%03h, data_bit=%b",
                         varcl1_axi_addr_o, varcl1_axi_data_o);
            end
            else if(waddr_beat >= VARCL2_BASE_ADDR && waddr_beat < (VARCL2_BASE_ADDR+VARCL2_SIZE_BYTES)) begin
                varcl2_axi_en_o    <= 1'b1;
                varcl2_axi_wr_en_o <= 1'b1;
                varcl2_axi_addr_o  <= waddr_beat[10:0];
                varcl2_axi_data_o  <= s_axi_wdata[0];
                $display("  => VARCL2 write: addr=0x%03h, data_bit=%b",
                         varcl2_axi_addr_o, varcl2_axi_data_o);
            end
            else begin
                wburst_resp <= RESP_SLVERR;
                $display("  => Out-of-range => SLVERR");
            end

            awbeat_count <= awbeat_count + 1'b1;
        end
    end
end

// Read response
localparam RIDLE=0, RADDR=1, RDATA=2, RLAST=3;
reg [1:0] rstate, rnext;

reg [AXI_ID_WIDTH-1:0]   arid_reg;
reg [AXI_ADDR_WIDTH-1:0] araddr_reg;
reg [7:0]                arlen_reg;
reg [2:0]                arsize_reg;
reg [1:0]                arburst_reg;
reg [7:0]                arbeat_count;
reg [1:0]  rburst_resp;

always @(posedge clk_i or posedge rst_i) begin
    if (rst_i) 
        rstate <= RIDLE;
    else
        rstate <= rnext;
end

always @(*) begin
    rnext          = rstate;
    s_axi_arready  = 1'b0;
    
    case(rstate)
        RIDLE: begin
            if(s_axi_arvalid) begin
                s_axi_arready = 1'b1;
                rnext         = RADDR;
            end
        end
        RADDR: begin
            rnext = RDATA;
        end
        RDATA: begin
            if (arbeat_count == arlen_reg) begin
                rnext = RLAST;
            end
        end
        RLAST: begin
            rnext = RIDLE;
        end
    endcase
end

always @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        arid_reg <= 0;
        araddr_reg <= 0;
        arlen_reg <= 0;
        arsize_reg<= 3'd0;
        arburst_reg<=2'b00;
        arbeat_count<=0;
        rburst_resp <= 2'b00;
    end else begin
        if (rstate == RIDLE && s_axi_arvalid && s_axi_arready) begin
            arid_reg     <= s_axi_arid;
            araddr_reg   <= s_axi_araddr;
            arlen_reg    <= s_axi_arlen;
            arsize_reg   <= s_axi_arsize;
            arburst_reg  <= s_axi_arburst;
            arbeat_count <= 0;
            rburst_resp  <= 2'b00; 
        end
        else if(rstate == RADDR) begin
            arbeat_count <= 0;
        end
        else if(rstate == RDATA) begin
            if(s_axi_rvalid && s_axi_rready) begin
                arbeat_count <= arbeat_count + 1;
            end
        end
    end
end

wire [1:0] rburst_type_err = (arburst_reg==2'b01) ? 2'b00 : RESP_SLVERR;
wire [1:0] rburst_len_err = (arlen_reg>=MAX_BURST_LEN) ? RESP_SLVERR : 2'b00;
wire [1:0] rresp_error = (rburst_type_err!=2'b00) ? rburst_type_err : (rburst_len_err!=2'b00) ? rburst_len_err : 2'b00;

always @(posedge clk_i or posedge rst_i) begin
    if(rst_i) 
        rburst_resp <= 2'b00;
    else if (rresp_error != 2'b00 && rstate != RIDLE) begin
        rburst_resp <= rresp_error;
    end
end

reg [AXI_ADDR_WIDTH-1:0] raddr_beat;

always @(posedge clk_i or posedge rst_i) begin
    if(rst_i) begin
        s_axi_rvalid <= 1'b0;
        s_axi_rdata  <= 0;
        s_axi_rresp  <= 2'b00;
        s_axi_rlast  <= 1'b0;
        s_axi_rid    <= 0;
    end else begin
        if (rstate == RDATA) begin
            if (!s_axi_rvalid || (s_axi_rvalid && s_axi_rready)) begin
                s_axi_rvalid <= 1'b1;
                s_axi_rid    <= arid_reg;
                s_axi_rresp  <= rburst_resp;

                if (arbeat_count==arlen_reg) 
                    s_axi_rlast <= 1'b1;
                else                       
                    s_axi_rlast <= 1'b0;

                raddr_beat = araddr_reg + (arbeat_count << arsize_reg);
                $display("[%0t] AXI4_Memory_Controller: RDATA => beat_count=%0d, raddr_beat=0x%08h, rlast=%b, rresp=%b",
                         $time, arbeat_count, raddr_beat, s_axi_rlast, rburst_resp);

                att_axi_rd_en_o       <= 1'b0;
                att_axi_rd_addr_o     <= 13'b0;
                clause_axi_rd_en_o    <= 1'b0;
                clause_axi_rd_addr_o  <= 11'b0;
                varcl1_axi_en_o       <= 1'b0;
                varcl1_axi_wr_en_o    <= 1'b0;
                varcl1_axi_addr_o     <= 11'b0;
                varcl1_axi_data_o     <= 1'b0;
                varcl2_axi_en_o       <= 1'b0;
                varcl2_axi_wr_en_o    <= 1'b0;
                varcl2_axi_addr_o     <= 11'b0;
                varcl2_axi_data_o     <= 1'b0;

                s_axi_rdata <= {AXI_DATA_WIDTH{1'b0}}; // default
                $display("  read_from_submodules: raddr=0x%08h", raddr_beat);

                if(raddr_beat >= ATT_BASE_ADDR && raddr_beat < (ATT_BASE_ADDR + ATT_SIZE_BYTES)) begin
                    att_axi_rd_en_o   <= 1'b1;
                    att_axi_rd_addr_o <= raddr_beat[12:0];
                    s_axi_rdata       <= {{(AXI_DATA_WIDTH-(11+20)){1'b0}}, att_axi_rd_data_i};
                    $display("    => ATT read: addr=0x%04h => data=0x%08h", att_axi_rd_addr_o, s_axi_rdata);
                end
                else if(raddr_beat >= CLAUSE_BASE_ADDR && raddr_beat < (CLAUSE_BASE_ADDR + CLAUSE_SIZE_BYTES)) begin
                    clause_axi_rd_en_o   <= 1'b1;
                    clause_axi_rd_addr_o = raddr_beat[10:0];
                    // s_axi_rdata = {AXI_DATA_WIDTH{1'b0}}; 
                    s_axi_rdata = clause_axi_rd_clauses_i[31:0];
                    $display("  => CLAUSE read: addr=0x%03h => data=0x%08h", clause_axi_rd_addr_o, s_axi_rdata);
                end
                else if(raddr_beat >= VARCL1_BASE_ADDR && raddr_beat < (VARCL1_BASE_ADDR + VARCL1_SIZE_BYTES)) begin
                    varcl1_axi_en_o   <= 1'b1;
                    varcl1_axi_addr_o = raddr_beat[10:0];
                    s_axi_rdata = {{(AXI_DATA_WIDTH-1){1'b0}}, varcl1_axi_data_read_i};
                    $display("    => VARCL1 read: addr=0x%03h => data_bit=%b", varcl1_axi_addr_o, varcl1_axi_data_read_i);
                end
                else if(raddr_beat >= VARCL2_BASE_ADDR && raddr_beat < (VARCL2_BASE_ADDR + VARCL2_SIZE_BYTES)) begin
                    varcl2_axi_en_o   <= 1'b1;
                    varcl2_axi_addr_o = raddr_beat[10:0];
                    s_axi_rdata = {{(AXI_DATA_WIDTH-1){1'b0}}, varcl2_axi_data_read_i};
                    $display("    => VARCL2 read: addr=0x%03h => data_bit=%b", varcl2_axi_addr_o, varcl2_axi_data_read_i);
                end
                else begin
                    rburst_resp = RESP_SLVERR;
                    $display("    => Out-of-range read => SLVERR");
                end
            end
        end else if (rstate==RLAST) begin
            if (s_axi_rvalid && s_axi_rready) begin
                s_axi_rvalid <= 1'b0;
                s_axi_rlast  <= 1'b0;
            end
        end else begin
            s_axi_rvalid <= 1'b0;
            s_axi_rlast  <= 1'b0;
        end
    end
end

endmodule