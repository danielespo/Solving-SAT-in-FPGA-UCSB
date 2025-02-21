/*
 Version: 2.0
 Heuristic_Selector_tb.v

 Updated testbench for the revised Heuristic_Selector RTL,
 which implements a more faithful WSAT/SKC:
  - random among multiple zero-break variables
  - random among ties for min-break
  - random walk with probability p
  - purely combinational logic

 Status:
 - V2.0: updated coverage for new tie-handling logic, plus fixes for “Selected out-of-range” errors
*/

`timescale 1ns / 1ps
`define SIM

// Uncomment if you want to run a large statistical test on random_walk:
`define RUN_PROBABILITY_TEST

// Simple assertion macro
`define ASSERT(CONDITION, MESSAGE) \
   if (!(CONDITION)) begin \
       $error($sformatf MESSAGE); \
   end

module Heuristic_Selector_tb;

parameter MAX_CLAUSES_PER_VARIABLE = 20;
parameter NSAT = 3;
localparam MCPV  = MAX_CLAUSES_PER_VARIABLE;
localparam MCPVB = $clog2(MAX_CLAUSES_PER_VARIABLE);
localparam NSAT_BITS = $clog2(NSAT);

// Probability threshold for random walk
parameter P = 32'h6E147AE0; // ~0.57 probability for random walk

parameter TESTS_PER_SECTION = 6;
parameter TEST_SECTIONS     = 8;
parameter NUMTESTS          = TESTS_PER_SECTION * TEST_SECTIONS;

// Additional random-walk coverage
`ifdef RUN_PROBABILITY_TEST
parameter PROBABILITY_TEST_COUNT = 10000;
integer random_count;
`endif

reg clk = 1;
always #5 clk = ~clk;

reg reset;

reg [(NSAT*MCPVB) - 1 : 0] break_values;
reg [NSAT - 1 : 0]         break_values_valid;
reg [31:0]                 random_lsfr;

wire [NSAT_BITS-1:0] select;
wire                  random_selection;

