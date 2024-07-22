/*
Temporal_Buffer_Wrapper_tb.v
Author: Zeiler

Description: 
Testbench file for Temporal_Buffer_Wrapper.v

Notes:
- In progress

Status: testbench constructed and passes linter
*/
`timescale 1ns / 1ps

//`define VERBOSE_TEST

module Temporal_Buffer_Wrapper_tb;
parameter NSAT = 3;
parameter LITERAL_ADDRESS_WIDTH = 4;
parameter MAX_CLAUSES_PER_VARIABLE = 1;
parameter NSAT_BITS = 2;

parameter NUM_TESTS = 10;

parameter CT_WIDTH = NSAT*MAX_CLAUSES_PER_VARIABLE*(LITERAL_ADDRESS_WIDTH+1);
parameter LOAD_CONST_DIV = CT_WIDTH / 32;
parameter LOAD_CONST_REM = CT_WIDTH % 32;

// Inputs
reg clk = 0;
always #5 clk <= ~clk;
reg reset;

reg [NSAT_BITS-1:0] wr_index;
    // note: this is equal to 20*12 = 240 bits
reg [MAX_CLAUSES_PER_VARIABLE*(LITERAL_ADDRESS_WIDTH+1)-1:0] flipped_literals;
    // note: this is equal to 2*20*12 = 480 bits
reg [(NSAT-1)*MAX_CLAUSES_PER_VARIABLE*(LITERAL_ADDRESS_WIDTH+1)-1:0] clause_table_literals;

reg [NSAT_BITS-1:0] re_index;

// Outputs
    // note: this is equal to 3*20*12 = 720 bits
wire [NSAT*MAX_CLAUSES_PER_VARIABLE*(LITERAL_ADDRESS_WIDTH+1)-1:0] clauses_out;

// Instantiate the Unit Under Test (UUT)
Temporal_Buffer_Wrapper #(
    .NSAT(NSAT),
    .LITERAL_ADDRESS_WIDTH(LITERAL_ADDRESS_WIDTH),
    .MAX_CLAUSES_PER_VARIABLE(MAX_CLAUSES_PER_VARIABLE),
    .NSAT_BITS(NSAT_BITS)
) uut (
    .clk(clk), .reset(reset),
    .write_index_i(wr_index),
    .flipped_literal_multi_i(flipped_literals),
    .clause_table_literals_multi_i(clause_table_literals),
    .read_index_i(re_index),
    .clause_multi_o(clauses_out)
);

/*
Testing brainstorm:

Essentially, all we need for this testbench is a way to load 3 sets of 
literals in (using the write index) and then select one of those three sets,
and then check it against the inputs.

Should probably check back to back runs to ensure continuous functionality

need to:
    (assuming default parameters)
    generate 36*20 = 720 bits randomly, NUM_TESTS times - maybe use separate 
        registers for each flip
    separate those bits (12 - 24) to load them into the respective inputs
      > this can be done by putting it all into a register file and then 
        assigning wires connecting to the UUT to the respective bit ranges
    generate some counter from 0 to 2 for the 'flips'
    choose one of the three flips to try to read
    compare that flip with stored data
    repeat in different situations 
*/

// test signals
wire [NSAT*MAX_CLAUSES_PER_VARIABLE*(LITERAL_ADDRESS_WIDTH+1)-1:0] clauses_in;
assign clauses_in = {clause_table_literals, flipped_literals};

/* testing constructs */
    // each of these stores a set of 'clauses' (720 bits in default params)
    reg [NSAT*MAX_CLAUSES_PER_VARIABLE*(LITERAL_ADDRESS_WIDTH+1)-1:0] flips_0 [NUM_TESTS-1:0];  
    reg [NSAT*MAX_CLAUSES_PER_VARIABLE*(LITERAL_ADDRESS_WIDTH+1)-1:0] flips_1 [NUM_TESTS-1:0];
    reg [NSAT*MAX_CLAUSES_PER_VARIABLE*(LITERAL_ADDRESS_WIDTH+1)-1:0] flips_2 [NUM_TESTS-1:0];
    
    // for-loop variables
    integer i, j, test_i;
    // using verilog's built in $urandom number generation, we can create a
    // 32-bit random number. If we concatenation these bits, we can create 
    // any n-bit random number, in this case 720/32 = 22.5 so we need 23 loops

    // test flags:
    reg passed;
    reg [31:0] tests_passed;

