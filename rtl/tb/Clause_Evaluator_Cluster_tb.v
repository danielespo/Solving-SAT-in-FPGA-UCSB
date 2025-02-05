`timescale 1ns / 1ps

module Clause_Evaluator_Cluster_tb;
    parameter CLUSTER_SIZE = 20;  // 20 evaluators
    parameter NSAT = 3;           // 3-SAT
    parameter IMPLEMENTATION = "OUTPUT_GATED";
    parameter REDUCE = 1;         // Exclude flipped variable
    parameter TEST_CASES = 20;    // Number of test vectors

    // Signals
    reg clk;
    reg rst_i;
    reg [(NSAT-REDUCE)*CLUSTER_SIZE-1:0] var_val_i;
    reg [(NSAT-REDUCE)*CLUSTER_SIZE-1:0] var_neg_i;
    wire [CLUSTER_SIZE-1:0] break_o;

    // Memory arrays
    reg [(NSAT-REDUCE)*CLUSTER_SIZE-1:0] var_val_mem [0:TEST_CASES-1];
    reg [(NSAT-REDUCE)*CLUSTER_SIZE-1:0] var_neg_mem [0:TEST_CASES-1];
    reg [CLUSTER_SIZE-1:0] break_mem [0:TEST_CASES-1];

    // DUT
    Clause_Evaluator_Cluster #(
        .CLUSTER_SIZE(CLUSTER_SIZE),
        .NSAT(NSAT),
        .IMPLEMENTATION(IMPLEMENTATION),
        .REDUCE(REDUCE)
    ) dut (
        .clk_i(clk),
        .rst_i(rst_i),
        .var_val_mi(var_val_i),
        .var_neg_mi(var_neg_i),
        .break_mo(break_o)
    );

    // Clock generation (100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Load test vectors
    initial begin
        $readmemh("../mem/Clause_Evaluator_var_val_fixed.mem", var_val_mem);
        $readmemh("../mem/Clause_Evaluator_var_neg_fixed.mem", var_neg_mem);
        $readmemh("../mem/Clause_Evaluator_break_fixed.mem", break_mem);
    end

    integer i;
    reg [CLUSTER_SIZE-1:0] expected;

    // Main test sequence
    initial begin

        // Initialize and reset
        rst_i = 1;
        var_val_i = 0;
        var_neg_i = 0;
        #20 rst_i = 0;  // Hold reset for 2 clock cyclesxs
        #10;

        // ----------------------------------------
        // Test Case 1: Memory File Validation
        // ----------------------------------------
        $display("\nStarting memory file tests...");
        for (i = 0; i < TEST_CASES; i = i + 1) begin
            // Apply test vector
            var_val_i = var_val_mem[i];
            var_neg_i = var_neg_mem[i];
            expected = break_mem[i];

            // Wait for pipeline delay (2 clock cycles)
            @(posedge clk);
            @(posedge clk);

            // Print results
            $display("Test Case %0d:", i);
            $display("  var_val=0x%10h", var_val_i);
            $display("  var_neg=0x%10h", var_neg_i);
            $display("  break_o=0x%05h (Expected: 0x%05h)", break_o, expected);

            // Check output
            if (break_o !== expected) begin
                $display("  [FAIL] Mismatch detected!");
            end else begin
                $display("  [PASS]");
            end
        end

        // ----------------------------------------
        // Test Case 2: Edge Cases
        // ----------------------------------------
        $display("\nTesting edge cases...");
        
        // Case 2.1: All clauses UNSAT
        var_val_i = 40'h0000000000;  // All variables = 0
        var_neg_i = 40'hFFFFFFFFFF;  // All literals negated
        #20;
        $display("Edge Case 1: All UNSAT");
        $display("  break_o=0x%05h (Expected: 0xFFFFF)", break_o);

        // Case 2.2: All clauses SAT
        var_val_i = 40'hFFFFFFFFFF;  // All variables = 1
        var_neg_i = 40'h0000000000;  // No negation
        #20;
        $display("Edge Case 2: All SAT");
        $display("  break_o=0x%05h (Expected: 0x00000)", break_o);

        $display("\nAll tests completed");
        $finish;
    end

    // Monitor (Optional)
    initial begin
        $monitor("Time=%0t | break_o=0x%05h", $time, break_o);
    end
endmodule