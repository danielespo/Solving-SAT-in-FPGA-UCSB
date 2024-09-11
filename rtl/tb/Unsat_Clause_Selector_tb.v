/*
Version: 2.0
Unsat_Clause_Buffer.v

Author V1.0: Zeiler Randall-Reed
Author V1.1: Zeiler Randall-Reed
Author V1.2: Zeiler Randall-Reed

Author V2.0: Zeiler Randall-Reed
Author V2.1: Zeiler Randall-Reed

Description:

Status:
- V1.0: testbench in progress, no successful testing yet
- V1.1: 29/30 tests passed - failed test due to rounding error in calculation
- V1.2: all tests passed - determined that by rounding up (instead of down) the errors were eliminated
        added 'exhaustive' tests that try all possible values of unsat_buffer_count with random values

- V2.0: testbench in progress
- V2.1: testbench complete, case tests passed, stress test passed
*/

//`define VERBOSE
`define TEST_TYPE_0 // uncomment for case tests
// `define TEST_TYPE_1 // uncomment for stress test

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
        reg clear_debug_DIV_BY_ZERO;
        wire debug_DIV_BY_ZERO;
    // fifo signals
        reg fifo_empty_i;
        reg [CLAUSE_WIDTH - 1 : 0] fifo_clause_i;
    // prng signal
        reg [31 : 0] random_i;
    // outputs
        wire [$clog2(BUFFER_DEPTH) - 1 : 0] buffer_count_o;
        wire [CLAUSE_WIDTH - 1 : 0] selected_o;
        wire ucb_overflow_o;

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
    .clear_debug_DIV_BY_ZERO(clear_debug_DIV_BY_ZERO),
    .debug_DIV_BY_ZERO(debug_DIV_BY_ZERO),
    .fifo_empty_i(fifo_empty_i),
    .fifo_clause_i(fifo_clause_i),
    .random_i(random_i),
    .buffer_count_o(buffer_count_o),
    .selected_o(selected_o),
    .ucb_overflow_o(ucb_overflow_o)
);

// monitor signals
wire [CLAUSE_WIDTH - 1 : 0] uut_ucb_data [0 : BUFFER_DEPTH - 1];
wire [CLAUSE_WIDTH - 1 : 0] uut_ucb_data_truncated [0 : 128 - 1];
generate
    for(n = 0; n < BUFFER_DEPTH; n = n + 1) begin
        assign uut_ucb_data[n] = uut.unsat_buffer.ram[n];
    end
    for(n = 0; n < 32; n = n + 1) begin
        assign uut_ucb_data_truncated[n] = uut.unsat_buffer.ram[n];
    end
endgenerate
wire [BUF_ADDR_WIDTH - 1 : 0] uut_selection;
assign uut_selection = uut.selection;

wire [RAN_WIDTH + M_TABLE_WIDTH - 1 : 0] uut_product2;
wire [RAN_WIDTH - 1 : 0] der_quotient;
wire [RAN_WIDTH - 1 : 0] uut_N_R1, uut_N_R2;
wire [BUF_ADDR_WIDTH - 1 : 0] uut_m1, uut_m2;
wire uut_request1, uut_request2, uut_request3, uut_request4;
assign uut_product2 = uut.product2;
assign der_quotient = uut.product2[M_TABLE_WIDTH +: RAN_WIDTH] ;
assign uut_N_R1 = uut.N_R1;
assign uut_N_R2 = uut.N_R2;
assign uut_m1 = uut.m1;
assign uut_m2 = uut.m2;
assign uut_request1 = uut.request1;
assign uut_request2 = uut.request2;
assign uut_request3 = uut.request3;
assign uut_request4 = uut.request4;

wire [BUF_ADDR_WIDTH - 1 : 0] uut_mt_addr;
wire [MT_WIDTH - 1 : 0] uut_mt_data_o;
assign uut_mt_addr = uut.mt_addr;
assign uut_mt_data_o = uut.mt_data_o;

