// *********** ClauseEvaluator 1 ***********
/*
    In this module, we will be evaluating the clauses that are associated with a given variable. 
    This module is desiged to have all of the clause evaluators running in parallel, 
    in one module and should not be instantiated multiple times in a one thread implementation.

    The clause evaluator will take in the address of the variable that was flipped, and retrive values from the varTable,
    and then evaluate the clauses that are associated with that variable in parallel.

    It then outputs a MAX_CLAUSES_PER_VARIABLE wide isBroken signal, 
    which will be high if the clause at that index was broken by the flip.

    ALERT [TODO] - This module is not done yet, and the addressing for the varTable is not setup yet.
    The deafult values are for clause evaluator 1, this module is now fully paramaterized
*/

module Clause_Evaluator #(
    parameter MAX_CLAUSES_PER_VARIABLE = 20, // Maximum number of clauses that can be associated with a single variable (determines # of clause evaluators)
    parameter NSAT = 3, // Number of Variables and Var Tables being evaluated for each clause
    parameter LITERAL_ADDRESS_WIDTH = 11 // Width of the incoming flipped variable address (11 bits for 2048 variables)
   
)(
    input                                       clk,          // Clock signal
    input                                       reset,        // Reset signal
    //input  [VARIABLE_ADDRESS_WIDTH-1:0]         variableAddress_in, // Address of the variable that was flipped
    //input                                       flippedValue_in, // Value of the variable that was flipped
    //input                                       valid_i [0: MAX_CLAUSES_PER_VARIABLE],
    
    output        [LITERAL_ADDRESS_WIDTH-1:0] clause_evaluator_address_o [0 : ((NSAT - 1) * LITERAL_ADDRESS_WIDTH) - 1], // To Variable Table

    // Outputs to the var table and the recived value, this module isn't done yet, and this addressing is not setup yet
    output  [LITERAL_ADDRESS_WIDTH-1:0]       varTableAddressL_out [LITERAL_ADDRESS_WIDTH-1:0], // Address to fetch from table for the left side of the clause
    output  [LITERAL_ADDRESS_WIDTH-1:0]       varTableAddressR_out [LITERAL_ADDRESS_WIDTH-1:0], // Address to fetch from table for the right side of the clause'
    input                                       negationBitLitL_in   [LITERAL_ADDRESS_WIDTH-1:0], // Negation bit recived from left address
    input                                       negationBitLitR_in   [LITERAL_ADDRESS_WIDTH-1:0], 

    //not sure what these are yet (rename later)
    input   [LITERAL_ADDRESS_WIDTH-1:0]                   alt_negationBitLitL_in,
    input   [LITERAL_ADDRESS_WIDTH-1:0]                   alt_negationBitLitR_in,

    output reg  [LITERAL_ADDRESS_WIDTH-1:0]               isBroken // Outputs high when the evaluated canadate clause was BROKEN by the flip
);
    wire [LITERAL_ADDRESS_WIDTH-1:0] negBitsLeft;
    wire [LITERAL_ADDRESS_WIDTH-1:0] negBitsRight;

    integer i;
//    for (i = 0; i < MAX_CLAUSES_PER_VARIABLE; i = i + 1) begin
//            assign negBitsLeft[i] = negationBitLitL_in[i];
//            assign negBitsRight[i] = negationBitLitR_in[i];
//    end

//    // This is the clause evaluator logic
//    //Xor all of the left sides 0-MAX_CLAUSES_PER_VARIABLE
//    wire [MAX_CLAUSES_PER_VARIABLE-1:0] leftXOR = negBitsLeft ^ alt_negationBitLitL_in;
//    //Xor all of the right sides 0-MAX_CLAUSES_PER_VARIABLE
//    wire [MAX_CLAUSES_PER_VARIABLE-1:0] rightXOR = negBitsRight ^ alt_negationBitLitR_in;

//    // NOR the two sides together
//    always @(posedge clk) begin
//        if (reset) begin
//            isBroken <= {MAX_CLAUSES_PER_VARIABLE{1'b0}};
//        end else begin
//            isBroken <= ~(leftXOR | rightXOR);
//        end
//    end


endmodule
