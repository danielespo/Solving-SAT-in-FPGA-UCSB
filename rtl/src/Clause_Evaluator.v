/* ----------------------------------------------------
Version: 2.0
Clause_Evaluator.v

V1.0 Author: Ben Richardson
V2.0 Author: Barry Wang

Description:
    This is a singular Clause Evaluator with i/o
    buffer configurations. 

Notes: 
    This module is defaulted to input buffered
    (clocked at input).
    Reset will set the next break output to all
    zeros (next clock rising edge).

Testing:
    2024/05/24 V1.0 testbench file created
    2024/07/16 V1.0 testbench invalidated
    2024/07/17 V2.0 tested as a submodule in Clause_Evaluator_20

Change Log:

2024/07/16 - Barry Wang
    Make Version 2 and update description
2024/07/17 - Barry Wang
    Fixed reset behavior
    Passed testbench
2024/07/25 - Barry Wang
    Changed default implementation to output gated
2024/09/11 - Zeiler Randall-Reed
    naming changes
    formatting changes

-----------------------------------------------------*/

module Clause_Evaluator #(
    // Number of Variables and Var Tables being evaluated for each clause
    parameter NSAT = 3, 
    // Implementation (gated I/O)
    // "INPUT_GATED" / "OUTPUT_GATED"
    parameter IMPLEMENTATION = "OUTPUT_GATED",
    // REDUCE is the number of variables that are know
    // to be unsat
    parameter REDUCE = 1
)(
    input clk_i,
    input rst_i,
    // Variable values and negation
    input [(NSAT - REDUCE) - 1 : 0] var_val_i,
    input [(NSAT - REDUCE) - 1 : 0] var_neg_i,
    output wire                     break_o
);
    if (IMPLEMENTATION == "INPUT_GATED") begin
        reg [(NSAT - REDUCE) - 1 : 0] var_val;
        reg [(NSAT - REDUCE) - 1 : 0] var_neg;
        assign break_o = ~|(var_val ^ var_neg);
        always @ (posedge clk_i) begin
            if (rst_i) begin
                var_val <= {((NSAT - REDUCE)){1'b1}};
                var_neg <= 0;
            end else begin
                var_val <= var_val_i;
                var_neg <= var_neg_i;
            end
        end
    end else begin
        reg break_out;
        reg [1:0] evaluated_literals;
        assign break_o = break_out;
        always @ (posedge clk_i) begin
            if (rst_i) begin
                break_out <= 1'b0;
            end else begin
                evaluated_literals <= (var_val_i ^ var_neg_i);
                break_out <= ~(evaluated_literals[0] | evaluated_literals[1]);
            end
        end
    end

endmodule
