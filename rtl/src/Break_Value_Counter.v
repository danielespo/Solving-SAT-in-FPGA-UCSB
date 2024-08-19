/* 
Version: 1.1
Break_Value_Counter.v

V1.0 Author: Zeiler Randall-Reed
V2.0 Author: Zeiler Randall-Reed
V2.1 Author: Zeiler Randall-Reed

Description:
This module takes the output of the clause evaluators, and clause table mask as an input. It 
expects an array of bits, where each bit represents the evaluation of a clause. If the clause is
broken, the bit is set to 1, otherwise it is set to 0. The module counts the number of broken 
clauses and outputs the break value.

Notes:
- 8/16 : according to the diagram, this module is not clocked. It is a combinatorial module that 
    works in conjunction with the Heuristic_Selector and some regs in the Break_Counter_Selector
- 8/18 : changed the summation method to one that is inefficient but works. see related comment 
    in the code below. (line 45-47)

Testing:
V1.0
- testbench file created 5/23/24
- all tests passed (august)
V2.0
- 8/15: tb not yet created - might test along with Heuristic_Selector in Break_Counter_Selector.v
V2.1
- 8/18: tb not yet created - will test standalone and as a part of Break_Counter_Selector.v
- 8/18: all tests passed

*/
module Break_Value_Counter #(
    parameter NUM_CLAUSES = 20,
    parameter NUM_ROWS = 3,
    parameter NUM_CLAUSES_BITS = 5
)
(
    // input                                   clk,                // Clock signal
    // input                                   reset,              // Reset signal
    input       [NUM_CLAUSES - 1 : 0]       clause_broken_i,    // bits indicating if the clause is broken / unsatisfied
    input       [NUM_CLAUSES - 1 : 0]       mask_bits_i,        // valid mask from the clause table
    output wire [NUM_CLAUSES_BITS - 1 : 0]  break_value_o,      // number of clauses that are broken
    output wire [NUM_CLAUSES - 1 : 0]       clause_broken_o     // forwarding of bits indicating if the clause is broken / unsatisfied
);

wire [NUM_CLAUSES_BITS - 1 : 0] break_sum_steps [NUM_CLAUSES - 2 : 0];


// this has the potential to be slow. if timing issues arise, consider a more efficient summation method
// - maybe try a tree of some sort. I was having a hard time finding a way to make one that is 
//   parameterizable, so I chose this simpler (and potentially slower) option.
genvar i;
generate
    assign break_sum_steps[0] = (clause_broken_i[0] & mask_bits_i[0]) + (clause_broken_i[1] & mask_bits_i[1]);
    for(i = 0; i < NUM_CLAUSES - 2; i = i + 1) begin
        assign break_sum_steps[i + 1] = break_sum_steps[i] + (clause_broken_i[i + 2] & mask_bits_i[i + 2]);
    end
endgenerate

assign break_value_o = break_sum_steps[NUM_CLAUSES - 2];
assign clause_broken_o = clause_broken_i & mask_bits_i;

endmodule