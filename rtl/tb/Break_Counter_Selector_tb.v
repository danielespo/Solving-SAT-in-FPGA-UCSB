/*
Version: 1.0
Break_Counter_Selector_tb.v

Author V1.0: Zeiler Randall-Reed

Description:
This module is where the break value counter and heuristic selector are combined. There is also an
included register to hold the break values for the first two cycles. This helps to ensure that all
of the data that is needed for the heuristic selector is available.

Status:
- V1.0: testbench in progress.
*/

`timescale 1ns / 1ps
`define SIM

module Break_Counter_Selector_tb;

// Break_Counter_Selector params
parameter MAX_CLAUSES_PER_VARIABLE = 20;
parameter NSAT = 3;
parameter MAX_CLAUSES_PER_VARIABLE_BITS = 5;
parameter NSAT_BITS = 2;
parameter P = 32'h6E147AE0;

// localparms
localparam MC = MAX_CLAUSES_PER_VARIABLE;
localparam MCB = MAX_CLAUSES_PER_VARIABLE_BITS;

// test params
parameter NUM_TESTS = 22;

// integer vars
integer i, j;

/* I/O */
// clock and reset
reg clk = 0;
always #5 clk = ~clk;
reg reset;

// data inputs
reg [MC - 1 : 0] clause_broken_i;
reg [MC - 1 : 0] mask_bits_i;
reg [NSAT - 1 : 0] break_values_valid_i;
reg [31:0] random_i;

// control inputs
reg [NSAT_BITS - 1 : 0] wren_i;

// data outputs
wire [NSAT_BITS - 1 : 0] selected_o;
wire [MC - 1 : 0] clause_broken_bits_o;

// instantiate the unit under test (UUT)
Break_Counter_Selector #(
    .MAX_CLAUSES_PER_VARIABLE(MAX_CLAUSES_PER_VARIABLE),
    .NSAT(NSAT),
    .MAX_CLAUSES_PER_VARIABLE_BITS(MAX_CLAUSES_PER_VARIABLE_BITS),
    .NSAT_BITS(NSAT_BITS),
    .P(P)
) uut (
    .clk(clk),
    .reset(reset),
    .clause_broken_i(clause_broken_i),
    .mask_bits_i(mask_bits_i),
    .break_values_valid_i(break_values_valid_i),
    .random_i(random_i),
    .wren_i(wren_i),
    .selected_o(selected_o),
    .clause_broken_bits_o(clause_broken_bits_o)
);

/* Testing Plan:
- basic cases
    selected_o
    - 3 all zero (trivial case)
    - zero override no duplicates
    - zero override w/ duplicates
    - deterministic selection no duplicates
    - deterministic selection w/ duplicates (deprioritize first flip)
    - random selection 
    clause_broken_bits_o
    - mask bit check 
    - break bit check
    - random assignment check
*/

// testing data
reg [MC - 1 : 0] break_bits [NSAT - 1 : 0]  [NUM_TESTS - 1 : 0];
reg [MC - 1 : 0] mask_bits  [NSAT - 1 : 0]  [NUM_TESTS - 1 : 0];
reg [NSAT - 1 : 0] break_valid              [NUM_TESTS - 1 : 0];
reg [31:0]       random_num [NSAT + 1 : 0]  [NUM_TESTS - 1 : 0];

// expected results
reg [NSAT_BITS - 1 : 0] select              [NUM_TESTS - 1 : 0];
reg [MC - 1 : 0] clause_broken_bits         [NUM_TESTS - 1 : 0];

// test register
reg [NUM_TESTS - 1 : 0] test_pass;
reg [$clog2(NUM_TESTS) - 1 : 0] num_passed;

