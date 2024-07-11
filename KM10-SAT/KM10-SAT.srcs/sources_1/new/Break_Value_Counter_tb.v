// break_value_counter_tb.v
// tests the BreakValueCounter module
`timescale 1ns / 1ps

`define SIM

`define ASSERT(CONDITION, MESSAGE) if ((CONDITION)==1'b1); else begin $error($sformatf MESSAGE); end

module BreakValueCounter_tb;

parameter NUM_CLAUSES = 20;
parameter NUM_ROWS = 3;
parameter NUM_CLAUSES_BITS = 5;

parameter NUM_TESTS = 10;

// inputs
reg clk = 1;
always #5 clk <= ~clk;
reg reset;

reg clause_status_i [NUM_CLAUSES-1:0];

// outputs
wire [NUM_CLAUSES_BITS-1:0] break_value_o;

// Instantiate the Unit Under Test (UUT)
BreakValueCounter #(
    .NUM_CLAUSES(NUM_CLAUSES),
    .NUM_ROWS(NUM_ROWS),
    .NUM_CLAUSES_BITS(NUM_CLAUSES_BITS)
) uut (
    .clk(clk),
    .reset(reset),
    .clause(clause_status_i),
    .break_value(break_value_o)
);

reg [NUM_CLAUSES-1:0] clause_status[NUM_TESTS-1:0];
reg [NUM_CLAUSES_BITS-1:0] break_value [NUM_TESTS-1:0];
integer i, test_index;


// 4 tests right now, various random bit streams
initial begin
    $readmemb("BreakValueCounter_tb_clauses.mem", clause_status);
    $readmemb("BreakValueCounter_tb_break_value.mem", break_value);
    $display("Break Value Counter Testbench: Begin Simulation");

    // reset the system
    reset = 1;
    @(negedge clk);
    @(negedge clk);
    reset = 0;

    test_index = 0;
    for(test_index = 0; test_index < NUM_TESTS; test_index = test_index + 1) begin        
        // load test values into the clause_status input
        for(i = 0; i < NUM_CLAUSES; i = i + 1) begin 
            clause_status_i[i] = clause_status[test_index][i];
        end 

        // wait for the output to be ready
        @(negedge clk);

        // check if the output matches the expected value
        `ASSERT(break_value_o == break_value[test_index], ("Break Value Counter Testbench: Test failed"));
    end 
    
    $display("Break Value Counter Testbench: End Simulation");
end


endmodule