wire uut_ucb_en, uut_ucb_we;
wire [BUF_ADDR_WIDTH - 1 : 0] uut_ucb_addr;
wire [CLAUSE_WIDTH - 1 : 0]   uut_ucb_data_in;
wire [CLAUSE_WIDTH - 1 : 0]   uut_ucb_data_out;
wire [BUF_ADDR_WIDTH - 1 : 0] uut_ucb_last_addr;
wire [CLAUSE_WIDTH - 1 : 0]   uut_ucb_last_data;
assign uut_ucb_en = uut.ucb_en;
assign uut_ucb_we = uut.ucb_we;
assign uut_ucb_addr = uut.ucb_addr;
assign uut_ucb_data_in = uut.ucb_data_in;
assign uut_ucb_data_out = uut.ucb_data_out;
assign uut_ucb_last_addr = uut.ucb_last_addr;
assign uut_ucb_last_data = uut.ucb_last_data;

wire uut_setup;
assign uut_setup = uut.setup;

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
  - test D: unsat_buffer_count = 32, (read while loading)
    -> fifo_empty_i should be set to zero, and data should be fed into fifo_clause_i
    -> check that the selection is within expected range
    -> predict selection by knowing random number
    -> make sure count is accurate
  - test E: unsat_buffer_count = 0 
    -> check division by zero
    -> make sure selection logic makes sense (and count is zero)
  - test F: try overfilling the buffer [incomplete]
    -> check overflow flag
  - test G: ensure reading the last element in the buffer doesn't duplicate it [incomplete]
    -> check that the counter decrements, and the next write overwrites it
  - test H: test write_disable (when the fifo value is sent directly to the clause register) [incomplete]

- stress test
    - plan: load the buffer with 128 values initially
        - read the buffer as would be expected in the normal operation of the module
        - load 2048 values as if they came from the FIFO tree 
            - only write sometimes, other times set fifo_empty and just read
        - match each output of the buffer with one of the inserted values 
            - with this many values, there might be duplicates
            - handle this by marking the first unmarked value that matches
        - count the number of matches, and the number of duplicates
        - report the number of matches and duplicates
*/