initial begin
    // generate random values for the flip arrays
    passed = 1'b0;
    tests_passed = 32'b0;
    $display("NSAT*MAX_CLAUSES_PER_VARIABLE*(LITERAL_ADDRESS_WIDTH+1)-1:0 = %d:0", NSAT*MAX_CLAUSES_PER_VARIABLE*(LITERAL_ADDRESS_WIDTH+1)-1);
    for(i = 0; i < NUM_TESTS; i = i + 1) begin
        // assign 32 bits at a time
        for(j = 0; j < LOAD_CONST_DIV; j = j + 1) begin
            flips_0[i][32*j+:32] = $random;
            flips_1[i][32*j+:32] = $random;
            flips_2[i][32*j+:32] = $random;
            // this is not allowed because both sides of range cannot be variables
            // flips_0[i][32*(j+1)-1:32*j] = $random;
            // flips_1[i][32*(j+1)-1:32*j] = $random;
            // flips_2[i][32*(j+1)-1:32*j] = $random;
        end
        flips_0[i][CT_WIDTH-1 -: LOAD_CONST_REM] = $random;
        flips_1[i][CT_WIDTH-1 -: LOAD_CONST_REM] = $random;
        flips_2[i][CT_WIDTH-1 -: LOAD_CONST_REM] = $random;
        // $display("flips_0 range: %h", flips_0[i][CT_WIDTH-1 -: LOAD_CONST_REM]);
        // $display("flips_0 full value: %h", flips_0[i]);
    end

    $display("Temporal Buffer Wrapper: Begin Simulation");

    // reset the system
    wr_index = 0;
    re_index = 0;

    reset = 1;
    @(negedge clk);
    @(negedge clk);
    reset = 0;

    // do tests
    for(test_i = 0; test_i < NUM_TESTS; test_i = test_i + 1) begin
        $display("Beginning test #%x at time %t", test_i, $time);

        $display("    writing clauses from flip 0");
        wr_index = 0;
        for(i = 0; i < MAX_CLAUSES_PER_VARIABLE; i = i + 1) begin
            // assuming tests_i = 0, NSAT = 3, LITERAL_ADDRESS_WIDTH = 11, i = 0 : 
            // flipped_literals[12-1:0] = flips_0[0][12-1:0];
            // clause_table_literals[24-1:0] = flips_0[0][36-1:12];
            // assuming tests_i = 0, NSAT = 3, LITERAL_ADDRESS_WIDTH = 11, i = 1 : 
            // flipped_literals[24-1:12] = flips_0[0][48-1:36];
            // clause_table_literals[48-1:24] = flips_0[0][72-1:48];
            
            // not allowed for because cannot have vars on both side of range
//            flipped_literals[(i+1)*(LITERAL_ADDRESS_WIDTH+1)-1:i*(LITERAL_ADDRESS_WIDTH+1)] = flips_0[test_i][(i*NSAT+1)*(LITERAL_ADDRESS_WIDTH+1)-1:(i*NSAT)*(LITERAL_ADDRESS_WIDTH+1)];
//            clause_table_literals[(i+1)*(NSAT-1)*(LITERAL_ADDRESS_WIDTH+1)-1:i*(NSAT-1)*(LITERAL_ADDRESS_WIDTH+1)] flips_0[test_i][(i*NSAT+NSAT)*(LITERAL_ADDRESS_WIDTH+1)-1:(i*NSAT+1)*(LITERAL_ADDRESS_WIDTH+1)];
            flipped_literals[i*(LITERAL_ADDRESS_WIDTH+1)+:(LITERAL_ADDRESS_WIDTH+1)] = flips_0[test_i][(i*NSAT)*(LITERAL_ADDRESS_WIDTH+1)+:(LITERAL_ADDRESS_WIDTH+1)];
            clause_table_literals[i*(NSAT-1)*(LITERAL_ADDRESS_WIDTH+1)+:(NSAT-1)*(LITERAL_ADDRESS_WIDTH+1)] = flips_0[test_i][(i*NSAT+1)*(LITERAL_ADDRESS_WIDTH+1)+:(NSAT-1)*(LITERAL_ADDRESS_WIDTH+1)];
            `ifdef VERBOSE_TEST
            $display("      flipped literals from data: %b", flips_0[test_i][(i*NSAT)*(LITERAL_ADDRESS_WIDTH+1)+:(LITERAL_ADDRESS_WIDTH+1)]);
            $display("      flipped literals from vari: %b", flipped_literals[i*(LITERAL_ADDRESS_WIDTH+1)+:(LITERAL_ADDRESS_WIDTH+1)]);
            $display("      clause table literals data: %b", flips_0[test_i][(i*NSAT+1)*(LITERAL_ADDRESS_WIDTH+1)+:(NSAT-1)*(LITERAL_ADDRESS_WIDTH+1)]);
            $display("      clause table literals vari: %b", clause_table_literals[i*(NSAT-1)*(LITERAL_ADDRESS_WIDTH+1)+:(NSAT-1)*(LITERAL_ADDRESS_WIDTH+1)]);
            $display("      full literal:     %b", flips_0[test_i][i*(LITERAL_ADDRESS_WIDTH+1)+:NSAT*(LITERAL_ADDRESS_WIDTH+1)]);
            `endif
