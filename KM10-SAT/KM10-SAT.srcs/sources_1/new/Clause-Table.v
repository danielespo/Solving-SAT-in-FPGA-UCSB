module ClauseTable #(
    parameter NUM_CLAUSES = 20,             // Number of clauses in the clause table
    parameter NUM_ROWS = 2048,              // Number of rows in the clause table
    parameter CLAUSE_ADDRESS_WIDTH = 11,    // Number of bits to address the clause table
    parameter NSAT = 3  // Number of SAT variables (3 for 3-SAT)
)
(
    input                               clk,        // Clock signal
    input                               reset,      // Reset signal
    input [CLAUSE_ADDRESS_WIDTH-1:0]    address,    // n-bit number to address the clause table
    output reg [CLAUSE_ADDRESS_WIDTH-1:0] clause [NUM_CLAUSES-1:0][NSAT-2:0]    // clause output
);

// Internal register to hold the clause table
reg [CLAUSE_ADDRESS_WIDTH-1:0] clause_table [NUM_ROWS-1:0][NUM_CLAUSES-1:0][NSAT-2:0];

integer i, j, k;

// Output the addressed 
// assuming synchronous read, which may be incorrect.
always @(posedge clk) begin
    if (reset) begin
        for (int i=0; i < NUM_ROWS; i++) begin
            for (int j=0; j < NUM_CLAUSES; j++) begin
                for (int k=0; k < NSAT-1; k++) begin
                    clause_table[i][j][k] <= 0;
                end
            end
        end
    end else begin
        for(int i = 0; i < NUM_CLAUSES; i++) begin
            for(int j = 0; j < NSAT-1; j++) begin
                clause[i][j] <= clause_table[address][i][j];
            end
        end
    end
end


endmodule