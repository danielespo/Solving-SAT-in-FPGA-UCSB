`timescale 1ns / 1ps

module Address_Translation_Table_tb;
    
    // Parameters
    parameter MAX_CLAUSES_PER_VARIABLE = 20;
    parameter LITERAL_ADDRESS_WIDTH = 11;
    parameter Nv = 32; // Number of variables
    parameter NvLog2 = 5; // Log2(Nv), adjust based on Nv
    parameter AT_SIZE = Nv * 2; // Twice the number of variables for negation bit

    // Testbench Signals Inputs
    reg clk;
    reg reset;
    reg [LITERAL_ADDRESS_WIDTH:0] index_i; // Input index_i to select an entry, assuming 11 bits for variable number + 1 bit for negation
    
    // Outputs
    reg [LITERAL_ADDRESS_WIDTH-1:0] address_o; // Output address_o field corresponding to the index_i (11b)
    reg [MAX_CLAUSES_PER_VARIABLE:0] mask_o; // Output mask_o field corresponding to the index_i (20b)

    // Start the module (UUT)
    Address_Translation_Table #(
        .MAX_CLAUSES_PER_VARIABLE(MAX_CLAUSES_PER_VARIABLE),
        .NvLog2(NvLog2),
        .AT_SIZE(AT_SIZE),
        .Nv(Nv),
        .LITERAL_ADDRESS_WIDTH(LITERAL_ADDRESS_WIDTH)
    ) uut (
        .clk(clk),
        .reset(reset),
        .index_i(index_i),
        .address_o(address_o),
        .mask_o(mask_o)
    );

    // Clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Generate a clock with a period of 10ns
    end
    integer i;  // Declare loop variables outside the for loop (verilog hates us)
    integer j; 

    initial begin
        // Initialize inputs
        reset = 1;
        index_i = 0;

        // Wait for global reset to finish
        @(posedge clk);
        reset = 0;

        // Test Case 1: Check reset behavior
        @(posedge clk);
        index_i = 1;  // Set index to 1
        @(posedge clk);
        index_i = 2;  // Set index to 2

        // Test Case 2: internal storage with test values
        @(posedge clk); // Wait for a positive edge of the clock
        for (i = 0; i < AT_SIZE; i = i + 1) begin
            @(posedge clk); // Wait for clock edge for each operation to mimic realistic scenario
            uut.internal_mask_field[i] = {20{i[0]}}; // Alternate pattern for mask
        end

        // Check initialized values
        @(posedge clk);
        for (j = 0; j < AT_SIZE; j = j + 1) begin
            @(posedge clk); // Update index on a clock edge
            index_i = j;
            @(posedge clk); // Wait for another clock edge to observe the output
        end


        // Test Case 2: Random access
        #10;
        index_i = {$random} % AT_SIZE;  // Random index

        // Additional test cases can be added here

        // Finish simulation
        #100;
        $finish;
    end

    // Monitor changes
    initial begin
        $monitor("Time = %t, index_i = %d, address_o = %b, mask_o = %b", $time, index_i, address_o, mask_o);
    end
    
    // Check the correctness of outputs
    initial begin
        for (j = 0; j < AT_SIZE; j = j+1) begin
            @(posedge clk);
            index_i = j;
            @(posedge clk);
            // Asserting expected output
            if (address_o !== j[10:0] || mask_o !== {20{j[0]}}) begin
                $display("Assertion failed at index %d: expected address_o = %b, mask_o = %b, got address_o = %b, mask_o = %b",
                        j, j[10:0], {20{j[0]}}, address_o, mask_o);
                $finish;
            end
        end
    end
    
endmodule