Heuristic_Selector #(
    .MAX_CLAUSES_PER_VARIABLE(MCPV),
    .NSAT(NSAT),
    .P(P)
) HS_UUT (
    .break_values_i(break_values),
    .break_values_valid_i(break_values_valid),
    .random_i(random_lsfr),
    .enable_i(1'b1),
    .select_o(select),
    .random_selection_o(random_selection)
);

// Large sets of test vectors
reg [(NSAT * MCPVB) - 1 : 0] bv   [0 : NUMTESTS - 1];
reg [NSAT - 1 : 0]           bvv  [0 : NUMTESTS - 1];
reg [31 : 0]                 rando[0 : NUMTESTS - 1];

reg [NSAT_BITS - 1 : 0] sel [0 : NUMTESTS - 1];
reg                     rand_sel [0 : NUMTESTS - 1];

// For pass/fail tracking by “section”
reg [TEST_SECTIONS - 1 : 0] test_pass;

// For intermediate checks
integer i, j, k, f;
reg [MCPVB-1:0] a, b, c;
reg [MCPVB - 1 : 0] aa, bb, cc;

initial begin
    $display("Heuristic Selector Testbench: Begin Simulation");

    // Initialize
    break_values       = 0;
    break_values_valid = 0;
    random_lsfr        = 0;
    test_pass          = {TEST_SECTIONS{1'b1}};

    // Reset
    reset = 1;
    @(negedge clk);
    @(negedge clk);
    reset = 0;

    generate_test_data();

    run_case_tests();

    `ifdef RUN_PROBABILITY_TEST
    run_probability_test();
    `endif

    $display("Heuristic Selector Testbench: End Simulation");
    $finish;
end

task generate_test_data;
begin
    $display("Generating test data...");

    for(i = 0; i < TESTS_PER_SECTION; i = i + 1) begin
        f = ($random & 32'h7FFF_FFFF) % 3;
        a = (f == 0) ? 0 : (1 + $random % 15);
        b = (f == 1) ? 0 : (1 + $random % 15);
        c = (f == 2) ? 0 : (1 + $random % 15);

        // Pack them into 3 x MCPVB bits each
        bv[i]  = { c, b, a };
        bvv[i] = 3'b111; // all valid
        rando[i] = i;
    end

    for(i = TESTS_PER_SECTION; i < TESTS_PER_SECTION*2; i = i + 1) begin
        aa = (1 + $random%10);
        bb = (2 + $random%10);
        cc = (3 + $random%10);
        bv[i] = {cc, bb, aa};
        bvv[i] = 3'b111;
        // set random_i > P => definitely random_walk
        rando[i] = 32'hF0000000 | (i * 12345);
    end

    for(i = TESTS_PER_SECTION*2; i < TESTS_PER_SECTION*3; i = i + 1) begin
        aa = (1 + $random%10);
        bb = (1 + $random%10);
        cc = (1 + $random%10);
        bv[i]  = {cc, bb, aa};
        bvv[i] = 3'b111;
        rando[i] = (i * 77) & 32'h0000FFFF; // < P
    end

    for(i = TESTS_PER_SECTION*3; i < TESTS_PER_SECTION*4; i = i + 1) begin
        aa = (i%2 == 0) ? 0 : (1 + $random%10);
        bb = (i%3 == 0) ? 0 : (1 + $random%10);
        cc = (i%4 == 0) ? 0 : (1 + $random%10);
        if((aa!=0) && (bb!=0)) bb = 0;
        bv[i]  = {cc, bb, aa};
        bvv[i] = 3'b111;
        rando[i] = $random;
    end

    for(i = TESTS_PER_SECTION*4; i < TESTS_PER_SECTION*5; i = i + 1) begin
        bv[i]  = $random;
        bvv[i] = 3'b000;
        rando[i] = $random;
    end

    for(i = TESTS_PER_SECTION*5; i < TESTS_PER_SECTION*6; i = i + 1) begin
        f = ($random % 3);
        bv[i] = $random;
        case(f)
          0: bvv[i] = 3'b001;
          1: bvv[i] = 3'b010;
          2: bvv[i] = 3'b100;
        endcase
        rando[i] = $random;
    end

    for(i = TESTS_PER_SECTION*6; i < TESTS_PER_SECTION*7; i = i + 1) begin
        f = ($random % 3);
        case(f)
          0: bvv[i] = 3'b110;
          1: bvv[i] = 3'b101;
          2: bvv[i] = 3'b011;
        endcase
        bv[i]   = $random;
        rando[i]= $random;
    end

    for(i = TESTS_PER_SECTION*7; i < TESTS_PER_SECTION*8; i = i + 1) begin
        f = (i % 3);
        case(f)
          0: bvv[i] = 3'b110;
          1: bvv[i] = 3'b101;
          2: bvv[i] = 3'b011;
        endcase
        aa = (2 + $random%5);
        bb = aa;
        cc = (8 + $random%5);
        bv[i] = {cc, bb, aa};
        rando[i] = (i*123) ^ 32'h00FF_AA55;
    end
end
endtask

integer zeroCount;
integer chosenIndex;
reg [MCPVB-1:0] lit0, lit1, lit2;
reg anyZero;
reg [MCPVB-1:0] litVal [2:0];
integer kMinVal;
integer bestMask, zeroMask;
integer validIndex;
integer idx[1:0];
integer count;
reg [MCPVB-1:0] litX, litY;

task run_case_tests;
begin
    @(negedge clk);

    $display("===== Running Case Tests =====");

    $display("Case Test 1: Zero override (multiple or single zeros)");

    for(i = 0; i < TESTS_PER_SECTION; i = i + 1) begin
        break_values       = bv[i];
        break_values_valid = bvv[i];
        random_lsfr        = rando[i];
        @(negedge clk);

        chosenIndex = select;

        sel[i]      = select;
        rand_sel[i] = random_selection;

        lit0 = break_values[0 +: MCPVB];
        lit1 = break_values[MCPVB +: MCPVB];
        lit2 = break_values[2*MCPVB +: MCPVB];

        zeroCount = 0;
        if(lit0==0 && bvv[i][0]) zeroCount=zeroCount+1;
        if(lit1==0 && bvv[i][1]) zeroCount=zeroCount+1;
        if(lit2==0 && bvv[i][2]) zeroCount=zeroCount+1;

        if(zeroCount > 0) begin
            case(chosenIndex)
              0: `ASSERT((lit0==0 && bvv[i][0]), ("Zero override failed: picked lit0 but it's not zero? test=%0d", i))
              1: `ASSERT((lit1==0 && bvv[i][1]), ("Zero override failed: picked lit1 but it's not zero? test=%0d", i))
              2: `ASSERT((lit2==0 && bvv[i][2]), ("Zero override failed: picked lit2 but it's not zero? test=%0d", i))
              default: `ASSERT(0, ("Selected out-of-range in zero override test %0d (select=%0d)", i, chosenIndex))
            endcase
        end
        else begin
            `ASSERT(0, ("No zero found but this is the zero-override test! i=%0d", i))
        end
    end

    $display("Case Test 2: random walk (no zero, random_i > P)");
    for(i = TESTS_PER_SECTION; i < TESTS_PER_SECTION*2; i = i + 1) begin
        break_values       = bv[i];
        break_values_valid = bvv[i];
        random_lsfr        = rando[i];
        @(negedge clk);

        chosenIndex = select;
        sel[i]      = select;
        rand_sel[i] = random_selection;

        // Must be random walk
        `ASSERT(random_selection==1, ("Should be random_walk but got random_selection=0 test=%0d", i))

        // Also check none of the breaks are zero
        anyZero = 0;
        for(j=0; j<NSAT; j=j+1) begin
            if(break_values[MCPVB*j +: MCPVB]==0 && bvv[i][j])
                anyZero=1;
        end
        `ASSERT(anyZero==0, ("We expected no zero breaks in section2 test i=%0d", i))
    end

    $display("Case Test 3: min-break logic (no zero, random_walk=off)");
    for(i = TESTS_PER_SECTION*2; i < TESTS_PER_SECTION*3; i = i + 1) begin
        break_values       = bv[i];
        break_values_valid = bvv[i];
        random_lsfr        = rando[i];
        @(negedge clk);

        chosenIndex = select;
        sel[i]      = select;
        rand_sel[i] = random_selection;

        `ASSERT(random_selection==0, ("Expected min-break selection, not random_walk, test=%0d", i))

        litVal[0] = break_values[0 +: MCPVB];
        litVal[1] = break_values[MCPVB +: MCPVB];
        litVal[2] = break_values[2*MCPVB +: MCPVB];

        kMinVal=9999;
        bestMask=0;
        for(j=0; j<3; j=j+1) begin
            if(bvv[i][j]) begin
                if(litVal[j]<kMinVal) begin
                    kMinVal = litVal[j];
                    bestMask = (1<<j);
                end
                else if(litVal[j]==kMinVal) begin
                    bestMask = bestMask|(1<<j);
                end
            end
        end

        `ASSERT((bestMask & (1<<chosenIndex))!=0,
          ("min-break test fail: chosen literal not among min break ties, test=%0d", i))
    end

    $display("Case Test 4: multiple zero-break tie => random among zeros");
    for(i = TESTS_PER_SECTION*3; i < TESTS_PER_SECTION*4; i = i + 1) begin
        break_values       = bv[i];
        break_values_valid = bvv[i];
        random_lsfr        = rando[i];
        @(negedge clk);

        chosenIndex = select;
        sel[i]      = select;
        rand_sel[i] = random_selection;

        zeroMask = 0;
        for(j=0; j<3; j=j+1) begin
            if(bvv[i][j] && (break_values[MCPVB*j +: MCPVB]==0)) begin
                zeroMask = zeroMask | (1<<j);
            end
        end
        `ASSERT(zeroMask!=0, ("No zero break found in multiple-zero-break test? i=%0d", i))
        `ASSERT((zeroMask & (1<<select))!=0,
            ("multiple-zero test fail: picked var %0d not in zeroMask %b at i=%0d",
             select, zeroMask, i))
    end

    $display("Case Test 5: no valid variables => expect select=2'b11");
    for(i = TESTS_PER_SECTION*4; i < TESTS_PER_SECTION*5; i = i + 1) begin
        break_values       = bv[i];
        break_values_valid = bvv[i];
        random_lsfr        = rando[i];
        @(negedge clk);

        chosenIndex = select;
        sel[i]      = select;
        rand_sel[i] = random_selection;

        `ASSERT((select==2'b11),
          ("No valid => expect 2'b11, got %0d, test=%0d", select, i))
    end

    $display("Case Test 6: exactly 1 valid => must pick that index");
    for(i = TESTS_PER_SECTION*5; i < TESTS_PER_SECTION*6; i = i + 1) begin
        break_values       = bv[i];
        break_values_valid = bvv[i];
        random_lsfr        = rando[i];
        @(negedge clk);

        chosenIndex = select;
        sel[i]      = select;
        rand_sel[i] = random_selection;

        validIndex=-1;
        for(j=0; j<3; j=j+1) begin
            if(bvv[i][j]==1'b1) validIndex=j;
        end
        `ASSERT((select==validIndex[1:0]),
          ("1 valid => must pick that var, but got %0d, test=%0d", select, i))
    end

    $display("Case Test 7: 2 valid => random or min pick");
    for(i = TESTS_PER_SECTION*6; i < TESTS_PER_SECTION*7; i = i + 1) begin
        break_values       = bv[i];
        break_values_valid = bvv[i];
        random_lsfr        = rando[i];
        @(negedge clk);

        chosenIndex = select;
        sel[i]      = select;
        rand_sel[i] = random_selection;

        `ASSERT(bvv[i][select]==1'b1,
          ("2 valid => pick must be from valid bits, got invalid var %0d, test=%0d", select, i))
    end

    $display("Case Test 8: 2 valid tie => must pick among the tied min values (randomly if tie).");
    for(i = TESTS_PER_SECTION*7; i < TESTS_PER_SECTION*8; i = i + 1) begin
        break_values       = bv[i];
        break_values_valid = bvv[i];
        random_lsfr        = rando[i];
        @(negedge clk);

        chosenIndex = select;
        sel[i]      = select;
        rand_sel[i] = random_selection;

        count=0;
        for(j=0; j<3; j=j+1) begin
            if(bvv[i][j]) begin
                idx[count] = j;
                count = count+1;
            end
        end
        litX = break_values[MCPVB*idx[0] +: MCPVB];
        litY = break_values[MCPVB*idx[1] +: MCPVB];

        if(litX==litY) begin
            `ASSERT((select==idx[0] || select==idx[1]),
              ("tie => must pick one of those tied, got %0d, test=%0d", select, i))
        end
        else if(litX<litY) begin
            if(random_selection==0) begin
                `ASSERT((select==idx[0]),
                  ("expected var%0d for min, got %0d, test=%0d", idx[0], select, i))
            end
            else begin
                `ASSERT(bvv[i][select]==1'b1,
                  ("random_walk => must pick valid var, got invalid %0d, test=%0d", select, i))
            end
        end
        else begin
            // litY < litX
            if(random_selection==0) begin
                `ASSERT((select==idx[1]),
                  ("expected var%0d for min, got %0d, test=%0d", idx[1], select, i))
            end
            else begin
                `ASSERT(bvv[i][select]==1'b1,
                  ("random_walk => must pick valid var, got invalid %0d, test=%0d", select, i))
            end
        end
    end

    $display("===== Case Test Results =====");
    for(i=0; i<TEST_SECTIONS; i=i+1) begin
        $display("  Test Section %0d: Completed", i+1);
    end
end
endtask


real expected_f;
real difference;

task run_probability_test;
begin
    $display("===== Probability Test Starting... =====");
    random_count = 0;
    for(i = 0; i < PROBABILITY_TEST_COUNT; i = i + 1) begin
        // random inputs
        break_values       = $random;
        break_values_valid = {NSAT{1'b1}};
        random_lsfr        = $random;
        @(negedge clk);

        if(random_selection) random_count = random_count + 1;
    end
    $display("Random Walk Probability Test Results:");
    $display("  Observed random_walk count: %0d / %0d", random_count, PROBABILITY_TEST_COUNT);

    // The expected average with p=~0.57
    expected_f = 0.57 * PROBABILITY_TEST_COUNT;
    difference = random_count - expected_f;
    $display("  Expected random_walk count: ~%.1f => difference=%.1f", expected_f, difference);
end
endtask

endmodule