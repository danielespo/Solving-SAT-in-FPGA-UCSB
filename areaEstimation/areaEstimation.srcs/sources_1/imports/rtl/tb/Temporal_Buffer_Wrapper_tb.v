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

module Temporal_Buffer_Wrapper_tb;
parameter NSAT = 3;
parameter LITERAL_ADDRESS_WIDTH = 11;
parameter MAX_CLAUSES_PER_VARIABLE = 20;
parameter NSAT_BITS = 2;

parameter NUM_TESTS = 31;

parameter CT_WIDTH = (NSAT-1)*MAX_CLAUSES_PER_VARIABLE*(LITERAL_ADDRESS_WIDTH+1);
parameter LOAD_CONST_DIV = CT_WIDTH / 32;
parameter LOAD_CONST_REM = CT_WIDTH % 32;

// Inputs
reg clk = 0;
always #5 clk <= ~clk;
reg reset;

reg [NSAT_BITS-1:0] wr_index;
reg wr_en;
    // note: this is equal to 2*20*12 = 480 bits
reg [(NSAT-1)*MAX_CLAUSES_PER_VARIABLE*(LITERAL_ADDRESS_WIDTH+1)-1:0] literals_in;

reg [NSAT_BITS-1:0] re_index;

// Outputs
    // note: this is equal to 2*20*12 = 480 bits
wire [(NSAT-1)*MAX_CLAUSES_PER_VARIABLE*(LITERAL_ADDRESS_WIDTH+1)-1:0] literals_out;

// Instantiate the Unit Under Test (UUT)
Temporal_Buffer_Wrapper #(
    .NSAT(NSAT),
    .LAW(LITERAL_ADDRESS_WIDTH),
    .MCPV(MAX_CLAUSES_PER_VARIABLE),
    .NSAT_BITS(NSAT_BITS)
) uut (
    .clk(clk), .reset(reset),
    .write_index_i(wr_index),
    .write_en_i(wr_en),
    .literals_multi_i(literals_in),
    .read_index_i(re_index),
    .literals_multi_o(literals_out)
);

/*
Testing brainstorm:

Essentially, all we need for this testbench is a way to load 3 sets of 
literals in (using the write index) and then select one of those three sets,
and then check it against the inputs.

Should probably check back to back runs to ensure continuous functionality

need to:
    (assuming default parameters)
    generate 24*20 = 480 bits randomly, NUM_TESTS times 
      - maybe use separate registers for each flip
    generate some counter from 0 to 2 for the 'flips'
    choose one of the three flips to try to read
    compare that flip with stored data
    repeat in different situations 
*/

/* testing constructs */
    // each of these stores a set of 'clauses' (720 bits in default params)
    reg [(NSAT-1)*MAX_CLAUSES_PER_VARIABLE*(LITERAL_ADDRESS_WIDTH+1)-1:0] flips_0 [NUM_TESTS-1:0];  
    reg [(NSAT-1)*MAX_CLAUSES_PER_VARIABLE*(LITERAL_ADDRESS_WIDTH+1)-1:0] flips_1 [NUM_TESTS-1:0];
    reg [(NSAT-1)*MAX_CLAUSES_PER_VARIABLE*(LITERAL_ADDRESS_WIDTH+1)-1:0] flips_2 [NUM_TESTS-1:0];
    
    // for-loop variables
    integer i, j, test_i;
    // using verilog's built in $urandom number generation, we can create a
    // 32-bit random number. If we concatenation these bits, we can create 
    // any n-bit random number, in this case 480/32 = 15 so we need 15 loops

    // test flags:
    reg passed;
    reg [31:0] tests_passed;

initial begin
    // generate random values for the flip arrays
    passed = 1'b0;
    tests_passed = 32'b0;
    $display("(NSAT-1)*MAX_CLAUSES_PER_VARIABLE*(LITERAL_ADDRESS_WIDTH+1)-1:0 = %d:0", (NSAT-1)*MAX_CLAUSES_PER_VARIABLE*(LITERAL_ADDRESS_WIDTH+1)-1);
    for(i = 0; i < NUM_TESTS; i = i + 1) begin
        // assign 32 bits at a time
        for(j = 0; j < LOAD_CONST_DIV; j = j + 1) begin
            flips_0[i][32*j+:32] = $random;
            flips_1[i][32*j+:32] = $random;
            flips_2[i][32*j+:32] = $random;
        end
        if(LOAD_CONST_REM != 0) begin
            flips_0[i][CT_WIDTH-1 -: LOAD_CONST_REM] = $random;
            flips_1[i][CT_WIDTH-1 -: LOAD_CONST_REM] = $random;
            flips_2[i][CT_WIDTH-1 -: LOAD_CONST_REM] = $random;
        end
    end

    $display("Temporal Buffer Wrapper: Begin Simulation");

    // reset the system
    wr_index = 0;
    wr_en = 0;
    re_index = 0;

    reset = 1;
    @(negedge clk);
    @(negedge clk);
    reset = 0;

    // do tests
    for(test_i = 0; test_i < NUM_TESTS; test_i = test_i + 1) begin
        $display("* Beginning test #%x at time %t", test_i, $time);

        $display("| * writing clauses from flip 0");
        wr_en = 1;
        wr_index = 0;
        literals_in = flips_0[test_i];
        
        // wait for clock
        @(negedge clk);
        $display("| * writing clauses from flip 1");
        wr_index = 1;
        literals_in = flips_1[test_i];

        // wait for clock
        @(negedge clk);
        $display("| * writing clauses from flip 2");
        wr_index = 2;
        re_index = $urandom%3;
        literals_in = flips_2[test_i];

        // wait for clk
        @(negedge clk);
        $display("| * reading data from flip %d", re_index);
        case (re_index)
            0 : if(literals_out == flips_0[test_i]) passed = 1'b1;
            1 : if(literals_out == flips_1[test_i]) passed = 1'b1;
            2 : if(literals_out == flips_2[test_i]) passed = 1'b1;
            default: $display("    read index invalid");
        endcase
        if(passed == 1'b1) begin
            $display("| * expected output: test passed");
            tests_passed = tests_passed + 1;
        end
        else $display("| * unexpected output: test failed");
        passed = 1'b0;
    end
    $display("Temporal Buffer Wrapper: End Simulation");
    $display("Passed %d/%d tests", tests_passed, NUM_TESTS);     
    $finish;
end

endmodule
