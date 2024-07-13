/*
Heuristic_Selector_tb.v
Author: Zeiler Randall-Reed

Description: 
Testbench file for Heuristic_Selector.v

Status: tests passed
*/

`timescale 1ns / 1ps
`define SIM
`define ASSERT(CONDITION, MESSAGE) if ((CONDITION)==1'b1); else begin $error($sformatf MESSAGE); end

module Heuristic_Selector_tb;

// Heuristic Selector Parameters
parameter MAX_CLAUSES_PER_VARIABLE = 20;
parameter NSAT = 3;
parameter MAX_CLAUSES_PER_VARIABLE_BITS = 5;
parameter NSAT_BITS = 2;
parameter P = 268435455; // this value should mean there is a 1/16 chance to random walk 

// Inputs
reg clk = 1;
always #5 clk <= ~clk;
reg reset;

reg [MAX_CLAUSES_PER_VARIABLE_BITS-1:0] break_value_i;
reg [NSAT_BITS-1:0] current_flip_i;
reg [31:0] random_lsfr; // comes from lfsr_prng

// Output
wire [NSAT_BITS-1:0] selected_flip_o;
wire random_selection_o;

// Instantiate UUT
Heuristic_Selector #(
    .MAX_CLAUSES_PER_VARIABLE(MAX_CLAUSES_PER_VARIABLE),
    .NSAT(NSAT),
    .MAX_CLAUSES_PER_VARIABLE_BITS(MAX_CLAUSES_PER_VARIABLE_BITS),
    .NSAT_BITS(NSAT_BITS),
    .P(P)
) HS (
    .clk(clk),
    .reset(reset),
    .break_value_i(break_value_i),
    .current_flip_i(current_flip_i),
    .random_i(random_lsfr),
    .selected_flip_o(selected_flip_o),
    .random_selection_o(random_selection_o)
);

// DONT NEED RANDOM NUMBER GEN TO TEST PERFORMANCE
// // Instantiate XOR_PRNG module
// module lfsr_prng(
//     .clk(clk),          // Clock signal
//     .reset(reset),      // Reset signal
//     .out(random_lsfr)   // 32-bit output
// );

// non-synth testing constructs
integer i, f;
reg [5-1:0] f0 [0:20];
reg [5-1:0] f1 [0:20];
reg [5-1:0] f2 [0:20];
reg [32-1:0] random [0:20];
reg [2-1:0] out [0:20];


initial begin

// load data
$readmemh("Heuristic_Selector_tb_memfiles/HS_tb_f0.mem", f0);
$readmemh("Heuristic_Selector_tb_memfiles/HS_tb_f1.mem", f1);
$readmemh("Heuristic_Selector_tb_memfiles/HS_tb_f2.mem", f2);
$readmemh("Heuristic_Selector_tb_memfiles/HS_tb_ri.mem", random);
$readmemh("Heuristic_Selector_tb_memfiles/HS_tb_xout.mem", out);

$display("Heuristic Selector Testbench: Begin Simulation");

break_value_i = 0;
current_flip_i = 0;
random_lsfr = 0;

// Reset the system
reset = 1;
@(negedge clk);
@(negedge clk);
reset = 0;

$display("Testing: zero override");
for(i = 0; i < 6; i = i + 1) begin
    @(negedge clk);
    current_flip_i = 0;
    break_value_i = f0[i];
    @(negedge clk);
    current_flip_i = 1;
    break_value_i = f1[i];
    @(negedge clk);
    current_flip_i = 2;
    break_value_i = f2[i];
    random_lsfr = random[i];
    @(posedge clk);
    #1
    if(selected_flip_o != out[i]) begin
        $display("    Error: Selected flip %d when it should have selected flip %d", selected_flip_o, out[i]);
    end
end
$display("Testing: random walk");
for(i = 6; i < 12; i = i + 1) begin
    @(negedge clk);
    current_flip_i = 0;
    break_value_i = f0[i];
    @(negedge clk);
    current_flip_i = 1;
    break_value_i = f1[i];
    @(negedge clk);
    current_flip_i = 2;
    break_value_i = f2[i];
    random_lsfr = random[i];
    @(posedge clk);
    #1
    if(selected_flip_o != out[i]) begin
        $display("    Error: Selected flip %d when it should have selected flip %d", selected_flip_o, out[i]);
    end
end
$display("Testing: comparison logic");
for(i = 12; i < 18; i = i + 1) begin
    @(negedge clk);
    current_flip_i = 0;
    break_value_i = f0[i];
    @(negedge clk);
    current_flip_i = 1;
    break_value_i = f1[i];
    @(negedge clk);
    current_flip_i = 2;
    break_value_i = f2[i];
    random_lsfr = random[i];
    @(posedge clk);
    #1
    if(selected_flip_o != out[i]) begin
        $display("    Error: Selected flip %d when it should have selected flip %d", selected_flip_o, out[i]);
    end
end
$display("Testing: bias against f0");
for(i = 12; i < 18; i = i + 1) begin
    @(negedge clk);
    current_flip_i = 0;
    break_value_i = f0[i];
    @(negedge clk);
    current_flip_i = 1;
    break_value_i = f1[i];
    @(negedge clk);
    current_flip_i = 2;
    break_value_i = f2[i];
    random_lsfr = random[i];
    @(posedge clk);
    #1
    if(selected_flip_o != out[i]) begin
        $display("    Error: Selected flip %d when it should have selected flip %d", selected_flip_o, out[i]);
    end
end



end
endmodule