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
parameter IMPLEMENTATION = "OUTPUT_GATED";

// IO
reg clk;
reg reset;
reg [(NSAT * CLUSTER_SIZE - 1) : 0] var_val_mem [0:19];
reg [(NSAT * CLUSTER_SIZE - 1) : 0] var_val_i;
reg [(NSAT * CLUSTER_SIZE - 1) : 0] var_neg_mem [0:19];
reg [(NSAT * CLUSTER_SIZE - 1) : 0] var_neg_i;
reg     [CLUSTER_SIZE - 1 : 0] break_mem [0:19];
wire    [CLUSTER_SIZE - 1 : 0] break_o;
reg     [CLUSTER_SIZE - 1 : 0] break;
reg     [CLUSTER_SIZE - 1 : 0] expected;

// HW
Clause_Evaluator_Cluster #(
    .CLUSTER_SIZE(CLUSTER_SIZE),
    .NSAT(NSAT),
    .IMPLEMENTATION(IMPLEMENTATION),
    .REDUCE(0)
) evaluator (
    .clk_i(clk),
    .reset_i(reset),
    .var_val_i(var_val_i),
    .var_neg_i(var_neg_i),
    .break_o(break_o)
);

integer i;

// Memory reading and generate clk
initial begin
    $readmemh("Clause_Evaluator_var_val.mem", var_val_mem);
    $readmemh("Clause_Evaluator_var_neg.mem", var_neg_mem);
    $readmemh("Clause_Evaluator_break.mem", break_mem);
    reset = 0;
    var_val_i <= var_val_mem[0];
    var_neg_i <= var_neg_mem[0]; 
    clk = 0;
    forever #5 clk = ~clk; // 100 MHz Clock
end

// Output capture
always @ (posedge clk)
begin
    break <= break_o;
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

    $display("Clause Evaluator Testbench: Running Test Cases");
    for (i = 0; i < 10; i = i + 1)
      begin
        var_val_i <= var_val_mem[i];
        var_neg_i <= var_neg_mem[i];
        #6;
        $display("Time %0t, Got 0x%15h, Expected 0x%15h", $time, break_o, break_mem[i]);
        #4;
      end

    #10;
    reset = 1;
    #10;
end

endmodule