initial begin
$display("Break Counter Selector Testbench: Begin Simulation");
// generate test data
    $display("Generating test data...");
    // case 0: 3 all zero (trivial - 1 test)
    for(i = 0; i < NSAT; i = i + 1) begin
        break_bits[i][0] = 20'b0;
        mask_bits[i][0] = 20'b0;
        random_num[i][0] = $random;
    end
    break_valid[0] = 3'b111;
    random_num[3][0] = 32'b0;
    random_num[4][0] = $random;
    select[0] = 2'b10; // when all are zeros, the last one is prioritized
    clause_broken_bits[0] = break_bits[select[0]][0] & mask_bits[select[0]][0];
    // case 1: zero overrride no duplicates (3 tests)
    for(j = 0; j < 3; j = j + 1) begin
        for(i = 0; i < NSAT; i = i + 1) begin
            break_bits[i][1 + j] = (j == i) ? 0 : ($random | {10'b0, 1'b1, 9'b0});
            mask_bits[i][1 + j] = (j == i) ? 0 : ($random | {10'b0, 1'b1, 9'b0});
            random_num[i][1 + j] = $random;
        end
        break_valid[1 + j] = 3'b111;
        random_num[3][1 + j] = $random; // should be irrelevant because of zero
        random_num[4][1 + j] = $random; 
        select[1 + j] = j; // zero override
        clause_broken_bits[1 + j] = break_bits[select[1 + j]][1 + j] & mask_bits[select[1 + j]][1 + j];
    end
    // case 2: zero override with duplicates (3 tests)
    for(j = 0; j < 3; j = j + 1) begin
        for(i = 0; i < NSAT; i = i + 1) begin
            break_bits[i][4 + j] = (j != i) ? 0 : ($random | {10'b0, 1'b1, 9'b0});
            mask_bits[i][4 + j] = (j != i) ? 0 : ($random | {10'b0, 1'b1, 9'b0});
            random_num[i][4 + j] = $random;
        end
        break_valid[4 + j] = 3'b111;
        random_num[3][4 + j] = $random; // should be irrelevant because of zero
        random_num[4][4 + j] = $random;
        select[4 + j] = (j == 3 ? 2'b10 : 2'b11); // zero override
        clause_broken_bits[4 + j] = break_bits[select[4 + j]][4 + j] & mask_bits[select[4 + j]][4 + j];
    end
    // case 3: deterministic selection no duplicates (3 tests)
    for(j = 0; j < 3; j = j + 1) begin
        for(i = 0; i < NSAT; i = i + 1) begin
            break_bits[i][7 + j] = (j == i) ? {10'b0, 1'b1, 9'b0} : ($random | {9'b0, 2'b11, 9'b0});
            mask_bits[i][7 + j] = (j == i) ? {10'b0, 1'b1, 9'b0} : ($random | {9'b0, 2'b11, 9'b0});
            random_num[i][7 + j] = $random;
        end
        break_valid[7 + j] = 3'b111;
        random_num[3][7 + j] = 0; // needs to be below threshold
        random_num[4][7 + j] = $random;
        select[7 + j] = j; // deterministic selection
        clause_broken_bits[7 + j] = break_bits[select[7 + j]][7 + j] & mask_bits[select[7 + j]][7 + j];
    end
    // case 4: deterministic selection with duplicates (3 tests)
    for(j = 0; j < 3; j = j + 1) begin
        for(i = 0; i < NSAT; i = i + 1) begin
            break_bits[i][10 + j] = (j != i) ? {10'b0, 1'b1, 9'b0} : ($random | {9'b0, 2'b11, 9'b0});
            mask_bits[i][10 + j] = (j != i) ? {10'b0, 1'b1, 9'b0} : ($random | {9'b0, 2'b11, 9'b0});
            random_num[i][10 + j] = $random;
        end
        break_valid[10 + j] = 3'b111;
        random_num[3][10 + j] = 0; // needs to be below threshold
        random_num[4][10 + j] = $random;
        select[10 + j] = (j == 1 ? 2'b10 : 2'b01); // deterministic selection - first flip deprioritized
        clause_broken_bits[10 + j] = break_bits[select[10 + j]][10 + j] & mask_bits[select[10 + j]][10 + j];
    end
    // case 5: random selection (9 tests)
    for(j = 0; j < 9; j = j + 1) begin
        for(i = 0; i < NSAT; i = i + 1) begin
            break_bits[i][13 + j] = ($random | {10'b0, 1'b1, 9'b0});
            mask_bits[i][13 + j] = ($random | {10'b0, 1'b1, 9'b0});
            random_num[i][13 + j] = $random;
        end
        break_valid[13 + j] = 3'b111;
        random_num[3][13 + j] = 32'hFF00_0000 + j; // matters for random selection
        random_num[4][13 + j] = $random;
        select[13 + j] = j % NSAT; // random selection (based on random[5:0])
        clause_broken_bits[13 + j] = break_bits[select[13 + j]][13 + j] & mask_bits[select[13 + j]][13 + j];
    end

// initialize values
clause_broken_i = 20'b0;
mask_bits_i = 20'b0;
break_values_valid_i = 3'b0;
random_i = 32'b0;
wren_i = 2'b00;
test_pass = {20{1'b1}};
num_passed = 0;

// reset the system
reset = 1;
@(negedge clk);
@(negedge clk);
reset = 0;

// case tests
for(i = 0; i < NUM_TESTS; i = i + 1) begin
    // D
    clause_broken_i = 20'bx;
    mask_bits_i = 20'bx;
    random_i = random_num[0][i];
    wren_i = 2'b00;
    @(negedge clk);
    // E1_1
    clause_broken_i = break_bits[0][i];
    mask_bits_i = mask_bits[0][i];
    random_i = random_num[1][i];
    wren_i = 2'b01;
    @(negedge clk);
    // E1_2
    clause_broken_i = break_bits[1][i];
    mask_bits_i = mask_bits[1][i];
    random_i = random_num[2][i];
    wren_i = 2'b10;
    @(negedge clk);
    // E1_3
    clause_broken_i = break_bits[2][i];
    mask_bits_i = mask_bits[2][i];
    random_i = random_num[3][i];
    wren_i = 2'b11;
    break_values_valid_i = break_valid[i];
    @(negedge clk);
    // E2
    clause_broken_i = 20'bx;
    mask_bits_i = 20'bx;
    random_i = random_num[4][i];
    wren_i = 2'b00;
    break_values_valid_i = 0;

    // check the results
    if(selected_o !== select[i]) begin
        $display("Test %0d: selected_o failed. Expected %0d, got %0d", i, select[i], selected_o);
        test_pass[i] = 1'b0;
    end
    if(clause_broken_bits_o !== clause_broken_bits[i]) begin
        $display("Test %0d: clause_broken_bits_o failed. Expected %b, got %b", i, clause_broken_bits[i], clause_broken_bits_o);
        test_pass[i] = 1'b0;
    end

    // give the system some time to settle
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
end

for(i = 0; i < NUM_TESTS; i = i + 1) if(test_pass[i]) num_passed = num_passed + 1;


$display("Break Counter Selector Testbench: End Simulation");
$display("Test Results: %0d/%0d tests passed", num_passed, NUM_TESTS);
$finish;


end

endmodule