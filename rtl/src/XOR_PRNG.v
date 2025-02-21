module XOR_PRNG(
    input             clk_i,
    input             rst_i,
    output reg [31:0] data_o
);
    reg [31:0] lfsr_reg;
    wire [31:0] feedback;
    
    // Feedback polynomial: x^32 + x^22 + x^2 + x^1 + 1
    assign feedback = {lfsr_reg[30:0], lfsr_reg[31] ^ lfsr_reg[21] ^ lfsr_reg[1] ^ lfsr_reg[0]};
    
    always @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            lfsr_reg <= 32'b1;
            // $display("XOR_PRNG Reset at time %0t", $time);
        end else begin
            lfsr_reg <= feedback;
        end
    end
    
    always @(posedge clk_i) begin
        data_o <= lfsr_reg;
        // $display("XOR_PRNG: data_o = 0x%0h at time %0t", data_o, $time);
    end

endmodule
