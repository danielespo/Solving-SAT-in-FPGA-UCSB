/*
Version: 2.0
Heuristic_Selector_tb.v

V1.0 Author: Zeiler Randall-Reed
V2.0 Author: Zeiler Randall-Reed

Description: 
Testbench file for Heuristic_Selector.v

Status: 
- V1.0 tests passed
- V2.0 tests passed
*/

`timescale 1ns / 1ps
`define SIM
`define RUN_PROBABILITY_TEST
`define ASSERT(CONDITION, MESSAGE) if ((CONDITION)==1'b1); else begin $error($sformatf MESSAGE); end

module Heuristic_Selector_tb;

// Heuristic Selector Parameters
parameter MAX_CLAUSES_PER_VARIABLE = 20;
parameter NSAT = 3;
parameter MAX_CLAUSES_PER_VARIABLE_BITS = 5;
parameter NSAT_BITS = 2;
parameter P = 'h6E147AE0; // this value should mean there is a 0.57 chance to random walk 

localparam MCPV = MAX_CLAUSES_PER_VARIABLE;
localparam MCPVB = MAX_CLAUSES_PER_VARIABLE_BITS;
// parameter ZERO_OVERRIDE_TESTS = 6;
// parameter RANDOM_WALK_TESTS = 6;
// parameter COMPARISON_TESTS = 6;
// parameter ZERO_BIAS_TESTS = 6;
// parameter ZERO_VALID_TESTS = 6;
// parameter ONE_VALID_TESTS = 6;
// parameter TWO_VALID_RAND_TESTS = 6;
// parameter TWO_VALID_COMP_TESTS = 6;

parameter TESTS_PER_SECTION = 6;
parameter TEST_SECTIONS = 8;
parameter NUMTESTS = TESTS_PER_SECTION * TEST_SECTIONS;

`ifdef RUN_PROBABILITY_TEST
parameter PROBABILITY_TEST_COUNT = 10000;
integer random_count;
`endif

// testing integers
integer i, j, k, f;

// Inputs
reg clk = 1;
always #5 clk <= ~clk;
reg reset;

reg [(NSAT*MCPVB) - 1 : 0] break_values;
reg [NSAT - 1 : 0] break_values_valid;
reg [31:0] random_lsfr; // comes from lfsr_prng

// Output
wire [NSAT_BITS-1:0] select;
wire random_selection;

// Instantiate UUT
Heuristic_Selector #(
    .MAX_CLAUSES_PER_VARIABLE(MCPV),
    .NSAT(NSAT),
    .MAX_CLAUSES_PER_VARIABLE_BITS(MCPVB),
    .NSAT_BITS(NSAT_BITS),
    .P(P)
) HS (
    .clk(clk),
    .reset(reset),
    .break_values_i(break_values),
    .break_values_valid_i(break_values_valid),
    .random_i(random_lsfr),
    .select_o(select),
    .random_selection_o(random_selection)
);

/* DONT NEED RANDOM NUMBER GEN TO TEST PERFORMANCE
    // Instantiate XOR_PRNG module
    module lfsr_prng(
        .clk(clk),          // Clock signal
        .reset(reset),      // Reset signal
        .out(random_lsfr)   // 32-bit output
    );
*/

/* Testing Plan:
    - cases
        - zero override
        - random walk
        - comparison logic
        - bias against f0
        - 0 valid
        - 1 valid
        - 2 valid random
        - 2 valid comparison
    - many tests
        - do a bunch of random generation and make sure the random selection probability is close to expected
*/

// testing data
reg [(NSAT * MCPVB) - 1 : 0]    bv      [0 : NUMTESTS - 1]; // NSAT*MCPVB = 15
reg [NSAT - 1 : 0]              bvv     [0 : NUMTESTS - 1];
reg [31 : 0]                    rand    [0 : NUMTESTS - 1];

reg [1 : 0] sel [0 : NUMTESTS - 1];
reg         rand_sel [0 : NUMTESTS - 1];

// testing registers
reg a,b,c;
reg [MCPVB - 1 : 0] aa, bb, cc;

reg[NSAT-1:0] test_reg_nsat;
reg[NSAT_BITS-1:0] test_reg_nsat_bits;

