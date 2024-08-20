/* 
Version: 1.1
Break_Value_Counter.v

V1.0 Author: Zeiler Randall-Reed
V2.0 Author: Zeiler Randall-Reed
V2.1 Author: Barry Wang
V2.2 Author: Zeiler Randall-Reed

Description:
This module takes the output of the clause evaluators, and clause table mask as an input. It 
expects an array of bits, where each bit represents the evaluation of a clause. If the clause is
broken, the bit is set to 1, otherwise it is set to 0. The module counts the number of broken 
clauses and outputs the break value.

Notes:
- 8/16 : according to the diagram, this module is not clocked. It is a combinatorial module that 
    works in conjunction with the Heuristic_Selector and some regs in the Break_Counter_Selector
- 8/18 : changed the summation method to one that is inefficient but works. 
V2.1
- 8/19 : changed to an always(*) block to allow for more optimizations
V2.2
- 8/19 : added `SIM` macro to bypass Vivado's restriction of the use of $clog2 in simulation


    
Testing:
V1.0
- testbench file created 5/23/24
- all tests passed (august)
V2.0
- 8/15: tb not yet created - might test along with Heuristic_Selector in Break_Counter_Selector.v
V2.1
- 8/18: tb not yet created - will test standalone and as a part of Break_Counter_Selector.v
- 8/18: all tests passed
V2.2
- 8/19 : checked with digitaljs
- 8/19 : all tests passed

Change Log:
2024/08/15 - Barry Wang
    Added mask support
    
*/
module Break_Value_Counter #(
    parameter NUM_CLAUSES = 20,
    parameter NUM_ROWS = 3
    `ifdef SIM
    , parameter NUM_CLAUSES_BITS = 5
    `endif
)
(
    // input                                   clk,                // Clock signal
    // input                                   reset,              // Reset signal
    input       [NUM_CLAUSES - 1 : 0]           clause_broken_i,    // bits indicating if the clause is broken / unsatisfied
    input       [NUM_CLAUSES - 1 : 0]           mask_bits_i,        // valid mask from the clause table
    `ifdef SIM
    input       [NUM_CLAUSES_BITS - 1 : 0]      break_value_o,      // number of clauses that are broken
    `else
    output reg  [$clog2(NUM_CLAUSES) - 1 : 0]   break_value_o,      // number of clauses that are broken
    `endif
    output wire [NUM_CLAUSES - 1 : 0]           clause_broken_o     // forwarding of bits indicating if the clauseis broken / unsatisfied
);

`ifndef SIM
localparam NUM_CLAUSES_BITS = $clog2(NUM_CLAUSES);
`endif
    
integer i;

assign clause_broken_o = clause_broken_i & mask_bits_i;
  
always @ (*) begin
    break_value_o = 0;
    for (i = 0; i < NUM_CLAUSES; i = i+1) begin
        break_value_o = break_value_o + clause_broken_o[i];
    end 
end
  
endmodule
