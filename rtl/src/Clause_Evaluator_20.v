/* ----------------------------------------------------
Version: 1.0
Clause_Evaluator_Cluster.v

V1.0 Author: Barry Wang

Description:
    This is the main clause evaluator cluster

Notes: 
    This module is defaulted to input buffered
    (clocked at input).

Testing:
    V1.0 testbench not created

Change Log:

2024/07/16 - Barry Wang
    Created file Clause_Evaluator_20.v

-----------------------------------------------------*/

module Clause_Evaluator_Cluster #(
    parameter CLUSTER_SIZE = 20,
    // Number of Variables and Var Tables being evaluated for each clause
    parameter NSAT = 3, 
    // Implementation (gated I/O)
    // "INPUT_GATED" / "OUTPUT_GATED"
    parameter IMPLEMENTATION = "INPUT_GATED"
)(
    // Clock signal
    input   wire    clk_i,
    // Reset signal
    input   wire    reset_i,
    // Variable values and negation
    input   wire    [(NSAT * CLUSTER_SIZE - 1) : 0] var_val_i,
    input   wire    [(NSAT * CLUSTER_SIZE - 1) : 0] var_neg_i,
    output  wire    [CLUSTER_SIZE - 1 : 0]          break_o
);

genvar i;
generate
    for (i = 0; i < CLUSTER_SIZE; i = i + 1)
      begin
        Clause_Evaluator ce # (
            .NSAT(NSAT),
            .IMPLEMENTATION(IMPLEMENTATION)
        )(
            .clk_i(clk_i),
            .reset_i(reset_i),
            .var_val_i(var_val_i[i * NSAT +: NSAT]),
            .var_neg_i(var_neg_i[i * NSAT +: NSAT]),
            .break_o(break_o[i])
        )
      end
endgenerate

endmodule