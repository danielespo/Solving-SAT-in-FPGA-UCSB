/*
Version: 1.1
Heuristic_Selector.v

V1.0 Author: Zeiler Randall-Reed
V1.1 Author: Zeiler Randall-Reed

Description: 
This module is where the specific SAT solver algorithm is implemented. 

Notes:
8/05 : want to make the heuristic selector accept all of the break values at the same time and make a choice by the next posedge of the clock
8/13 : want to add valid signal to input break values in the case we decide a flip is illegal or unwanted

Testing:
- made some changes that need to be tested (8/5)
- more changes made (8/13)
- testbench complete, testing in progress
*/

module Heuristic_Selector #(
    parameter MAX_CLAUSES_PER_VARIABLE = 20,
    parameter NSAT = 3,
    parameter MAX_CLAUSES_PER_VARIABLE_BITS = 5,
    parameter NSAT_BITS = 2,
    parameter P = 'h6E147AE0 // can be assigned any value 0 to 4294967295 
                            // - if the LSFR input is above this number, the selector will random walk
                            // - if we want greedy move probability around 4.3, we can use 1846835936
)(
    input clk,
    input reset,
    input [(NSAT*MAX_CLAUSES_PER_VARIABLE_BITS)-1:0] break_values_i,
    input [NSAT-1:0] break_value_valid_i, // this is a vector of valid bits for each break value
    input [31:0] random_i, 

    output reg [NSAT_BITS-1:0] select_o,
    output reg random_selection_o
);

wire [MAX_CLAUSES_PER_VARIABLE_BITS - 1 : 0] break_values [NSAT - 1 : 0];
wire [MAX_CLAUSES_PER_VARIABLE_BITS - 1 : 0] valid_break_values [NSAT - 1 : 0];
wire [NSAT_BITS - 1 : 0]                     valid_break_index [NSAT - 1 : 0];
reg hasZero;
reg[NSAT_BITS-1:0] num_valid;

genvar index, jndex;
generate
    jndex = 0;
    for(index = 0; index < NSAT; index = index + 1) begin
        // assign break_values[index] = {(~break_values_valid_i[index]), break_values_i[index*MAX_CLAUSES_PER_VARIABLE_BITS+:MAX_CLAUSES_PER_VARIABLE_BITS]};
        assign break_values[index] = break_values_i[index*MAX_CLAUSES_PER_VARIABLE_BITS+:MAX_CLAUSES_PER_VARIABLE_BITS];
        if(break_value_valid_i[index]) begin
            assign valid_break_values[jndex] = break_values_i[index*MAX_CLAUSES_PER_VARIABLE_BITS+:MAX_CLAUSES_PER_VARIABLE_BITS];
            assign valid_break_index[jndex] = index;
            jndex = jndex + 1;
        end
    end
endgenerate

integer i, j;

// random walk and selection determination
reg random_walk, rand_sel_2;
reg [NSAT_BITS-1:0] rand_sel_3;
always @(posedge clk) begin
    random_walk <= random_i > P;
    rand_sel_2 <= random_i[7];
    rand_sel_3 <= random_i[5:0] % NSAT;
end

// selection registers
reg [NSAT_BITS-1:0] sel_2, sel_3;

// count num_valid and trivial case selection (when only one valid)
wire [NSAT_BITS-1:0] sel_1, sel_2, sel_3, num_valid;
assign num_valid = break_value_valid_i[0] + break_value_valid_i[1] + break_value_valid_i[2];
assign sel_1 = break_value_valid_i[0] ? 2'b00 :
               break_value_valid_i[1] ? 2'b01 : 
               break_value_valid_i[2] ? 2'b10 : 
               2'b11;
assign sel_2 =  (valid_break_values[0] > valid_break_values[1]) ? valid_break_index[0] : valid_break_index [1];
assign sel_3 =  (break_values[0] <  break_values[1] && break_values[0] <  break_values[2]) ? 0 :
                (break_values[1] <= break_values[0] && break_values[1] <= break_values[2]) ? 1 :
                (break_values[2] <= break_values[0] && break_values[2] <= break_values[1]) ? 2 ;

assign random_selection_o = random_walk;

always @(posedge clk) begin
    if(reset) begin
        selected_o <= 2'b11; // invalid value for reset to catch bugs potentially
        hasZero <= 0;
        random_selection_o <= 0;
    end else begin
        for(i = 0; i < NSAT; i = i + 1) begin   
            if((break_value[i] == 0) && (break_value_valid_i[i])) begin  // if a break value is zero and valid, we want to select it
                hasZero <= 1;
                selected_flip_o <= i;
            end
        end
        if(hasZero == 0) begin
            // assign output based on the number of valid inputs
            case(num_valid)
                0: select_o <= 2'b11;
                1: select_o <= sel_1;
                2: select_o <= random_walk ? rand_sel_2 : sel_2;
                3: select_o <= random_walk ? rand_sel_3 : sel_3;
            endcase
        end
        hasZero <= 0;
    end
end

endmodule