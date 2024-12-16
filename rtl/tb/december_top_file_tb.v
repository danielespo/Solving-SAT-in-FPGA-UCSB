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
    localparam VARIABLE_ADDRESS_WIDTH = $clog2(NUM_VARIABLES);
    localparam LITERAL_ADDRESS_WIDTH  = VARIABLE_ADDRESS_WIDTH + 1;

    // Signals
    reg clk_i;
    reg rst_i;
    reg start_i;
    wire [CONTROLLER_SIGNAL_WIDTH-1:0] control_signal_i;
    wire done_signal;

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
        .start_i(start_i),
        .control_signal_i(control_signal_i),
        .done_signal(done_signal)
    );

    // Hard-coded AXI signals
    assign dut.address_translation_table.axi_wr_en_i = 1'b0;
    assign dut.address_translation_table.axi_wr_addr_i = {LITERAL_ADDRESS_WIDTH{1'b0}};
    assign dut.address_translation_table.axi_wr_data_i = {MAX_CLAUSE_MEMBERSHIP{1'b0}};

    assign dut.clause_table.axi_wr_en_i = 1'b0;
    assign dut.clause_table.axi_wr_addr_i = {VARIABLE_ADDRESS_WIDTH{1'b0}};
    assign dut.clause_table.axi_wr_clauses_i = {(NSAT-1)*MAX_CLAUSE_MEMBERSHIP*LITERAL_ADDRESS_WIDTH{1'b0}};

    assign dut.variable_table_cluster.axi_en_i = 1'b0;
    assign dut.variable_table_cluster.axi_wr_en_i = 1'b0;
    assign dut.variable_table_cluster.axi_addr_i = {VARIABLE_ADDRESS_WIDTH{1'b0}};
    assign dut.variable_table_cluster.axi_data_i = 1'b0;

    assign dut.variable_table_cluster_2.axi_en_i = 1'b0;
    assign dut.variable_table_cluster_2.axi_wr_en_i = 1'b0;
    assign dut.variable_table_cluster_2.axi_addr_i = {VARIABLE_ADDRESS_WIDTH{1'b0}};
    assign dut.variable_table_cluster_2.axi_data_i = 1'b0;

    assign dut.unsat_clause_selector.setup_i = 1'b0;
    assign dut.unsat_clause_selector.ucb_setup_wr_en_i = 1'b0;
    assign dut.unsat_clause_selector.ucb_setup_addr_i = {$clog2(UNSAT_CLAUSE_BUFFER_DEPTH){1'b0}};
    assign dut.unsat_clause_selector.ucb_setup_data_i = {NSAT*LITERAL_ADDRESS_WIDTH{1'b0}};
    assign dut.unsat_clause_selector.clear_debug_DIV_BY_ZERO_i = 1'b0;

    // Instantiate the controller
    top_file_controller #(
        .NSAT(NSAT),
        .NUM_VARIABLES(NUM_VARIABLES),
        .MAX_CLAUSE_MEMBERSHIP(MAX_CLAUSE_MEMBERSHIP),
        .FIFO_DEPTH(FIFO_DEPTH),
        .UNSAT_CLAUSE_BUFFER_DEPTH(UNSAT_CLAUSE_BUFFER_DEPTH),
        .CONTROLLER_SIGNAL_WIDTH(CONTROLLER_SIGNAL_WIDTH)
    ) 
    controller (
        .clk(clk_i),
        .rst(rst_i),
        .start(start_i),
        .done(done_signal),
        .control_signal_o(control_signal_i)
    );

    // Clock generation
    always #(CLK_PERIOD/2) clk_i = ~clk_i;

    // Test stimulus
    initial begin
        // Initialize signals
        clk_i = 0;
        rst_i = 1;
        start_i = 0;

        // Reset test
        reset_test();

        // Test cases
        test_idle_to_load();
        test_load_to_select_unsat_clauses();
        test_select_unsat_clauses();
        test_read_clause_table();
        test_read_variable_table();
        test_evaluate_clause();
        test_count_unsat_clauses();
        test_gather_unsat_clauses();
        test_select_unsat_clauses_again();
        test_done_state();
        test_full_cycle();
        test_multiple_cycles();
        test_reset_during_operation();
        test_start_signal_timing();
        test_clause_register_operation();
        test_address_translation_table();
        test_clause_table_operation();
        test_variable_table_cluster();
        test_temporal_buffer_wrapper();
        test_xor_prng();
        test_clause_evaluator_cluster();
        test_variable_flip_selector();
        test_fifo_tree();
        test_unsat_clause_selector();
        test_controller_state_transitions();
        test_control_signal_propagation();
        test_done_signal_assertion();
        test_start_signal_debounce();
        test_reset_signal_priority();

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
        start_i = 0;
        #(CLK_PERIOD*2);
        rst_i = 0;
        #(CLK_PERIOD);
        if (dut.controller_inst.state == 4'd0 && control_signal_i == 0) begin
            $display("Reset test passed: Controller in IDLE state and control signals cleared");
            passed_tests = passed_tests + 1;
        end else begin
            $display("Reset test failed: Controller not in IDLE state or control signals not cleared");
            failed_tests = failed_tests + 1;
        end
    end
    endtask

    // Test case: IDLE to LOAD transition
    task test_idle_to_load();
    begin
        $display("Testing IDLE to LOAD transition");
        rst_i = 0;
        start_i = 1;
        #(CLK_PERIOD);
        start_i = 0;
        #(CLK_PERIOD);
        if (dut.controller_inst.state == 4'd1) begin
            $display("IDLE to LOAD transition test passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("IDLE to LOAD transition test failed");
            failed_tests = failed_tests + 1;
        end
    end
    endtask

    // Test case: LOAD to SELECT_UNSAT_CLAUSES transition
    task test_load_to_select_unsat_clauses();
    begin
        $display("Testing LOAD to SELECT_UNSAT_CLAUSES transition");
        #(CLK_PERIOD);
        if (dut.controller_inst.state == 4'd2) begin
            $display("LOAD to SELECT_UNSAT_CLAUSES transition test passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("LOAD to SELECT_UNSAT_CLAUSES transition test failed");
            failed_tests = failed_tests + 1;
        end
    end
    endtask

    // Test case: SELECT_UNSAT_CLAUSES state
    task test_select_unsat_clauses();
    begin
        $display("Testing SELECT_UNSAT_CLAUSES state");
        #(CLK_PERIOD);
        if (control_signal_i[13] == 1'b1 && control_signal_i[0] == 1'b1) begin
            $display("SELECT_UNSAT_CLAUSES state test passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("SELECT_UNSAT_CLAUSES state test failed");
            failed_tests = failed_tests + 1;
        end
    end
    endtask

    // Test case: READ_CLAUSE_TABLE state
    task test_read_clause_table();
    begin
        $display("Testing READ_CLAUSE_TABLE state");
        #(CLK_PERIOD);
        if (dut.controller_inst.state == 4'd3 && control_signal_i[12:11] == 2'b00 && control_signal_i[4:3] == 2'b00) begin
            $display("READ_CLAUSE_TABLE state test passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("READ_CLAUSE_TABLE state test failed");
            failed_tests = failed_tests + 1;
        end
    end
    endtask

    // Test case: READ_VARIABLE_TABLE state
    task test_read_variable_table();
    begin
        $display("Testing READ_VARIABLE_TABLE state");
        #(CLK_PERIOD);
        if (dut.controller_inst.state == 4'd4 && control_signal_i[9] == 1'b1 && control_signal_i[8] == 1'b0 && control_signal_i[10] == 1'b0 && control_signal_i[4:3] == 2'b01) begin
            $display("READ_VARIABLE_TABLE state test passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("READ_VARIABLE_TABLE state test failed");
            failed_tests = failed_tests + 1;
        end
    end
    endtask

    // Test case: EVALUATE_CLAUSE state
    task test_evaluate_clause();
    begin
        $display("Testing EVALUATE_CLAUSE state");
        #(CLK_PERIOD);
        if (dut.controller_inst.state == 4'd5 && control_signal_i[7:6] == 2'b01 && control_signal_i[5] == 1'b1 && control_signal_i[4:3] == 2'b10) begin
            $display("EVALUATE_CLAUSE state test passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("EVALUATE_CLAUSE state test failed");
            failed_tests = failed_tests + 1;
        end
    end
    endtask

    // Test case: COUNT_UNSAT_CLAUSES state
    task test_count_unsat_clauses();
    begin
        $display("Testing COUNT_UNSAT_CLAUSES state");
        #(CLK_PERIOD);
        if (dut.controller_inst.state == 4'd6 && control_signal_i[7:6] == 2'b00) begin
            $display("COUNT_UNSAT_CLAUSES state test passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("COUNT_UNSAT_CLAUSES state test failed");
            failed_tests = failed_tests + 1;
        end
    end
    endtask

    // Test case: GATHER_UNSAT_CLAUSES state
    task test_gather_unsat_clauses();
    begin
        $display("Testing GATHER_UNSAT_CLAUSES state");
        #(CLK_PERIOD);
        if (dut.controller_inst.state == 4'd7 && control_signal_i[2] == 1'b1) begin
            $display("GATHER_UNSAT_CLAUSES state test passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("GATHER_UNSAT_CLAUSES state test failed");
            failed_tests = failed_tests + 1;
        end
    end
    endtask

    // Test case: SELECT_UNSAT_CLAUSES_AGAIN state
    task test_select_unsat_clauses_again();
    begin
        $display("Testing SELECT_UNSAT_CLAUSES_AGAIN state");
        #(CLK_PERIOD);
        if (dut.controller_inst.state == 4'd8 && control_signal_i[1] == 1'b1) begin
            $display("SELECT_UNSAT_CLAUSES_AGAIN state test passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("SELECT_UNSAT_CLAUSES_AGAIN state test failed");
            failed_tests = failed_tests + 1;
        end
    end
    endtask

    // Test case: DONE state
    task test_done_state();
    begin
        $display("Testing DONE state");
        #(CLK_PERIOD);
        if (dut.controller_inst.state == 4'd9 && done_signal == 1'b1 && control_signal_i == 0) begin
            $display("DONE state test passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("DONE state test failed");
            failed_tests = failed_tests + 1;
        end
    end
    endtask

    // Test case: Full cycle
    task test_full_cycle();
    begin
        $display("Testing full cycle");
        rst_i = 1;
        #(CLK_PERIOD);
        rst_i = 0;
        start_i = 1;
        #(CLK_PERIOD);
        start_i = 0;
        #(CLK_PERIOD * 10);
        if (done_signal == 1'b1) begin
            $display("Full cycle test passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("Full cycle test failed");
            failed_tests = failed_tests + 1;
        end
    end
    endtask

    // Test case: Multiple cycles
    task test_multiple_cycles();
    begin
        $display("Testing multiple cycles");
        repeat (3) begin
            rst_i = 1;
            #(CLK_PERIOD);
            rst_i = 0;
            start_i = 1;
            #(CLK_PERIOD);
            start_i = 0;
            wait(done_signal == 1'b1);
            #(CLK_PERIOD);
        end
        $display("Multiple cycles test passed");
        passed_tests = passed_tests + 1;
    end
    endtask

    // Test case: Reset during operation
    task test_reset_during_operation();
    begin
        $display("Testing reset during operation");
        rst_i = 0;
        start_i = 1;
        #(CLK_PERIOD);
        start_i = 0;
        #(CLK_PERIOD * 5);
        rst_i = 1;
        #(CLK_PERIOD);
        rst_i = 0;
        if (dut.controller_inst.state == 4'd0 && control_signal_i == 0) begin
            $display("Reset during operation test passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("Reset during operation test failed");
            failed_tests = failed_tests + 1;
        end
    end
    endtask

    // Test case: Start signal timing
    task test_start_signal_timing();
    begin
        $display("Testing start signal timing");
        rst_i = 0;
        start_i = 1;
        #(CLK_PERIOD/2);
        start_i = 0;
        #(CLK_PERIOD/2);
        if (dut.controller_inst.state == 4'd1) begin
            $display("Start signal timing test passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("Start signal timing test failed");
            failed_tests = failed_tests + 1;
        end
    end
    endtask

    // Test case: Clause Register operation
    task test_clause_register_operation();
    begin
        $display("Testing Clause Register operation");
        rst_i = 0;
        start_i = 1;
        #(CLK_PERIOD);
        start_i = 0;
        #(CLK_PERIOD * 3);
        // Example check for clause_register writes
        if (dut.clause_register.wr_en_i == 1'b1) begin
            $display("Clause Register operation test passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("Clause Register operation test failed");
            failed_tests = failed_tests + 1;
        end
    end
    endtask

    // Test case: Address Translation Table
    task test_address_translation_table();
    begin
        $display("Testing Address Translation Table");
        rst_i = 0;
        start_i = 1;
        #(CLK_PERIOD);
        start_i = 0;
        #(CLK_PERIOD * 4);
        // Use the LITERAL_ADDRESS_WIDTH from the localparam in testbench
        if (dut.address_translation_table.rd_addr_i !== {LITERAL_ADDRESS_WIDTH{1'bx}}) begin
            $display("Address Translation Table test passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("Address Translation Table test failed");
            failed_tests = failed_tests + 1;
        end
    end
    endtask

    // Test case: Clause Table operation
    task test_clause_table_operation();
    begin
        $display("Testing Clause Table operation");
        rst_i = 0;
        start_i = 1;
        #(CLK_PERIOD);
        start_i = 0;
        #(CLK_PERIOD * 5);
        if (dut.clause_table.rd_addr_i === dut.att_addr_out) begin
            $display("Clause Table operation test passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("Clause Table operation test failed");
            failed_tests = failed_tests + 1;
        end
    end
    endtask

    // Test case: Variable Table Cluster operation
    task test_variable_table_cluster();
    begin
        $display("Testing Variable Table Cluster operation");
        rst_i = 0;
        start_i = 1;
        #(CLK_PERIOD);
        start_i = 0;
        #(CLK_PERIOD * 6);
        if (dut.variable_table_cluster.en_i === 1'b1 && dut.variable_table_cluster.wr_en_i === 1'b0) begin
            $display("Variable Table Cluster operation test passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("Variable Table Cluster operation test failed");
            failed_tests = failed_tests + 1;
        end
    end
    endtask

    // Test case: Temporal Buffer Wrapper operation
    task test_temporal_buffer_wrapper();
    begin
        $display("Testing Temporal Buffer Wrapper operation");
        rst_i = 0;
        start_i = 1;
        #(CLK_PERIOD);
        start_i = 0;
        #(CLK_PERIOD * 7);
        if (dut.temporal_buffer_wrapper.wr_en_i === 1'b1) begin
            $display("Temporal Buffer Wrapper operation test passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("Temporal Buffer Wrapper operation test failed");
            failed_tests = failed_tests + 1;
        end
    end
    endtask

    // Test case: XOR PRNG operation
    task test_xor_prng();
    reg [31:0] first_value;  // Declare up front (no inline assignment)
    begin
        $display("Testing XOR PRNG operation");
        rst_i = 0;
        start_i = 1;
        #(CLK_PERIOD);
        start_i = 0;
        #(CLK_PERIOD * 2);

        // Separate assignment
        first_value = dut.prng.data_o;  

        #(CLK_PERIOD * 10);
        if (dut.prng.data_o !== first_value) begin
            $display("XOR PRNG operation test passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("XOR PRNG operation test failed");
            failed_tests = failed_tests + 1;
        end
    end
    endtask

    // Test case: Clause Evaluator Cluster operation
    task test_clause_evaluator_cluster();
    begin
        $display("Testing Clause Evaluator Cluster operation");
        rst_i = 0;
        start_i = 1;
        #(CLK_PERIOD);
        start_i = 0;
        #(CLK_PERIOD * 8);
        if (dut.clause_evaluator_cluster.var_val_mi === dut.vtc_value_bits &&
            dut.clause_evaluator_cluster.var_neg_mi === dut.nb_negation_bits) begin
            $display("Clause Evaluator Cluster operation test passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("Clause Evaluator Cluster operation test failed");
            failed_tests = failed_tests + 1;
        end
    end
    endtask

    // Test case: Variable Flip Selector operation
    task test_variable_flip_selector();
    begin
        $display("Testing Variable Flip Selector operation");
        rst_i = 0;
        start_i = 1;
        #(CLK_PERIOD);
        start_i = 0;
        #(CLK_PERIOD * 9);
        if (dut.variable_flip_selector.wr_en_i === control_signal_i[7:6]) begin
            $display("Variable Flip Selector operation test passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("Variable Flip Selector operation test failed");
            failed_tests = failed_tests + 1;
        end
    end
    endtask

    // Test case: FIFO Tree operation
    task test_fifo_tree();
    begin
        $display("Testing FIFO Tree operation");
        rst_i = 0;
        start_i = 1;
        #(CLK_PERIOD);
        start_i = 0;
        #(CLK_PERIOD * 10);
        if (dut.fifo_tree.wr_en_i === control_signal_i[2] &&
            dut.fifo_tree.rd_en_i === control_signal_i[1]) begin
            $display("FIFO Tree operation test passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("FIFO Tree operation test failed");
            failed_tests = failed_tests + 1;
        end
    end
    endtask

    // Test case: Unsat Clause Selector operation
    task test_unsat_clause_selector();
    begin
        $display("Testing Unsat Clause Selector operation");
        rst_i = 0;
        start_i = 1;
        #(CLK_PERIOD);
        start_i = 0;
        #(CLK_PERIOD * 11);
        if (dut.unsat_clause_selector.request_i === control_signal_i[0]) begin
            $display("Unsat Clause Selector operation test passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("Unsat Clause Selector operation test failed");
            failed_tests = failed_tests + 1;
        end
    end
    endtask

    // Test case: Controller state transitions
    task test_controller_state_transitions();
    begin
        $display("Testing Controller state transitions");
        rst_i = 0;
        start_i = 1;
        #(CLK_PERIOD);
        start_i = 0;
        #(CLK_PERIOD * 12);
        if (dut.controller_inst.state !== dut.controller_inst.IDLE &&
            dut.controller_inst.state !== dut.controller_inst.DONE) begin
            $display("Controller state transitions test passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("Controller state transitions test failed");
            failed_tests = failed_tests + 1;
        end
    end
    endtask

    // Test case: Control signal propagation
    task test_control_signal_propagation();
    begin
        $display("Testing Control signal propagation");
        rst_i = 0;
        start_i = 1;
        #(CLK_PERIOD);
        start_i = 0;
        #(CLK_PERIOD * 13);
        if (dut.control_signal_i === control_signal_i) begin
            $display("Control signal propagation test passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("Control signal propagation test failed");
            failed_tests = failed_tests + 1;
        end
    end
    endtask

    // Test case: Done signal assertion
    task test_done_signal_assertion();
    begin
        $display("Testing Done signal assertion");
        rst_i = 0;
        start_i = 1;
        #(CLK_PERIOD);
        start_i = 0;
        wait(done_signal === 1'b1);
        #(CLK_PERIOD);
        if (dut.controller_inst.state === dut.controller_inst.DONE) begin
            $display("Done signal assertion test passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("Done signal assertion test failed");
            failed_tests = failed_tests + 1;
        end
    end
    endtask

    // Test case: Start signal debounce
    task test_start_signal_debounce();
    begin
        $display("Testing Start signal debounce");
        rst_i = 0;
        start_i = 1;
        #(CLK_PERIOD/4);
        start_i = 0;
        #(CLK_PERIOD/4);
        start_i = 1;
        #(CLK_PERIOD/4);
        start_i = 0;
        #(CLK_PERIOD/4);
        if (dut.controller_inst.state === dut.controller_inst.LOAD) begin
            $display("Start signal debounce test passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("Start signal debounce test failed");
            failed_tests = failed_tests + 1;
        end
    end
    endtask

    // Test case: Reset signal priority
    task test_reset_signal_priority();
    begin
        $display("Testing Reset signal priority");
        rst_i = 0;
        start_i = 1;
        #(CLK_PERIOD/2);
        rst_i = 1;
        #(CLK_PERIOD/2);
        if (dut.controller_inst.state === dut.controller_inst.IDLE) begin
            $display("Reset signal priority test passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("Reset signal priority test failed");
            failed_tests = failed_tests + 1;
        end
    end
    endtask

    initial begin
        $dumpfile("december_top_file_tb.vcd");
        $dumpvars(0, december_top_file_tb);
    end

endmodule