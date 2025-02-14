/*
Version 1.1
Controller.v

V1.0 Author: Harim Choe
V1.1 Author: Daniel Espinosa

Description: This module is the controller for a single thread of the SAT Solver,
  it is basically a FSM that makes sure to start solving only when data is stable,
    and to stop when either the thread runs out of MAXFLIPS or it finds SAT.
    

Testing: 
02/14/2025 - Daniel Espinosa
    Harim's original design passed testing fine, the diff here is trying to add the extra signals
      from the Overlord.v file which is being a bit of a pain.

Change Log:
*/

module Controller #(
  parameter NSAT                        = 3,
  parameter NUM_VARIABLES               = 2048,
  parameter MAX_CLAUSE_MEMBERSHIP       = 20,
  parameter FIFO_DEPTH                  = 32,
  parameter UNSAT_CLAUSE_BUFFER_DEPTH   = 2048,
  parameter CONTROLLER_SIGNAL_WIDTH     = 14,
  parameter MAX_FLIPS                   = 32'h00FF_FFFF,
  parameter VARIABLE_ADDRESS_WIDTH      = $clog2(NUM_VARIABLES),
  parameter LITERAL_ADDRESS_WIDTH       = $clog2(NUM_VARIABLES)+1,
  parameter CT_WIDTH                    = (LITERAL_ADDRESS_WIDTH * (NSAT-1) * MAX_CLAUSE_MEMBERSHIP)
)
(
  input  wire clk, 
  input  wire rst,
  input  wire start,
  input  wire start_run, // NEW: When asserted, leave the LOAD state

  // Load interface signals (unchanged)
  input  wire [LITERAL_ADDRESS_WIDTH:0]  att_load_addr_i,
  input  wire [(VARIABLE_ADDRESS_WIDTH+MAX_CLAUSE_MEMBERSHIP)-1:0] att_load_data_i,
  input  wire att_load_valid_i,
  input  wire [VARIABLE_ADDRESS_WIDTH-1:0] ct_load_addr_i,
  input  wire [CT_WIDTH-1:0]              ct_load_data_i,
  input  wire ct_load_valid_i,
  input  wire [$clog2(UNSAT_CLAUSE_BUFFER_DEPTH)-1:0] ucb_load_addr_i,
  input  wire [NSAT*LITERAL_ADDRESS_WIDTH-1:0]      ucb_load_data_i,
  input  wire ucb_load_valid_i,
  input  wire [10:0] unsat_buffer_count_i,

  output reg [CONTROLLER_SIGNAL_WIDTH-1:0] control_signal_o,
  output reg        att_wr_en_o,
  output reg [LITERAL_ADDRESS_WIDTH:0] att_wr_addr_o,
  output reg [(VARIABLE_ADDRESS_WIDTH+MAX_CLAUSE_MEMBERSHIP)-1:0] att_wr_data_o,
  output reg        ct_wr_en_o,
  output reg [VARIABLE_ADDRESS_WIDTH-1:0] ct_wr_addr_o,
  output reg [CT_WIDTH-1:0]              ct_wr_data_o,
  output reg        ucb_setup_wr_en_o,
  output reg [$clog2(UNSAT_CLAUSE_BUFFER_DEPTH)-1:0] ucb_setup_addr_o,
  output reg [NSAT*LITERAL_ADDRESS_WIDTH-1:0]      ucb_setup_data_o,
  output reg        ucb_setup_o,

  output reg done,
  output reg load_done // NEW: high once the thread has finished loading its data
);

localparam IDLE         = 4'd0,
           LOAD         = 4'd1,
           SELECT_UNSAT = 4'd2,
           READ_CLAUSETAB = 4'd3,
           READ_VARTAB  = 4'd4,
           EVAL_CLAUSE  = 4'd5,
           WAIT_EVAL    = 4'd6,
           GATHER_UNSAT = 4'd7,
           WAIT_GATHER  = 4'd8,
           CHECK_SOL    = 4'd9,
           DONE         = 4'd10;

reg [3:0] state, next_state;
reg [31:0] flip_count, next_flip_count;