reg[TEST_SECTIONS - 1 : 0] test_pass;

reg[MCPVB - 1 : 0] bv_packed [NSAT - 1 : 0];
reg[NSAT_BITS - 1 : 0] index_packed [NSAT - 1 : 0];


initial begin
$display("Heuristic Selector Testbench: Begin Simulation");
// generate test data
    $display("Generating test data...");
    // zero override data
    for(i = 0; i < TESTS_PER_SECTION; i = i + 1) begin
        f = ($random & 32'h7FFF_FFFF) % 3;
        a = !(f == 0);
        b = !(f == 1);
        c = !(f == 2);
        bv[i] = ($random & {{MCPVB{c}}, {MCPVB{b}}, {MCPVB{a}}}) | {{(MCPVB - 1){1'b0}}, c, {(MCPVB - 1){1'b0}}, b, {(MCPVB - 1){1'b0}}, a};
        bvv[i] = {NSAT{1'b1}};
        rand[i] = 32'b0;
    end
    // random walk data
    for(i = TESTS_PER_SECTION; i < TESTS_PER_SECTION * 2; i = i + 1) begin
        bv[i] = {5'b01100, 5'b01000, 5'b00100};
        bvv[i] = {NSAT{1'b1}};
        rand[i] = 32'hFFFF_0000 + i;
    end
    // comparison logic
    for(i = TESTS_PER_SECTION * 2; i < TESTS_PER_SECTION * 3; i = i + 1) begin
        bv[i] = $random | {NSAT{{(MCPVB - 1){1'b0}}, 1'b1}};
        bvv[i] = {NSAT{1'b1}};
        rand[i] = $random & 32'h00FF_FFFF;
    end
    // anti f0 bias 
    for(i = TESTS_PER_SECTION * 3; i < TESTS_PER_SECTION * 4; i = i + 1) begin
        f = ($random & 32'h7FFF_FFFF) % 2;
        aa = $random & 5'b00011;
        bb = f ? aa : $random | 5'b10000;
        cc = f ? $random | 5'b10000 : aa;
        bv[i] = {cc, bb, aa};
        bvv[i] = {NSAT{1'b1}};
        rand[i] = $random & 32'h00FF_FFFF;
    end
    // 0 valid
    for(i = TESTS_PER_SECTION * 4; i < TESTS_PER_SECTION * 5; i = i + 1) begin
        bv[i] = $random;
        bvv[i] = {NSAT{1'b0}};
        rand[i] = $random;
    end
    // 1 valid
    for(i = TESTS_PER_SECTION * 5; i < TESTS_PER_SECTION * 6; i = i + 1) begin
        f = ($random & 32'h7FFF_FFFF) % 3;
        a = (f == 0);
        b = (f == 1);
        c = (f == 2);
        bv[i] = $random;
        bvv[i] = {c, b, a};
        rand[i] = $random;
    end
    // 2 valid random
    for(i = TESTS_PER_SECTION * 6; i < TESTS_PER_SECTION * 7; i = i + 1) begin
        f = ($random & 32'h7FFF_FFFF) % 3;
        a = ~(f == 0);
        b = ~(f == 1);
        c = ~(f == 2);
        bv[i] = $random;
        bvv[i] = {c, b, a};
        rand[i] = 32'hFF00_0000 + (i << 7);
    end
    // 2 valid comparison
    for(i = TESTS_PER_SECTION * 7; i < TESTS_PER_SECTION * 8; i = i + 1) begin
        f = i % 3;
        a = ~(f == 0);
        b = ~(f == 1);
        c = ~(f == 2);
        bv[i] = $random;
        bvv[i] = {c, b, a};
        rand[i] = 32'b0;
    end

// initialize values
break_values = 0;
break_values_valid = 0;
random_lsfr = 0;

test_pass = {TEST_SECTIONS{1'b1}};

// Reset the system
reset = 1;
@(negedge clk);
@(negedge clk);
reset = 0;

// case tests
    $display("Case Test 1: zero override");
    for(i = 0; i < TESTS_PER_SECTION; i = i + 1) begin
        break_values = bv[i];
        break_values_valid = bvv[i];
        random_lsfr = rand[i];
        @(negedge clk);
        sel[i] = select;
        rand_sel[i] = random_selection;
        for(j = 0; j < NSAT; j = j + 1) begin
            test_reg_nsat[j] = |break_values[MCPVB*j +: MCPVB]; 
            if(test_reg_nsat[j] == 0) test_reg_nsat_bits = j;
        end
        if(select != test_reg_nsat_bits) begin
            $display("    Error: Selected %0d instead of %0d on test %0d", select, test_reg_nsat_bits, i);
            test_pass[0] = 0;
        end
    end

    $display("Case Test 2: random walk");
    for(i = TESTS_PER_SECTION; i < TESTS_PER_SECTION * 2; i = i + 1) begin
        break_values = bv[i];
        break_values_valid = bvv[i];
        random_lsfr = rand[i];
        @(negedge clk);
        sel[i] = select;
        rand_sel[i] = random_selection;
        if(select != (i % 3)) begin
            $display("    Error: Selected %0d instead of %0d on test %0d", select, i % 3, i);
            test_pass[1] = 0;
        end
        if(random_selection != 1) begin
            $display("    Error: Failed to do random walk  on test %0d", i);
            test_pass[1] = 0;
        end
    end

    $display("Case Test 3: comparison logic");
    for(i = TESTS_PER_SECTION * 2; i < TESTS_PER_SECTION * 3; i = i + 1) begin
        break_values = bv[i];
        break_values_valid = bvv[i];
        random_lsfr = rand[i];
        @(negedge clk);
        sel[i] = select;
        rand_sel[i] = random_selection;
        for(j = 0; j < NSAT; j = j + 1) begin
            bv_packed[j] = break_values[MCPVB*j +: MCPVB];
        end
        if(bv_packed[0] < bv_packed[1] && bv_packed[0] < bv_packed[2]) begin
            test_reg_nsat_bits = 0;
        end else if(bv_packed[1] <= bv_packed[0] && bv_packed[1] <= bv_packed[2]) begin
            test_reg_nsat_bits = 1;
        end else if(bv_packed[2] <= bv_packed[0] && bv_packed[2] <= bv_packed[1]) begin
            test_reg_nsat_bits = 2;
        end 
        if(select != test_reg_nsat_bits) begin
            $display("    Error: Selected %0d instead of %0d on test %0d", select, test_reg_nsat_bits, i);
            test_pass[2] = 0;
        end
    end

    $display("Case Test 4: bias against f0");
    for(i = TESTS_PER_SECTION * 3; i < TESTS_PER_SECTION * 4; i = i + 1) begin
        break_values = bv[i];
        break_values_valid = bvv[i];
        random_lsfr = rand[i];
        @(negedge clk);
        sel[i] = select;
        rand_sel[i] = random_selection;
        for(j = 0; j < NSAT; j = j + 1) begin
            bv_packed[j] = break_values[MCPVB*j +: MCPVB];
        end
        if(bv_packed[0] == bv_packed[1]) begin
            test_reg_nsat_bits = 1;
        end else if (bv_packed[0] == bv_packed[2]) begin
            test_reg_nsat_bits = 2;
        end
        if(select != test_reg_nsat_bits) begin
            $display("    Error: Selected %0d instead of %0d on test %0d", select, test_reg_nsat_bits, i);
            test_pass[3] = 0;
        end
    end

    $display("Case Test 5: 0 valid");
    for(i = TESTS_PER_SECTION * 4; i < TESTS_PER_SECTION * 5; i = i + 1) begin
        break_values = bv[i];
        break_values_valid = bvv[i];
        random_lsfr = rand[i];
        @(negedge clk);
        sel[i] = select;
        rand_sel[i] = random_selection;
        if(select != 3) begin
            $display("    Error: Selected %0d instead of 3 on test %0d", select, i);
            test_pass[4] = 0;
        end
    end

    $display("Case Test 6: 1 valid");
    for(i = TESTS_PER_SECTION * 5; i < TESTS_PER_SECTION * 6; i = i + 1) begin
        break_values = bv[i];
        break_values_valid = bvv[i];
        random_lsfr = rand[i];
        @(negedge clk);
        sel[i] = select;
        rand_sel[i] = random_selection;
        for(j = 0; j < NSAT; j = j + 1) begin
            if(break_values_valid[j] == 1) test_reg_nsat_bits = j;
        end
        if(select != test_reg_nsat_bits) begin
            $display("    Error: Selected %0d instead of %0d on test %0d", select, test_reg_nsat_bits, i);
            test_pass[5] = 0;
        end
    end

    $display("Case Test 7: 2 valid random");
    for(i = TESTS_PER_SECTION * 6; i < TESTS_PER_SECTION * 7; i = i + 1) begin
        break_values = bv[i];
        break_values_valid = bvv[i];
        random_lsfr = rand[i];
        @(negedge clk);
        sel[i] = select;
        rand_sel[i] = random_selection;
        for(j = 0; j < NSAT; j = j + 1) begin
            if(break_values_valid[j] == 1) begin
                bv_packed[k] = break_values[MCPVB*j +: MCPVB];
                index_packed[k] = j;
                k = k + 1;
            end
        end
        if(random_lsfr[7] == 1) begin
            test_reg_nsat_bits = index_packed[1];
        end else begin 
            test_reg_nsat_bits = index_packed[0];
        end
        if(select != test_reg_nsat_bits) begin
            $display("    Error: Selected %0d instead of %0d on test %0d", select, i % 3, i);
            test_pass[6] = 0;
        end
        if(random_selection != 1) begin
            $display("    Error: Failed to do random walk on test %0d", i);
            test_pass[6] = 0;
        end
    end

    $display("Case Test 8: 2 valid comparison");
    for(i = TESTS_PER_SECTION * 7; i < TESTS_PER_SECTION * 8; i = i + 1) begin
        break_values = bv[i];
        break_values_valid = bvv[i];
        random_lsfr = rand[i];
        @(negedge clk);
        sel[i] = select;
        rand_sel[i] = random_selection;
        k = 0;
        for(j = 0; j < NSAT; j = j + 1) begin
            if(break_values_valid[j] == 1) begin
                bv_packed[k] = break_values[MCPVB*j +: MCPVB];
                index_packed[k] = j;
                k = k + 1;
            end
        end
        if(bv_packed[0] > bv_packed[1]) begin
            test_reg_nsat_bits = index_packed[1];
        end else if(bv_packed[0] == bv_packed[1]) begin 
            test_reg_nsat_bits = index_packed[1];
        end else begin
            test_reg_nsat_bits = index_packed[0];
        end
        if(select != test_reg_nsat_bits) begin
            $display("    Error: Selected %0d instead of %0d on test %0d", select, test_reg_nsat_bits, i);
            test_pass[7] = 0;
        end
    end

$display("Case Test Results:");
for(i = 0; i < TEST_SECTIONS; i = i + 1) begin
    if(test_pass[i] == 1) begin
        $display("    Test %0d: Passed", i + 1);
    end else begin
        $display("    Test %0d: Failed", i + 1);
    end
end


// probablility test
`ifdef RUN_PROBABILITY_TEST

// Reset the system
reset = 1;
@(negedge clk);
@(negedge clk);
reset = 0;
random_count = 0;

for(i = 0; i < PROBABILITY_TEST_COUNT; i = i + 1) begin
    break_values = $random;
    break_values_valid = {NSAT{1'b1}};
    random_lsfr = $random;
    @(negedge clk);
    if(random_selection) random_count = random_count + 1;
end

`endif


$display("Case Test Results:");
for(i = 0; i < TEST_SECTIONS; i = i + 1) begin
    if(test_pass[i] == 1) begin
        $display("    Test %0d: Passed", i + 1);
    end else begin
        $display("    Test %0d: Failed", i + 1);
    end
end

`ifdef RUN_PROBABILITY_TEST
$display("Random Walk Probability Test Results:");
$display("    Random Walk Count: %0d", random_count);
$display("    Expected Random Walk Count: %0d", 0.57 * PROBABILITY_TEST_COUNT);
//$display("    Error: %0d", random_count - (PROBABILITY_TEST_COUNT * P));
`endif

$display("Heuristic Selector Testbench: End Simulation");
$finish;

end
endmodule