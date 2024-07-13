/* 
Break_Value_Counter.v
Author: Zeiler Randall-Reed
Module name: BreakValueCounter

Description:
This module takes the output of the clause evaluators as an input.
It expects an array of bits, where each bit represents the evaluation of a clause.
If the clause is broken, the bit is set to 1, otherwise it is set to 0.
The module counts the number of broken clauses and outputs the break value.

Notes:
- My understanding is that the temporal buffers will contain the logic
    for determining clause fitness. This module is simply counting the 
    number of broken clauses from the clause evaluators. 
- There may be more work necessary if I have misunderstood this.
- If not, this module is ready for testing.

Testing:
- testbench file created 5/23/24
- all tests passed

*/
module Break_Value_Counter #(
    parameter NUM_CLAUSES = 20,
    parameter NUM_ROWS = 3,
    parameter NUM_CLAUSES_BITS = 5
)
(
    input           clk,                            // Clock signal
    input           reset,                          // Reset signal
    input [NUM_CLAUSES-1:0] clause ,                // bits indicating if the clause is broken / unsatisfied
    output reg [NUM_CLAUSES_BITS-1:0] break_value   // number of clauses that are broken
);

integer index;

always @(posedge clk) begin
    if(reset) begin         // on reset, reset the output
        break_value = 0;
    end else begin
        break_value = 0;   // set the output to 0
        for(index = 0; index < NUM_CLAUSES; index = index + 1) begin    // loop through the "isBroken" array
            if(clause[index]) begin
                break_value = break_value + 1'b1;                         // increment the output for each broken clause
            end
        end
    end
end

endmodule