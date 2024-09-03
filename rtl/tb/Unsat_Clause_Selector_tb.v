/*
Version: 1.0
Unsat_Clause_Buffer.v

Author V1.0: Zeiler Randall-Reed
Author V1.1: Zeiler Randall-Reed
Author V1.2: Zeiler Randall-Reed

Description:

Status:
- V1.0: testbench in progress, no successful testing yet
- V1.1: 29/30 tests passed - failed test due to rounding error in calculation
- V1.2: all tests passed - determined that by rounding up (instead of down) the errors were eliminated
        added 'exhaustive' tests that try all possible values of unsat_buffer_count with random values
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

parameter NUM_EXHAUSTIVE = 20;

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

reg [$clog2(BUFFER_DEPTH) - 1 : 0]  unsat_buffer_count_exhaustive   [0 : BUFFER_DEPTH][0 : NUM_EXHAUSTIVE - 1];
reg [31 : 0]                        random_exhaustive               [0 : BUFFER_DEPTH][0 : NUM_EXHAUSTIVE - 1];
reg [$clog2(BUFFER_DEPTH) - 1 : 0]  selected_exhaustive             [0 : BUFFER_DEPTH][0 : NUM_EXHAUSTIVE - 1];

// test reg
reg [NUM_TESTS - 1 : 0] r_test_passed;
integer r_num_passed;

reg [BUFFER_DEPTH - 1 : 0] e_test_passed [0 : NUM_EXHAUSTIVE - 1];
integer e_num_passed [0 : NUM_EXHAUSTIVE - 1];
integer e_num_passed_total;
real e_num_missed_avg;


// testbench
initial begin
    $display("Unsat Clause Buffer Testbench: begin test");
    $display("Loading 1/m table");
    $readmemh("M_table_roundup.mem", m_table);

    // generate random test data
    for(i = 0; i < NUM_TESTS; i = i + 1) begin
        unsat_buffer_count[i] = $random % BUFFER_DEPTH;
        random[i] = $random;
        selected[i] = random[i][RANDOM_OFFSET +: RAN_WIDTH] % unsat_buffer_count[i];
    end

    // generate exhaustive test data
    for(i = 0; i < BUFFER_DEPTH; i = i + 1) begin
        for(j = 0; j < NUM_EXHAUSTIVE; j = j + 1) begin
            unsat_buffer_count_exhaustive[i][j] = i;
            random_exhaustive[i][j] = $random;
            selected_exhaustive[i][j] = random_exhaustive[i][j][RANDOM_OFFSET +: RAN_WIDTH] % unsat_buffer_count_exhaustive[i][j];
        end
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

    // // reset the system
    // reset = 1;
    // @(negedge clk);
    // @(negedge clk);
    // reset = 0;

    // // test m-table
    // mt_en_i = 1;
    // for(i = 1; i < BUFFER_DEPTH + 1; i = i + 1) begin
    //     unsat_buffer_count_i = i;
    //     @(negedge clk);
    //     if(uut_mt_data_o != m_table[i]) begin
    //         $display("M table test failed at index %d", i);
    //         $display("Expected: %0h, Got: %0h", m_table[i], uut_mt_data_o);
    //     end
    // end
    // mt_en_i = 0;
    // // $finish;

    // test selection logic

    r_num_passed = 0;
    r_test_passed = {NUM_TESTS{1'b1}};
    for(j = 0; j < NUM_EXHAUSTIVE; j = j + 1) begin
        e_num_passed[j] = 0;
        e_test_passed[j] = {BUFFER_DEPTH{1'b1}};
    end

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
            $display("Random Test %0h failed: Expected: %0h, Got: %0h", i - 2, selected[i - 2], selected_o);
            r_test_passed[i - 2] = 0;
        end
    end
    @(negedge clk);
    if(selected_o != selected[NUM_TESTS - 2]) begin
        $display("Random Test %0h failed: Expected: %0h, Got: %0h", NUM_TESTS - 2, selected[NUM_TESTS - 2], selected_o);
        r_test_passed[NUM_TESTS - 2] = 0;
    end
    @(negedge clk);
    if(selected_o != selected[NUM_TESTS - 1]) begin
        $display("Random Test %0h failed: Expected: %0h, Got: %0h", NUM_TESTS - 1, selected[NUM_TESTS - 1], selected_o);
        r_test_passed[NUM_TESTS - 1] = 0;
    end

    // exhaustive tests
    for(j = 0; j < NUM_EXHAUSTIVE; j = j + 1) begin
        // reset the system
        reset = 1;
        @(negedge clk);
        @(negedge clk);
        reset = 0;
        // tests
        mt_en_i = 1;
        unsat_buffer_count_i = unsat_buffer_count_exhaustive[0][j];
        random_i = random_exhaustive[0][j];
        @(negedge clk);
        unsat_buffer_count_i = unsat_buffer_count_exhaustive[1][j];
        random_i = random_exhaustive[1][j];
        @(negedge clk);
        for(i = 2; i < BUFFER_DEPTH; i = i + 1) begin
            unsat_buffer_count_i = unsat_buffer_count_exhaustive[i][j];
            random_i = random_exhaustive[i][j];
            @(negedge clk);
            if(selected_o != selected_exhaustive[i - 2][j]) begin
                $display("Exhaustive Test %0h-%0h failed: Expected: %0h, Got: %0h", j, i - 2, selected_exhaustive[i - 2][j], selected_o);
                e_test_passed[j][i - 2] = 0;
            end
            // if(selected_exhaustive[i - 2][j] == 0) begin
            //     $display("Exhaustive Test %0h-%0h expected zero)", i - 2, j);
            // end
        end
        @(negedge clk);
        if(selected_o != selected_exhaustive[BUFFER_DEPTH - 2][j]) begin
            $display("Exhaustive Test %0h-%0h failed: Expected: %0h, Got: %0h", j, BUFFER_DEPTH - 2, selected_exhaustive[BUFFER_DEPTH - 2][j], selected_o);
            e_test_passed[j][BUFFER_DEPTH - 2] = 0;
        end
        @(negedge clk);
        if(selected_o != selected_exhaustive[BUFFER_DEPTH - 1][j]) begin
            $display("Exhaustive Test %0h-%0h failed: Expected: %0h, Got: %0h", j, BUFFER_DEPTH - 1, selected_exhaustive[BUFFER_DEPTH - 1][j], selected_o);
            e_test_passed[j][BUFFER_DEPTH - 1] = 0;
        end

    end

e_num_passed_total = 0;
e_num_missed_avg = 0;

$display("Unsat Clause Buffer Testbench: End Test");
for(i = 0; i < NUM_TESTS; i = i + 1) if(r_test_passed[i]) r_num_passed = r_num_passed + 1;
for(j = 0; j < NUM_EXHAUSTIVE; j = j + 1) for(i = 0; i < BUFFER_DEPTH; i = i + 1) if(e_test_passed[j][i]) e_num_passed[j] = e_num_passed[j] + 1;
for(j = 0; j < NUM_EXHAUSTIVE; j = j + 1) e_num_passed_total = e_num_passed_total + e_num_passed[j];
$display("    Random Test Results: %0d/%0d tests passed", r_num_passed, NUM_TESTS);
for(j = 0; j < NUM_EXHAUSTIVE; j = j + 1) $display("    Exhaustive Test %0d Results: %0d/%0d tests passed", j, e_num_passed[j], BUFFER_DEPTH);
$display("    Exhaustive Test Results Total: %0d/%0d tests passed", e_num_passed_total, BUFFER_DEPTH * NUM_EXHAUSTIVE);
$finish;

end

endmodule