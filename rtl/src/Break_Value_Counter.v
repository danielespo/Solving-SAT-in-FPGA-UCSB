/* 
Version: 1.1
Break_Value_Counter.v

V1.0 Author: Zeiler Randall-Reed
V2.0 Author: Zeiler Randall-Reed

Description:
This module takes the output of the clause evaluators, and clause table mask as an input. It 
expects an array of bits, where each bit represents the evaluation of a clause. If the clause is
broken, the bit is set to 1, otherwise it is set to 0. The module counts the number of broken 
clauses and outputs the break value.

Notes:
- 8/16 : according to the diagram, this module is not clocked. It is a combinatorial module that 
    works in conjunction with the Heuristic_Selector and some regs in the Break_Counter_Selector

Testing:
V1.0
- testbench file created 5/23/24
- all tests passed
V2.0
- testbench not yet created - might test along with Heuristic_Selector in Break_Counter_Selector.v

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

wire [NUM_CLAUSES_BITS - 1 : 0] break_sum_steps [NUM_CLAUSES - 1 : 0];

genvar i;
generate
    for(i = 0; i < NUM_CLAUSES / 2; i = i + 1) begin
        assign break_sum_steps[i] = clause_broken_i[i * 2] + clause_broken_i[i * 2 + 1];
    end
    for(i = 0; i < NUM_CLAUSES / 4; i = i + 1) begin
        assign break_sum_steps[i + NUM_CLAUSES / 2] = break_sum_steps[i * 2] + break_sum_steps[i * 2 + 1];
    end
    assign break_sum_steps[0] = clause_broken_i[0] + clause_broken_i[1];
    for(i = 0; i < NUM_CLAUSES; i = i + 1) begin
        assign break_value_o = break_value_o + (clause_broken_i[i] && mask_bits[i]);
    end
endgenerate

assign clause_broken_o = clause_broken_i & mask_bits_i;

// always @(posedge clk) begin
//     if(reset) begin         // on reset, reset the output
//         break_value_o = 0;
//         clause_broken_o = 0;
//     end else begin
//         break_value_o = 0;  // set the output to 0
//         for(i = 0; i < NUM_CLAUSES; i = i + 1) begin        // loop through the broken and mask bits
//             if(clause_broken_i[i] && mask_bits[i]) begin    // if the clause is broken and the mask is valid for a given clause,
//                 break_value_o = break_value_o + 1'b1;       // increment the break value counter
//             end
//         end
//         clause_broken_o = clause_broken_i;                  // forward the clause broken bits
//     end
// end

endmodule