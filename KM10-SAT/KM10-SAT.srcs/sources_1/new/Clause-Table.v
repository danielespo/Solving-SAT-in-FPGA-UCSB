module ClauseTable #(
    parameter NUM_CLAUSES = 20,
    parameter NUM_ROWS = 2048,
    parameter CLAUSE_ADDRESS_WIDTH = 11,
)
(
    input                               clk,        // Clock signal
    input                               reset,      // Reset signal
    input [CLAUSE_ADDRESS_WIDTH-1:0]    address,    // n-bit number to address the clause table
    output reg [(CLAUSE_ADDRESS_WIDTH+1)*2-1:0] clause [NUM_CLAUSES-1:0]    // clause output
);

// Internal register to hold the clause table
reg [(CLAUSE_ADDRESS_WIDTH+1)*2-1:0] clause_table [NUM_CLAUSES-1:0][NUM_ROWS-1:0];

// Output the addressed 
// assuming synchronous read, which may be incorrect.
always @(posedge clk) begin
    if (reset) begin
        for (int i=0; i<NUM_CLAUSES; i++) begin
            for (int j=0; j<NUM_ROWS; j++) begin
                clause_table[i][j] <= 0;
            end
        end
    end else begin
        for(int i = 0; i < NUM_CLAUSES; i++) begin
            clause[i] <= clause_table[i][address];
        end
    end
end


endmodule