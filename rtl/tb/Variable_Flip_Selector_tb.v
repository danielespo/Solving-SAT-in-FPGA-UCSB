/*
 Version: 2.3 (Verilog-friendly)
 Variable_Flip_Selector_tb.v

 Testbench for Variable_Flip_Selector.
 This version uses an XOR-based PRNG to generate the random_i input.
 A multiplexer (controlled by "use_prng") selects either the PRNG output or an override
 value (random_override) so that you can force specific values in corner tests.
*/

`timescale 1ns / 1ps

module Variable_Flip_Selector_tb;

// ---------------------------------------------------------------------------
// 1) PARAMETERS
// ---------------------------------------------------------------------------
parameter MAX_CLAUSES_PER_VARIABLE = 20;
parameter NSAT = 3;
parameter MAX_CLAUSES_PER_VARIABLE_BITS = 5;
parameter NSAT_BITS = 2;
parameter P = 32'h6E147AE0; 

localparam MC  = MAX_CLAUSES_PER_VARIABLE;
localparam MCB = MAX_CLAUSES_PER_VARIABLE_BITS;

// We'll keep a certain number of random tests.
parameter NUM_TESTS = 22;

// ---------------------------------------------------------------------------
// 2) SIGNALS & CLOCK
// ---------------------------------------------------------------------------
reg clk_i = 0;
always #5 clk_i = ~clk_i;

reg rst_i;

// ---------------------------------------------------------------------------
// 2a) RANDOM SIGNAL MUX
// Instead of driving random_i directly, we create a multiplexer that selects between
// the PRNG output and a testbench override value.
reg [31:0] random_override;
reg use_prng;  // when 1, random_i is driven by PRNG; when 0, use random_override.
wire [31:0] prng_random_number;
wire [31:0] random_i_wire;
assign random_i_wire = use_prng ? prng_random_number : random_override;

// ---------------------------------------------------------------------------
// 3) DATA INPUTS TO THE UUT
// (Other signals remain as before.)
reg [MC - 1 : 0] clause_broken_i;
reg [MC - 1 : 0] mask_bits_i;
reg [NSAT - 1 : 0] break_values_valid_i;
// Now, instead of a reg for random_i, we drive the UUT with random_i_wire:
reg [NSAT_BITS - 1 : 0] wr_en_i; 

// Data outputs
wire [NSAT_BITS - 1 : 0] selected_o;
wire [MC - 1 : 0]        clause_valid_bits_o;

// ---------------------------------------------------------------------------
// 4) UUT INSTANTIATION
// ---------------------------------------------------------------------------
Variable_Flip_Selector #(
    .MAX_CLAUSES_PER_VARIABLE(MAX_CLAUSES_PER_VARIABLE),
    .NSAT(NSAT),
    .P(P)
) uut (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .clause_broken_i(clause_broken_i),
    .mask_bits_i(mask_bits_i),
    .break_values_valid_i(break_values_valid_i),
    .random_i(random_i_wire),
    .wr_en_i(wr_en_i),
    .selected_o(selected_o),
    .clause_valid_bits_o(clause_valid_bits_o)
);

// ---------------------------------------------------------------------------
// 5) PRNG INSTANTIATION
// Use the provided XOR_PRNG module. Note: We connect clk_i and rst_i.
XOR_PRNG prng_inst (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .data_o(prng_random_number)
);

// ---------------------------------------------------------------------------
// 6) STORAGE FOR TEST VECTORS (for random tests)
// (These remain for the tests that want to override the PRNG.)
reg [MC-1:0] break_bits_0 [0:NUM_TESTS-1];
reg [MC-1:0] break_bits_1 [0:NUM_TESTS-1];
reg [MC-1:0] break_bits_2 [0:NUM_TESTS-1];

reg [MC-1:0] mask_bits_0 [0:NUM_TESTS-1];
reg [MC-1:0] mask_bits_1 [0:NUM_TESTS-1];
reg [MC-1:0] mask_bits_2 [0:NUM_TESTS-1];

reg [NSAT-1:0] break_valid_mem [0:NUM_TESTS-1];

reg [31:0] test_random_0 [0:NUM_TESTS-1];
reg [31:0] test_random_1 [0:NUM_TESTS-1];
reg [31:0] test_random_2 [0:NUM_TESTS-1];
reg [31:0] test_random_3 [0:NUM_TESTS-1];
reg [31:0] test_random_4 [0:NUM_TESTS-1];

reg [NUM_TESTS-1:0] test_pass;
reg [$clog2(NUM_TESTS)-1:0] num_passed;

// ---------------------------------------------------------------------------
// 7) POPCOUNT FUNCTION (pure Verilog style)
// ---------------------------------------------------------------------------
function [4:0] popcount;
    input [MC-1:0] bitsIn; 
    integer i;
    reg [4:0] tmp;
begin
    tmp = 0;
    for(i=0; i<MC; i=i+1) begin
        tmp = tmp + bitsIn[i];
    end
    popcount = tmp;
end
endfunction

// ---------------------------------------------------------------------------
// 8) TEST GENERATION (for random tests)
// ---------------------------------------------------------------------------
task generate_test_data;
integer t;
begin
    $display("Generating random test data... (NUM_TESTS=%0d)", NUM_TESTS);
    for(t=0; t<NUM_TESTS; t=t+1) begin
        break_bits_0[t] = $random;
        break_bits_1[t] = $random;
        break_bits_2[t] = $random;

        mask_bits_0[t]  = $random;
        mask_bits_1[t]  = $random;
        mask_bits_2[t]  = $random;

        break_valid_mem[t] = 3'b111; // All candidates valid for random tests

        test_random_0[t] = $random;
        test_random_1[t] = $random;
        test_random_2[t] = $random;
        test_random_3[t] = $random;
        test_random_4[t] = $random;
    end
end
endtask

// ---------------------------------------------------------------------------
// 9) ORIGINAL RUN_TESTS TASK (random tests)
// In these tests we override the PRNG by setting use_prng = 0 and driving random_override.
// ---------------------------------------------------------------------------
task run_tests;
integer test_i;
begin
    for(test_i=0; test_i<NUM_TESTS; test_i=test_i+1) begin
        use_prng = 0;  // Override random_i with test vectors.

        // 1) Idle
        clause_broken_i      = 20'b0;
        mask_bits_i          = 20'b0;
        random_override      = test_random_0[test_i];
        wr_en_i              = 2'b00;
        break_values_valid_i = 3'b000;
        @(negedge clk_i);

        // 2) partial flip for literal0
        clause_broken_i      = break_bits_0[test_i];
        mask_bits_i          = mask_bits_0[test_i];
        random_override      = test_random_1[test_i];
        wr_en_i              = 2'b01;
        @(negedge clk_i);

        // 3) partial flip for literal1
        clause_broken_i      = break_bits_1[test_i];
        mask_bits_i          = mask_bits_1[test_i];
        random_override      = test_random_2[test_i];
        wr_en_i              = 2'b10;
        @(negedge clk_i);

        // 4) partial flip for literal2 => final selection
        clause_broken_i      = break_bits_2[test_i];
        mask_bits_i          = mask_bits_2[test_i];
        random_override      = test_random_3[test_i];
        wr_en_i              = 2'b11; 
        break_values_valid_i = break_valid_mem[test_i];
        @(negedge clk_i);

        // 5) Idle again
        clause_broken_i      = 20'b0;
        mask_bits_i          = 20'b0;
        random_override      = test_random_4[test_i];
        wr_en_i              = 2'b00;
        break_values_valid_i = 3'b000;
        @(negedge clk_i);

        // Do partial check
        partial_check(test_i);

        // Extra settle cycles
        @(negedge clk_i);
        @(negedge clk_i);
        @(negedge clk_i);
    end
end
endtask

// ---------------------------------------------------------------------------
// 10) PARTIAL_CHECK TASK (existing partial check)
// ---------------------------------------------------------------------------
task automatic partial_check(input integer tidx);
reg [1:0] chosen;
reg [4:0] brCount0, brCount1, brCount2;
reg [2:0] validMask;
reg [2:0] zeroMask;
reg [2:0] minMask;
reg hasZero;
reg rwalk;
integer minVal;
reg [MC-1:0] chosen_bits;
begin
    chosen = selected_o;

    // Compute break count for literal0..2
    brCount0 = popcount(break_bits_0[tidx] & mask_bits_0[tidx]);
    brCount1 = popcount(break_bits_1[tidx] & mask_bits_1[tidx]);
    brCount2 = popcount(break_bits_2[tidx] & mask_bits_2[tidx]);

    validMask = break_valid_mem[tidx];

    zeroMask[0] = (validMask[0] && (brCount0==0)) ? 1'b1 : 1'b0;
    zeroMask[1] = (validMask[1] && (brCount1==0)) ? 1'b1 : 1'b0;
    zeroMask[2] = (validMask[2] && (brCount2==0)) ? 1'b1 : 1'b0;
    hasZero = (zeroMask != 0);

    rwalk = (test_random_3[tidx] > P);  // using the test vector value for comparison

    // Find minimum among valid candidates
    minVal = 9999;
    minMask = 3'b000;
    if(validMask[0]) begin
        if(brCount0 < minVal) begin
            minVal = brCount0;
            minMask = 3'b001;
        end else if(brCount0 == minVal)
            minMask = minMask | 3'b001;
    end
    if(validMask[1]) begin
        if(brCount1 < minVal) begin
            minVal = brCount1;
            minMask = 3'b010;
        end else if(brCount1 == minVal)
            minMask = minMask | 3'b010;
    end
    if(validMask[2]) begin
        if(brCount2 < minVal) begin
            minVal = brCount2;
            minMask = 3'b100;
        end else if(brCount2 == minVal)
            minMask = minMask | 3'b100;
    end

    // Check selection according to WSAT/SKC rules:
    if(hasZero) begin
        if( (zeroMask & (1<<chosen)) == 0 ) begin
            $display("Test %0d FAIL: hasZero => chosen literal %0d not in zeroMask %b", tidx, chosen, zeroMask);
            test_pass[tidx] = 1'b0;
        end
    end else if(rwalk) begin
        if(~validMask[chosen]) begin
            $display("Test %0d FAIL: random_walk => chosen literal %0d not valid. validMask=%b", tidx, chosen, validMask);
            test_pass[tidx] = 1'b0;
        end
    end else begin
        if( (minMask & (1<<chosen))==0 ) begin
            $display("Test %0d FAIL: min-break => chosen literal %0d not in minMask %b", tidx, chosen, minMask);
            test_pass[tidx] = 1'b0;
        end
    end

    // Check clause_valid_bits_o against the expected masked break bits
    case(chosen)
      2'b00: chosen_bits = break_bits_0[tidx] & mask_bits_0[tidx];
      2'b01: chosen_bits = break_bits_1[tidx] & mask_bits_1[tidx];
      2'b10: chosen_bits = break_bits_2[tidx] & mask_bits_2[tidx];
      default: chosen_bits = {MC{1'b0}};
    endcase

    if(clause_valid_bits_o !== chosen_bits) begin
        $display("Test %0d FAIL: clause_valid_bits_o mismatch. Got %b, expected %b",
            tidx, clause_valid_bits_o, chosen_bits);
        test_pass[tidx] = 1'b0;
    end
end
endtask

// ---------------------------------------------------------------------------
// 11) CORNER CASE TESTS
// For corner tests we disable the PRNG override by setting use_prng = 0 and drive known values.
// ---------------------------------------------------------------------------
task run_corner_tests;
integer corner_test_count;
begin
    corner_test_count = 0;
    $display("Running corner case tests...");

    // Corner Test 1: Only candidate0 is valid.
    $display("Corner Test 1: Only candidate0 valid");
    use_prng = 0;
    // Idle
    clause_broken_i = 20'b0; mask_bits_i = 20'b0; random_override = 32'h0; wr_en_i = 2'b00; break_values_valid_i = 3'b000; @(negedge clk_i);
    // Candidate0
    clause_broken_i = 20'h00003; mask_bits_i = 20'hFFFFF; random_override = 32'h0; wr_en_i = 2'b01; @(negedge clk_i);
    // Candidate1 (invalid)
    clause_broken_i = 20'h00123; mask_bits_i = 20'hFFFFF; random_override = 32'h0; wr_en_i = 2'b10; @(negedge clk_i);
    // Candidate2 (invalid) → final selection
    clause_broken_i = 20'h04567; mask_bits_i = 20'hFFFFF; random_override = 32'h0; wr_en_i = 2'b11;
    // Mark only candidate0 valid. (Bit 0 = 1)
    break_values_valid_i = 3'b001; @(negedge clk_i);
    // Idle
    clause_broken_i = 20'b0; mask_bits_i = 20'b0; random_override = 32'h0; wr_en_i = 2'b00; break_values_valid_i = 3'b000; @(negedge clk_i);
    if(selected_o !== 2'b00)
       $display("Corner Test 1 FAIL: expected candidate0, got %b", selected_o);
    else begin
       $display("Corner Test 1 PASS");
       corner_test_count = corner_test_count + 1;
    end

    // Corner Test 2: All candidates have zero break count.
    $display("Corner Test 2: All candidates have break count zero");
    clause_broken_i = 20'b0; mask_bits_i = 20'b0; random_override = 32'h0; wr_en_i = 2'b00; break_values_valid_i = 3'b000; @(negedge clk_i);
    clause_broken_i = 20'h00000; mask_bits_i = 20'hFFFFF; random_override = 32'h10; wr_en_i = 2'b01; @(negedge clk_i);
    clause_broken_i = 20'h00000; mask_bits_i = 20'hFFFFF; random_override = 32'h20; wr_en_i = 2'b10; @(negedge clk_i);
    clause_broken_i = 20'h00000; mask_bits_i = 20'hFFFFF; random_override = 32'h30; wr_en_i = 2'b11;
    break_values_valid_i = 3'b111; @(negedge clk_i);
    clause_broken_i = 20'b0; mask_bits_i = 20'b0; random_override = 32'h0; wr_en_i = 2'b00; break_values_valid_i = 3'b000; @(negedge clk_i);
    if((selected_o != 2'b00) && (selected_o != 2'b01) && (selected_o != 2'b10))
       $display("Corner Test 2 FAIL: expected candidate among 0,1,or 2, got %b", selected_o);
    else begin
       $display("Corner Test 2 PASS");
       corner_test_count = corner_test_count + 1;
    end

    // Corner Test 3: All candidates have identical nonzero break counts.
    $display("Corner Test 3: Identical nonzero break counts");
    clause_broken_i = 20'b0; mask_bits_i = 20'b0; random_override = 32'h0; wr_en_i = 2'b00; break_values_valid_i = 3'b000; @(negedge clk_i);
    clause_broken_i = 20'h00003; mask_bits_i = 20'hFFFFF; random_override = 32'h5; wr_en_i = 2'b01; @(negedge clk_i);
    clause_broken_i = 20'h00003; mask_bits_i = 20'hFFFFF; random_override = 32'h5; wr_en_i = 2'b10; @(negedge clk_i);
    clause_broken_i = 20'h00003; mask_bits_i = 20'hFFFFF; random_override = 32'h5; wr_en_i = 2'b11;
    break_values_valid_i = 3'b111; @(negedge clk_i);
    clause_broken_i = 20'b0; mask_bits_i = 20'b0; random_override = 32'h0; wr_en_i = 2'b00; break_values_valid_i = 3'b000; @(negedge clk_i);
    if((selected_o != 2'b00) && (selected_o != 2'b01) && (selected_o != 2'b10))
       $display("Corner Test 3 FAIL: expected candidate among 0,1,or 2, got %b", selected_o);
    else begin
       $display("Corner Test 3 PASS");
       corner_test_count = corner_test_count + 1;
    end

    // Corner Test 4: No valid candidate (all invalid).
    $display("Corner Test 4: No valid candidate");
    clause_broken_i = 20'b0; mask_bits_i = 20'b0; random_override = 32'h0; wr_en_i = 2'b00; break_values_valid_i = 3'b000; @(negedge clk_i);
    clause_broken_i = 20'h00005; mask_bits_i = 20'hFFFFF; random_override = 32'h0; wr_en_i = 2'b01; @(negedge clk_i);
    clause_broken_i = 20'h00007; mask_bits_i = 20'hFFFFF; random_override = 32'h0; wr_en_i = 2'b10; @(negedge clk_i);
    clause_broken_i = 20'h00009; mask_bits_i = 20'hFFFFF; random_override = 32'h0; wr_en_i = 2'b11;
    break_values_valid_i = 3'b000; @(negedge clk_i);
    clause_broken_i = 20'b0; mask_bits_i = 20'b0; random_override = 32'h0; wr_en_i = 2'b00; break_values_valid_i = 3'b000; @(negedge clk_i);
    // With no valid candidate, the design defaults to 2'b11.
    if(selected_o !== 2'b11)
       $display("Corner Test 4 FAIL: expected no valid candidate (2'b11), got %b", selected_o);
    else begin
       $display("Corner Test 4 PASS");
       corner_test_count = corner_test_count + 1;
    end     

    $display("Corner Tests Completed: %0d/4 passed", corner_test_count);
end
endtask

// ---------------------------------------------------------------------------
// 12) UPDATED CONTINUOUS THROUGHPUT TESTS WITH VALID SIGNALS DRIVEN FOR ALL CANDIDATES
// ---------------------------------------------------------------------------
task run_continuous_tests;
    integer i;
    integer cycle_count;
    reg [31:0] random_used;  // capture PRNG value at candidate2 phase
    reg rwalk;
    begin
      $display("Running continuous throughput test with cycle count measurement...");
      cycle_count = 0;
      use_prng = 1;  // use PRNG output for random_i in continuous tests.
      // Run 50 continuous sequences of the complete candidate update and selection.
      for (i = 0; i < 50; i = i + 1) begin
         // Idle cycle
         clause_broken_i = 20'b0; 
         mask_bits_i     = 20'b0; 
         wr_en_i         = 2'b00; 
         break_values_valid_i = 3'b000; 
         @(negedge clk_i); 
         cycle_count = cycle_count + 1;
         
         // Candidate0: fixed pattern (higher break count)
         clause_broken_i = 20'h00003; 
         mask_bits_i     = 20'hFFFFF; 
         wr_en_i         = 2'b01; 
         break_values_valid_i = 3'b000; // drive valid signal for candidate0
         @(negedge clk_i); 
         cycle_count = cycle_count + 1;
         
         // Candidate1: lower break count.
         clause_broken_i = 20'h00002; 
         mask_bits_i     = 20'hFFFFF; 
         wr_en_i         = 2'b10;
         break_values_valid_i = 3'b111; // drive valid signal for candidate0 
         @(negedge clk_i); 
         cycle_count = cycle_count + 1;
         
         // Candidate2: lowest break count (final selection)
         clause_broken_i = 20'h00001; 
         mask_bits_i     = 20'hFFFFF; 
         wr_en_i         = 2'b11;
         break_values_valid_i = 3'b111; // drive valid signal for candidate0  
         @(negedge clk_i); 
         cycle_count = cycle_count + 1;
         
         // Capture the PRNG value used at candidate2 stage.
         random_used = prng_random_number;
         rwalk = (random_used > P);
         @(negedge clk_i);
         
         // Idle cycle to allow output to settle.
         clause_broken_i = 20'b0; 
         mask_bits_i     = 20'b0; 
         wr_en_i         = 2'b00; 
         break_values_valid_i = 3'b000; 
         @(negedge clk_i); 
         cycle_count = cycle_count + 1;
         
         // Check selection:
         // If random_walk is active, any candidate (0,1, or 2) is acceptable.
         // Otherwise (greedy mode) only candidate 1 or candidate 2 should be chosen.
         if (!rwalk) begin
           if((selected_o != 2'b01) && (selected_o != 2'b10))
             $display("Continuous Test FAIL at iteration %0d (greedy mode): expected candidate 1 or 2, got %b", i, selected_o);
         end else begin
           if((selected_o != 2'b00) && (selected_o != 2'b01) && (selected_o != 2'b10))
             $display("Continuous Test FAIL at iteration %0d (random walk mode): expected candidate 0, 1, or 2, got %b", i, selected_o);
         end
      end
      $display("Continuous throughput test completed. Total cycles for 50 sequences = %0d, average = %0d cycles per sequence", 
                cycle_count, cycle_count/50);
    end
  endtask  
  
// ---------------------------------------------------------------------------
// 13) INITIAL BLOCK
// ---------------------------------------------------------------------------
initial begin
    $display("Variable Flip Selector TB: Begin Simulation");
    generate_test_data();

    // Initialize signals
    clause_broken_i      = 0;
    mask_bits_i          = 0;
    break_values_valid_i = 0;
    // For controlled tests, default the override to 0.
    random_override      = 32'h0;
    use_prng             = 0;
    wr_en_i              = 0;
    test_pass            = {NUM_TESTS{1'b1}};
    num_passed           = 0;

    // Reset
    rst_i = 1;
    @(negedge clk_i); @(negedge clk_i);
    rst_i = 0;
    $display("Running random tests with partial correctness checks...");
    run_tests();

    $display("Running corner case tests...");
    run_corner_tests();

    $display("Running continuous throughput tests...");
    run_continuous_tests();

    // Summarize random test results.
    begin : summary_block
        integer idx;
        for(idx=0; idx<NUM_TESTS; idx=idx+1) begin
            if(test_pass[idx]) num_passed = num_passed + 1;
        end
    end

    $display("Variable Flip Selector TB: End Simulation");
    $display("    Random Test Results: %0d/%0d tests passed (partial checks).", num_passed, NUM_TESTS);
    $finish;
end

endmodule
