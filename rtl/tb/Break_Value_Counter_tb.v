/* 
Break_Value_Counter_tb.v
Author: Zeiler Randall-Reed

Description:
Testbench file for Break_Value_Counter.v

Status:
Complete
*/
`timescale 1ns / 1ps

`define SIM

`define ASSERT(CONDITION, MESSAGE) if ((CONDITION)==1'b1); else begin $display(MESSAGE); end

module Break_Value_Counter_tb;

parameter NUM_CLAUSES = 20;
parameter NUM_ROWS = 3;
parameter NUM_CLAUSES_BITS = 5;

parameter NUM_TESTS = 10;

// inputs
reg clk = 1;
always #5 clk <= ~clk;
reg reset;

reg [NUM_CLAUSES-1:0] clause_status_i;

// outputs
wire [NUM_CLAUSES_BITS-1:0] break_value_o;

// Instantiate the Unit Under Test (UUT)
Break_Value_Counter #(
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
    $readmemb("Break_Value_Counter_tb_status.mem", clause_status);
    $readmemh("Break_Value_Counter_tb_value.mem", break_value);
    $display("Break Value Counter Testbench: Begin Simulation");

    // reset the system
    reset = 1;
    @(negedge clk);
    @(negedge clk);
    reset = 0;

    test_index = 0;
    for(test_index = 0; test_index < NUM_TESTS; test_index = test_index + 1) begin        
        // load test values into the clause_status input
        clause_status_i = clause_status[test_index];
        // $display("Clause status: %b", clause_status_i);
        // for(i = 0; i < NUM_CLAUSES; i = i + 1) begin 
        //     clause_status_i[i] = clause_status[test_index][i];
        // end 

        // wait for the output to be ready
        @(negedge clk);

        // check if the output matches the expected value
        if(break_value_o != break_value[test_index]) $display("Test failed: Got %d, expected %d", break_value_o, break_value[test_index]);
        //`ASSERT(break_value_o == break_value[test_index], ("Break Value Counter Testbench: Test failed"));
    end 
    
    $display("Break Value Counter Testbench: End Simulation");
end


endmodule