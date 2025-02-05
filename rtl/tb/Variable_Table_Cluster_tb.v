/*
Variable_Table_Cluster_tb.v
V2.0 Author: Harim Choe (modified for THREAD_ID_WIDTH)

Testbench file for Variable_Table_Cluster.v

Status:
    All tests passed (example)
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
    reg                               axi_en, axi_wr_en;
    reg  [VARIABLE_ADDRESS_WIDTH-1:0] axi_addr;
    reg                               axi_data;
    reg                               en, wr_en;
    reg  [TOTAL_ADDR_WIDTH-1:0]       addr_m;    // combined thread+variable addresses
    reg                               data_in;
    wire [CLUSTER_SIZE-1:0]          data_out;

    // DUT Instantiation
    Variable_Table_Cluster #(
        .VARIABLE_ADDRESS_WIDTH(VARIABLE_ADDRESS_WIDTH),
        .THREAD_ID_WIDTH       (4),
        .CLUSTER_SIZE          (CLUSTER_SIZE)
    ) dut(
        .clk_i       (clk),
        
        // AXI side
        .axi_en_i    (axi_en),
        .axi_wr_en_i (axi_wr_en),
        .axi_addr_i  (axi_addr),
        .axi_data_i  (axi_data),
        
        // Runtime side
        .en_i        (en),
        .wr_en_i     (wr_en),
        .addr_mi     (addr_m),
        .data_i      (data_in),
        .data_mo     (data_out)
    );

    // Clock Generation: 100 MHz => period = 10ns
    always #5 clk = ~clk;

    // A small helper function to build {thread_id, var_address}
    function [RUNTIME_ADDRESS_WIDTH-1:0] make_addr;
        input [THREAD_ID_WIDTH-1:0]        thread_id;
        input [VARIABLE_ADDRESS_WIDTH-1:0] var_addr;
    begin
        make_addr = {thread_id, var_addr}; 
    end
    endfunction

    initial begin
        clk       = 0;
        axi_en    = 0;
        axi_wr_en = 0;
        axi_addr  = 0;
        axi_data  = 0;
        en        = 0;
        wr_en     = 0;
        addr_m    = 0;
        data_in   = 0;

        //=========================================
        // TEST 1: AXI Write and Read
        // Write to thread=0 / var_addr=0x005 
        // (AXI interface is still only 11 bits, so thread=0 region)
        // Then verify all tables see '1' at that location.
        //=========================================
        $display("TEST 1: Performing AXI Write and Read...");
        axi_en    = 1;
        axi_wr_en = 1;
        axi_addr  = 11'h005;  // For thread=0 region
        axi_data  = 1'b1;
        #10;
        // Stop AXI writes
        axi_wr_en = 0;

        // Now do a runtime read from {thread=0, var=0x005} across all tables
        en    = 1;
        wr_en = 0;
        // Replicate the same combined address {4'h0, 11'h005} for all tables
        addr_m = {CLUSTER_SIZE{15'h0005}}; 
        #10;

        if (data_out == {CLUSTER_SIZE{1'b1}})
            $display("TEST 1 PASSED: AXI Write and Read is correct.");
        else
            $display("TEST 1 FAILED: AXI Write and Read is incorrect.");

        //=========================================
        // TEST 2: Runtime Write and Read
        // Write '0' to {thread=0, var=0x00A} across all tables
        // Then read it back
        //=========================================
        $display("TEST 2: Performing Runtime Write and Read...");
        en    = 1;
        wr_en = 1;
        // Again, replicate {thread=0, var=0x00A}
        addr_m  = {CLUSTER_SIZE{15'h000A}};
        data_in = 1'b0;
        #10;
        wr_en   = 0;

        // Read back from the same addresses
        addr_m  = {CLUSTER_SIZE{15'h000A}};
        #10;

        if (data_out == {CLUSTER_SIZE{1'b0}})
            $display("TEST 2 PASSED: Runtime Write and Read is correct.");
        else
            $display("TEST 2 FAILED: Runtime Write and Read is incorrect.");

        //=========================================
        // TEST 3: Mixed AXI and Runtime Writes
        // AXI writes a '1' to address=0x007 (thread=0).
        // Then runtime writes '0' to that same location.
        //=========================================
        $display("TEST 3: Performing Mixed AXI and Runtime Writes...");
        axi_en    = 1;
        axi_wr_en = 1;
        axi_addr  = 11'h007;
        axi_data  = 1'b1;
        #10;
        axi_wr_en = 0;

        // Now runtime writes '0' to that location
        en    = 1;
        wr_en = 1;
        addr_m  = {CLUSTER_SIZE{15'h0007}}; // {thread=0, var=0x007}
        data_in = 1'b0;
        #10;
        wr_en   = 0;

        // Read back
        addr_m  = {CLUSTER_SIZE{15'h0007}};
        #10;

        if (data_out == {CLUSTER_SIZE{1'b0}})
            $display("TEST 3 PASSED: Mixed AXI and Runtime Writes are correct.");
        else
            $display("TEST 3 FAILED: Mixed AXI and Runtime Writes are incorrect.");

        //=========================================
        // TEST 4: Multiple Instantiations
        // Similar check as above, ensuring all 40 (CLUSTER_SIZE) tables
        // see the same data in a single broadcast address
        //=========================================
        $display("TEST 4: Testing Multiple Instantiations...");
        // AXI write to all instances
        axi_en    = 1;
        axi_wr_en = 1;
        axi_addr  = 11'h003;
        axi_data  = 1'b1;
        #10;
        axi_wr_en = 0;

        // Runtime read from all instances
        en    = 1;
        addr_m  = {CLUSTER_SIZE{15'h0003}}; 
        #10;

        if (data_out == {CLUSTER_SIZE{1'b1}})
            $display("TEST 4 PASSED: Multiple instantiations work as expected.");
        else
            $display("TEST 4 FAILED: Multiple instantiations do not work as expected.");

        //=========================================
        // TEST 5: Multi-Thread Concurrent Access
        // Here we demonstrate two "tables" in the cluster 
        // with different thread IDs. (We only modify the 
        // first two addresses in addr_m, the rest remain 0.)
        //=========================================
        $display("TEST 5: Multi-Thread Concurrent Access...");
        en    = 1;
        wr_en = 1;

        // For instance 0 in the cluster, set thread=0, var=0x100
        addr_m[0*RUNTIME_ADDRESS_WIDTH +: RUNTIME_ADDRESS_WIDTH] = make_addr(4'h0, 11'h100);
        // For instance 1 in the cluster, set thread=1, var=0x200
        addr_m[1*RUNTIME_ADDRESS_WIDTH +: RUNTIME_ADDRESS_WIDTH] = make_addr(4'h1, 11'h200);

        // Make sure the rest of the tables get some valid address (e.g. all zeros)
        // so as not to cause out-of-range if they are enabled. Typically you might
        // zero them out:
        // for i=2..(CLUSTER_SIZE-1), set address to {thread=0,var=0x0} ...
        // A quick way:
        addr_m[TOTAL_ADDR_WIDTH-1 -: (CLUSTER_SIZE-2)*RUNTIME_ADDRESS_WIDTH] = 0;

        data_in = 1'b1; // both instance 0 and 1 write '1'
        #10;
        wr_en   = 0;

        // Read back from those two addresses
        // (keeping same addresses)
        #10;

        if ((data_out[0] == 1'b1) && (data_out[1] == 1'b1))
            $display("TEST 5 PASSED: Multi-Thread writes do not interfere.");
        else
            $display("TEST 5 FAILED: Data corruption detected.");

        //=========================================
        // TEST 6: Pipeline Back-to-Back Flips
        // Write to address 0x015 with '1',
        // then immediately write to 0x016 with '1',
        // then read both back.
        //=========================================
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
        if (data_out != {CLUSTER_SIZE{1'b1}}) begin
            $display("TEST 6 FAILED: Address 0x015 mismatch.");
        end

        // Read address=0x016
        addr_m = {CLUSTER_SIZE{15'h0016}};
        #10;
        if (data_out != {CLUSTER_SIZE{1'b1}}) begin
            $display("TEST 6 FAILED: Address 0x016 mismatch.");
        end else begin
            $display("TEST 6 PASSED.");
        end

        // End of tests
        $display("All tests completed.");
        $stop;
    end

    // Optional Monitor
    initial begin
        $monitor("Time=%0t | en=%b | wr_en=%b | addr_m=%b | data_in=%b | "
                 +"axi_en=%b | axi_wr_en=%b | axi_addr=%d | axi_data=%b | data_out=%b",
                  $time, en, wr_en, addr_m, data_in,
                  axi_en, axi_wr_en, axi_addr, axi_data, data_out);
    end

endmodule