//            $display("      full literal uut: %b", uut.gen_temp_buf[0].TB.stored_clauses[0]);

        end

        // wait for clock
        @(negedge clk);
        $display("    writing clauses from flip 1");
        wr_index = 1;
        for(i = 0; i < MAX_CLAUSES_PER_VARIABLE; i = i + 1) begin
            flipped_literals[i*(LITERAL_ADDRESS_WIDTH+1)+:(LITERAL_ADDRESS_WIDTH+1)] = flips_1[test_i][(i*NSAT)*(LITERAL_ADDRESS_WIDTH+1)+:(LITERAL_ADDRESS_WIDTH+1)];
            clause_table_literals[i*(NSAT-1)*(LITERAL_ADDRESS_WIDTH+1)+:(NSAT-1)*(LITERAL_ADDRESS_WIDTH+1)] = flips_1[test_i][(i*NSAT+1)*(LITERAL_ADDRESS_WIDTH+1)+:(NSAT-1)*(LITERAL_ADDRESS_WIDTH+1)];
            `ifdef VERBOSE_TEST
            $display("      flipped literals from data: %b", flips_1[test_i][(i*NSAT)*(LITERAL_ADDRESS_WIDTH+1)+:(LITERAL_ADDRESS_WIDTH+1)]);
            $display("      flipped literals from vari: %b", flipped_literals[i*(LITERAL_ADDRESS_WIDTH+1)+:(LITERAL_ADDRESS_WIDTH+1)]);
            $display("      clause table literals data: %b", flips_1[test_i][(i*NSAT+1)*(LITERAL_ADDRESS_WIDTH+1)+:(NSAT-1)*(LITERAL_ADDRESS_WIDTH+1)]);
            $display("      clause table literals vari: %b", clause_table_literals[i*(NSAT-1)*(LITERAL_ADDRESS_WIDTH+1)+:(NSAT-1)*(LITERAL_ADDRESS_WIDTH+1)]);
            $display("      full literal:     %b", flips_1[test_i][i*(LITERAL_ADDRESS_WIDTH+1)+:NSAT*(LITERAL_ADDRESS_WIDTH+1)]);
            `endif
        end

        // wait for clock
        @(negedge clk);
        $display("    writing clauses from flip 2");
        wr_index = 2;
        re_index = $urandom%3;
        $display("    selected flip %d to read", re_index);
        for(i = 0; i < MAX_CLAUSES_PER_VARIABLE; i = i + 1) begin
            flipped_literals[i*(LITERAL_ADDRESS_WIDTH+1)+:(LITERAL_ADDRESS_WIDTH+1)] = flips_2[test_i][(i*NSAT)*(LITERAL_ADDRESS_WIDTH+1)+:(LITERAL_ADDRESS_WIDTH+1)];
            clause_table_literals[i*(NSAT-1)*(LITERAL_ADDRESS_WIDTH+1)+:(NSAT-1)*(LITERAL_ADDRESS_WIDTH+1)] = flips_2[test_i][(i*NSAT+1)*(LITERAL_ADDRESS_WIDTH+1)+:(NSAT-1)*(LITERAL_ADDRESS_WIDTH+1)];
            `ifdef VERBOSE_TEST
            $display("      flipped literals from data: %b", flips_2[test_i][(i*NSAT)*(LITERAL_ADDRESS_WIDTH+1)+:(LITERAL_ADDRESS_WIDTH+1)]);
            $display("      flipped literals from vari: %b", flipped_literals[i*(LITERAL_ADDRESS_WIDTH+1)+:(LITERAL_ADDRESS_WIDTH+1)]);
            $display("      clause table literals data: %b", flips_2[test_i][(i*NSAT+1)*(LITERAL_ADDRESS_WIDTH+1)+:(NSAT-1)*(LITERAL_ADDRESS_WIDTH+1)]);
            $display("      clause table literals vari: %b", clause_table_literals[i*(NSAT-1)*(LITERAL_ADDRESS_WIDTH+1)+:(NSAT-1)*(LITERAL_ADDRESS_WIDTH+1)]);
            $display("      full literal:     %b", flips_2[test_i][i*(LITERAL_ADDRESS_WIDTH+1)+:NSAT*(LITERAL_ADDRESS_WIDTH+1)]);
            `endif
        end

        // wait for clk
        @(negedge clk);
        $display("    reading data from flip %d: %b", re_index, clauses_out);
        case (re_index)
            0 : if(clauses_out == flips_0[test_i]) passed = 1'b1;
            1 : if(clauses_out == flips_1[test_i]) passed = 1'b1;
            2 : if(clauses_out == flips_2[test_i]) passed = 1'b1;
            default: $display("    read index invalid");
        endcase
        if(passed == 1'b1) begin
            $display("    expected output: test passed");
            tests_passed = tests_passed + 1;
        end
        else $display("    unexpected output: test failed");
        passed = 1'b0;
    end
    $display("Temporal Buffer Wrapper: End Simulation");
    $display("    Passed %d/%d tests", tests_passed, NUM_TESTS);     
    $finish;
end

endmodule
