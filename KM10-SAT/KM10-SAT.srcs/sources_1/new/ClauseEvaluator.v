// *********** ClauseEvaluator 1 ***********
/*
    In this module, we will be evaluating the clauses that are associated with a given variable. 
    This module is desiged to have all of the clause evaluators running in parallel, 
    in one module and should not be instantiated multiple times in a one thread implementation.

    The clause evaluator will take in the address of the variable that was flipped, and retrive values from the varTable,
    and then evaluate the clauses that are associated with that variable in parallel.

    It then outputs a NUM_CLAUSES wide isBroken signal, 
    which will be high if the clause at that index was broken by the flip.

    ALERT [TODO] - This module is not done yet, and the addressing for the varTable is not setup yet.
*/

module clauseEvaluator #(
    parameter NUM_CLAUSES = 20, // Maximum number of clauses that can be associated with a single variable (determines # of clause evaluators)
    parameter NUM_VARIABLES = 2, // Number of Variables and Var Tables being evaluated for each clause
    parameter VARIABLE_ADDRESS_WIDTH = 11, // Width of the incoming flipped variable address (11 bits for 2048 variables)
    parameter VAR_TABLE_ADDRESS_WIDTH = 11 // Width of the address leaving the clause evaluator to fetch the current value of that literal
)(
    input                                       clk,          // Clock signal
    input                                       reset,        // Reset signal
    input  [VARIABLE_ADDRESS_WIDTH-1:0]         variableAddress_in, // Address of the variable that was flipped
    input                                       flippedValue_in, // Value of the variable that was flipped
    
    
    // Outputs to the var table and the recived value, this module isn't done yet, and this addressing is not setup yet
    output  [VAR_TABLE_ADDRESS_WIDTH-1:0]       varTableAddressL_out [NUM_CLAUSES-1:0], // Address to fetch from table for the left side of the clause
    output  [VAR_TABLE_ADDRESS_WIDTH-1:0]       varTableAddressR_out [NUM_CLAUSES-1:0], // Address to fetch from table for the right side of the clause'
    input                                       negationBitLitL_in   [NUM_CLAUSES-1:0], // Negation bit recived from left address
    input                                       negationBitLitR_in   [NUM_CLAUSES-1:0], 

    //not sure what these are yet (rename later)
    input   [NUM_CLAUSES-1:0]                   alt_negationBitLitL_in,
    input   [NUM_CLAUSES-1:0]                   alt_negationBitLitR_in,

    output reg  [NUM_CLAUSES-1:0]               isBroken // Outputs high when the evaluated canadate clause was BROKEN by the flip
);
    wire [NUM_CLAUSES-1:0] negBitsLeft;
    wire [NUM_CLAUSES-1:0] negBitsRight;

    integer i;
    for (i = 0; i < NUM_CLAUSES; i = i + 1) begin
            assign negBitsLeft[i] = negationBitLitL_in[i];
            assign negBitsRight[i] = negationBitLitR_in[i];
    end

    // This is the clause evaluator logic
    //Xor all of the left sides 0-NUM_CLAUSES
    wire [NUM_CLAUSES-1:0] leftXOR = negBitsLeft ^ alt_negationBitLitL_in;
    //Xor all of the right sides 0-NUM_CLAUSES
    wire [NUM_CLAUSES-1:0] rightXOR = negBitsRight ^ alt_negationBitLitR_in;

    // NOR the two sides together
    always @(posedge clk) begin
        if (reset) begin
            isBroken <= NUM_CLAUSES'b0;
        end else begin
            isBroken <= ~(leftXOR | rightXOR);
        end
    end


endmodule
