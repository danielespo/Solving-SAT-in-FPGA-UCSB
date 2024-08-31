/*
Version: 1.0
M_Table_tb.v

Author V1.0: Zeiler Randall-Reed

Description:
Testbench for the 1/m table module.

Status:
- V1.0: testbench in progress, no successful testing yet

*/

module M_Table_tb;

parameter BUFFER_DEPTH = 2048;
parameter M_TABLE_WIDTH = 32;
parameter M_TABLE_NAME = "M_table_roundup.mem";

integer i;

// i/o
    reg clk;
    always #5 clk = ~clk;
    reg en, we;
    reg [$clog2(BUFFER_DEPTH) - 1 : 0] addr_i;
    reg [M_TABLE_WIDTH - 1 : 0] data_i;
    reg clear_debug_DIV_BY_ZERO;
    wire [M_TABLE_WIDTH : 0] data_o;
    wire debug_DIV_BY_ZERO;

// module instantiation
    M_Table #(
        .BUFFER_DEPTH(BUFFER_DEPTH),
        .M_TABLE_WIDTH(M_TABLE_WIDTH),
        .M_TABLE_NAME(M_TABLE_NAME)
    ) m_table (
        .clk(clk),
        .en(en),
        .addr_i(addr_i),
        .clear_debug_DIV_BY_ZERO(clear_debug_DIV_BY_ZERO),
        .data_o(data_o),
        .debug_DIV_BY_ZERO(debug_DIV_BY_ZERO)
    );

// test data
    reg [M_TABLE_WIDTH - 1 : 0] m_table_expected [0 : BUFFER_DEPTH - 1];
    reg [BUFFER_DEPTH - 1 : 0] test_passed;
    integer num_passed = 0;

initial begin
    $display("Starting M_Table_tb testbench");
    $readmemh(M_TABLE_NAME, m_table_expected);
    // test

    // reset
    clk = 0;
    en = 0;
    we = 0;
    addr_i = 0;
    data_i = 0;
    clear_debug_DIV_BY_ZERO = 0;
    test_passed = {BUFFER_DEPTH{1'b1}};
    num_passed = BUFFER_DEPTH;

    @(negedge clk);
    @(negedge clk);

    // check if data matches
    
    for(i = 0; i < BUFFER_DEPTH; i = i + 1) begin
        en = 1;
        addr_i = i;
        @(negedge clk);
        if(data_o !== m_table_expected[i]) begin
            $display("Error: data_o[%0d] = %0h, expected %0h", i, data_o, m_table_expected[i]);
            test_passed[i] = 1'b0;
            num_passed = num_passed - 1;
        end
    end
    
    $display("M_Table_tb testbench complete");
    $display("Number of tests passed: %0d/%0d", num_passed, BUFFER_DEPTH);
    $finish;

end

endmodule