`ifdef TEST_TYPE_0
/* - - - - - - - - - - - - - - - - - - - - CASE TESTS - - - - - - - - - - - - - - - - - - - - */
    // test params
    parameter TEST_COUNT = 2048;
    parameter READ_WHILE_LOADING = 16;


    // test data
    reg [31 : 0]                        random                      [0 : TEST_COUNT - 1];
    reg [BUF_ADDR_WIDTH - 1 : 0]        expected_selection_index    [0 : TEST_COUNT - 1];
    reg [BUF_ADDR_WIDTH - 1 : 0]        actual_selection_index      [0 : TEST_COUNT - 1];
    reg [CLAUSE_WIDTH - 1 : 0]          expected_selected_clause    [0 : TEST_COUNT - 1];
    reg [CLAUSE_WIDTH - 1 : 0]          actual_selected_clause      [0 : TEST_COUNT - 1];
    reg [BUF_ADDR_WIDTH - 1 : 0]        buf_count                   [0 : TEST_COUNT - 1];

    reg [CLAUSE_WIDTH - 1 : 0]          sim_buffer                  [0 : BUFFER_DEPTH - 1];
    reg [BUF_ADDR_WIDTH - 1 : 0]        sim_index;
    reg [BUF_ADDR_WIDTH - 1 : 0]        sim_counter;
    reg [CLAUSE_WIDTH - 1 : 0]          sim_fifo_clause             [0 : READ_WHILE_LOADING - 1];  
    reg [READ_WHILE_LOADING - 1 : 0]    sim_fifo_counter;        

    reg [CLAUSE_WIDTH - 1 : 0]          fifo_count;

    // reg [$clog2(BUFFER_DEPTH) - 1 : 0]  unsat_buffer_count_exhaustive   [0 : BUFFER_DEPTH][0 : NUM_EXHAUSTIVE - 1];
    // reg [31 : 0]                        random_exhaustive               [0 : BUFFER_DEPTH][0 : NUM_EXHAUSTIVE - 1];
    // reg [$clog2(BUFFER_DEPTH) - 1 : 0]  selected_exhaustive             [0 : BUFFER_DEPTH][0 : NUM_EXHAUSTIVE - 1];

    // test reg
    reg test_passed;
    integer test_cycles;

    // reg [BUFFER_DEPTH - 1 : 0] e_test_passed [0 : NUM_EXHAUSTIVE - 1];
    // integer e_num_passed [0 : NUM_EXHAUSTIVE - 1];
    // integer e_num_passed_total;

    // testbench
    initial begin
        $display("Unsat Clause Buffer Testbench: begin case test");

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

        // test A: unsat_buffer_count = 1
    $display("  Test A: unsat_buffer_count = 1");
        test_cycles = 1;
        expected_selected_clause[0] = {3{12'b011001100110}};
        expected_selection_index[0] = 0;

        reset = 1;
        @(negedge clk);
        @(negedge clk);
        reset = 0;

        setup = 1;
        ucb_setup_wren_i = 1;
        ucb_setup_addr_i = 0;
        ucb_setup_data_i = expected_selected_clause[0];
        @(negedge clk);
        setup = 0;
        fifo_empty_i = 1;

        request_i = 1;
        @(negedge clk);
        request_i = 0;
        @(negedge clk);
        @(negedge clk);
        actual_selection_index[0] = uut_selection;
        @(negedge clk);
        if(selected_o !== expected_selected_clause[0] && actual_selection_index[0] !== expected_selection_index[0]) begin
            $display("    Test A failed: Expected o utput %0h, Got %0h; Expected index %0h, Got %0h", expected_selected_clause[0], selected_o, expected_selection_index[0], actual_selection_index[0]);
        end else if(selected_o !== expected_selected_clause[0]) begin
            $display("    Test A failed: Expected output %0h, Got %0h", expected_selected_clause[0], selected_o);
        end else if(actual_selection_index[0] !== expected_selection_index[0]) begin
            $display("    Test A failed: Expected index %0h, Got %0h", expected_selection_index[0], actual_selection_index[0]);
        end else begin
            $display("    Test A passed");
        end

        @(negedge clk);

    $display("  Test B: unsat_buffer_count = 10");
        $display("    Pre-setup: Generate expected values");
        test_cycles = 10;
        sim_counter = 0;
        test_passed = 1;
        // simulate loading
        for(i = 0; i < test_cycles; i = i + 1) begin
            random[i] = $random;
            sim_buffer[i] = i;
            sim_counter = sim_counter + 1;
        end
        // simulate reading
        for(i = 0; i < test_cycles; i = i + 1) begin
            sim_index = random[i][RANDOM_OFFSET +: RAN_WIDTH] % (sim_counter);
            expected_selected_clause[i] = sim_buffer[sim_index];
            expected_selection_index[i] = sim_index;
            sim_buffer[sim_index] = sim_buffer[sim_counter - 1];
            sim_counter = sim_counter - 1;
        end
        $display("    Setup stage: Load the buffer with sequential values to test");
        reset = 1;
        @(negedge clk);
        @(negedge clk);
        reset = 0;
        setup = 1;
        for(i = 0; i < test_cycles; i = i + 1) begin
            ucb_setup_wren_i = 1;
            ucb_setup_addr_i = i;
            ucb_setup_data_i = i;
            @(negedge clk);
        end
        setup = 0;
        fifo_empty_i = 1;

        $display("    Test stage: Run the module");
        for(i = 0; i < test_cycles; i = i + 1) begin
            random_i = random[i];
            request_i = 1;
            @(negedge clk);
            request_i = 0;
            @(negedge clk);
            @(negedge clk);
            actual_selection_index[i] = uut_selection;
            buf_count[i] = buffer_count_o;
            @(negedge clk);
            actual_selected_clause[i] = selected_o;
        end
        $display("    Test stage: Check the results");
        for(i = 0; i < test_cycles; i = i + 1) begin
            if(actual_selection_index[i] > buf_count[i]) begin
                $display("    Test B-%0d failed: Selection index %0h is greater than buffer count %0h", i, actual_selection_index[i], buf_count[i]);
                test_passed = 0;
            end else if(actual_selection_index[i] !== expected_selection_index[i] || actual_selected_clause[i] !== expected_selected_clause[i]) begin
                $display("    Test B-%0d failed: Expected output %0h, Got %0h; Expected index %0h, Got %0h", i, expected_selected_clause[i], actual_selected_clause[i], expected_selection_index[i], actual_selection_index[i]);
                test_passed = 0;
            end 
        end
        if(test_passed) begin
            $display("    Test B passed");
        end

        @(negedge clk);

    $display("  Test C: unsat_buffer_count = 128");
        $display("    Pre-setup: Generate expected values");
        test_cycles = 128;
        sim_counter = 0;
        test_passed = 1;
        // simulate loading
        for(i = 0; i < test_cycles; i = i + 1) begin
            random[i] = $random;
            sim_buffer[i] = i;
            sim_counter = sim_counter + 1;
        end
        for(i = 0; i < READ_WHILE_LOADING; i = i + 1) begin
            sim_fifo_clause[i] = {12'h001, 24'h000000} | i;
        end
        // simulate reading
        for(i = 0; i < test_cycles; i = i + 1) begin
            sim_index = random[i][RANDOM_OFFSET +: RAN_WIDTH] % (sim_counter);
            expected_selected_clause[i] = sim_buffer[sim_index];
            expected_selection_index[i] = sim_index;
            sim_buffer[sim_index] = sim_buffer[sim_counter - 1];
            sim_counter = sim_counter - 1;
        end
        $display("    Setup stage: Load the buffer with sequential values to test");
        reset = 1;
        @(negedge clk);
        @(negedge clk);
        reset = 0;
        setup = 1;
        for(i = 0; i < test_cycles; i = i + 1) begin
            ucb_setup_wren_i = 1;
            ucb_setup_addr_i = i;
            ucb_setup_data_i = i;
            @(negedge clk);
        end
        setup = 0;
        fifo_empty_i = 1;

        $display("    Test stage: Run the module");
        for(i = 0; i < test_cycles; i = i + 1) begin
            random_i = random[i];
            request_i = 1;
            @(negedge clk);
            request_i = 0;
            @(negedge clk);
            @(negedge clk);
            actual_selection_index[i] = uut_selection;
            buf_count[i] = buffer_count_o;
            @(negedge clk);
            actual_selected_clause[i] = selected_o;
        end
        $display("    Test stage: Check the results");
        for(i = 0; i < test_cycles; i = i + 1) begin
            if(actual_selection_index[i] > buf_count[i]) begin
                $display("    Test C-%0d failed: Selection index %0h is greater than buffer count %0h", i, actual_selection_index[i], buf_count[i]);
                test_passed = 0;
            end else if(actual_selection_index[i] !== expected_selection_index[i] || actual_selected_clause[i] !== expected_selected_clause[i]) begin
                $display("    Test C-%0d failed: Expected output %0h, Got %0h; Expected index %0h, Got %0h", i, expected_selected_clause[i], actual_selected_clause[i], expected_selection_index[i], actual_selection_index[i]);
                test_passed = 0;
            end 
        end
        if(test_passed) begin
            $display("    Test C passed");
        end

        @(negedge clk);

    $display("  Test D: unsat_buffer_count = 16, (read while loading - %0d)", READ_WHILE_LOADING);
        $display("    Pre-setup: Generate expected values");
        test_cycles = 16;
        sim_counter = 0;
        sim_fifo_counter = 0;
        test_passed = 1;
        // simulate loading
        for(i = 0; i < test_cycles; i = i + 1) begin
            random[i] = $random;
            sim_buffer[i] = i;
            sim_counter = sim_counter + 1;
        end
        // simulate buffer
        for(i = 0; i < test_cycles + READ_WHILE_LOADING; i = i + 1) begin
            sim_index = random[i][RANDOM_OFFSET +: RAN_WIDTH] % (sim_counter);
            expected_selected_clause[i] = sim_buffer[sim_index];
            expected_selection_index[i] = sim_index;
            if(sim_fifo_counter < READ_WHILE_LOADING) begin
                for(j = 0; j < 3; j = j + 1) begin
                    sim_buffer[sim_counter] = sim_fifo_clause[sim_fifo_counter];
                    sim_counter = sim_counter + 1;
                    sim_fifo_counter = sim_fifo_counter + 1;
                end
                sim_buffer[sim_index] = sim_fifo_clause[sim_fifo_counter];
                sim_fifo_counter = sim_fifo_counter + 1;
            end else begin
                sim_buffer[sim_index] = sim_buffer[sim_counter - 1];
                sim_counter = sim_counter - 1;
            end
        end
        $display("    Setup stage: Load the buffer with sequential values to test");
        reset = 1;
        @(negedge clk);
        @(negedge clk);
        reset = 0;
        setup = 1;
        for(i = 0; i < test_cycles; i = i + 1) begin
            ucb_setup_wren_i = 1;
            ucb_setup_addr_i = i;
            ucb_setup_data_i = i;
            @(negedge clk);
        end
        setup = 0;
        fifo_empty_i = 0;
        fifo_count = 0;

        $display("    Test stage: Run the module");
        for(i = 0; i < test_cycles + READ_WHILE_LOADING; i = i + 1) begin
            random_i = random[i];
            request_i = 1;
            if(fifo_count < READ_WHILE_LOADING) begin
                fifo_clause_i = sim_fifo_clause[fifo_count];
                fifo_count = fifo_count + 1;
            end else begin
                fifo_empty_i = 1;
            end
            @(negedge clk);
            request_i = 0;
            if(fifo_count < READ_WHILE_LOADING) begin
                fifo_clause_i = sim_fifo_clause[fifo_count];
                fifo_count = fifo_count + 1;
            end else begin
                fifo_empty_i = 1;
            end
            @(negedge clk);
            if(fifo_count < READ_WHILE_LOADING) begin
                fifo_clause_i = sim_fifo_clause[fifo_count];
                fifo_count = fifo_count + 1;
            end else begin
                fifo_empty_i = 1;
            end
            @(negedge clk);
            actual_selection_index[i] = uut_selection;
            buf_count[i] = buffer_count_o;
            if(fifo_count < READ_WHILE_LOADING) begin
                fifo_clause_i = sim_fifo_clause[fifo_count];
                fifo_count = fifo_count + 1;
            end else begin
                fifo_empty_i = 1;
            end
            @(negedge clk);
            actual_selected_clause[i] = selected_o;
        end
        $display("    Test stage: Check the results");
        for(i = 0; i < test_cycles + READ_WHILE_LOADING; i = i + 1) begin
            `ifdef VERBOSE
                $display("      Test D-%2d:", i);
                if(actual_selection_index[i] > buf_count[i]) begin
                    $display("        Test failed: Selection index %0h is greater than buffer count %0h", actual_selection_index[i], buf_count[i]);
                    test_passed = 0;
                end else if(actual_selection_index[i] !== expected_selection_index[i] || actual_selected_clause[i] !== expected_selected_clause[i]) begin
                    $display("        Test failed: Expected output %7h, Got %7h; Expected index %3h, Got %3h", expected_selected_clause[i], actual_selected_clause[i], expected_selection_index[i], actual_selection_index[i]);
                    test_passed = 0;
                end else begin
                    $display("        Test passed: Output %7h, Index %3h", actual_selected_clause[i], actual_selection_index[i]);
                end
            `else
                if(actual_selection_index[i] > buf_count[i]) begin
                    $display("        Test D-%2d failed: Selection index %0h is greater than buffer count %0h", i, actual_selection_index[i], buf_count[i]);
                    test_passed = 0;
                end else if(actual_selection_index[i] !== expected_selection_index[i] || actual_selected_clause[i] !== expected_selected_clause[i]) begin
                    $display("        Test D-%2d failed: Expected output %7h, Got %7h; Expected index %3h, Got %3h", i, expected_selected_clause[i], actual_selected_clause[i], expected_selection_index[i], actual_selection_index[i]);
                    test_passed = 0;
                end
            `endif
        end
        if(test_passed) begin
            $display("    Test D passed");
        end

        @(negedge clk);

    $display("  Test E: unsat_buffer_count = 1");
        test_cycles = 1;

        reset = 1;
        @(negedge clk);
        @(negedge clk);
        reset = 0;

        setup = 1;
        @(negedge clk);
        setup = 0;
        fifo_empty_i = 1;

        request_i = 1;
        @(negedge clk);
        request_i = 0;
        @(negedge clk);
        if(~debug_DIV_BY_ZERO) begin
            $display("    Test E failed: Division by zero not detected");
        end else begin
            $display("    Test E passed");
        end

        clear_debug_DIV_BY_ZERO = 1;
        @(negedge clk);
        clear_debug_DIV_BY_ZERO = 0;

    $display("  Test F: buffer overflow");
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

        test_cycles = 20;

        reset = 1;
        @(negedge clk);
        @(negedge clk);
        reset = 0;

        $display("    Setup stage: Load the buffer with sequential values");
        setup = 1;
        for(i = 0; i < BUFFER_DEPTH - test_cycles; i = i + 1) begin
            ucb_setup_wren_i = 1;
            ucb_setup_addr_i = i;
            ucb_setup_data_i = i;
            @(negedge clk);
        end
        setup = 0;
        $display("   Test stage: Try to overflow the buffer");

        fifo_empty_i = 0;
        for(i = 0; i < test_cycles + 2; i = i + 1) begin
            request_i = 0;
            fifo_clause_i = i;
            @(negedge clk);
        end
        if(!ucb_overflow_o) begin
            $display("    Test F failed: Overflow not detected, buffer count %0h", buffer_count_o);
        end else begin
            $display("    Test F passed");
        end

        @(negedge clk);
        

    $display("  Test G: reading the last element");
        test_passed = 1;
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

        test_cycles = 8;

        reset = 1;
        @(negedge clk);
        @(negedge clk);
        reset = 0;

        $display("    Setup stage: Load the buffer with sequential values");
        setup = 1;
        for(i = 0; i < test_cycles; i = i + 1) begin
            ucb_setup_wren_i = 1;
            ucb_setup_addr_i = i;
            ucb_setup_data_i = i;
            @(negedge clk);
        end
        setup = 0;

        fifo_empty_i = 1;
        $display("    Test stage: Try to read the last element");
        random_i = 3'b111 << RANDOM_OFFSET;
        request_i = 1;
        @(negedge clk);
        request_i = 0;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        if(selected_o !== test_cycles - 1) begin
            $display("    Test G failed: Expected selection %0h, Got %0h", test_cycles - 1, selected_o);
            test_passed = 0;
        end else if(buffer_count_o !== test_cycles - 1) begin
            $display("    Test G failed: Expected buffer count %0h, Got %0h", test_cycles - 1, buffer_count_o);
            test_passed = 0;
        end 
        fifo_empty_i = 0;
        fifo_clause_i = {CLAUSE_WIDTH{1'b1}};
        @(negedge clk);
        if(uut_ucb_data[test_cycles - 1] !== {CLAUSE_WIDTH{1'b1}}) begin
            $display("    Test G failed: Expected clause %0h, Got %0h", {CLAUSE_WIDTH{1'b1}}, uut_ucb_data[test_cycles - 1]);
            test_passed = 0;
        end

        if(test_passed) begin
            $display("    Test G passed");
        end

        @(negedge clk);

    $display("  Test H: write_disable");
        test_passed = 1;
        // set values to zero
        reset = 0;
        setup = 0;
        ucb_setup_wren_i = 0;
        ucb_setup_addr_i = 0;
        ucb_setup_data_i = 0;
        request_i = 0;
        write_disable_i = 0;
        fifo_empty_i = 1;
        fifo_clause_i = 0;
        random_i = 0;

        test_cycles = 8;

        reset = 1;
        @(negedge clk);
        @(negedge clk);
        reset = 0;

        $display("    Setup stage: Load the buffer with sequential values");
        setup = 1;
        for(i = 0; i < test_cycles; i = i + 1) begin
            ucb_setup_wren_i = 1;
            ucb_setup_addr_i = i;
            ucb_setup_data_i = i;
            @(negedge clk);
        end
        setup = 0;

        fifo_empty_i = 0;
        $display("    Test stage: Try to write when write_disable is set");
        for(i = 0; i < test_cycles; i = i + 1) begin
            fifo_clause_i = i;
            if(i > test_cycles/2 - 1) begin
                write_disable_i = 1;
            end
            @(negedge clk);
        end

        $display("    Test stage: Check the results");
        if(buffer_count_o !== test_cycles + test_cycles/2) begin
            $display("    Test H failed: Expected buffer count %0h, Got %0h", test_cycles + test_cycles/2, buffer_count_o);
            test_passed = 0;
        end

        if(test_passed) begin
            $display("    Test H passed");
        end
        

    $display("Unsat Clause Buffer Testbench: End Case Test");
    $finish;
        
    end
        

`elsif TEST_TYPE_1
/* - - - - - - - - - - - - - - - - - - - - STRESS TESTS - - - - - - - - - - - - - - - - - - - - */
    parameter INITIAL_LOAD = 128;
    parameter FIFO_LOAD = 2048;
    parameter TOTAL_LOAD = INITIAL_LOAD + FIFO_LOAD; // 2176

    parameter PIPELINE_DEPTH = 8; // actual depth is 12
    parameter FIFO_RATE_PER_CYCLE = 4; // number of values to write from FIFO per cycle
    parameter FIFO_EMPTY_RATE = 3; // every third cycle, fifo_empty_i is set to 1

    // test data
    reg [31 : 0]                random              [0 : TOTAL_LOAD - 1];
    reg [CLAUSE_WIDTH - 1 : 0]  init_clauses        [0 : INITIAL_LOAD - 1];
    reg [CLAUSE_WIDTH - 1 : 0]  fifo_clauses        [0 : FIFO_LOAD - 1];
    integer                     fifo_counter;

    reg [CLAUSE_WIDTH - 1 : 0]  all_clauses_exp     [0 : TOTAL_LOAD - 1];
    reg                         all_clauses_matched [0 : TOTAL_LOAD - 1];
    reg [CLAUSE_WIDTH - 1 : 0]  output_clauses      [0 : TOTAL_LOAD - 1];
    reg                         output_clauses_v    [0 : TOTAL_LOAD - 1];

    reg other_match;
    reg match_found;

    integer fifo_empty_cycle_counter;
    integer counter;
    integer matches;
    integer misses;
    integer duplicates;

    initial begin
        $display("Unsat Clause Buffer Testbench: begin stress test");

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

        // generate random test data
        $display("  Pre-setup: Generate random test data");
        for(i = 0; i < INITIAL_LOAD; i = i + 1) begin
            init_clauses[i][31:0] = $random;
            init_clauses[i][CLAUSE_WIDTH - 1:32] = $random;
            random[i] = $random;
            all_clauses_exp[i] = init_clauses[i];
            all_clauses_matched[i] = 0;
        end
        for(i = 0; i < FIFO_LOAD; i = i + 1) begin
            fifo_clauses[i][31:0] = $random;
            fifo_clauses[i][CLAUSE_WIDTH - 1:32] = $random;
            random[INITIAL_LOAD + i] = $random;
            all_clauses_exp[INITIAL_LOAD + i] = fifo_clauses[i];
            all_clauses_matched[INITIAL_LOAD + i] = 0;
        end

        $display("  Setup stage: Load the buffer with sequential values to test");
        reset = 1;
        @(negedge clk);
        @(negedge clk);
        reset = 0;
        setup = 1;
        for(i = 0; i < INITIAL_LOAD; i = i + 1) begin
            ucb_setup_wren_i = 1;
            ucb_setup_addr_i = i;
            ucb_setup_data_i = init_clauses[i];
            @(negedge clk);
        end
        setup = 0;

        $display("  Test stage: Run the module");
        fifo_empty_cycle_counter = 1;
        fifo_counter = 0;
        counter = 0;
        matches = 0;
        misses = 0;
        duplicates = 0;
        while(buffer_count_o !== 0) begin
            if(fifo_empty_cycle_counter == FIFO_EMPTY_RATE) begin
                fifo_empty_i = 1;
                fifo_empty_cycle_counter = 1;
            end else begin
                fifo_empty_i = 0;
                fifo_empty_cycle_counter = fifo_empty_cycle_counter + 1;
            end
            // if fifo data is exhausted, set fifo to empty
            if(fifo_counter == FIFO_LOAD) fifo_empty_i = 1;
            for(i = 0; i < PIPELINE_DEPTH; i = i + 1) begin
                // request at beginning of each pipeline
                if(i == 0) request_i = 1;
                else request_i = 0;

                // record the output 4 stages after request
                if(i == 4) begin
                    output_clauses[counter] = selected_o;
                    output_clauses_v[counter] = 1;
                    counter = counter + 1;
                end

                // write from FIFO for first 4 cycles (or not if marked empty)
                if(i < FIFO_RATE_PER_CYCLE && !fifo_empty_i) begin
                    fifo_clause_i = fifo_clauses[fifo_counter];
                    fifo_counter = fifo_counter + 1;
                end else begin
                    fifo_empty_i = 1;
                    fifo_clause_i = 0;
                end

                @(negedge clk);
            end
        end

        $display("Unsat Clause Buffer Testbench: End Stress Test");
        $display("    Calculating Results ...");
        for(i = 0; i < TOTAL_LOAD; i = i + 1) begin
            other_match = 0;
            match_found = 0;
            for(j = 0; j < TOTAL_LOAD; j = j + 1) begin
                if(all_clauses_exp[i] === output_clauses[j] && !match_found) begin
                    if(!all_clauses_matched[j]) begin
                        all_clauses_matched[j] = 1;
                        match_found = 1;
                        matches = matches + 1;
                    end else begin
                        other_match = 1;
                    end
                end
            end
            if(!match_found) begin
                if(other_match) begin
                    duplicates = duplicates + 1;
                    $display("    Test failed: Output %0h is a duplicate", output_clauses[i]);
                end else begin
                    misses = misses + 1;
                    $display("    Test failed: Output %0h not found in expected values", output_clauses[i]);
                end
            end
        end
        $display("    Matches: %0d", matches);
        $display("    Misses: %0d", misses);
        $display("    Duplicates: %0d", duplicates);
        $display("    Total clauses: %0d", TOTAL_LOAD);
        $finish;
    end
    
`else
    $display("No test type selected");
`endif    

//     // generate random test data
//     for(i = 0; i < TEST_COUNT; i = i + 1) begin
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
//     r_test_passed = {TEST_COUNT{1'b1}};
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
//     for(i = 2; i < TEST_COUNT; i = i + 1) begin
//         unsat_buffer_count_i = unsat_buffer_count[i];
//         random_i = random[i];
//         @(negedge clk);
//         if(selected_o != selected[i - 2]) begin
//             $display("Random Test %0h failed: Expected: %0h, Got: %0h", i - 2, selected[i - 2], selected_o);
//             r_test_passed[i - 2] = 0;
//         end
//     end
//     @(negedge clk);
//     if(selected_o != selected[TEST_COUNT - 2]) begin
//         $display("Random Test %0h failed: Expected: %0h, Got: %0h", TEST_COUNT - 2, selected[TEST_COUNT - 2], selected_o);
//         r_test_passed[TEST_COUNT - 2] = 0;
//     end
//     @(negedge clk);
//     if(selected_o != selected[TEST_COUNT - 1]) begin
//         $display("Random Test %0h failed: Expected: %0h, Got: %0h", TEST_COUNT - 1, selected[TEST_COUNT - 1], selected_o);
//         r_test_passed[TEST_COUNT - 1] = 0;
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

endmodule