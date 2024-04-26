/*
Variable table takes in the address the clause evaluators are looking for, and returns the values of the variables at that address.

In 3-SAT, in clause evaluator 1 each CE accesses 2n of its value and 2n+1 as its addressing for variables

TO UPDATE THE VARIABLE TABLE AND FLIP A VARIABLE: 
    - set flip_var_address_i to the address of the variable you want to flip
    - set write_var_i to high to flip the variable, flips are done automatically on the falling edge of the clock

*/

module Variable_Table #(
    parameter LITERAL_ADDRESS_WIDTH = 11,
    parameter MAX_CLAUSES_PER_VARIABLE = 20, // Maximum number of clauses that can be associated with a single variable (determines # of clause evaluators)
    parameter NSAT = 3,  // Number of SAT variables (3 for 3-SAT)
    parameter NUM_VARIABLES = 2048 // Number of Variables
)
(
    input               clk,
   input        [LITERAL_ADDRESS_WIDTH-1:0] clause_evaluator_address_i [0:MAX_CLAUSES_PER_VARIABLE - 1] [0:NSAT-2], // For clause evaluator 1
    output wire                              calause [0:MAX_CLAUSES_PER_VARIABLE - 1] [0:NSAT-2],
    input        [LITERAL_ADDRESS_WIDTH-1:0] clause_evaluator_2_i [0: NSAT - 1], // For clause evaluator 2
    output wire                              clause_evaluator_2_o [0: NSAT - 1],
    input        [LITERAL_ADDRESS_WIDTH-1:0] clause_evaluator_3_i [0: NSAT - 1], // For clause evaluator 3
    output wire                              clause_evaluator_3_o [0: NSAT - 1],
    input        [LITERAL_ADDRESS_WIDTH-1:0] flip_var_address_i,
    input                                    write_var_i
);

reg variableMem [0:NUM_VARIABLES-1];


always @ (negedge clk) begin
    if (write_var_i) begin
        variableMem[flip_var_address_i] <= ~variableMem[flip_var_address_i];
    end
end

integer i, j, k;
for (i = 0; i < MAX_CLAUSES_PER_VARIABLE; i = i + 1) begin
    for (j = 0; j < NSAT-1; j = j + 1) begin
        assign calause[i][j] = variableMem[clause_evaluator_address_i[i][j]];
    end
end

for (k = 0; k < NSAT; k = k + 1) begin
    assign clause_evaluator_2_o[k] = variableMem[clause_evaluator_2_i[k]];
    assign clause_evaluator_3_o[k] = variableMem[clause_evaluator_3_i[k]];
end



endmodule
