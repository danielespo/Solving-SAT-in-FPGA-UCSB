/*
Version: 0.0
top_file_controller.v

V0.0 Author: Harim Choe
V0.1 Author: Daniel Espinosa

Description:
This is the controller for the datapath.v file

Notes:
	A: Select unsatisfied clauses and read the address table
	B: Read clause table
	C: Read variable table
	D: Evaluate clause and store if unsatisfied
	E: Count the number of unsatisfied clauses
	F: Gather unsatisfied clauses
	G: Select unsatisfied clauses

	States:
    	IDLE:
        	Wait for the start signal
        	No control signals
    	LOAD:
        	Initialize or load data
    	SELECT_UNSAT_CLAUSES (Step A)
        	cr_wr_en (CR_WR_EN_BIT): Set to 1 to write to the clause register
        	ucs_request (UCS_REQUEST_BIT): Set to 1 to request an unsatisfied clause
    	READ_CLAUSE_TABLE (Step B)
        	att_src (ATT_SRC_BITS): Select which literal from the clause register to use. 2'b00 selects the first literal
    	READ_VARIABLE_TABLE (Step C)
        	vt_en (VT_EN_BIT): Enable the variable table
        	vt_wr_en (VT_WR_EN_BIT): Set to 0 for read operation
        	vt_addr_src (VT_ADDR_SRC_BIT): Select the address source for the variable table
    	EVALUATE_CLAUSE (Step D)
        	vfs_wr_en (VFS_WR_EN_BITS): Enable writing to the Variable Flip Selector. 2'b01 enables it
        	cflb_wr_en (CFLB_WR_EN_BIT): Write enable for the Clause Negated Literals Buffer
    	COUNT_UNSAT_CLAUSES (Step E)
        	Counting might be an internal operation
    	GATHER_UNSAT_CLAUSES (Step F)
        	fifo_wr_en (FIFO_WR_EN_BIT): Enable writing unsatisfied clauses to the FIFO
    	SELECT_UNSAT_CLAUSES_AGAIN (Step G)
        	fifo_rd_en (FIFO_RD_EN_BIT): Enable reading clauses from the FIFO
    	DONE
        	done = 1'b1.

Change Log:
12/04/2024:
	Started working on the controller

12/11/2024 - Harim Choe
	Had some issues with the done stage. Fixed it by using an always block for the done flag.
	Added TB_WR_INDEX signal to control the temporal buffer wrapper where:
    	We start writing to the temporal buffer in the READ_CLAUSE_TABLE state, using index 00.
    	We continue writing in the READ_VARIABLE_TABLE state, using index 01.
    	We finish writing in the EVALUATE_CLAUSE state, using index 10.

01/11/2025 - Daniel Espinosa
	Adding AXI port information to the controller so it can communicate with the AXI4_Memory_Controller
	module. The main idea is using the AXI to control the state transitions of the FSM.
*/

module top_file_controller #(
	parameter NSAT = 3,
	parameter NUM_VARIABLES = 2048,
	parameter MAX_CLAUSE_MEMBERSHIP = 20,
	parameter FIFO_DEPTH = 32,
	parameter UNSAT_CLAUSE_BUFFER_DEPTH = 2048,
	parameter CONTROLLER_SIGNAL_WIDTH = 14,
	parameter AXI_DATA_WIDTH = 32,
	parameter AXI_STRB_WIDTH = AXI_DATA_WIDTH/8
) (
	input clk,
	input rst,
	input start, // now we want to drive this with the AXI
	output reg done,
	output reg [CONTROLLER_SIGNAL_WIDTH - 1:0] control_signal_o,
	output reg s_axi_wvalid,
	output reg [AXI_DATA_WIDTH-1:0] s_axi_wdata,
	output reg [AXI_STRB_WIDTH-1:0] s_axi_wstrb,
	output reg s_axi_wlast
);

