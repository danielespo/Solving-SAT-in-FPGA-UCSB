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
    localparam CLAUSE_WIDTH = NSAT * 8; // 24 bits (3 * 8)

    // Signals
    reg clk_i;
    reg rst_i;
    reg start_i;
    wire [CONTROLLER_SIGNAL_WIDTH-1:0] control_signal_i;
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
        .control_signal_i(control_signal_i),
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
                    hardcoded_clauses[i][23:16],
                    hardcoded_clauses[i][15:8],
                    hardcoded_clauses[i][7:0]
                );
                
                if ((hardcoded_clauses[i][23] ^ dut.vtc_value_bits[hardcoded_clauses[i][22:16]]) |
                    (hardcoded_clauses[i][15] ^ dut.vtc_value_bits[hardcoded_clauses[i][14:8]]) |
                    (hardcoded_clauses[i][7] ^ dut.vtc_value_bits[hardcoded_clauses[i][6:0]])) begin
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
            force dut.vt_addr_src = 1'b0;

            for (i = 0; i < NUM_VARIABLES; i = i + 1) begin
                force dut._vtc_address_m = i[VARIABLE_ADDRESS_WIDTH-1:0];
                force dut._vtc_data = 1'b0;
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

    // Task to display solved clauses
    task display_solved_clauses;
        reg [NUM_VARIABLES-1:0] variable_assignments;
        reg [2:0] clause_results;

        reg literal_value;
        reg is_negated;
        reg [VARIABLE_ADDRESS_WIDTH-1:0] var_index;
        integer i, j;
        begin
            // Read variable assignments from the Variable Table Cluster
            for (i = 0; i < NUM_VARIABLES; i = i + 1) begin
                variable_assignments[i] = dut.vtc_value_bits[i];
            end

            $display("Final variable assignments:");
            for (i = 0; i < 10; i = i + 1) begin // Display first 10 variables
                $display("x%0d = %b", i+1, variable_assignments[i]);
            end

            // Evaluate each clause
            for (i = 0; i < 3; i = i + 1) begin
                clause_results[i] = 1'b0; // Initialize to false
                for (j = 0; j < NSAT; j = j + 1) begin
                    is_negated = hardcoded_clauses[i][j*8 + 7];
                    var_index = hardcoded_clauses[i][j*8 +: VARIABLE_ADDRESS_WIDTH];
                    literal_value = variable_assignments[var_index];

                    clause_results[i] = clause_results[i] | (literal_value ^ is_negated);
                end
            end

            // Display results
            $display("\nSolved clauses:");
            for (i = 0; i < 3; i = i + 1) begin
                $display("Clause %0d: (%s%0d OR %s%0d OR %s%0d) = %s",
                    i+1,
                    hardcoded_clauses[i][23] ? "NOT " : "", hardcoded_clauses[i][22:16] + 1,
                    hardcoded_clauses[i][15] ? "NOT " : "", hardcoded_clauses[i][14:8] + 1,
                    hardcoded_clauses[i][7]  ? "NOT " : "", hardcoded_clauses[i][6:0] + 1,
                    clause_results[i] ? "SATISFIED" : "NOT SATISFIED"
                );
            end

            $display("\nOverall result: %s", &clause_results ? "SAT" : "UNSAT");
        end
    endtask

    // Test stimulus
    initial begin
        // Initialize signals
        clk_i = 0;
        rst_i = 1;
        start_i = 0;

        // Hardcode clauses (24 bits for 3-SAT with 8-bit literal addressing)
        // (x5 OR NOT x2 OR x7)
        hardcoded_clauses[0] = {8'b00000101, 8'b10000010, 8'b00000111};
        // (NOT x1 OR x3 OR NOT x6)
        hardcoded_clauses[1] = {8'b10000110, 8'b00000011, 8'b10000001};
        // (x4 OR NOT x7 OR x2)
        hardcoded_clauses[2] = {8'b00000010, 8'b10000111, 8'b00000100};
        
        $display("Hardcoded clauses:");
        $display("Clause 1: (x5 OR NOT x2 OR x7)");
        $display("Clause 2: (NOT x1 OR x3 OR NOT x6)");
        $display("Clause 3: (x4 OR NOT x7 OR x2)");

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

        // Wait for done signal or timeout
        repeat(10000) begin
            #(CLK_PERIOD);
            if (done_signal) begin
                $display("Solver finished");
                display_solved_clauses();
                #(CLK_PERIOD*10);
                $finish;
            end
        end

        // If we reach here, the solver has timed out
        $display("Solver timed out");
        display_solved_clauses();
        #(CLK_PERIOD*10);
        $finish;
    end

    // // Monitor control signals
    // always @(posedge clk_i) begin
    //     $display("Time %t: control_signal_i = %b", $time, control_signal_i);
    // end

    // // Monitor state transitions
    // always @(posedge clk_i) begin
    //     case(dut.controller_inst.state)
    //         4'd0: $display("Time %t: State = IDLE", $time);
    //         4'd1: $display("Time %t: State = LOAD", $time);
    //         4'd2: $display("Time %t: State = SELECT_UNSAT_CLAUSES", $time);
    //         4'd3: $display("Time %t: State = READ_CLAUSE_TABLE", $time);
    //         4'd4: $display("Time %t: State = READ_VARIABLE_TABLE", $time);
    //         4'd5: $display("Time %t: State = EVALUATE_CLAUSE", $time);
    //         4'd6: $display("Time %t: State = COUNT_UNSAT_CLAUSES", $time);
    //         4'd7: $display("Time %t: State = GATHER_UNSAT_CLAUSES", $time);
    //         4'd8: $display("Time %t: State = SELECT_UNSAT_CLAUSES_AGAIN", $time);
    //         4'd9: $display("Time %t: State = DONE", $time);
    //         default: $display("Time %t: State = UNKNOWN", $time);
    //     endcase
    // end

    // // Monitor for Clause Register
    // always @(posedge clk_i) begin
    //     if (dut.cr_wr_en)
    //         $display("Time %t: Clause Register - Writing clause: %h", $time, dut.ucs_selected_clause);
    //     $display("Time %t: Clause Register - Current clause: %h", $time, dut.cr_selected_clause);
    // end

    // // Monitor for Address Translation Table
    // always @(posedge clk_i) begin
    //     $display("Time %t: ATT - Input address: %h, Output address: %h, Mask: %b", 
    //              $time, dut._cr_negated_literal, dut.att_addr_out, dut.att_mask_out);
    // end

    // // Monitor for Clause Table
    // always @(posedge clk_i) begin
    //     $display("Time %t: Clause Table - Reading clauses for address: %h", $time, dut.att_addr_out);
    //     $display("Time %t: Clause Table - Output clauses: %h", $time, dut.ct_clauses);
    // end

    // // Monitor for Variable Table Cluster
    // always @(posedge clk_i) begin
    //     if (dut.vt_wr_en)
    //         $display("Time %t: VTC - Writing data: %b to addresses: %h", $time, dut._vtc_data, dut._vtc_address_m);
    //     $display("Time %t: VTC - Reading values: %b", $time, dut.vtc_value_bits);
    // end

    // // Monitor for Temporal Buffer Wrapper
    // always @(posedge clk_i) begin
    //     if (~(&dut.tb_wr_index))
    //         $display("Time %t: TBW - Writing literals: %h, Index: %b", $time, dut.ct_clauses, dut.tb_wr_index);
    //     $display("Time %t: TBW - Reading literals: %h, Index: %b", $time, dut.tbw_literals_multi_out, dut.vfs_selected);
    // end

    // // Monitor for Clause Evaluator Cluster
    // always @(posedge clk_i) begin
    //     $display("Time %t: CEC - Input values: %b, Negations: %b", $time, dut.vtc_value_bits, dut.nb_negation_bits);
    //     $display("Time %t: CEC - Break bits: %b", $time, dut.ce1_break_bits);
    // end

    // // Monitor for Variable Flip Selector
    // always @(posedge clk_i) begin
    //     $display("Time %t: VFS - Break bits: %b, Mask: %b, Random: %h", 
    //              $time, dut.ce1_break_bits, dut.mb_mask_bits, dut.prng_random_number);
    //     $display("Time %t: VFS - Selected: %b, Valid bits: %b", $time, dut.vfs_selected, dut.vfs_clause_valid_bits);
    // end

    // // Monitor for FIFO Tree
    // always @(posedge clk_i) begin
    //     if (dut.fifo_wr_en)
    //         $display("Time %t: FIFO - Writing clauses: %h", $time, dut._broken_clauses);
    //     if (dut.fifo_rd_en)
    //         $display("Time %t: FIFO - Reading clause: %h", $time, dut.fifo_clause);
    //     $display("Time %t: FIFO - Empty: %b", $time, dut.fifo_empty);
    // end

    // // Monitor for Unsat Clause Selector
    // always @(posedge clk_i) begin
    //     if (dut.ucs_request)
    //         $display("Time %t: UCS - Requesting clause", $time);
    //     $display("Time %t: UCS - Selected clause: %h", $time, dut.ucs_selected_clause);
    // end

    // // Monitor for Controller
    // always @(posedge clk_i) begin
    //     $display("Time %t: Controller - State: %d, Control signals: %b", 
    //              $time, dut.controller_inst.state, dut.control_signal_i);
    // end

    // Dump waveforms
    initial begin
        $dumpfile("december_top_file_tb.vcd");
        $dumpvars(0, december_top_file_tb);
    end

endmodule