/*
Version: 2.0
FIFO_Tree_tb.v

V0.0 Author: Dan Espinosa
V1.0 Author: Zeiler Randall-Reed
V2.0 Author: Zeiler Randall-Reed 

Description:
Testbench file for FIFO_Tree.v

Status: 
    V1.0 - Test passed
    V2.0 - Test in progress 

Change Log:
2024/08/05 - Zeiler Randall-Reed 
    Started V2.0
2024/08/06 - Zeiler Randall-Reed
    Added test plan and phase 1
    Having problems with the FIFO tree data being invalid so I'm going to try to test the buffer itself first.
*/

`timescale 1ns / 1ps
`define SIM
//`define VERBOSE
`define ASSERT(CONDITION, MESSAGE) if ((CONDITION)==1'b1); else begin $error($sformatf MESSAGE); end

module FIFO_Tree_tb;

// Parameters for the FIFO tree
parameter CLAUSE_COUNT = 20;
parameter CLAUSE_WIDTH = 9;  
parameter BUFFER_DEPTH = 32;
// testing parameters
parameter NUM_TESTS = 5;
parameter TEST_CYCLES = 0.6 * CLAUSE_COUNT;

localparam CW = CLAUSE_WIDTH;
localparam CC = CLAUSE_COUNT;

localparam D_WORDS = (CC * CW) / 32;
localparam D_REM = (CC * CW) % 32;

// loop variables
genvar n;
integer i, j, k;

// Inputs
reg clk = 1;
always #5 clk <= ~clk;
reg reset;

reg [CW * CC - 1 : 0] clauses_i; // 20*36 = 720
reg [CC - 1 : 0] clauses_valid_i;
reg wr_en_i;
reg rd_en_i;
reg cOF_i;

// Output
wire empty_o;
wire OF_o;
wire [CW - 1 : 0] clause_o;

// Instantiate the Unit Under Test (UUT)
FIFO_Tree #(
    .CLAUSE_COUNT(CC),
    .CLAUSE_WIDTH(CW),
    .BUFFER_DEPTH(BUFFER_DEPTH)
) uut (
    .clk_i(clk),
    .rst_i(reset),
    .clauses_i(clauses_i),
    .clauses_valid_i(clauses_valid_i),
    .wr_en_i(wr_en_i),
    .rd_en_i(rd_en_i),
    .cOF_i(cOF_i),
    .empty_o(empty_o),
    .OF_o(OF_o),
    .clause_o(clause_o)
);

// UUT internal signals
// wire [CW * 4 - 1 : 0] L0dout = uut.L0dout;
// wire [CW * 4 - 1 : 0] L0din = uut.L0din;
// wire [CW * 2 - 1 : 0] L1dout = uut.L1dout;
// wire [CW * 2 - 1 : 0] L1din = uut.L1din;
// wire [CW - 1 : 0] L2dout = uut.L2dout;
// wire [CW - 1 : 0] L2din = uut.L2din;

// generated testing data
reg [CC - 1 : 0]            valid_bits              [0 : NUM_TESTS - 1];
reg [CW * CC - 1 : 0]       clauses                 [0 : NUM_TESTS - 1];
reg [$clog2(CC) - 1 : 0]    valid_count             [0 : NUM_TESTS - 1];

reg [CW - 1 : 0]            clauses_packed          [0 : NUM_TESTS - 1][CC - 1 : 0];
reg [CW - 1 : 0]            valid_clauses_packed    [0 : NUM_TESTS - 1][CC - 1 : 0];
reg                         valid_clauses_matched   [0 : NUM_TESTS - 1][CC - 1 : 0];

// per test signals for waveform
reg [CW - 1 : 0]    valid_clauses_t     [CC - 1 : 0]; // packed valid clauses per test
reg                 valid_clauses_m     [CC - 1 : 0]; // mark for already matched clauses per test
reg [CW - 1 : 0]    all_clauses_t       [CC - 1 : 0]; // packed all clauses per test

// per test signals for checking
integer matched, mismatched, duplicates;
reg has_match;
reg  [NUM_TESTS - 1 : 0] test_passed; // tracked for each test for summary report

// monitor signals
    wire [3:0] uut_L0E, uut_L0F, uut_L0wr_en, uut_L0rd_en;
    assign uut_L0E = uut.L0E;
    assign uut_L0F = uut.L0F;
    assign uut_L0wr_en = uut.L0wr_en;
    assign uut_L0rd_en = uut.L0rd_en;
    wire [CW - 1 : 0] uut_L0dout_packed [3:0];
    wire [CW - 1 : 0] uut_L0din_packed [3:0];
    for(n = 0; n < 4; n = n + 1) begin
        assign uut_L0dout_packed[n] = uut.L0dout[CW * n +: CW];
        assign uut_L0din_packed[n] = uut.L0din[CW * n +: CW];
    end
    wire [2:0] uut_L0src;
    assign uut_L0src = uut.L0src;
    wire [CW - 1 : 0] uut_L0_FIFO_0_buffer [0 : BUFFER_DEPTH - 1];
    wire [CW - 1 : 0] uut_L0_FIFO_1_buffer [0 : BUFFER_DEPTH - 1];
    wire [CW - 1 : 0] uut_L0_FIFO_2_buffer [0 : BUFFER_DEPTH - 1];
    wire [CW - 1 : 0] uut_L0_FIFO_3_buffer [0 : BUFFER_DEPTH - 1];
    wire [$clog2(BUFFER_DEPTH) - 1 : 0] uut_L0_FIFO_3_counter;
    wire [$clog2(BUFFER_DEPTH) - 1 : 0] uut_L0_FIFO_3_read_ptr;
    wire [$clog2(BUFFER_DEPTH) - 1 : 0] uut_L0_FIFO_3_write_ptr;


    wire [1:0] uut_L1E, uut_L1F, uut_L1rd_en, uut_L1wr_en;
    assign uut_L1E = uut.L1E;
    assign uut_L1F = uut.L1F;
    assign uut_L1rd_en = uut.L1rd_en;
    assign uut_L1wr_en = uut.L1wr_en;
    wire [CW - 1 : 0] uut_L1dout_packed [1:0];
    wire [CW - 1 : 0] uut_L1din_packed [1:0];
    for(n = 0; n < 2; n = n + 1) begin
        assign uut_L1dout_packed[n] = uut.L1dout[CW * n +: CW];
        assign uut_L1din_packed[n] = uut.L1din[CW * n +: CW];
    end
    wire [1:0] uut_L1src;
    assign uut_L1src = uut.L1src;
    wire [CW - 1 : 0] uut_L1_FIFO_0_buffer [0 : BUFFER_DEPTH - 1];
    wire [CW - 1 : 0] uut_L1_FIFO_1_buffer [0 : BUFFER_DEPTH - 1];


    wire uut_L2E, uut_L2F, uut_L2rd_en, uut_L2wr_en;
    assign uut_L2E = uut.L2E;
    assign uut_L2F = uut.L2F;
    assign uut_L2rd_en = uut.L2rd_en;
    assign uut_L2wr_en = uut.L2wr_en;
    wire [CW - 1 : 0] uut_L2dout, uut_L2din;
    assign uut_L2dout = uut.L2dout;
    assign uut_L2din = uut.L2din;
    wire uut_L2src;
    assign uut_L2src = uut.L2src;
    wire [CW - 1 : 0] uut_L2_FIFO_0_buffer [0 : BUFFER_DEPTH - 1];

    // try to access internal signals
    for(n = 0; n < BUFFER_DEPTH; n = n + 1) begin
        assign uut_L0_FIFO_0_buffer[n] = uut.L0_FIFO[0].L0_FIFO_inst.buffer[n];
        assign uut_L0_FIFO_1_buffer[n] = uut.L0_FIFO[1].L0_FIFO_inst.buffer[n];
        assign uut_L0_FIFO_2_buffer[n] = uut.L0_FIFO[2].L0_FIFO_inst.buffer[n];
        assign uut_L0_FIFO_3_buffer[n] = uut.L0_FIFO[3].L0_FIFO_inst.buffer[n];
        assign uut_L1_FIFO_0_buffer[n] = uut.L1_FIFO[0].L1_FIFO_inst.buffer[n];
        assign uut_L1_FIFO_1_buffer[n] = uut.L1_FIFO[1].L1_FIFO_inst.buffer[n];
        assign uut_L2_FIFO_0_buffer[n] = uut.FIFO_last.buffer[n];
    end

    assign uut_L0_FIFO_3_counter = uut.L0_FIFO[3].L0_FIFO_inst.counter;
    assign uut_L0_FIFO_3_read_ptr = uut.L0_FIFO[3].L0_FIFO_inst.read_ptr;
    assign uut_L0_FIFO_3_write_ptr = uut.L0_FIFO[3].L0_FIFO_inst.write_ptr;

/*
Test Plan:
    I want to test a few things:
    1. That the FIFO tree can store and retrieve data
    2. That the FIFO tree handles overflow correctly
    3. That the FIFO tree does First-In-First-Out (data ordering)

    Plan to use sequential tests to do this (i.e. there will be multiple phases to the test)

    [IN PROGRESS]
    Phase 1: Test that the FIFO tree can store and retrieve data 
        1. Load the FIFO tree with data and valid bits
        2. Read the data back out (over 12 cycles)
        3. Check that the data read out matches the data that was loaded in
        4. Repeat for multiple sets of data

    [TODO]
    Phase 2: Test that the FIFO tree handles overflow correctly
        need some way of overfilling the FIFO tree 
        I need a better idea of how it works to do that, so I'll come back to this
            maybe i can do this by setting all input clauses as valid for a couple cycles 
    Phase 3: Test that the FIFO tree does First-In-First-Out (data ordering)
        1. Load the FIFO tree with data and valid bits
        2. Load more data into the FIFO tree
        3. Read the data back out (over several cycles)
        4. make sure all the data from the first load is read out before the data from the second load
*/

initial begin
$display("FIFO Tree Testbench: Begin Simulation");

// generate test data using random number generation
$display("> Generating test data... ");
for(i = 0; i < NUM_TESTS; i = i + 1) begin
    // get random valid bit assignment less than or equal to TEST_CYCLES
    valid_bits[i] = $random;
    valid_count[i] = 0;
    for(j = 0; j < CC; j = j + 1) begin
        if(valid_bits[i][j] == 1) valid_count[i] = valid_count[i] + 1;
    end
    if(valid_count[i] > TEST_CYCLES) begin 
        valid_bits[i] = ~valid_bits[i];
        valid_count[i] = CC - valid_count[i];
    end

    // generate random clauses
    for(k = 0; k < D_WORDS; k = k + 1) begin
        clauses[i][32 * k +: 32] = $random;
    end
    clauses[i][D_WORDS * 32 +: D_REM] = $random;

    // pack the clauses
    k = 0;
    for(j = 0; j < CC; j = j + 1) begin
        clauses_packed[i][j] = clauses[i][CW * j +: CW];
        if(valid_bits[i][j] == 1) begin
            valid_clauses_packed[i][k] = clauses_packed[i][j];
            valid_clauses_matched[i][k] = 1;
            k = k + 1;
        end
    end
    for(j = 0; j < CC - k; j = j + 1) begin
        valid_clauses_packed[i][j + k] = 0;
        valid_clauses_matched[i][j + k] = 0;
    end

    $display("  * Test %d: %d valid", i, valid_count[i]);
end


// Test Phase 1
$display("> Phase 1: Test that the FIFO tree can store and retrieve data");
    // initialize signals
    clauses_i = 0;
    clauses_valid_i = 0;
    wr_en_i = 0;
    rd_en_i = 0;
    cOF_i = 0;

    // Reset the system
    reset = 1;
    @(negedge clk);
    @(negedge clk);
    reset = 0;

    // Test
    for(i = 0; i < NUM_TESTS; i = i + 1) begin
        $display(" * Test %0d", i);

        // initialize test variables
        matched = 0;
        mismatched = 0;
        duplicates = 0;
        test_passed[i] = 1;

        // load testing data
        for(j = 0; j < CC; j = j + 1) begin
            valid_clauses_t[j] = valid_clauses_packed[i][j];
            valid_clauses_m[j] = valid_clauses_matched[i][j];
            all_clauses_t[j] = clauses_packed[i][j];
        end

        // load the FIFO tree data
        clauses_i = clauses[i];
        clauses_valid_i = valid_bits[i];
        wr_en_i = 1;
        rd_en_i = 0;

        // wait on data to sift to the bottom of the FIFO tree
        while(empty_o == 1) begin
            @(negedge clk);
            wr_en_i = 0;
        end

        // read data out of the FIFO tree
        rd_en_i = 1;
        for(j = 0; j < TEST_CYCLES; j = j + 1) begin
            $display(" .* Cycle %0d", j);
            @(negedge clk);
            wr_en_i = 0;
            has_match = 0;
            if(empty_o == 1) begin
                $display(" ..* tree is empty");
            end else begin
                if(clause_o === {CW{1'bx}}) begin
                    $display(" ..* tree not empty, but clause is null");
                    mismatched = mismatched + 1;
                    test_passed[i] = 0;
                end else begin
                    $display(" ..* Checking clause: %3x", clause_o);
                    for(k = 0; k < valid_count[i]; k = k + 1) begin
                        `ifdef VERBOSE
                        $display(" ....> against %3x", clause_o, valid_clauses_t[k]);
                        `endif
                        if(clause_o == valid_clauses_t[k]) begin
                            if(valid_clauses_m[k] == 0) begin
                                $display(" ...* duplicate clause");
                                duplicates = duplicates + 1;
                                has_match = 1;
                                test_passed[i] = 0;
                            end else begin
                                valid_clauses_m[k] = 0;
                                $display(" ...* found match");
                                matched = matched + 1;
                                has_match = 1;
                            end
                        end
                    end
                    if(~has_match) begin
                        $display(" ...* clause not found in valid clauses");
                        mismatched = mismatched + 1;
                        test_passed[i] = 0;
                    end
                end
            end
        end

        if(test_passed[i] == 0) begin
            $display(" .* Test Failed");
            $display(" ..* %0d/%0d clauses matched", matched, valid_count[i]);
            $display(" ..* %0d clauses mismatched", mismatched);
            $display(" ..* %0d duplicate clauses", duplicates);
        end else begin
            $display(" .* Test Passed");
        end
    end

    if(&test_passed) begin
        $display("  Phase 1 Passed");
    end else begin
        $display("  Phase 1 Failed");
    end




$display("FIFO Tree Testbench: End Simulation");
$finish;

end

endmodule