always @(posedge clk or posedge rst) begin
  if (rst) begin
    state       <= IDLE;
    flip_count  <= 0;
    load_done   <= 1'b0;
  end else begin
    state       <= next_state;
    flip_count  <= next_flip_count;
    // Latch load_done when leaving LOAD state
    if(state == LOAD && next_state != LOAD)
      load_done <= 1'b1;
  end
end

always @(*) begin
  next_state       = state;
  next_flip_count  = flip_count;
  control_signal_o = {CONTROLLER_SIGNAL_WIDTH{1'b0}};
  done             = 1'b0;

  att_wr_en_o      = 1'b0;
  att_wr_addr_o    = {LITERAL_ADDRESS_WIDTH+1{1'b0}};
  att_wr_data_o    = {(VARIABLE_ADDRESS_WIDTH+MAX_CLAUSE_MEMBERSHIP){1'b0}};

  ct_wr_en_o       = 1'b0;
  ct_wr_addr_o     = {VARIABLE_ADDRESS_WIDTH{1'b0}};
  ct_wr_data_o     = {CT_WIDTH{1'b0}};

  ucb_setup_wr_en_o = 1'b0;
  ucb_setup_addr_o  = {$clog2(UNSAT_CLAUSE_BUFFER_DEPTH){1'b0}};
  ucb_setup_data_o  = {NSAT*LITERAL_ADDRESS_WIDTH{1'b0}};
  ucb_setup_o       = 1'b0;

  case (state)
    IDLE: begin
      if (start)
        next_state = LOAD;
    end
    LOAD: begin
      if (att_load_valid_i) begin
         att_wr_en_o   = 1'b1;
         att_wr_addr_o = att_load_addr_i;
         att_wr_data_o = att_load_data_i;
      end
      else if (ct_load_valid_i) begin
         ct_wr_en_o   = 1'b1;
         ct_wr_addr_o = ct_load_addr_i;
         ct_wr_data_o = ct_load_data_i;
      end
      else if (ucb_load_valid_i) begin
         ucb_setup_o         = 1'b1;
         ucb_setup_wr_en_o   = 1'b1;
         ucb_setup_addr_o    = ucb_load_addr_i;
         ucb_setup_data_o    = ucb_load_data_i;
      end
      else begin
         // Hold in LOAD until the external start_run is asserted
         if(start_run)
           next_state = SELECT_UNSAT;
         else
           next_state = LOAD;
      end
    end
    SELECT_UNSAT: begin
      control_signal_o[13] = 1'b1;
      control_signal_o[0]  = 1'b1;
      next_state = READ_CLAUSETAB;
    end
    READ_CLAUSETAB: begin
      control_signal_o[12:11] = 2'b00;
      control_signal_o[4:3]   = 2'b00;
      next_state = READ_VARTAB;
    end
    READ_VARTAB: begin
      control_signal_o[9]    = 1'b1;
      control_signal_o[8]    = 1'b0;
      control_signal_o[10]   = 1'b0;
      control_signal_o[4:3]  = 2'b01;
      next_state = EVAL_CLAUSE;
    end
    EVAL_CLAUSE: begin
      control_signal_o[7:6] = 2'b01;
      control_signal_o[5]   = 1'b1;
      control_signal_o[4:3] = 2'b10;
      next_state = WAIT_EVAL;
    end
    WAIT_EVAL: begin
      control_signal_o[7:6] = 2'b00;
      next_state = GATHER_UNSAT;
    end
    GATHER_UNSAT: begin
      control_signal_o[2] = 1'b1;
      next_state = WAIT_GATHER;
    end
    WAIT_GATHER: begin
      control_signal_o[1] = 1'b1;
      next_flip_count = flip_count + 1;
      next_state = CHECK_SOL;
    end
    CHECK_SOL: begin
      if (unsat_buffer_count_i == 0)
         next_state = DONE;
      else if (flip_count >= MAX_FLIPS)
         next_state = DONE;
      else
         next_state = SELECT_UNSAT;
    end
    DONE: begin
      done = 1'b1;
      if (start)
         next_state = LOAD;
    end
    default: next_state = IDLE;
  endcase
end

endmodule

