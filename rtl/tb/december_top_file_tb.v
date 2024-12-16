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
    localparam CLAUSE_WIDTH = NSAT * LITERAL_ADDRESS_WIDTH;

    // Signals
    reg clk_i;
    reg rst_i;
    reg start_i;
    reg [CONTROLLER_SIGNAL_WIDTH-1:0] control_signal_i; // Declare control_signal_i
    wire done_signal;

    // Hardcoded clauses
    reg [CLAUSE_WIDTH-1:0] hardcoded_clauses [2:0];

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
        .control_signal_i(control_signal_i), // Add this line
        .done_signal(done_signal)
    );

    // Clock generation
    always #(CLK_PERIOD/2) clk_i = ~clk_i;

    integer i;

    // Task to check if all clauses are satisfied
    task check_all_clauses_satisfaction;
        begin
            $display("Checking all clauses satisfaction...");
            $display("Variable Table Cluster data: %b", dut.vtc_value_bits);
            
            // Check each clause
            for (i = 0; i < 3; i = i + 1) begin
                $display("Checking clause %0d: (%b OR %b OR %b)",
                    i,
                    hardcoded_clauses[i][20:14],
                    hardcoded_clauses[i][13:7],
                    hardcoded_clauses[i][6:0]
                );
                
                if ((hardcoded_clauses[i][20] ^ dut.vtc_value_bits[hardcoded_clauses[i][19:14]]) |
                    (hardcoded_clauses[i][13] ^ dut.vtc_value_bits[hardcoded_clauses[i][12:7]]) |
                    (hardcoded_clauses[i][6] ^ dut.vtc_value_bits[hardcoded_clauses[i][5:0]])) begin
                    $display("Clause %0d is SATISFIED", i);
                end else begin
                    $display("Clause %0d is NOT SATISFIED", i);
                end
            end

            $display("Variable assignments: x1=%b, x2=%b, x3=%b, x4=%b", 
                     dut.vtc_value_bits[0],
                     dut.vtc_value_bits[1],
                     dut.vtc_value_bits[2],
                     dut.vtc_value_bits[3]);
        end
    endtask

    // Task to initialize the variable table
    task initialize_variable_table;
        integer i;
        begin
            // Enable writing to the variable table
            force dut.vt_en = 1'b1;
            force dut.vt_wr_en = 1'b1;
            force dut.vt_addr_src = 1'b0; // Use external addressing

            for (i = 0; i < NUM_VARIABLES; i = i + 1) begin
                force dut._vtc_address_m = i;
                force dut._vtc_data = 1'b0; // Initialize all variables to false
                #(CLK_PERIOD);
            end

            // Disable writing to the variable table
            force dut.vt_en = 1'b0;
            force dut.vt_wr_en = 1'b0;
        end
    endtask

    // Task to load clauses into the clause table
    task load_clauses;
        integer i;
        begin
            // Enable writing to the clause table
            force dut.clause_table.axi_wr_en_i = 1'b1;

            for (i = 0; i < 3; i = i + 1) begin
                force dut.clause_table.axi_wr_addr_i = i;
                force dut.clause_table.axi_wr_clauses_i = hardcoded_clauses[i];
                #(CLK_PERIOD);
            end

            // Disable writing to the clause table
            force dut.clause_table.axi_wr_en_i = 1'b0;
        end
    endtask

    // Test stimulus
    initial begin
        // Initialize signals
        clk_i = 0;
        rst_i = 1;
        start_i = 0;
        control_signal_i = 0;

        // Hardcode clauses (24 bits for 3-SAT with 7-bit literal addressing)
        // (x1 OR x2 OR NOT x3)
        hardcoded_clauses[0] = {7'b0000001, 7'b0000010, 7'b1000011};
        // (NOT x2 OR x3 OR x4)
        hardcoded_clauses[1] = {7'b0000100, 7'b0000011, 7'b1000010};
        // (x1 OR NOT x3 OR NOT x4)
        hardcoded_clauses[2] = {7'b1000100, 7'b1000011, 7'b0000001};
        
        $display("Hardcoded clauses:");
        $display("Clause 1: (x1 OR x2 OR NOT x3)");
        $display("Clause 2: (NOT x2 OR x3 OR x4)");
        $display("Clause 3: (x1 OR NOT x3 OR NOT x4)");

        // Reset
        #(CLK_PERIOD*2);
        rst_i = 0;
        #(CLK_PERIOD);
        $display("Reset complete");

        // Initialize variable table
        initialize_variable_table();
        $display("Variable table initialized");

        // Load clauses
        load_clauses();
        $display("Clauses loaded");

        // Start the solver
        start_i = 1;
        #(CLK_PERIOD);
        start_i = 0;
        $display("Solver started");

        // Generate some control signals
        repeat(100) begin
            #(CLK_PERIOD);
            control_signal_i = $random; // Generate random control signals
            $display("Time %t: control_signal_i = %b", $time, control_signal_i);
        end

        // Wait for done signal or timeout
        repeat(9900) begin
            #(CLK_PERIOD);
            if (done_signal) begin
                $display("Solver finished");
                check_all_clauses_satisfaction();
                #(CLK_PERIOD*10);
                $finish;
            end
        end

        // If we reach here, the solver has timed out
        $display("Solver timed out");
        check_all_clauses_satisfaction();
        #(CLK_PERIOD*10);
        $finish;
    end

    // Dump waveforms
    initial begin
        $dumpfile("december_top_file_tb.vcd");
        $dumpvars(0, december_top_file_tb);
    end

endmodule