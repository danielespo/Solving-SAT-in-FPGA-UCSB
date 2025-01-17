/*
Variable_Table_Cluster_tb.v
V1.0 Author: Harim Choe

Testbench file for Variable_Table_Cluster_tb.v

Status:
    All tests passed
*/
`timescale 1ns / 1ps

module Variable_Table_Cluster_tb;

    // Parameters
    parameter VARIABLE_ADDRESS_WIDTH = 11;
    parameter CLUSTER_SIZE = 20 * 2;

    // Local Parameters
    localparam ADDR_WIDTH = VARIABLE_ADDRESS_WIDTH;
    localparam TOTAL_ADDR_WIDTH = CLUSTER_SIZE * VARIABLE_ADDRESS_WIDTH;

    reg clk;
    reg axi_en, axi_wr_en;
    reg [ADDR_WIDTH - 1 : 0] axi_addr;
    reg axi_data;
    reg en, wr_en;
    reg [TOTAL_ADDR_WIDTH - 1 : 0] addr_m;
    reg data_in;
    wire [CLUSTER_SIZE - 1 : 0] data_out;

    // DUT Instantiation
    Variable_Table_Cluster #(
        .VARIABLE_ADDRESS_WIDTH(VARIABLE_ADDRESS_WIDTH),
        .CLUSTER_SIZE(CLUSTER_SIZE)
    ) dut(
        .clk_i(clk),
        .axi_en_i(axi_en),
        .axi_wr_en_i(axi_wr_en),
        .axi_addr_i(axi_addr),
        .axi_data_i(axi_data),
        .en_i(en),
        .wr_en_i(wr_en),
        .addr_mi(addr_m),
        .data_i(data_in),
        .data_mo(data_out)
    );

    // Clock Generation
    always #5 clk = ~clk; // 100 MHz clock

    initial begin
        clk = 0;
        axi_en = 0;
        axi_wr_en = 0;
        axi_addr = 0;
        axi_data = 0;
        en = 0;
        wr_en = 0;
        addr_m = 0;
        data_in = 0;

        // TEST 1: AXI Write and Read
        $display("TEST 1: Performing AXI Write and Read...");
        axi_en = 1;                    
        axi_wr_en = 1;                 
        axi_addr = 11'h005;            
        axi_data = 1'b1;               
        #10;                          
        axi_wr_en = 0;                 

        // Check if data has been written
        en = 1;                       
        wr_en = 0;                    
        addr_m = {CLUSTER_SIZE{11'h005}};
        #10;

        // Verify data output
        if (data_out == {CLUSTER_SIZE{1'b1}})
            $display("TEST 1 PASSED: AXI Write and Read is correct.");
        else
            $display("TEST 1 FAILED: AXI Write and Read is incorrect.");

        // TEST 2: Runtime Write and Read
        $display("TEST 2: Performing Runtime Write and Read...");
        en = 1;                       
        wr_en = 1;                    
        addr_m = {CLUSTER_SIZE{11'h00A}}; 
        data_in = 1'b0;               
        #10;
        wr_en = 0;                     

        // Read back the data
        addr_m = {CLUSTER_SIZE{11'h00A}};
        #10;

        // Verify data output
        if (data_out == {CLUSTER_SIZE{1'b0}})
            $display("TEST 2 PASSED: Runtime Write and Read is correct.");
        else
            $display("TEST 2 FAILED: Runtime Write and Read is incorrect.");

        // TEST 3: Mixed AXI and Runtime Writes
        $display("TEST 3: Performing Mixed AXI and Runtime Writes...");
        axi_en = 1;                   
        axi_wr_en = 1;                 
        axi_addr = 11'h007;           
        axi_data = 1'b1;               
        #10;                          
        axi_wr_en = 0;                 

        en = 1;                       
        wr_en = 1;                     
        addr_m = {CLUSTER_SIZE{11'h007}}; 
        data_in = 1'b0;                
        #10;
        wr_en = 0;                     

        // Read back the data
        addr_m = {CLUSTER_SIZE{11'h007}};
        #10;

        // Verify data output
        if (data_out == {CLUSTER_SIZE{1'b0}})
            $display("TEST 3 PASSED: Mixed AXI and Runtime Writes are correct.");
        else
            $display("TEST 3 FAILED: Mixed AXI and Runtime Writes are incorrect.");

        // TEST 4: Multiple Instantiations
        $display("TEST 4: Testing Multiple Instantiations...");

        // AXI write to both instances
        axi_en = 1;
        axi_wr_en = 1;
        axi_addr = 11'h003;
        axi_data = 1'b1;
        #10;
        axi_wr_en = 0;

        // Runtime read from both instances
        en = 1;
        addr_m = {CLUSTER_SIZE{11'h003}};
        #10;

        if (data_out == {CLUSTER_SIZE{1'b1}})
            $display("TEST 4 PASSED: Multiple instantiations work as expected.");
        else
            $display("TEST 4 FAILED: Multiple instantiations do not work as expected.");

        // End of simulation
        $display("All tests completed.");
        $stop;
    end

    // Monitor signal changes
    initial begin
        $monitor("Time=%0t | en=%b | wr_en=%b | addr_m=%b | data_in=%b | axi_en=%b | axi_wr_en=%b | axi_addr=%d | axi_data=%b", 
                    $time, en, wr_en, addr_m, data_in, axi_en, axi_wr_en, axi_addr, axi_data);
    end

endmodule