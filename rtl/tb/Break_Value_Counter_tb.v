/*
Version: 2.0 
Break_Value_Counter_tb.v

V1.0 Author: Zeiler Randall-Reed
V2.0 Author: Zeiler Randall-Reed

Description:
Testbench file for Break_Value_Counter.v

Status:
- V1.0: Complete, passes all tests
- V2.0: 
    - In progress (8/18)
    - all tests passed (8/18)

*/
`timescale 1ns / 1ps

`define SIM

`define ASSERT(CONDITION, MESSAGE) if ((CONDITION)==1'b1); else begin $display(MESSAGE); end

module Break_Value_Counter_tb;

parameter NUM_CLAUSES = 20;
parameter NUM_ROWS = 3;
parameter NUM_CLAUSES_BITS = 5;

parameter NUM_TESTS_DET = 10; 
parameter NUM_TESTS_RAN = 40;

parameter NUM_TESTS = NUM_TESTS_DET + NUM_TESTS_RAN;

// inputs
reg clk = 1;
always #5 clk <= ~clk;
reg reset;

reg [NUM_CLAUSES - 1 : 0] clause_status_i;
reg [NUM_CLAUSES - 1 : 0] mask_bits_i;

// outputs
wire [NUM_CLAUSES_BITS - 1 : 0] break_value_o;
wire [NUM_CLAUSES - 1 : 0] clause_broken_o;

// Instantiate the Unit Under Test (UUT)
Break_Value_Counter #(
    .NUM_CLAUSES(NUM_CLAUSES),
    .NUM_ROWS(NUM_ROWS),
    .NUM_CLAUSES_BITS(NUM_CLAUSES_BITS)
) uut (
    .clause_broken_i(clause_status_i),
    .mask_bits_i(mask_bits_i),
    .break_value_o(break_value_o),
    .clause_broken_o(clause_broken_o)
);

reg [NUM_CLAUSES - 1 : 0]       clause_status   [NUM_TESTS - 1 : 0];
reg [NUM_CLAUSES - 1 : 0]       mask_bits       [NUM_TESTS - 1 : 0];
reg [NUM_CLAUSES_BITS - 1 : 0]  break_value     [NUM_TESTS - 1 : 0];
reg [NUM_CLAUSES - 1 : 0]       clause_broken   [NUM_TESTS - 1 : 0];
integer i, j;


// testing vars
reg bv_pass;
reg cb_pass;
reg [NUM_TESTS - 1 : 0] test_pass;

// 4 tests right now, various random bit streams
initial begin
$display("Break Value Counter Testbench: Begin Simulation");
// generate test data
    $display("Generating test data ...");
    for(i = 0; i < NUM_TESTS_DET; i = i + 1) begin
        if(i == 0) begin            // 
            clause_status[i]    = {20{1'b1}};
            mask_bits[i]        = {20{1'b0}};
            break_value[i]      = 0;
            clause_broken[i]    = {20{1'b0}};
        end else if(i == 1) begin
            clause_status[i]    = {20{1'b0}};
            mask_bits[i]        = {20{1'b0}};
            break_value[i]      = 0;
            clause_broken[i]    = {20{1'b0}};
        end else if(i == 2) begin
            clause_status[i]    = {10{2'b10}};
            mask_bits[i]        = {10{2'b01}};
            break_value[i]      = 0;
            clause_broken[i]    = {10{1'b0}};
        end else if(i == 3) begin
            clause_status[i]    = {{10{1'b1}}, {10{1'b0}}};
            mask_bits[i]        = {{10{1'b0}}, {10{1'b1}}};
            break_value[i]      = 0;
            clause_broken[i]    = {20'b0};
        end else if(i == 4) begin
            clause_status[i]    = {20{1'b1}};
            mask_bits[i]        = {20{1'b1}};
            break_value[i]      = 20;
            clause_broken[i]    = {20{1'b1}};
        end else begin
            clause_status[i]    = $random;
            mask_bits[i]        = ~clause_status[i];
            break_value[i]      = 0;
            clause_broken[i]    = clause_status[i] & mask_bits[i]; // = 0;
        end
    end
    for(i = NUM_TESTS_DET; i < NUM_TESTS; i = i + 1) begin
        clause_status[i]    = $random;
        mask_bits[i]        = $random;
        break_value[i]      = 0;
        for(j = 0; j < NUM_CLAUSES; j = j + 1) begin
            break_value[i]      = break_value[i] + (clause_status[i][j] & mask_bits[i][j]);
        end
        clause_broken[i]    = clause_status[i] & mask_bits[i];
    end

    // initialize values
    clause_status_i = 0;
    mask_bits_i = 0;

    // reset the system
    reset = 1;
    @(negedge clk);
    @(negedge clk);
    reset = 0;

    // run the tests
    i = 0;
    $display("Running tests...");
    for(i = 0; i < NUM_TESTS; i = i + 1) begin        
        // load test values into the inputs
        clause_status_i = clause_status[i];
        mask_bits_i = mask_bits[i];

        bv_pass = 1;
        cb_pass = 1;
        test_pass[i] = 1;

        // wait for the output to be ready (does not need to be on clock cycle, but it is a way to do timing)
        @(negedge clk);

        // check if the output matches the expected value
        if(break_value_o != break_value[i]) bv_pass = 0;
        if(clause_broken_o != clause_broken[i]) cb_pass = 0;
        
        case({bv_pass, cb_pass})
            2'b00: $display("Test %d: FAIL: Break Value and Clause Broken do not match", i);
            2'b01: $display("Test %d: FAIL: Break Value does not match", i);
            2'b10: $display("Test %d: FAIL: Clause Broken does not match", i);
            2'b11: $display("Test %d: PASS", i);
        endcase
        test_pass[i] = bv_pass & cb_pass;
    end 
    
    $display("Break Value Counter Testbench: End Simulation");
    $display("Results:");
    if(~|test_pass) begin
        $display("    Some tests failed:");
        for(i = 0; i < NUM_TESTS; i = i + 1) begin
            if(~test_pass[i]) begin
                $display("Test %d: FAIL", i);
            end
        end
    end else begin
        $display("    All tests passed");
    end

end


endmodule