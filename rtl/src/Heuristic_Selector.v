/*
Heuristic_Selector.v
Author: Zeiler Randall-Reed

Description: 
This module is where the specific SAT solver algorithm is implemented. 

Notes:
8/5 new changes - want to make the heuristic selector accept all of the break values at the same time and make a choice by the next posedge of the clock

Testing:
- made some changes that need to be tested (8/5)
*/

module Heuristic_Selector #(
    parameter MAX_CLAUSES_PER_VARIABLE = 20,
    parameter NSAT = 3,
    parameter MAX_CLAUSES_PER_VARIABLE_BITS = 5,
    parameter NSAT_BITS = 2,
    parameter P = 268435455 // can be assigned any value 0 to 4294967296 - if the LSFR input is below this number, the selector will random walk
)(
    input clk,
    input reset,
    input [(NSAT*MAX_CLAUSES_PER_VARIABLE_BITS)-1:0] break_values_i,
    input [31:0] random_i, 

    output reg [NSAT_BITS-1:0] select_o,
    output reg random_selection_o
);

wire [MAX_CLAUSES_PER_VARIABLE_BITS-1:0] break_values [NSAT-1:0];
reg hasZero;

genvar index;
generate
    for(index = 0; index < NSAT; index = index + 1) begin
        assign break_values[index] = break_values_i[index*MAX_CLAUSES_PER_VARIABLE_BITS+:MAX_CLAUSES_PER_VARIABLE_BITS];
    end
endgenerate

integer i;

always @(posedge clk) begin
    if(reset) begin
        selected_flip_o <= 3; // invalid value for reset to catch bugs potentially
        hasZero <= 0;
        random_selection_o <= 0;
    end else begin
        for(i = 0; i < NSAT; i = i + 1) begin   
            if(break_value[i] == 0) begin
                hasZero <= 1;
                selected_flip_o <= i;
            end
        end
        if(hasZero == 0) begin
            if(random_i < P) begin       // maybe the best way to do this? open to suggestions
                selected_flip_o <= random_i[5:0] % NSAT;  // hoping the modulo function isn't too expensive
                random_selection_o <= 1;
            /* By using < instead of <= for the first flip, we prioritize other flips over the first flip. 
             * This is because changed literals are set to the first literal in each clause after clause evaluation.
             * This means that the first flip is marginally more likely to be a flip done recently.
             * The heuristic selecter does have a slight bias towards the last flip because of the comparison. */
            end else if(break_values[0] < break_values[1] && break_values[0] < break_values[2]) begin  
                selected_flip_o <= 0;
            end else if(break_values[1] <= break_values[0] && break_values[1] <= break_values[2]) begin
                selected_flip_o <= 1;
            end else if(break_values[2] <= break_values[0] && break_values[2] <= break_values[1]) begin
                selected_flip_o <= 2;
            end
        end
        hasZero <= 0;
    end
end

endmodule