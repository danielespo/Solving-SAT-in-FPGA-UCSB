
/************ ClauseEvaluator 1 ***********
    In this module, we will be evaluating the clauses that are associated with a given variable. 
    This module is desiged to have all of the clause evaluators running in parallel, 
    in one module and should not be instantiated multiple times in a one thread implementation.

    The clause evaluator will take in the address of the variable that was flipped, and retrive values from the varTable,
    and then evaluate the clauses that are associated with that variable in parallel.

    It then outputs a MAX_CLAUSES_PER_VARIABLE wide isBroken signal, 
    which will be high if the clause at that index was broken by the flip.

    ALERT [TODO] - This module is not done yet, and the addressing for the varTable is not setup yetVariable_Table (Variable_Table.v).
    NOTE: Clause Evaluator takes 2 CLOCK CYCLES as it needs to call on the variable table.
*/

module Clause_Evaluator #(
    parameter MAX_CLAUSES_PER_VARIABLE = 20, // Maximum number of clauses that can be associated with a single variable (determines # of clause evaluators)
    parameter NSAT = 3, // Number of Variables and Var Tables being evaluated for each clause
    parameter LITERAL_ADDRESS_WIDTH = 11 // Width of the incoming flipped variable address (11 bits for 2048 variables)
)(
    input                                         clk,          // Clock signal
    input                                         reset,        // Reset signal
    input  [LITERAL_ADDRESS_WIDTH:0]              clause_table_i [MAX_CLAUSES_PER_VARIABLE-1:0][NSAT-2:0],    // clause table input
    input  [MAX_CLAUSES_PER_VARIABLE-1:0]           clause_table_mask_i,
    output [LITERAL_ADDRESS_WIDTH-1:0]            var_table_address_o [MAX_CLAUSES_PER_VARIABLE-1:0][NSAT-2:0],    // clause output
    input                                         var_table_data_i [0:MAX_CLAUSES_PER_VARIABLE - 1] [NSAT-2:0],
    output reg  [MAX_CLAUSES_PER_VARIABLE-1:0]    isBroken, // Outputs high when the evaluated candidate clause was BROKEN by the flip
    output reg  [LITERAL_ADDRESS_WIDTH:0]         flipped_literal_temp_buffer_o   [0:MAX_CLAUSES_PER_VARIABLE - 1],
    output reg  [LITERAL_ADDRESS_WIDTH:0]         rest_clause_temp_buffer_o       [0:MAX_CLAUSES_PER_VARIABLE - 1] [NSAT-2:0]
);

    // Wire arrays for XOR outputs
    wire [MAX_CLAUSES_PER_VARIABLE-1:0] negBitsLeft;
    wire [MAX_CLAUSES_PER_VARIABLE-1:0] negBitsRight;

    // Continuous assignment using generate block for conditional compiling
    // I changed this from just the forloop because I was getting syntax errors, Ben - Daniel
    genvar i;
    generate
        for (i = 0; i < MAX_CLAUSES_PER_VARIABLE; i = i + 1) begin : gen_negBits
//            assign negBitsLeft[i] = negationBitLitL_in[i];
//            assign negBitsRight[i] = negationBitLitR_in[i];
        end
    endgenerate

//    // This is the clause evaluator logic
//    //Xor all of the left sides 0-MAX_CLAUSES_PER_VARIABLE
//    wire [MAX_CLAUSES_PER_VARIABLE-1:0] leftXOR = negBitsLeft ^ alt_negationBitLitL_in;
//    //Xor all of the right sides 0-MAX_CLAUSES_PER_VARIABLE
//    wire [MAX_CLAUSES_PER_VARIABLE-1:0] rightXOR = negBitsRight ^ alt_negationBitLitR_in;

    // NOR the two sides together
    always @(posedge clk) begin
        if (reset) begin
            isBroken <= {MAX_CLAUSES_PER_VARIABLE{1'b0}};
        end else begin
            //isBroken <= ~(leftXOR | rightXOR);
        end
    end


endmodule
