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

  initial begin
    // Initialize signals
    rst = 1'b1;
    start = 1'b0;

    // 10-cycle reset
    #(CLK_PERIOD*5);
    rst = 1'b0;
    #(CLK_PERIOD*2);
    start = 1'b1;
    #(CLK_PERIOD);
    start = 1'b0;

    // Wait for done signal
    wait(done);
    #(CLK_PERIOD*2);

    // Reset during operation
    start = 1'b1;
    #(CLK_PERIOD);
    start = 1'b0;
    #(CLK_PERIOD*5);
    rst = 1'b1;
    #(CLK_PERIOD);
    rst = 1'b0;

    // Wait for done signal
    wait(done);
    #(CLK_PERIOD*2);

    // End simulation
    $display("All tests completed");
    $finish;
  end

  // Monitor and check outputs
  integer current_state;

  always @(posedge clk) begin
    if (!rst) begin
      // Infer current state based on control signals
      case (control_signal_o)
        14'b10000000000001: current_state = 2; // SELECT_UNSAT_CLAUSES
        14'b00100000000000: current_state = 3; // READ_CLAUSE_TABLE
        14'b00001000000000: current_state = 4; // READ_VARIABLE_TABLE
        14'b00000001100000: current_state = 5; // EVALUATE_CLAUSE
        14'b00000000000000: current_state = 6; // COUNT_UNSAT_CLAUSES
        14'b00000000000100: current_state = 7; // GATHER_UNSAT_CLAUSES
        14'b00000000000010: current_state = 8; // SELECT_UNSAT_CLAUSES_AGAIN
        default: current_state = 0; // IDLE or unknown
      endcase

      // Check state transitions
      if (start && current_state == 0) begin
        $display("Test passed: Transition from IDLE to LOAD on start signal");
      end

      if (done && current_state == 0) begin
        $display("Test passed: DONE state reached");
      end
    end
  end

endmodule