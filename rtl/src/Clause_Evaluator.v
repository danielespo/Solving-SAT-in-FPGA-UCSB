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

Testing:
    2024/05/24 V1.0 testbench file created
    2024/07/16 V1.0 testbench invalidated
    V2.0 testbench not created

Change Log:

2024/07/16 - Barry Wang
    Make Version 2 and update description

-----------------------------------------------------*/

module Clause_Evaluator #(
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
    input   wire    [NSAT - 1 : 0]  var_val_i,
    input   wire    [NSAT - 1 : 0]  var_neg_i,
    output  wire    break_o
);

if (IMPLEMENTATION == "INPUT_GATED")
begin
    reg [NSAT - 1 : 0] var_val;
    reg [NSAT - 1 : 0] var_neg;
    wire [NSAT - 1 : 0] negated = var_val ^ var_neg;
    assign break_o = ~|negated;
    always @ (posedge clk_i)
      begin
        if (reset_i)
          begin
            var_val <= 0;
            var_neg <= 0;
          end else begin
            var_val <= var_val_i;
            var_neg <= var_neg_i;
          end
      end
end else begin
    reg [NSAT - 1 : 0] break;
    assign break_o = break;
    wire [NSAT - 1 : 0] negated = var_val_i ^ var_neg_i;
    always @ (posedge clk_i)
      begin
        if (reset_i)
          begin
            break <= 1'b0;
          end else begin
            break <= ~|negated;
          end
      end
end

endmodule
