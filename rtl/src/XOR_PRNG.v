module lfsr_prng(
    input clk,          // Clock signal
    input reset,        // Reset signal
    output reg [31:0] out // 32-bit output
);

// Internal register to hold the current state
reg [31:0] lfsr_reg;

// Feedback polynomial: x^32 + x^22 + x^2 + x^1 + 1
// It's important to choose a polynomial that will ensure a maximal length cycle for the LFSR.
// The choice of polynomial depends on the number of bits in the LFSR.
wire feedback = lfsr_reg[31] ^ lfsr_reg[21] ^ lfsr_reg[1] ^ lfsr_reg[0];

always @(posedge clk or posedge reset) begin
    if (reset) begin
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
    out <= lfsr_reg;
end

endmodule