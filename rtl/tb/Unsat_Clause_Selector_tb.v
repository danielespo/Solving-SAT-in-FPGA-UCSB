/*
Version: 1.0
Unsat_Clause_Buffer.v

Author V1.0: Zeiler Randall-Reed

Description:

Status:
- V1.0: testbench in progress, no successful testing yet

*/

module Unsat_Clause_Selector_tb;

parameter BUFFER_DEPTH = 2048;
parameter RANDOM_OFFSET = 10;
parameter RANDOM_NUM_WIDTH = 18;
parameter M_TABLE_WIDTH = 32;

// localparams
localparam RAN_WIDTH = RANDOM_NUM_WIDTH;
localparam BUF_ADDR_WIDTH = $clog2(BUFFER_DEPTH);
localparam M_WIDTH = M_TABLE_WIDTH;

// test params
parameter NUM_TESTS = 30;

// integer vars
integer i, j;

/* I/O */
// clock and reset
reg clk = 0;
always #5 clk = ~clk;
reg reset;

// loading 1/m table
reg setup;
wire ready;
reg [$clog2(BUFFER_DEPTH) - 1 : 0] write_addr_i;
reg [M_TABLE_WIDTH - 1 : 0] mt_data_i;

// selecting index signals
reg mt_en_i;
reg [$clog2(BUFFER_DEPTH) - 1 : 0] unsat_buffer_count_i;
reg [31 : 0] random_i;
wire [$clog2(BUFFER_DEPTH) - 1 : 0] selected_o;

// instantiate the unit under test (UUT)
Unsat_Clause_Selector #(
    .BUFFER_DEPTH(BUFFER_DEPTH),
    .RANDOM_OFFSET(RANDOM_OFFSET),
    .RANDOM_NUM_WIDTH(RANDOM_NUM_WIDTH),
    .M_TABLE_WIDTH(M_TABLE_WIDTH)
) uut (
    .clk(clk),
    .reset(reset),
    .setup(setup),
    .ready(ready),
    .write_addr_i(write_addr_i),
    .mt_data_i(mt_data_i),
    .mt_en_i(mt_en_i),
    .unsat_buffer_count_i(unsat_buffer_count_i),
    .random_i(random_i),
    .selected_o(selected_o)
);

// monitor signals


/* Testing plan:
- need to load the 1/m table with values
- need to test the selection logic by setting the unsat_buffer_count_i and random_i
- 
*/

// 1/m table values
reg [M_TABLE_WIDTH - 1 : 0] m_table [0 : BUFFER_DEPTH];


// test data
reg [$clog2(BUFFER_DEPTH) - 1 : 0]  unsat_buffer_count  [0 : NUM_TESTS - 1];
reg [31 : 0]                        random              [0 : NUM_TESTS - 1];
reg [$clog2(BUFFER_DEPTH) - 1 : 0]  selected            [0 : NUM_TESTS - 1];

// test reg
reg [NUM_TESTS - 1 : 0] test_passed;

// testbench
initial begin
    $display("Unsat Clause Buffer Testbench: begin test");
    $display("Loading 1/m table");
    $readmemh("1overM_table.mem", m_table);

    // generate test data
    for(i = 0; i < NUM_TESTS; i = i + 1) begin
        unsat_buffer_count[i] = $random % BUFFER_DEPTH;
        random[i] = $random;
        selected[i] = random[i] % unsat_buffer_count[i];
    end

    // load 1/m table
    setup = 1;
    for(i = 0; i < BUFFER_DEPTH + 1; i = i + 1) begin
        write_addr_i = i;
        mt_data_i = m_table[i];
        @(negedge clk);
    end
    setup = 0;

    // reset the system
    reset = 1;
    @(negedge clk);
    @(negedge clk);
    reset = 0;
    
    // tests
    mt_en_i = 1;
    unsat_buffer_count_i = unsat_buffer_count[0];
    random_i = random[0];
    @(negedge clk);
    unsat_buffer_count_i = unsat_buffer_count[1];
    random_i = random[1];
    @(negedge clk);
    for(i = 2; i < NUM_TESTS; i = i + 1) begin
        if(selected_o != selected[i - 2]) begin
            $display("Test %d failed", i - 2);
            test_passed[i - 2] = 0;
        end
        unsat_buffer_count_i = unsat_buffer_count[i];
        random_i = random[i];
        @(negedge clk);
    end
    if(selected_o != selected[NUM_TESTS - 2]) begin
        $display("Test %d failed", NUM_TESTS - 2);
        test_passed[NUM_TESTS - 2] = 0;
    end
    if(selected_o != selected[NUM_TESTS - 1]) begin
        $display("Test %d failed", NUM_TESTS - 1);
        test_passed[NUM_TESTS - 1] = 0;
    end


$display("Unsat Clause Buffer Testbench: end test");
$finish;

end

endmodule