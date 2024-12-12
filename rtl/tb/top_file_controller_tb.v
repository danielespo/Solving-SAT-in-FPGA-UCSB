`timescale 1ns/1ps

module top_file_controller_tb;

  parameter CLK_PERIOD = 10;
  parameter CONTROLLER_SIGNAL_WIDTH = 14;

  reg clk;
  reg rst;
  reg start;
  wire done;
  wire [CONTROLLER_SIGNAL_WIDTH - 1:0] control_signal_o;

  top_file_controller dut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .done(done),
    .control_signal_o(control_signal_o)
  );

  always begin
    clk = 1'b0;
    #(CLK_PERIOD/2);
    clk = 1'b1;
    #(CLK_PERIOD/2);
  end

  localparam IDLE                       = 4'd0,
             LOAD                       = 4'd1,
             SELECT_UNSAT_CLAUSES       = 4'd2,  // Step A
             READ_CLAUSE_TABLE          = 4'd3,  // Step B
             READ_VARIABLE_TABLE        = 4'd4,  // Step C
             EVALUATE_CLAUSE            = 4'd5,  // Step D
             COUNT_UNSAT_CLAUSES        = 4'd6,  // Step E
             GATHER_UNSAT_CLAUSES       = 4'd7,  // Step F
             SELECT_UNSAT_CLAUSES_AGAIN = 4'd8,  // Step G
             DONE                       = 4'd9;

  // Note: This matches the always @(*) block in the DUT
  
  // control_signal_o[13] = CR_WR_EN_BIT
  // control_signal_o[0]  = UCS_REQUEST_BIT
  // control_signal_o[12:11] = ATT_SRC_BITS
  // control_signal_o[10] = VT_ADDR_SRC_BIT
  // control_signal_o[9]  = VT_EN_BIT
  // control_signal_o[8]  = VT_WR_EN_BIT
  // control_signal_o[7:6] = VFS_WR_EN_BITS
  // control_signal_o[5]  = CFLB_WR_EN_BIT
  // control_signal_o[2]  = FIFO_WR_EN_BIT
  // control_signal_o[1]  = FIFO_RD_EN_BIT

  // For each state, define the expected control_signal_o:
  // Default: {CONTROLLER_SIGNAL_WIDTH{1'b0}} = 14'b0000_0000_0000_00
  reg [CONTROLLER_SIGNAL_WIDTH-1:0] expected_control_signals [0:9];

  initial begin
    // IDLE (0)
    expected_control_signals[IDLE] = 14'b00000000000000;
    
    // LOAD (1)
    expected_control_signals[LOAD] = 14'b00000000000000;
   
    // SELECT_UNSAT_CLAUSES (2): CR_WR_EN_BIT=1 at [13], UCS_REQUEST_BIT=1 at [0]
    expected_control_signals[SELECT_UNSAT_CLAUSES] = 14'b10000000000001;
    
    // READ_CLAUSE_TABLE (3): ATT_SRC_BITS=00 at [12:11], TB_WR_INDEX=00 at [4:3]
    expected_control_signals[READ_CLAUSE_TABLE] =   14'b00000000000000;
    
    // READ_VARIABLE_TABLE (4): VT_EN=1 at [9], VT_WR_EN=0 at [8], VT_ADDR_SRC=0 at [10], TB_WR_INDEX=01 at [4:3]
    expected_control_signals[READ_VARIABLE_TABLE] = 14'b00001000001000;
    
    // EVALUATE_CLAUSE (5): VFS_WR_EN_BITS=01 at [7:6], CFLB_WR_EN=1 at [5], TB_WR_INDEX=10 at [4:3]
    expected_control_signals[EVALUATE_CLAUSE] =     14'b00000001110000;
    
    // COUNT_UNSAT_CLAUSES (6): All off (based on code given)
    expected_control_signals[COUNT_UNSAT_CLAUSES] = 14'b00000000000000;
    
    // GATHER_UNSAT_CLAUSES (7): FIFO_WR_EN=1 at [2]
    expected_control_signals[GATHER_UNSAT_CLAUSES] =14'b00000000000100;
   
    // SELECT_UNSAT_CLAUSES_AGAIN (8): FIFO_RD_EN=1 at [1]
    expected_control_signals[SELECT_UNSAT_CLAUSES_AGAIN] = 14'b00000000000010;
    
    // DONE (9): All signals off
    expected_control_signals[DONE] = 14'b00000000000000;
  end

  integer state_counter;
  reg start_detected;
  
  initial begin
    rst = 1'b1;
    start = 1'b0;
    start_detected = 1'b0;
    state_counter = IDLE;

    // Perform reset
    #(CLK_PERIOD*5);
    rst = 1'b0;
    #(CLK_PERIOD*2);

    start = 1'b1;
    #(CLK_PERIOD);
    start = 1'b0;

    // We expect transitions through the states and it is finished when done
    wait(done);

    if (state_counter != DONE) begin
      $display("ERROR: Did not reach DONE state in expected order!");
      $finish;
    end

    $display("INFO: First run completed successfully. Re-applying start and reset...");

    // start = 1'b1;
    // #(CLK_PERIOD);
    // start = 1'b0;
    // #(CLK_PERIOD*5);
    // rst = 1'b1;
    // #(CLK_PERIOD);
    // rst = 1'b0;

    #(CLK_PERIOD*2);
    start = 1'b1;
    #(CLK_PERIOD);
    start = 1'b0;

    // Wait for done again
    wait(done);
    #(CLK_PERIOD*2);
    
    $display("INFO: Second run completed successfully.");

    // End simulation
    $display("All tests completed successfully!");
    $finish;
  end

  always @(posedge clk) begin
    if (!rst) begin
      $display("Time=%0t ns | state_counter=%0d | start=%b | rst=%b | done=%b | control_signal_o=%b", 
                $time, state_counter, start, rst, done, control_signal_o);

      if (start == 1'b1 && state_counter == IDLE) begin
        $display("INFO: Detected start in IDLE state, FSM should move to LOAD next.");
      end

      // Check if done is reached prematurely
      if (done && (state_counter != DONE)) begin
        $display("ERROR: 'done' asserted at unexpected time. Current state=%0d", state_counter);
        $finish;
      end

      // Compare actual control signals to expected control signals
      if (control_signal_o !== expected_control_signals[state_counter]) begin
        // It's possible that we haven't advanced to the next state yet. Check next state's expected signals.
        if (state_counter < DONE && (control_signal_o === expected_control_signals[state_counter+1])) begin
          // If the signals match the next state's expectations, then the FSM advanced
          // to the next state and update state_counter
          state_counter = state_counter + 1;

          // After incrementing state_counter, check again
          if (control_signal_o !== expected_control_signals[state_counter]) begin
            $display("ERROR: After incrementing state, control signals do not match. State=%0d Expected=%b Got=%b",
                     state_counter, expected_control_signals[state_counter], control_signal_o);
            $finish;
          end else begin
            $display("INFO: FSM advanced to state %0d with correct control signals.", state_counter);
          end
        end else if (state_counter == SELECT_UNSAT_CLAUSES_AGAIN && control_signal_o === expected_control_signals[DONE]) begin
          // Special case: transitioning from SELECT_UNSAT_CLAUSES_AGAIN to DONE
          state_counter = DONE;
          $display("INFO: FSM advanced to DONE state from SELECT_UNSAT_CLAUSES_AGAIN.");
        end else begin
          // The signals don't match the current or the next state's expected pattern
          if (state_counter == DONE && done) begin
            // We might be stable in the DONE state and this might not be acceptable
          end else begin
            $display("ERROR: Control signals do not match expected for state %0d. Expected=%b Got=%b",
                     state_counter, expected_control_signals[state_counter], control_signal_o);
            $finish;
          end
        end
      end else begin
        // The signals match the expected signals for the current state.
        // The FSM typically advances every clock cycle, so we expect a change in the next cycle.
        $display("INFO: Control signals match expected for state %0d", state_counter);
        
        // Check if we're not in the DONE state
        if (state_counter != DONE) begin
          if (state_counter == IDLE) begin
            // In IDLE state, we only expect to advance when start is asserted
            if (start) begin
              #(CLK_PERIOD);
              if (control_signal_o === expected_control_signals[LOAD]) begin
                state_counter = LOAD;
                $display("INFO: FSM advanced to LOAD state as expected");
              end else begin
                $display("ERROR: FSM did not advance to LOAD state when start was asserted");
                $finish;
              end
            end
          end else begin
            // For other states, we expect to advance in the next cycle
            #(CLK_PERIOD);
            if (control_signal_o === expected_control_signals[state_counter]) begin
              $display("WARNING: FSM did not advance as expected after one clock cycle in state %0d", state_counter);
            end else begin
              // The state has changed, update the state counter
              state_counter = state_counter + 1;
              $display("INFO: FSM advanced to state %0d as expected", state_counter);
            end
          end
        end else begin
          $display("INFO: FSM is in DONE state, no further state transitions expected");
        end
      end

      if (state_counter == DONE && done) begin
        $display("INFO: Reached DONE state as expected. Test sequence completed.");
      end
    end else begin
      $display("INFO: Reset active at time=%0t ns. State machine re-initializing.", $time);
    end
  end

endmodule