/* --- AXI controller --- */
AXI4_Memory_Controller #(
) axi_inst (
	.clk_i  	(clk_i),
	.rst_i  	(rst_i),
	// Write address
	.s_axi_awid 	(s_axi_awid),
	.s_axi_awaddr   (s_axi_awaddr),
	.s_axi_awlen	(s_axi_awlen),
	.s_axi_awsize   (s_axi_awsize),
	.s_axi_awburst  (s_axi_awburst),
	.s_axi_awvalid  (s_axi_awvalid),
	.s_axi_awready  (s_axi_awready),

	// Write data
	.s_axi_wdata	(s_axi_wdata),
	.s_axi_wstrb	(s_axi_wstrb),
	.s_axi_wlast	(s_axi_wlast),
	.s_axi_wvalid   (s_axi_wvalid),
	.s_axi_wready   (s_axi_wready),

	// Write response
	.s_axi_bid  	(s_axi_bid),
	.s_axi_bresp	(s_axi_bresp),
	.s_axi_bvalid   (s_axi_bvalid),
	.s_axi_bready   (s_axi_bready),

	// Read address
	.s_axi_arid 	(s_axi_arid),
	.s_axi_araddr   (s_axi_araddr),
	.s_axi_arlen	(s_axi_arlen),
	.s_axi_arsize   (s_axi_arsize),
	.s_axi_arburst  (s_axi_arburst),
	.s_axi_arvalid  (s_axi_arvalid),
	.s_axi_arready  (s_axi_arready),

	// Read data
	.s_axi_rid  	(s_axi_rid),
	.s_axi_rdata	(s_axi_rdata),
	.s_axi_rresp	(s_axi_rresp),
	.s_axi_rlast	(s_axi_rlast),
	.s_axi_rvalid   (s_axi_rvalid),
	.s_axi_rready   (s_axi_rready),

	// Submodules
	.att_axi_wr_en_o	(att_axi_wr_en_o),
	.att_axi_wr_addr_o  (att_axi_wr_addr_o),
	.att_axi_wr_data_o  (att_axi_wr_data_o),
	.att_axi_rd_en_o	(att_axi_rd_en_o),
	.att_axi_rd_addr_o  (att_axi_rd_addr_o),
	.att_axi_rd_data_i  (att_axi_rd_data_i),

	.clause_axi_wr_en_o  	(clause_axi_wr_en_o),
	.clause_axi_wr_addr_o	(clause_axi_wr_addr_o),
	.clause_axi_wr_clauses_o (clause_axi_wr_clauses_o),
	.clause_axi_rd_en_o  	(clause_axi_rd_en_o),
	.clause_axi_rd_addr_o	(clause_axi_rd_addr_o),
	.clause_axi_rd_clauses_i (clause_axi_rd_clauses_i),

	.varcl1_axi_en_o	(varcl1_axi_en_o),
	.varcl1_axi_wr_en_o (varcl1_axi_wr_en_o),
	.varcl1_axi_addr_o  (varcl1_axi_addr_o),
	.varcl1_axi_data_o  (varcl1_axi_data_o),
	.varcl1_axi_data_read_i (varcl1_axi_data_read_i),

	.varcl2_axi_en_o	(varcl2_axi_en_o),
	.varcl2_axi_wr_en_o (varcl2_axi_wr_en_o),
	.varcl2_axi_addr_o  (varcl2_axi_addr_o),
	.varcl2_axi_data_o  (varcl2_axi_data_o),
	.varcl2_axi_data_read_i (varcl2_axi_data_read_i),
	.state_data (state_data)
);

localparam IDLE                  	= 4'd0,
       	LOAD                  	= 4'd1,
       	SELECT_UNSAT_CLAUSES  	= 4'd2,  // Step A
       	READ_CLAUSE_TABLE     	= 4'd3,  // Step B
       	READ_VARIABLE_TABLE   	= 4'd4,  // Step C
       	EVALUATE_CLAUSE       	= 4'd5,  // Step D
       	COUNT_UNSAT_CLAUSES   	= 4'd6,  // Step E
       	GATHER_UNSAT_CLAUSES  	= 4'd7,  // Step F
       	SELECT_UNSAT_CLAUSES_AGAIN= 4'd8,  // Step G
       	DONE                  	= 4'd9;

      	 
reg [3:0] state, next_state;

always @(posedge clk or posedge rst) begin
	if (rst) begin
    	state <= IDLE;
	end else begin
    	state <= next_state;
	end
end

