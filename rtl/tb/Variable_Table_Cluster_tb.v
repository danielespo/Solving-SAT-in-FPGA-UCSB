/*
Variable_Table_Cluster_tb.v
V2.0 Author: Harim Choe (modified for THREAD_ID_WIDTH)

Testbench file for Variable_Table_Cluster.v

Status:
    All tests passed
*/
`timescale 1ns / 1ps

module Variable_Table_Cluster_tb;

    // Parameters
    parameter VARIABLE_ADDRESS_WIDTH = 11;
    parameter THREAD_ID_WIDTH        = 4; // <-- New
    parameter CLUSTER_SIZE           = 20 * 2; // 40 total tables

    // Derived Parameters
    localparam RUNTIME_ADDRESS_WIDTH = THREAD_ID_WIDTH + VARIABLE_ADDRESS_WIDTH; 
    localparam TOTAL_ADDR_WIDTH      = CLUSTER_SIZE * RUNTIME_ADDRESS_WIDTH; 

    // Testbench signals
    reg                               clk;
    reg                               en, wr_en;
    reg  [TOTAL_ADDR_WIDTH-1:0]       addr_m;    // combined thread+variable addresses
    reg                               data_in;
    wire [CLUSTER_SIZE-1:0]          data_out;

    // A small helper function to build {thread_id, var_address}
    function [RUNTIME_ADDRESS_WIDTH-1:0] make_addr;
        input [THREAD_ID_WIDTH-1:0]        thread_id;
        input [VARIABLE_ADDRESS_WIDTH-1:0] var_addr;
    begin
        make_addr = {thread_id, var_addr}; 
    end
    endfunction

    // DUT Instantiation (AXI signals removed)
    Variable_Table_Cluster #(
        .VARIABLE_ADDRESS_WIDTH(VARIABLE_ADDRESS_WIDTH),
        .CLUSTER_SIZE          (CLUSTER_SIZE)
    ) dut(
        .clk_i       (clk),
        .en_i        (en),
        .wr_en_i     (wr_en),
        .addr_mi     (addr_m),
        .data_i      (data_in),
        .data_mo     (data_out)
    );

    // Clock Generation: 100 MHz => period = 10ns
    always #5 clk = ~clk;

    initial begin
        clk    = 0;
        en     = 0;
        wr_en  = 0;
        addr_m = 0;
        data_in = 0;

        $display("TEST 1: Write '1' to var=0x005 (thread=0), read it back...");
        en    = 1;
        wr_en = 1;
        addr_m = {CLUSTER_SIZE{15'h0005}};
        data_in = 1'b1;
        #10;
        wr_en = 0;

        addr_m = {CLUSTER_SIZE{15'h0005}};
        #10;

        if (data_out == {CLUSTER_SIZE{1'b1}})
            $display("TEST 1 PASSED: Write and Read are correct.");
        else
            $display("TEST 1 FAILED: Write and Read are incorrect.");


        $display("TEST 2: Write '0' to var=0x00A (thread=0), read it back...");
        en    = 1;
        wr_en = 1;
        addr_m  = {CLUSTER_SIZE{15'h000A}};
        data_in = 1'b0;
        #10;
        wr_en = 0;

        // Read back from the same addresses
        addr_m  = {CLUSTER_SIZE{15'h000A}};
        #10;

        if (data_out == {CLUSTER_SIZE{1'b0}})
            $display("TEST 2 PASSED: Write and Read are correct.");
        else
            $display("TEST 2 FAILED: Write and Read are incorrect.");

        $display("TEST 3: Overwrite address=0x007 (thread=0)...");
        // First write '1'
        en    = 1;
        wr_en = 1;
        addr_m  = {CLUSTER_SIZE{15'h0007}};
        data_in = 1'b1;
        #10;
        // Now overwrite with '0'
        data_in = 1'b0;
        #10;
        wr_en = 0;

        // Read back
        addr_m  = {CLUSTER_SIZE{15'h0007}};
        #10;

        if (data_out == {CLUSTER_SIZE{1'b0}})
            $display("TEST 3 PASSED: Overwrites are correct.");
        else
            $display("TEST 3 FAILED: Overwrites are incorrect.");

        $display("TEST 4: Testing Multiple Instantiations...");
        en    = 1;
        wr_en = 1;
        addr_m  = {CLUSTER_SIZE{15'h0003}};
        data_in = 1'b1;
        #10;
        wr_en = 0;

        // Runtime read from all instances
        addr_m  = {CLUSTER_SIZE{15'h0003}};
        #10;

        if (data_out == {CLUSTER_SIZE{1'b1}})
            $display("TEST 4 PASSED: Multiple instantiations work as expected.");
        else
            $display("TEST 4 FAILED: Multiple instantiations do not work as expected.");

        $display("TEST 5: Multi-Thread Concurrent Access...");
        en    = 1;
        wr_en = 1;

        // For instance 0 in the cluster, set thread=0, var=0x100
        addr_m[0*RUNTIME_ADDRESS_WIDTH +: RUNTIME_ADDRESS_WIDTH] = make_addr(4'h0, 11'h100);
        // For instance 1 in the cluster, set thread=1, var=0x200
        addr_m[1*RUNTIME_ADDRESS_WIDTH +: RUNTIME_ADDRESS_WIDTH] = make_addr(4'h1, 11'h200);

        // Zero out the rest
        addr_m[TOTAL_ADDR_WIDTH-1 -: (CLUSTER_SIZE-2)*RUNTIME_ADDRESS_WIDTH] = 0;

        data_in = 1'b1; 
        #10;
        wr_en   = 0;

        // Read back from those two addresses (keeping same addresses)
        #10;

        if ((data_out[0] == 1'b1) && (data_out[1] == 1'b1))
            $display("TEST 5 PASSED: Multi-Thread writes do not interfere.");
        else
            $display("TEST 5 FAILED: Data corruption detected.");


        $display("TEST 6: Back-to-Back Flips...");
        en    = 1;
        wr_en = 1;

        // Write '1' to var=0x015, thread=0 for all tables
        addr_m = {CLUSTER_SIZE{15'h0015}};
        data_in = 1'b1;
        #10;

        // Immediately switch to var=0x016, still thread=0
        addr_m = {CLUSTER_SIZE{15'h0016}};
        #10;

        // Check both addresses
        wr_en = 0;

        // Read address=0x015
        addr_m = {CLUSTER_SIZE{15'h0015}};
        #10;
        if (data_out != {CLUSTER_SIZE{1'b1}})
            $display("TEST 6 FAILED: Address 0x015 mismatch.");
        // Read address=0x016
        addr_m = {CLUSTER_SIZE{15'h0016}};
        #10;
        if (data_out != {CLUSTER_SIZE{1'b1}})
            $display("TEST 6 FAILED: Address 0x016 mismatch.");
        else
            $display("TEST 6 PASSED.");

        // End of tests
        $display("All tests completed.");
        $stop;
    end

    // Optional Monitor
    initial begin
        $monitor("Time=%0t | en=%b | wr_en=%b | addr_m=%b | data_in=%b | data_out=%b",
                  $time, en, wr_en, addr_m, data_in, data_out);
    end

endmodule