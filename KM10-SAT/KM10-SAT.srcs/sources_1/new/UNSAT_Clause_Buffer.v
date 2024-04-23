// Skeleton file of the UNSAT buffer, now better
// The truth assignment is downloaded to variable tables in clause evaluators, and the unsatisfied clauses are downloaded in unsatisfied clause buffer

module UNSAT_Clause_Buffer # (
    parameter NSAT = 3,
    parameter LITERAL_ADDRESS_WIDTH = 11
)(
    input clk,
    input reset,
    input [(LITERAL_ADDRESS_WIDTH+1)*NSAT - 1:0] clause_i,
    output reg [(LITERAL_ADDRESS_WIDTH+1)*NSAT - 1:0] clause_o
);

// Temporary storage for the clause input
reg [(LITERAL_ADDRESS_WIDTH+1)*NSAT - 1:0] clause_buffer;

// Buffer the input clause on each clock edge
always @(posedge clk) begin
    if (reset) begin
        clause_buffer <= 0;  // Reset the buffer to 0 on reset
    end else begin
        clause_buffer <= clause_i;  // Update the buffer with the input clause
    end
end

// Output the buffered clause
always @(posedge clk) begin
    if (reset) begin
        clause_o <= 0;  // Reset the output to 0 on reset
    end else begin
        clause_o <= clause_buffer;  // Set the output to the current buffer value
    end
end

endmodule