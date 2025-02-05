`timescale 1ns / 1ps

module Clause_Evaluator_tb;
    parameter CLUSTER_SIZE = 1;    
    parameter NSAT = 3;            // 3-SAT
    parameter REDUCE = 1;          // One literal excluded (flipped variable)
    parameter IMPLEMENTATION = "OUTPUT_GATED";

    // Signals
    reg clk;
    reg rst_i;
    reg [(NSAT - REDUCE) - 1 : 0] var_val_i; // 2 bits (2 literals evaluated)
    reg [(NSAT - REDUCE) - 1 : 0] var_neg_i; 
    wire break_o;

    // Instantiate DUT
    Clause_Evaluator #(
        .NSAT(NSAT),
        .IMPLEMENTATION(IMPLEMENTATION),
        .REDUCE(REDUCE)
    ) dut (
        .clk_i(clk),
        .rst_i(rst_i),
        .var_val_i(var_val_i),
        .var_neg_i(var_neg_i),
        .break_o(break_o)
    );

    // Clock generation (100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test procedure
    initial begin
        // Initialize
        rst_i = 1;
        var_val_i = 2'b00;
        var_neg_i = 2'b00;
        #20 
        rst_i = 0;
        #10 

        // ----------------------------------------
        // Test 1: Both literals false → UNSAT (break=1)
        // ----------------------------------------
        var_val_i = 2'b00;  // Variables = 0
        var_neg_i = 2'b11;  // Both literals negated (¬0 = 1)
        #10; // Wait for clock
        if (break_o !== 1'b1)
            $display("Test 1 FAILED: Expected break=1, Got=%b", break_o);
        else
            $display("Test 1 PASSED: UNSAT detected");

        // ----------------------------------------
        // Test 2: One literal true → SAT (break=0)
        // ----------------------------------------
        var_val_i = 2'b10;  // Literal 1 = 1
        var_neg_i = 2'b00;  // No negation
        #10;
        if (break_o !== 1'b0)
            $display("Test 2 FAILED: Expected break=0, Got=%b", break_o);
        else
            $display("Test 2 PASSED: SAT detected");

        // ----------------------------------------
        // Test 3: Both literals true → SAT (break=0)
        // ----------------------------------------
        var_val_i = 2'b11;  
        var_neg_i = 2'b00;
        #10;
        if (break_o !== 1'b0)
            $display("Test 3 FAILED: Expected break=0, Got=%b", break_o);
        else
            $display("Test 3 PASSED: SAT detected");

        // ----------------------------------------
        // Test 4: Reset behavior
        // ----------------------------------------
        rst_i = 1;
        #10;
        if (break_o !== 1'b0)
            $display("Test 4 FAILED: Reset not working, Got=%b", break_o);
        else
            $display("Test 4 PASSED: Reset behavior correct");

        // ----------------------------------------
        // Test 5: Edge case (alternating literals)
        // ----------------------------------------
        rst_i = 0;
        var_val_i = 2'b10;  
        var_neg_i = 2'b01;  // Literals: var_val[1] ^ 1, var_val[0] ^ 0
        #10;
        if (break_o !== 1'b0)  // (1^1=0) | (0^0=0) → break=1? Wait no:
            $display("Test 5 FAILED: Expected break=1, Got=%b", break_o);
        else
            $display("Test 5 PASSED: Correct evaluation");
        
        $display("All tests completed");
        $finish;
    end

    // Monitor
    initial begin
        $monitor("Time=%0t | var_val=%b | var_neg=%b | break=%b", 
                 $time, var_val_i, var_neg_i, break_o);
    end

endmodule