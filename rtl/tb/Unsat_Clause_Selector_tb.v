/*
Version: 2.0
Unsat_Clause_Buffer.v

Author V1.0: Zeiler Randall-Reed
Author V1.1: Zeiler Randall-Reed
Author V1.2: Zeiler Randall-Reed

Author V2.0: Zeiler Randall-Reed

Description:

Status:
- V1.0: testbench in progress, no successful testing yet
- V1.1: 29/30 tests passed - failed test due to rounding error in calculation
- V1.2: all tests passed - determined that by rounding up (instead of down) the errors were eliminated
        added 'exhaustive' tests that try all possible values of unsat_buffer_count with random values

- V2.0: testbench in progress
*/

module Unsat_Clause_Selector_tb;

parameter BUFFER_DEPTH = 2048;
parameter RANDOM_OFFSET = 10;
parameter RANDOM_NUM_WIDTH = 18;
parameter M_TABLE_WIDTH = 32;
parameter NSAT = 3;
parameter LITERAL_ADDRESS_WIDTH = 12;

// localparams
localparam RAN_WIDTH = RANDOM_NUM_WIDTH;
localparam BUF_ADDR_WIDTH = $clog2(BUFFER_DEPTH);
localparam MT_WIDTH = M_TABLE_WIDTH;

localparam CLAUSE_WIDTH = NSAT * LITERAL_ADDRESS_WIDTH;

// test params
parameter NUM_TESTS = 30;

parameter NUM_EXHAUSTIVE = 20;

// integer vars
integer i, j;
genvar n;

/* I/O */
    // clock and reset
        reg clk = 0;
        always #5 clk = ~clk;
        reg reset;
    // setup
        reg setup;
        wire ready;
        reg                                 ucb_setup_wren_i;
        reg [$clog2(BUFFER_DEPTH) - 1 : 0]  ucb_setup_addr_i;
        reg [CLAUSE_WIDTH - 1 : 0]          ucb_setup_data_i;
    // controller signals
        reg request_i;
        reg write_disable_i;
    // fifo signals
        reg fifo_empty_i;
        reg [CLAUSE_WIDTH - 1 : 0] fifo_clause_i;
    // prng signal
        reg [31 : 0] random_i;
    // outputs
        wire [$clog2(BUFFER_DEPTH) - 1 : 0] buffer_count_o;
        wire [CLAUSE_WIDTH - 1 : 0] selected_o;

// instantiate the unit under test (UUT)
Unsat_Clause_Selector #(
    .BUFFER_DEPTH(BUFFER_DEPTH),
    .RANDOM_NUM_WIDTH(RANDOM_NUM_WIDTH),
    .RANDOM_OFFSET(RANDOM_OFFSET),
    .M_TABLE_WIDTH(M_TABLE_WIDTH),
    .NSAT(NSAT),
    .LITERAL_ADDRESS_WIDTH(LITERAL_ADDRESS_WIDTH)
) uut (
    .clk(clk),
    .reset(reset),
    .setup(setup),
    .ready(ready),
    .ucb_setup_wren_i(ucb_setup_wren_i),
    .ucb_setup_addr_i(ucb_setup_addr_i),
    .ucb_setup_data_i(ucb_setup_data_i),
    .request_i(request_i),
    .write_disable_i(write_disable_i),
    .fifo_empty_i(fifo_empty_i),
    .fifo_clause_i(fifo_clause_i),
    .random_i(random_i),
    .buffer_count_o(buffer_count_o),
    .selected_o(selected_o)
);

// monitor signals
wire [CLAUSE_WIDTH - 1 : 0] uut_ucb_data [0 : BUFFER_DEPTH - 1];
generate
    for(n = 0; n < BUFFER_DEPTH; n = n + 1) begin
        assign uut_ucb_data[n] = uut.unsat_buffer.ram[n];
    end
endgenerate
wire [BUF_ADDR_WIDTH - 1 : 0] uut_selection;
assign uut_selection = uut.selection;

