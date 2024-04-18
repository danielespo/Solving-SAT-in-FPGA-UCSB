module Clause_Table #(
    parameter MAX_CLAUSES_PER_VARIABLE = 20,             // Number of clauses in the clause table
    parameter NUM_ROWS = 2048,              // Number of rows in the clause table
    parameter LITERAL_ADDRESS_WIDTH = 11,    // Number of bits to address the clause table
    parameter NSAT = 3  // Number of SAT variables (3 for 3-SAT)
)
(
    input                               clk,        // Clock signal
    input                               reset,      // Reset signal
    input [LITERAL_ADDRESS_WIDTH-1:0]   address_i,    // n-bit number to address the clause 
    // clause[i][j] is the jth SAT variable w/ negation bit in the ith clause
    // negation bit is held in the MSB of the variable
    output reg [LITERAL_ADDRESS_WIDTH:0] clauses_o [MAX_CLAUSES_PER_VARIABLE-1:0][NSAT-2:0]    // clause output

    // load input at the beginning:
    
);

// Internal register to hold the clause table
// clause_table[i][j][k] is the kth SAT variable w/ negation bit in the jth clause in the ith row
// negation bit is held in the MSB of the variable
reg [LITERAL_ADDRESS_WIDTH:0] clause_table [NUM_ROWS-1:0][MAX_CLAUSES_PER_VARIABLE-1:0][NSAT-2:0];

integer i, j, k;

// Output the addressed 
// assuming synchronous read, which may be incorrect.
always @(posedge clk) begin
    if (reset) begin
        for (int i=0; i < NUM_ROWS; i = i + 1) begin
            for (int j=0; j < MAX_CLAUSES_PER_VARIABLE; j = j + 1) begin
                for (int k=0; k < NSAT-1; k = k +1) begin
                    clause_table[i][j][k] <= 0;
                end
            end
        end
    end else begin
        for(int i = 0; i < MAX_CLAUSES_PER_VARIABLE; i = i + 1) begin
            for(int j = 0; j < NSAT-1; j = j + 1) begin
                clauses_o[i][j] <= clause_table[address_i][i][j];
            end
        end
    end
end


endmodule