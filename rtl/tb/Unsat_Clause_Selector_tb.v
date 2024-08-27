/*
Version: 1.0
Unsat_Clause_Buffer.v

Author V1.0: Zeiler Randall-Reed
Author V1.1: Zeiler Randall-Reed

Description:

Status:
- V1.0: testbench in progress, no successful testing yet
- V1.1: 29/30 tests passed - failed test due to rounding error in calculation
*/

module Unsat_Clause_Selector_tb;

parameter BUFFER_DEPTH = 2048;
parameter RANDOM_OFFSET = 10;
parameter RANDOM_NUM_WIDTH = 18;
parameter M_TABLE_WIDTH = 32;

// localparams
localparam RAN_WIDTH = RANDOM_NUM_WIDTH;
localparam BUF_ADDR_WIDTH = $clog2(BUFFER_DEPTH);
localparam MT_WIDTH = M_TABLE_WIDTH;

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
wire [RAN_WIDTH + M_TABLE_WIDTH - 1 : 0] uut_product2;
wire [RAN_WIDTH - 1 : 0] quotient;
wire [RAN_WIDTH - 1 : 0] uut_N_R1, uut_N_R2;
wire [BUF_ADDR_WIDTH - 1 : 0] uut_m1, uut_m2;
assign uut_product2 = uut.product2;
assign quotient = uut.product2[M_TABLE_WIDTH +: RAN_WIDTH] ;
assign uut_N_R1 = uut.N_R1;
assign uut_N_R2 = uut.N_R2;
assign uut_m1 = uut.m1;
assign uut_m2 = uut.m2;

wire uut_mt_en, uut_mt_we;
wire [BUF_ADDR_WIDTH - 1 : 0] uut_mt_addr_i;
wire [MT_WIDTH - 1 : 0] uut_mt_data_o;
assign uut_mt_en = uut.mt_en;
assign uut_mt_we = uut.mt_we;
assign uut_mt_addr_i = uut.mt_addr_i;
assign uut_mt_data_o = uut.mt_data_o;

/* Testing plan:
- need to load the 1/m table with values
- need to test the selection logic by setting the unsat_buffer_count_i and random_i
- 
*/

// 1/m table values
reg [M_TABLE_WIDTH - 1 : 0] m_table [0 : BUFFER_DEPTH];
wire [M_TABLE_WIDTH - 1 : 0] mt_data [0 : BUFFER_DEPTH];
genvar n;
for(n = 0; n < BUFFER_DEPTH + 1; n = n + 1) begin
    assign mt_data[n] = m_table[n];
end

// test data
reg [$clog2(BUFFER_DEPTH) - 1 : 0]  unsat_buffer_count  [0 : NUM_TESTS - 1];
reg [31 : 0]                        random              [0 : NUM_TESTS - 1];
reg [$clog2(BUFFER_DEPTH) - 1 : 0]  selected            [0 : NUM_TESTS - 1];

// test reg
reg [NUM_TESTS - 1 : 0] test_passed;
integer num_passed;

// testbench
initial begin
    $display("Unsat Clause Buffer Testbench: begin test");
    $display("Loading 1/m table");
    $readmemh("1overM_table.mem", m_table);

    // generate test data
    for(i = 0; i < NUM_TESTS; i = i + 1) begin
        unsat_buffer_count[i] = $random % BUFFER_DEPTH;
        random[i] = $random;
        selected[i] = random[i][RANDOM_OFFSET +: RAN_WIDTH] % unsat_buffer_count[i];
    end

    // load 1/m table
    setup = 1;
    for(i = 0; i < BUFFER_DEPTH + 1; i = i + 1) begin
        write_addr_i = i;
        mt_data_i = m_table[i];
        //$display("Loading 1/m table index %0h with data %0h", i, m_table[i]);
        @(negedge clk);
    end
    setup = 0;

    // reset the system
    reset = 1;
    @(negedge clk);
    @(negedge clk);
    reset = 0;
    num_passed = 0;
    test_passed = {NUM_TESTS{1'b1}};

    // test m-table
    mt_en_i = 1;
    for(i = 1; i < BUFFER_DEPTH + 1; i = i + 1) begin
        unsat_buffer_count_i = i;
        @(negedge clk);
        if(uut_mt_data_o != m_table[i]) begin
            $display("M table test failed at index %d", i);
            $display("Expected: %0h, Got: %0h", m_table[i], uut_mt_data_o);
        end
    end
    mt_en_i = 0;
    // $finish;

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
        unsat_buffer_count_i = unsat_buffer_count[i];
        random_i = random[i];
        @(negedge clk);
        if(selected_o != selected[i - 2]) begin
            $display("Test %0d failed: Expected: %0h, Got: %0h", i - 2, selected[i - 2], selected_o);
            test_passed[i - 2] = 0;
        end
    end
    @(negedge clk);
    if(selected_o != selected[NUM_TESTS - 2]) begin
        $display("Test %0d failed: Expected: %0h, Got: %0h", NUM_TESTS - 2, selected[NUM_TESTS - 2], selected_o);
        test_passed[NUM_TESTS - 2] = 0;
    end
    @(negedge clk);
    if(selected_o != selected[NUM_TESTS - 1]) begin
        $display("Test %0d failed: Expected: %0h, Got: %0h", NUM_TESTS - 1, selected[NUM_TESTS - 1], selected_o);
        test_passed[NUM_TESTS - 1] = 0;
    end


$display("Unsat Clause Buffer Testbench: End Test");
for(i = 0; i < NUM_TESTS; i = i + 1) if(test_passed[i]) num_passed = num_passed + 1;
$display("    Test Results: %0d/%0d tests passed", num_passed, NUM_TESTS);
$finish;

end

endmodule