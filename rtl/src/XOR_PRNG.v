module XOR_PRNG(
    input             clk_i, // Clock signal
    input             rst_i, // Reset signal
    output reg [31:0] data_o // 32-bit output
);
    // Internal register to hold the current state
    reg [31:0] lfsr_reg;
    
    // Feedback polynomial: x^32 + x^22 + x^2 + x^1 + 1
    // It's important to choose a polynomial that will ensure a maximal length cycle for the LFSR.
    // The choice of polynomial depends on the number of bits in the LFSR.
    wire feedback = lfsr_reg[31] ^ lfsr_reg[21] ^ lfsr_reg[1] ^ lfsr_reg[0];
    
    always @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            // Reset or initialize LFSR with a non-zero value
            // Non-zero to avoid the LFSR getting stuck in a zero state
            lfsr_reg <= 32'b1;
        end
        else begin
            // Shift left by one bit and insert feedback into LSB
            lfsr_reg <= {lfsr_reg[30:0], feedback};
        end
    end
    
    // Output the current state of the LFSR
    always @(posedge clk) begin
        data_o <= lfsr_reg;
    end

endmodule