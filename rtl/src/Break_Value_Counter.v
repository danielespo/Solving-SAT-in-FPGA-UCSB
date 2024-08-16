/* 
Version: 1.1
Break_Value_Counter.v

V1.0 Author: Zeiler Randall-Reed
V1.1 Author: Zeiler Randall-Reed

Description:
This module takes the output of the clause evaluators, and clause table mask as an input. It 
expects an array of bits, where each bit represents the evaluation of a clause. If the clause is
broken, the bit is set to 1, otherwise it is set to 0. The module counts the number of broken 
clauses and outputs the break value.

Notes:
- My understanding is that the temporal buffers will contain the logic
    for determining clause fitness. This module is simply counting the 
    number of broken clauses from the clause evaluators. 
- There may be more work necessary if I have misunderstood this.
- If not, this module is ready for testing.

Testing:
V1.0
- testbench file created 5/23/24
- all tests passed
V1.1
- testbench not yet created - might test along with Heuristic_Selector in Break_Counter_Selector.v

*/
module Break_Value_Counter #(
    parameter NUM_CLAUSES = 20,
    parameter NUM_ROWS = 3,
    parameter NUM_CLAUSES_BITS = 5
)
(
    input                                   clk,                // Clock signal
    input                                   reset,              // Reset signal
    input       [NUM_CLAUSES - 1 : 0]       clause_broken_i,    // bits indicating if the clause is broken / unsatisfied
    input       [NUM_CLAUSES - 1 : 0]       mask_bits_i,        // valid mask from the clause table
    output reg  [NUM_CLAUSES_BITS - 1 : 0]  break_value_o,      // number of clauses that are broken
    output reg  [NUM_CLAUSES - 1 : 0]       clause_broken_o     // forwarding of bits indicating if the clause is broken / unsatisfied
);

integer i;

always @(posedge clk) begin
    if(reset) begin         // on reset, reset the output
        break_value_o = 0;
        clause_broken_o = 0;
    end else begin
        break_value_o = 0;  // set the output to 0
        for(i = 0; i < NUM_CLAUSES; i = i + 1) begin        // loop through the broken and mask bits
            if(clause_broken_i[i] && mask_bits[i]) begin    // if the clause is broken and the mask is valid for a given clause,
                break_value_o = break_value_o + 1'b1;       // increment the break value counter
            end
        end
        clause_broken_o = clause_broken_i;                  // forward the clause broken bits
    end
end

endmodule