// wire [RAN_WIDTH + M_TABLE_WIDTH - 1 : 0] uut_product2;
// wire [RAN_WIDTH - 1 : 0] quotient;
// wire [RAN_WIDTH - 1 : 0] uut_N_R1, uut_N_R2;
// wire [BUF_ADDR_WIDTH - 1 : 0] uut_m1, uut_m2;
// assign uut_product2 = uut.product2;
// assign quotient = uut.product2[M_TABLE_WIDTH +: RAN_WIDTH] ;
// assign uut_N_R1 = uut.N_R1;
// assign uut_N_R2 = uut.N_R2;
// assign uut_m1 = uut.m1;
// assign uut_m2 = uut.m2;
// 
// wire uut_mt_en, uut_mt_we;
// wire [BUF_ADDR_WIDTH - 1 : 0] uut_mt_addr_i;
// wire [MT_WIDTH - 1 : 0] uut_mt_data_o;
// assign uut_mt_en = uut.mt_en;
// assign uut_mt_we = uut.mt_we;
// assign uut_mt_addr_i = uut.mt_addr_i;
// assign uut_mt_data_o = uut.mt_data_o;

/* Testing plan:
- 1/m table loaded during its initial block (make sure this works) -- done separate testbench
- run tests on m-table/selection logic
- test loading the unsat clause buffer with random values
- case tests
  - test A: unsat_buffer_count = 1
    -> check that the selection is 0
    -> count should decrement after a read
  - test B: unsat_buffer_count = 10
    -> check that the selection is within the range of 0-9
    -> predict selection by knowing random number
    -> make sure count is accurate, and that the writing doesn't overwrite anything
  - test C: unsat_buffer_count = 128
    -> check that the selection is within the range of 0-127
    -> predict selection by knowing random number
    -> make sure count is accurate, and that the writing doesn't overwrite anything
  - test D: unsat_buffer_count = 2048
    -> check that the selection is within the range of 0-2047
    -> predict selection by knowing random number
    -> make sure count is accurate
  - test E: unsat_buffer_count = 0 
    -> check division by zero
    -> make sure selection logic makes sense (and count is zero)
  - test F: try overfilling the buffer
    -> check overflow flag

- edge case
  - test to make sure that reading from the last element in the buffer doesn't duplicate it (should just be cleared)
*/



// test data
reg [31 : 0]                        random              [0 : NUM_TESTS - 1];
reg [$clog2(BUFFER_DEPTH) - 1 : 0]  selected            [0 : NUM_TESTS - 1];
reg [BUF_ADDR_WIDTH - 1 : 0]        expected_selection_index [0 : NUM_TESTS - 1];
reg [BUF_ADDR_WIDTH - 1 : 0]        actual_selection_index [0 : NUM_TESTS - 1];
reg [CLAUSE_WIDTH - 1 : 0]          expected_selected_clause [0 : NUM_TESTS - 1];

reg [$clog2(BUFFER_DEPTH) - 1 : 0]  unsat_buffer_count_exhaustive   [0 : BUFFER_DEPTH][0 : NUM_EXHAUSTIVE - 1];
reg [31 : 0]                        random_exhaustive               [0 : BUFFER_DEPTH][0 : NUM_EXHAUSTIVE - 1];
reg [$clog2(BUFFER_DEPTH) - 1 : 0]  selected_exhaustive             [0 : BUFFER_DEPTH][0 : NUM_EXHAUSTIVE - 1];

// test reg
reg [NUM_TESTS - 1 : 0] r_test_passed;
integer r_num_passed;

reg [BUFFER_DEPTH - 1 : 0] e_test_passed [0 : NUM_EXHAUSTIVE - 1];
integer e_num_passed [0 : NUM_EXHAUSTIVE - 1];
integer e_num_passed_total;

