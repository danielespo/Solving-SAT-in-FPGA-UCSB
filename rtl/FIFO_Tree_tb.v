/*
FIFO_Tree_tb.v
Author: initially Dan Espinosa, major rework by Zeiler Randall-Reed

Description:
Testbench file for FIFO_Tree.v

Status: Test passed
*/

`timescale 1ns / 1ps
`define SIM
`define ASSERT(CONDITION, MESSAGE) if ((CONDITION)==1'b1); else begin $error($sformatf MESSAGE); end

module FIFO_Tree_tb;

// Parameters for the FIFO tree
parameter MAX_CLAUSES_PER_VARIABLE = 20;
parameter DATA_WIDTH = 36;
parameter BUFFER_SIZE = 32;
parameter FIRST_LEVEL_PARALLEL = 5;
parameter TREE_LEAVES = MAX_CLAUSES_PER_VARIABLE / FIRST_LEVEL_PARALLEL;

// Inputs
reg clk = 1;
always #5 clk <= ~clk;
reg reset;

reg [DATA_WIDTH - 1 : 0] clauses_i [MAX_CLAUSES_PER_VARIABLE-1:0];
reg [MAX_CLAUSES_PER_VARIABLE-1:0] clause_valid_i;
reg write_en_i;

// Output
wire [DATA_WIDTH - 1 : 0] clause_o;

// Instantiate the Unit Under Test (UUT)
FIFO_tree #(
    .MAX_CLAUSES_PER_VARIABLE(MAX_CLAUSES_PER_VARIABLE),
    .DATA_WIDTH(DATA_WIDTH),
    .BUFFER_SIZE(BUFFER_SIZE),
    .FIRST_LEVEL_PARALLEL(FIRST_LEVEL_PARALLEL)
) uut (
    .clk(clk),
    .reset(reset),
    .clauses_i(clauses_i),
    .clause_valid_i(clause_valid_i),
    .write_en_i(write_en_i),
    .clause_o(clause_o)
);

integer clauses[12];
integer matched[12];
integer index, i, j;

// Initialize Inputs and apply test cases
initial begin

// Read test data from files
// note: the paper says that there will be a max of 12 valid clauses per FIFO input
$readmemb("FIFO_tb_clauses.mem", clauses_i);
$readmemb("FIFO_tb_clause_valid.mem", clause_valid_i);
$display("FIFO Tree Testbench: Begin Simulation");

// load the clauses into the test array
index = 0;
for(i = 0; i < 20; i = i + 1) begin
    $display("Clause %d: %b", i, clauses_i[i]);
    if(clause_valid_i[i] == 1) begin
        clauses[index] = clauses_i[i];
        matched[index] = 0;
        index = index + 1;
        $display("Valid clause %d: %b", index, clauses[index]);
    end
end

// Reset the system
reset = 1;
@(negedge clk);
@(negedge clk);
reset = 0;

// Test
write_en_i = 1;
for(i = 0; i < 20; i = i + 1) begin
    @(negedge clk);
    write_en_i = 0;
    $display("FIFO output: %b", clause_o);
    // check for output clause in expected clause list
    for(j = 0; j <= index; j = j + 1) begin
        if(clause_o == clauses[j]) begin
            $display("Matched clause %d: %b", j, clause_o);
            if(matched[j] == 1) begin
                $display("Error: Duplicate clause %d: %b", j, clause_o);
            end
            matched[j] = 1;
            break;
        end else if(j == index) begin
            $display("Error: Unexpected clause %b", clause_o);
        end
    end
end

// Check if all clauses have been matched
for(i = 0; i <= index; i = i + 1) begin
    if(matched[i] == 0) begin
        $display("Error: Unmatched clause %d: %b", i, clauses[i]);
    end
end

$display("FIFO Tree Testbench: End Simulation");

end

endmodule