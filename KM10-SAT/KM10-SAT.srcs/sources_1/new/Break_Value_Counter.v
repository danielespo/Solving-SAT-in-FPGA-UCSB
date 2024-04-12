/* 
MODULE NAME: BreakValueCounter

This module takes the output of the clause evaluators as an input.
It expects an array of bits, where each bit represents the evaluation of a clause.
If the clause is broken, the bit is set to 1, otherwise it is set to 0.
The module counts the number of broken clauses and outputs the break value.

NOTES:
- My understanding is that the temporal buffers will contain the logic
    for determining clause fitness. This module is simply counting the 
    number of broken clauses from the clause evaluators. 
- There may be more work necessary if I have misunderstood this.
- If not, this module is ready for testing.

*/
module Break_Value_Counter #(
    parameter MAX_CLAUSES_PER_VARIABLE = 20,
    parameter NSAT = 3,
    parameter MAX_CLAUSES_PER_VARIABLE_BITS = clog2(MAX_CLAUSES_PER_VARIABLE)
)
(
    input           clk,                            // Clock signal
    input           reset,                          // Reset signal
    input           clause_sat_i [MAX_CLAUSES_PER_VARIABLE-1:0],       // array of bits indicating if the clause is broken / unsatisfied
    output reg [MAX_CLAUSES_PER_VARIABLE_BITS-1:0] break_value_o   // number of clauses that are broken
);

integer index;

always @(posedge clk) begin
    if(reset) begin         // on reset, reset the output
        break_value_o <= 0;
    end else begin
        break_value_o <= 0;   // set the output to 0
        for(index = 0; index < MAX_CLAUSES_PER_VARIABLE; index = index + 1) begin    // loop through the "isBroken" array
            if(clause_sat_i[index]) begin
                break_value_o <= break_value_o + 1;                         // increment the output for each broken clause
            end
        end
    end
end

endmodule