// testbench
initial begin
    $display("Unsat Clause Buffer Testbench: begin test");

    // set values to zero
    reset = 0;
    setup = 0;
    ucb_setup_wren_i = 0;
    ucb_setup_addr_i = 0;
    ucb_setup_data_i = 0;
    request_i = 0;
    write_disable_i = 0;
    fifo_empty_i = 0;
    fifo_clause_i = 0;
    random_i = 0;

    reset = 1;
    @(negedge clk);
    @(negedge clk);
    reset = 0;

    // test A: unsat_buffer_count = 1
    $display("  Test A: unsat_buffer_count = 1");
    expected_selected_clause[0] = {3{12'b011001100110}};
    expected_selection_index[0] = 0;

    setup = 1;
    ucb_setup_wren_i = 1;
    ucb_setup_addr_i = 0;
    ucb_setup_data_i = expected_selected_clause[0];
    @(negedge clk);
    setup = 0;
    request_i = 1;
    @(negedge clk);
    request_i = 0;
    @(negedge clk);
    @(negedge clk);
    actual_selection_index[0] = uut_selection;
    @(negedge clk);
    if(selected_o != expected_selected_clause[0] && actual_selection_index[0] != expected_selection_index[0]) begin
        $display("    Test A failed: Expected output %0h, Got %0h; Expected index %0h, Got %0h", expected_selected_clause[0], selected_o, expected_selection_index[0], actual_selection_index[0]);
    end else if(selected_o != expected_selected_clause[0]) begin
        $display("    Test A failed: Expected output %0h, Got %0h", expected_selected_clause[0], selected_o);
    end else if(actual_selection_index[0] != expected_selection_index[0]) begin
        $display("    Test A failed: Expected index %0h, Got %0h", expected_selection_index[0], actual_selection_index[0]);
    end else begin
        $display("    Test A passed");
    end

    @(negedge clk);
    
    $display("Setup stage: Load the buffer with sequential values to test");
    reset = 1;
    @(negedge clk);
    @(negedge clk);
    reset = 0;
    setup = 1;
    for(i = 0; i < 20; i = i + 1) begin
        ucb_setup_wren_i = 1;
        ucb_setup_addr_i = i;
        ucb_setup_data_i = i;
        @(negedge clk);
    end
    setup = 0;

    @(negedge clk);
    @(negedge clk);
    @(negedge clk);



//     // generate random test data
//     for(i = 0; i < NUM_TESTS; i = i + 1) begin
//         unsat_buffer_count[i] = $random % BUFFER_DEPTH;
//         random[i] = $random;
//         selected[i] = random[i][RANDOM_OFFSET +: RAN_WIDTH] % unsat_buffer_count[i];
//     end

//     // generate exhaustive test data
//     for(i = 0; i < BUFFER_DEPTH; i = i + 1) begin
//         for(j = 0; j < NUM_EXHAUSTIVE; j = j + 1) begin
//             unsat_buffer_count_exhaustive[i][j] = i;
//             random_exhaustive[i][j] = $random;
//             selected_exhaustive[i][j] = random_exhaustive[i][j][RANDOM_OFFSET +: RAN_WIDTH] % unsat_buffer_count_exhaustive[i][j];
//         end
//     end

//     // load 1/m table
//     setup = 1;
//     for(i = 0; i < BUFFER_DEPTH + 1; i = i + 1) begin
//         write_addr_i = i;
//         mt_data_i = m_table[i];
//         //$display("Loading 1/m table index %0h with data %0h", i, m_table[i]);
//         @(negedge clk);
//     end
//     setup = 0;

//     // // reset the system
//     // reset = 1;
//     // @(negedge clk);
//     // @(negedge clk);
//     // reset = 0;

//     // // test m-table
//     // mt_en_i = 1;
//     // for(i = 1; i < BUFFER_DEPTH + 1; i = i + 1) begin
//     //     unsat_buffer_count_i = i;
//     //     @(negedge clk);
//     //     if(uut_mt_data_o != m_table[i]) begin
//     //         $display("M table test failed at index %d", i);
//     //         $display("Expected: %0h, Got: %0h", m_table[i], uut_mt_data_o);
//     //     end
//     // end
//     // mt_en_i = 0;
//     // // $finish;

//     // test selection logic

//     r_num_passed = 0;
//     r_test_passed = {NUM_TESTS{1'b1}};
//     for(j = 0; j < NUM_EXHAUSTIVE; j = j + 1) begin
//         e_num_passed[j] = 0;
//         e_test_passed[j] = {BUFFER_DEPTH{1'b1}};
//     end

//     // reset the system
//     reset = 1;
//     @(negedge clk);
//     @(negedge clk);
//     reset = 0;
    
//     // tests
//     mt_en_i = 1;
//     unsat_buffer_count_i = unsat_buffer_count[0];
//     random_i = random[0];
//     @(negedge clk);
//     unsat_buffer_count_i = unsat_buffer_count[1];
//     random_i = random[1];
//     @(negedge clk);
//     for(i = 2; i < NUM_TESTS; i = i + 1) begin
//         unsat_buffer_count_i = unsat_buffer_count[i];
//         random_i = random[i];
//         @(negedge clk);
//         if(selected_o != selected[i - 2]) begin
//             $display("Random Test %0h failed: Expected: %0h, Got: %0h", i - 2, selected[i - 2], selected_o);
//             r_test_passed[i - 2] = 0;
//         end
//     end
//     @(negedge clk);
//     if(selected_o != selected[NUM_TESTS - 2]) begin
//         $display("Random Test %0h failed: Expected: %0h, Got: %0h", NUM_TESTS - 2, selected[NUM_TESTS - 2], selected_o);
//         r_test_passed[NUM_TESTS - 2] = 0;
//     end
//     @(negedge clk);
//     if(selected_o != selected[NUM_TESTS - 1]) begin
//         $display("Random Test %0h failed: Expected: %0h, Got: %0h", NUM_TESTS - 1, selected[NUM_TESTS - 1], selected_o);
//         r_test_passed[NUM_TESTS - 1] = 0;
//     end

//     // exhaustive tests
//     for(j = 0; j < NUM_EXHAUSTIVE; j = j + 1) begin
//         // reset the system
//         reset = 1;
//         @(negedge clk);
//         @(negedge clk);
//         reset = 0;
//         // tests
//         mt_en_i = 1;
//         unsat_buffer_count_i = unsat_buffer_count_exhaustive[0][j];
//         random_i = random_exhaustive[0][j];
//         @(negedge clk);
//         unsat_buffer_count_i = unsat_buffer_count_exhaustive[1][j];
//         random_i = random_exhaustive[1][j];
//         @(negedge clk);
//         for(i = 2; i < BUFFER_DEPTH; i = i + 1) begin
//             unsat_buffer_count_i = unsat_buffer_count_exhaustive[i][j];
//             random_i = random_exhaustive[i][j];
//             @(negedge clk);
//             if(selected_o != selected_exhaustive[i - 2][j]) begin
//                 $display("Exhaustive Test %0h-%0h failed: Expected: %0h, Got: %0h", j, i - 2, selected_exhaustive[i - 2][j], selected_o);
//                 e_test_passed[j][i - 2] = 0;
//             end
//             // if(selected_exhaustive[i - 2][j] == 0) begin
//             //     $display("Exhaustive Test %0h-%0h expected zero)", i - 2, j);
//             // end
//         end
//         @(negedge clk);
//         if(selected_o != selected_exhaustive[BUFFER_DEPTH - 2][j]) begin
//             $display("Exhaustive Test %0h-%0h failed: Expected: %0h, Got: %0h", j, BUFFER_DEPTH - 2, selected_exhaustive[BUFFER_DEPTH - 2][j], selected_o);
//             e_test_passed[j][BUFFER_DEPTH - 2] = 0;
//         end
//         @(negedge clk);
//         if(selected_o != selected_exhaustive[BUFFER_DEPTH - 1][j]) begin
//             $display("Exhaustive Test %0h-%0h failed: Expected: %0h, Got: %0h", j, BUFFER_DEPTH - 1, selected_exhaustive[BUFFER_DEPTH - 1][j], selected_o);
//             e_test_passed[j][BUFFER_DEPTH - 1] = 0;
//         end

//     end

// e_num_passed_total = 0;
// e_num_missed_avg = 0;

// $display("Unsat Clause Buffer Testbench: End Test");
// for(i = 0; i < NUM_TESTS; i = i + 1) if(r_test_passed[i]) r_num_passed = r_num_passed + 1;
// for(j = 0; j < NUM_EXHAUSTIVE; j = j + 1) for(i = 0; i < BUFFER_DEPTH; i = i + 1) if(e_test_passed[j][i]) e_num_passed[j] = e_num_passed[j] + 1;
// for(j = 0; j < NUM_EXHAUSTIVE; j = j + 1) e_num_passed_total = e_num_passed_total + e_num_passed[j];
// $display("    Random Test Results: %0d/%0d tests passed", r_num_passed, NUM_TESTS);
// for(j = 0; j < NUM_EXHAUSTIVE; j = j + 1) $display("    Exhaustive Test %0d Results: %0d/%0d tests passed", j, e_num_passed[j], BUFFER_DEPTH);
// $display("    Exhaustive Test Results Total: %0d/%0d tests passed", e_num_passed_total, BUFFER_DEPTH * NUM_EXHAUSTIVE);


    $finish;

end

endmodule