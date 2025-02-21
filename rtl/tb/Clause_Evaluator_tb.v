/* 
Version: 2.0
Clause_Evaluator_tb.v

V1.0 Author: Dan Espinosa
V2.0 Author: Barry Wang

Description:
    This is the test bench for one clause evaluator

Notes:

Change Log:

2024/07/17 - Barry Wang
    Reworked test bench
*/
module Clause_Evaluator_tb;
    parameter CLUSTER_SIZE = 20;
    parameter NSAT = 3;
    
    // IO
    reg clk;
    reg reset;
    reg [(NSAT * CLUSTER_SIZE - 1) : 0] var_val_mem [0:19];
    reg [(NSAT * CLUSTER_SIZE - 1) : 0] var_val_i;
    reg [(NSAT * CLUSTER_SIZE - 1) : 0] var_neg_mem [0:19];
    reg [(NSAT * CLUSTER_SIZE - 1) : 0] var_neg_i;
    reg     [CLUSTER_SIZE - 1 : 0] break_mem [0:19];
    wire    [CLUSTER_SIZE - 1 : 0] break_o;
    // reg     [CLUSTER_SIZE - 1 : 0] break;
    // reg     [CLUSTER_SIZE - 1 : 0] expected;
    
    reg [(NSAT * CLUSTER_SIZE - 1) : 0] var_val_i_2;
    reg [(NSAT * CLUSTER_SIZE - 1) : 0] var_neg_i_2;
    wire    [CLUSTER_SIZE - 1 : 0] break_o_2;
    
    // HW
    Clause_Evaluator_Cluster #(
        .CLUSTER_SIZE(CLUSTER_SIZE),
        .NSAT(NSAT),
        .IMPLEMENTATION("OUTPUT_GATED"),
        .REDUCE(0)
    ) out_gate_evaluator (
        .clk_i(clk),
        .rst_i(reset),
        .var_val_mi(var_val_i),
        .var_neg_mi(var_neg_i),
        .break_mo(break_o)
    );
    
    Clause_Evaluator_Cluster #(
        .CLUSTER_SIZE(CLUSTER_SIZE),
        .NSAT(NSAT),
        .IMPLEMENTATION("INPUT_GATED"),
        .REDUCE(0)
    ) in_gate_evaluator (
        .clk_i(clk),
        .rst_i(reset),
        .var_val_mi(var_val_i_2),
        .var_neg_mi(var_neg_i_2),
        .break_mo(break_o_2)
    );
    
    integer i;
    
    // Memory reading and generate clk
    initial begin
        $readmemh("/home/harim_choe/Z_KSAT/rtl/mem/Clause_Evaluator_var_val.mem", var_val_mem);
        $readmemh("/home/harim_choe/Z_KSAT/rtl/mem/Clause_Evaluator_var_neg.mem", var_neg_mem);
        $readmemh("/home/harim_choe/Z_KSAT/rtl/mem/Clause_Evaluator_break.mem", break_mem);
        reset = 0;
        var_val_i <= var_val_mem[0];
        var_neg_i <= var_neg_mem[0]; 
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz Clock
    end
    
    // Ins and test cases
    initial begin
        $display("Clause Evaluator Testbench: Begin Simulation");
        #20;
        $display("Clause Evaluator Testbench: Reset Test");
        reset = 1;
        #10;
        reset = 0;
        #10;
    
        $display("Clause Evaluator Testbench (OUTPUT_GATED): Running Test Cases");
        for (i = 0; i < 20; i = i + 1)
          begin
            var_val_i <= var_val_mem[i];
            var_neg_i <= var_neg_mem[i];
            #6;
            if (break_o == break_mem[i]) begin
                $display("Time %0t, OG Test Case %0d Passed", $time, i);
                end
            else begin
                $display("Time %0t, OG Test Case %0d Failed", $time, i);
                $display("Expected: 0x%15h, Got: 0x%15h", break_mem[i], break_o);
            end
            #4;
          end
    
        #10;
        reset = 1;
        #10;
        reset = 0;
        #10;  
    
        $display("Clause Evaluator Testbench (INPUT_GATED): Running Test Cases");
        for (i = 0; i < 20; i = i + 1)
          begin
            var_val_i_2 <= var_val_mem[i];
            var_neg_i_2 <= var_neg_mem[i];
            #6;
            if (break_o_2 == break_mem[i]) begin
                $display("Time %0t, IG Test Case %0d Passed", $time, i);
                end
            else begin
                $display("Time %0t, IG Test Case %0d Failed", $time, i);
                $display("Expected: 0x%15h, Got: 0x%15h", break_mem[i], break_o_2);
            end
            #4;
          end
    
          #10;
          reset = 1;
          #10;
        
        $finish;
    end
    
    endmodule