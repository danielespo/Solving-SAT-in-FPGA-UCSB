// ucsbece154b_top_tb.v
// All Rights Reserved
// Copyright (c) 2024 UCSB ECE
// Distribution Prohibited


`define SIM
`define ASSERT(CONDITION, MESSAGE) if ((CONDITION)==1'b1); else begin $error($sformatf MESSAGE); end

module XOR_PRNG_tb ();

// Inputs
reg clk;
reg reset;

// Outputs
wire [31:0] out;

// Instantiate the Design Under Test (DUT)
XOR_PRNG dut (
    .clk_i(clk), 
    .rst_i(reset), 
    .data_o(out)
);

// Clock generation
initial begin
    clk = 0;
    forever #1 clk = ~clk; // Generate a clock with a period of 20ns
end

// Test sequence
initial begin
    // Initialize Inputs
    reset = 1;
    
    // Wait for the global reset
    #100;
    
    // Release the reset
    reset = 0;

    // Wait for a specific amount of time to observe the output
    #2000;

    // Stop the simulation
    $stop;
end

// Optional: Monitor changes
initial begin
    $monitor("Time=%t, Reset=%b, Output=%b", $time, reset, out);
end

endmodule