// TODO: learn how to subinstance this and set it to 1
// The general idea is that now in this branch we have access to the output state of the state machine based on the
// state_data output, so you cna use it as a conditional inside this state machine controller
// so that you can advance the state of the solver in the IDLE -> LOAD state and the DONE to IDLE states
// for loading problem data then solving, for getting our results back and resetting.

always @(*) begin

	// state_ data == 3 = WRESP
	// 2 = WDATA
	// 1 = WADDR
	// 0 = WIDLE
	next_state = state;
	control_signal_o = {CONTROLLER_SIGNAL_WIDTH{1'b0}}; // Default all signals to 0

	case (state)
    	IDLE: begin // Now: start signal is coming from the AXI port ; don't we need to change it?
        	// start <- (CT-data-handshake-ok & AT-data-handshake-ok & VTC-data-handshake-ok) (sequential conditional)
            	if (state_data != 0) begin
                	next_state = LOAD;
            	end
        	end
    	LOAD: begin // Here we instantiate the axi data
        	// enable write on all axi ports
        	s_axi_wvalid = 1;
        	if (state_data == 3 ) begin
            	next_state = SELECT_UNSAT_CLAUSES;
        	end

    	end
    	SELECT_UNSAT_CLAUSES: begin // Step A
        	control_signal_o[13] = 1'b1;   // CR_WR_EN_BIT
        	control_signal_o[0] = 1'b1;	// UCS_REQUEST_BIT
        	next_state = READ_CLAUSE_TABLE;
    	end
    	READ_CLAUSE_TABLE: begin // Step B
        	control_signal_o[12:11] = 2'b00; // ATT_SRC_BITS
        	control_signal_o[4:3] = 2'b00;  //TB_WR_INDEX - Start writing to first index
        	next_state = READ_VARIABLE_TABLE;
    	end
    	READ_VARIABLE_TABLE: begin // Step C
        	control_signal_o[9] = 1'b1; 	// VT_EN_BIT
        	control_signal_o[8] = 1'b0; 	// VT_WR_EN_BIT
        	control_signal_o[10] = 1'b0;	// VT_ADDR_SRC_BIT
        	control_signal_o[4:3] = 2'b01;  //TB_WR_INDEX - Write to second index
        	next_state = EVALUATE_CLAUSE;
    	end
    	EVALUATE_CLAUSE: begin // Step D
        	control_signal_o[7:6] = 2'b01;  // VFS_WR_EN_BITS
        	control_signal_o[5] = 1'b1; 	// CFLB_WR_EN_BIT
        	control_signal_o[4:3] = 2'b10;  // TB_WR_INDEX - Write to third index
        	next_state = COUNT_UNSAT_CLAUSES;
    	end
    	COUNT_UNSAT_CLAUSES: begin // Step E
        	control_signal_o[7:6] = 2'b00; // Low VFS_WR_EN_BITS
        	next_state = GATHER_UNSAT_CLAUSES;
    	end
    	GATHER_UNSAT_CLAUSES: begin // Step F
        	control_signal_o[2] = 1'b1; 	// FIFO_WR_EN_BIT
        	next_state = SELECT_UNSAT_CLAUSES_AGAIN;
    	end
    	SELECT_UNSAT_CLAUSES_AGAIN: begin // Step G
        	control_signal_o[1] = 1'b1; 	// FIFO_RD_EN_BIT
        	next_state = DONE;  // Go to DONE state after completing the cycle
    	end
    	DONE: begin
        	// Do the same you do in the LOAD state of the FSM
        	control_signal_o = {CONTROLLER_SIGNAL_WIDTH{1'b0}}; // All signals off in DONE state
        	// Enable Axi read signals
        	// start <- (CT-data-handshake-ok & AT-data-handshake-ok & VTC-data-handshake-ok) (sequential conditional)
        	// set axi read enable to high
        	// if RREADY for CT, ATT and VTC then start
        	if (state_data != 0) begin
            	next_state = LOAD;
        	end
    	end
    	default: next_state = IDLE;
	endcase
end

// Latch the done flag
always @(posedge clk or posedge rst) begin
	if (rst) begin
    	done <= 1'b0;
	end else if (state == DONE) begin
    	done <= 1'b1;
	end else if (state == LOAD) begin
    	done <= 1'b0;
	end
	else begin
    	done <= 1'b0;
	end
end

endmodule