`timescale 1ns/1ps

module december_top_file_tb;

    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in ns
    parameter NSAT = 3;
    parameter NUM_VARIABLES = 2048;
    parameter MAX_CLAUSE_MEMBERSHIP = 20;
    parameter FIFO_DEPTH = 32;
    parameter UNSAT_CLAUSE_BUFFER_DEPTH = 2048;
    parameter CONTROLLER_SIGNAL_WIDTH = 14;

    // Signals
    reg clk_i;
    reg rst_i;
    reg [CONTROLLER_SIGNAL_WIDTH-1:0] control_signal_i;

    // Counters for passed and failed tests
    integer passed_tests = 0;
    integer failed_tests = 0;

    // Instantiate the DUT
    december_top_file #(
        .NSAT(NSAT),
        .NUM_VARIABLES(NUM_VARIABLES),
        .MAX_CLAUSE_MEMBERSHIP(MAX_CLAUSE_MEMBERSHIP),
        .FIFO_DEPTH(FIFO_DEPTH),
        .UNSAT_CLAUSE_BUFFER_DEPTH(UNSAT_CLAUSE_BUFFER_DEPTH),
        .CONTROLLER_SIGNAL_WIDTH(CONTROLLER_SIGNAL_WIDTH)
    ) 
    
    dut (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .control_signal_i(control_signal_i)
    );

    // Clock generation
    always #(CLK_PERIOD/2) clk_i = ~clk_i;

    // Test stimulus
    initial begin
        // Initialize signals
        clk_i = 0;
        rst_i = 1;
        control_signal_i = 0;

        // Reset test
        reset_test();

        // Basic control signal test
        basic_control_signal_test();

        // End simulation
        #(CLK_PERIOD*10);
        $display("Passed tests: %0d, Failed tests: %0d", passed_tests, failed_tests);
        $finish;
    end

    // Task for reset test
    task reset_test();
    begin
        $display("Starting reset test");
        rst_i = 1;
        control_signal_i = 0;
        #(CLK_PERIOD*2);
        rst_i = 0;
        #(CLK_PERIOD);
        if (dut.clause_register.data_o == 0) begin
            $display("Reset test passed: Clause register cleared");
            passed_tests = passed_tests + 1;
        end else begin
            $display("Reset test failed: Clause register not cleared");
            failed_tests = failed_tests + 1;
        end
    end
    endtask

    // Task for basic control signal test
    task basic_control_signal_test();
    begin
        $display("Starting basic control signal test");
        control_signal_i = 14'b10_00_1_1_1_00_1_00_1_1;
        #(CLK_PERIOD);
        if (dut.cr_wr_en == 1 && dut.vt_en == 1 && dut.vt_wr_en == 1) begin
            $display("Basic control signal test passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("Basic control signal test failed");
            $display("Expected: cr_wr_en=1, vt_en=1, vt_wr_en=1");
            $display("Actual: cr_wr_en=%b, vt_en=%b, vt_wr_en=%b", dut.cr_wr_en, dut.vt_en, dut.vt_wr_en);
            failed_tests = failed_tests + 1;
        end
    end
    endtask

    // Dump waves
    initial begin
        $dumpfile("testbench.vcd");
        $dumpvars(0, testbench);
    end

endmodule