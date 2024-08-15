/* 
Version: 1.1
Break_Value_Counter.v

V1.0 Author: Zeiler Randall-Reed
V1.1 Author: Barry Wang

Module name: Break_Value_Counter

Description:
    This module takes the output of the clause evaluators as an input.
    It expects an array of bits, where each bit represents the evaluation of a clause.
    If the clause is broken, the bit is set to 1, otherwise it is set to 0.
    The module counts the number of broken clauses and outputs the break value.
    
Testing:
    V1.0 testbench file created 5/23/24
    V1.0 all tests passed
    V1.1 checked with digitaljs

Change Log:

2024/08/15 - Barry Wang
    Added mask support
    
*/
module Break_Value_Counter #(
    parameter NUM_CLAUSES = 20,
    parameter NUM_ROWS = 3,
    parameter NUM_CLAUSES_BITS = 5
)
(
    input           clk,                            // Clock signal
    input           reset,                          // Reset signal
    input [NUM_CLAUSES-1:0] is_broken ,             // bits indicating if the clause is broken / unsatisfied
    input [NUM_CLAUSES-1:0] mask,                   // is_broken valid mask
    output reg [NUM_CLAUSES_BITS-1:0] break_value   // number of clauses that are broken
);

integer index;

always @(posedge clk) begin
    if(reset) begin         // on reset, reset the output
        break_value = 0;
    end else begin
        break_value = 0;   // set the output to 0
        for(index = 0; index < NUM_CLAUSES; index = index + 1) begin    // loop through the "isBroken" array
            if(is_broken[index] && mask[index]) begin
                break_value = break_value + 1'b1;                         // increment the output for each broken clause
            end
        end
    end
end

endmodule