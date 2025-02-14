module Overlord #(
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
    input  wire cpu_start, // Serial activation from CPU
    input  wire load_end,  // Indicates that loading for the current thread is complete
  
    // CPU serial load interface for the three memories:
    input  wire att_load_valid,
    input  wire [LITERAL_ADDRESS_WIDTH:0] att_load_addr,
    input  wire [(VARIABLE_ADDRESS_WIDTH+MAX_CLAUSE_MEMBERSHIP)-1:0] att_load_data,
  
    input  wire ct_load_valid,
    input  wire [VARIABLE_ADDRESS_WIDTH-1:0] ct_load_addr,
    input  wire [CT_WIDTH-1:0] ct_load_data,
  
    input  wire ucb_load_valid,
    input  wire [$clog2(UNSAT_CLAUSE_BUFFER_DEPTH)-1:0] ucb_load_addr,
    input  wire [NSAT*LITERAL_ADDRESS_WIDTH-1:0] ucb_load_data,
  
    input  wire [10:0] unsat_buffer_count,
  
    output reg cpu_done
  );
  
    // Overlord state machine: four states (idle, load, run, wait_done)
    localparam OV_IDLE      = 2'd0,
               OV_LOAD      = 2'd1,
               OV_RUN       = 2'd2,
               OV_WAIT_DONE = 2'd3;
               
    reg [1:0] ov_state, ov_next;
    reg [1:0] current_thread; // index 0..3
    reg [3:0] loaded_mask;    // one bit per thread
    
    // The start_run signal will be asserted (for one cycle) to all controllers simultaneously
    reg [3:0] ctrl_start_run;
    // Each Controller provides a done signal.
    wire [3:0] ctrl_done;
    
    // Because the CPU sends load data serially we “demux” the signals.
    // Only the controller corresponding to current_thread gets the CPU load data.
    // For instance, for controller i:
    wire att_valid[3:0];
    wire [LITERAL_ADDRESS_WIDTH:0] att_addr[3:0];
    wire [(VARIABLE_ADDRESS_WIDTH+MAX_CLAUSE_MEMBERSHIP)-1:0] att_data[3:0];
    
    wire ct_valid[3:0];
    wire [VARIABLE_ADDRESS_WIDTH-1:0] ct_addr[3:0];
    wire [CT_WIDTH-1:0] ct_data[3:0];
    
    wire ucb_valid[3:0];
    wire [$clog2(UNSAT_CLAUSE_BUFFER_DEPTH)-1:0] ucb_addr[3:0];
    wire [NSAT*LITERAL_ADDRESS_WIDTH-1:0] ucb_data[3:0];
    
    genvar i;
    generate
      for(i = 0; i < 4; i = i + 1) begin : load_mux
        assign att_valid[i] = (current_thread == i) ? att_load_valid : 1'b0;
        assign att_addr[i]  = (current_thread == i) ? att_load_addr  : {LITERAL_ADDRESS_WIDTH+1{1'b0}};
        assign att_data[i]  = (current_thread == i) ? att_load_data  : {(VARIABLE_ADDRESS_WIDTH+MAX_CLAUSE_MEMBERSHIP){1'b0}};
        
        assign ct_valid[i] = (current_thread == i) ? ct_load_valid : 1'b0;
        assign ct_addr[i]  = (current_thread == i) ? ct_load_addr  : {VARIABLE_ADDRESS_WIDTH{1'b0}};
        assign ct_data[i]  = (current_thread == i) ? ct_load_data  : {CT_WIDTH{1'b0}};
        
        assign ucb_valid[i] = (current_thread == i) ? ucb_load_valid : 1'b0;
        assign ucb_addr[i]  = (current_thread == i) ? ucb_load_addr  : {$clog2(UNSAT_CLAUSE_BUFFER_DEPTH){1'b0}};
        assign ucb_data[i]  = (current_thread == i) ? ucb_load_data  : {NSAT*LITERAL_ADDRESS_WIDTH{1'b0}};
      end
    endgenerate
    
    // Overlord state machine sequential logic
    always @(posedge clk or posedge rst) begin
      if(rst) begin
        ov_state       <= OV_IDLE;
        current_thread <= 2'd0;
        loaded_mask    <= 4'b0;
        cpu_done       <= 1'b0;
      end else begin
        ov_state <= ov_next;
        // When load_end is received, mark the current thread as loaded
        if(ov_state==OV_LOAD && load_end) begin
           loaded_mask[current_thread] <= 1'b1;
           if(current_thread != 2'd3)
             current_thread <= current_thread + 1;
        end
        if(ov_state==OV_IDLE) begin
           loaded_mask    <= 4'b0;
           current_thread <= 2'd0;
           cpu_done       <= 1'b0;
        end
      end
    end
    
    // Overlord state machine combinational logic
    always @(*) begin
      ov_next = ov_state;
      ctrl_start_run = 4'b0;
      case(ov_state)
        OV_IDLE: begin
          if(cpu_start)
            ov_next = OV_LOAD;
        end
        OV_LOAD: begin
          if(loaded_mask == 4'b1111)
            ov_next = OV_RUN;
          else
            ov_next = OV_LOAD;
        end
        OV_RUN: begin
          // Assert start_run for all controllers for one cycle.
          ctrl_start_run = 4'b1111;
          ov_next = OV_WAIT_DONE;
        end
        OV_WAIT_DONE: begin
          if(ctrl_done == 4'b1111)
            ov_next = OV_IDLE;
          else
            ov_next = OV_WAIT_DONE;
        end
        default: ov_next = OV_IDLE;
      endcase
    end
    
   // Declare a wire array to capture the load_done signals from each Controller.
    wire [3:0] ctrl_load_done;
  
    generate
      for(i = 0; i < 4; i = i + 1) begin : controllers
        Controller #(
           .NSAT(NSAT),
           .NUM_VARIABLES(NUM_VARIABLES),
           .MAX_CLAUSE_MEMBERSHIP(MAX_CLAUSE_MEMBERSHIP),
           .FIFO_DEPTH(FIFO_DEPTH),
           .UNSAT_CLAUSE_BUFFER_DEPTH(UNSAT_CLAUSE_BUFFER_DEPTH),
           .CONTROLLER_SIGNAL_WIDTH(CONTROLLER_SIGNAL_WIDTH),
           .MAX_FLIPS(MAX_FLIPS)
        ) ctrl_inst (
           .clk(clk),
           .rst(rst),
           .start((current_thread == i) ? cpu_start : 1'b0),
           .start_run(ctrl_start_run[i]),
           .att_load_addr_i(att_addr[i]),
           .att_load_data_i(att_data[i]),
           .att_load_valid_i(att_valid[i]),
           .ct_load_addr_i(ct_addr[i]),
           .ct_load_data_i(ct_data[i]),
           .ct_load_valid_i(ct_valid[i]),
           .ucb_load_addr_i(ucb_addr[i]),
           .ucb_load_data_i(ucb_data[i]),
           .ucb_load_valid_i(ucb_valid[i]),
           .unsat_buffer_count_i(unsat_buffer_count),
           .control_signal_o(),  // Unused here.
           .att_wr_en_o(),
           .att_wr_addr_o(),
           .att_wr_data_o(),
           .ct_wr_en_o(),
           .ct_wr_addr_o(),
           .ct_wr_data_o(),
           .ucb_setup_wr_en_o(),
           .ucb_setup_addr_o(),
           .ucb_setup_data_o(),
           .ucb_setup_o(),
           .done(ctrl_done[i]),
           .load_done(ctrl_load_done[i])  // New connection.
        );
      end
    endgenerate
  
    // Once all controllers are done, signal cpu_done
    always @(posedge clk or posedge rst) begin
      if(rst)
         cpu_done <= 1'b0;
      else if(ov_state == OV_WAIT_DONE && (ctrl_done == 4'b1111))
         cpu_done <= 1'b1;
    end
  
endmodule  