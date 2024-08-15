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
    input [NSAT-1:0] break_values_valid_i, // this is a vector of valid bits for each break value
    input [31:0] random_i, 

    output reg [NSAT_BITS-1:0] select_o,
    output reg random_selection_o
);

wire [MAX_CLAUSES_PER_VARIABLE_BITS - 1 : 0] break_values [NSAT - 1 : 0];
reg hasZero;

integer i, j;

genvar index, jndex;
generate
    for(index = 0; index < NSAT; index = index + 1) begin
        // assign break_values[index] = {(~break_values_valid_i[index]), break_values_i[index*MAX_CLAUSES_PER_VARIABLE_BITS+:MAX_CLAUSES_PER_VARIABLE_BITS]};
        assign break_values[index] = break_values_i[index*MAX_CLAUSES_PER_VARIABLE_BITS+:MAX_CLAUSES_PER_VARIABLE_BITS];
    end
endgenerate

wire bvv_000, bvv_001, bvv_010, bvv_100, bvv_011, bvv_101, bvv_110, bvv_111;
assign bvv_000 = (break_values_valid_i[0] == 0 && break_values_valid_i[1] == 0 && break_values_valid_i[2] == 0);
assign bvv_001 = (break_values_valid_i[0] == 1 && break_values_valid_i[1] == 0 && break_values_valid_i[2] == 0);
assign bvv_010 = (break_values_valid_i[1] == 1 && break_values_valid_i[0] == 0 && break_values_valid_i[2] == 0);
assign bvv_100 = (break_values_valid_i[2] == 1 && break_values_valid_i[0] == 0 && break_values_valid_i[1] == 0);
assign bvv_011 = (break_values_valid_i[0] == 1 && break_values_valid_i[1] == 1 && break_values_valid_i[2] == 0);
assign bvv_101 = (break_values_valid_i[0] == 1 && break_values_valid_i[2] == 1 && break_values_valid_i[1] == 0);
assign bvv_110 = (break_values_valid_i[1] == 1 && break_values_valid_i[2] == 1 && break_values_valid_i[0] == 0);
assign bvv_111 = (break_values_valid_i[0] == 1 && break_values_valid_i[1] == 1 && break_values_valid_i[2] == 1);

// random walk and random selection determination
wire random_walk;
wire [NSAT_BITS-1:0] rand_sel_2, rand_sel_3;
wire [NSAT_BITS-1:0] rand_sel_2_011, rand_sel_2_101, rand_sel_2_110;

assign random_walk = random_i > P;
assign rand_sel_2_011 = random_i[7] ? 2'b01 : 2'b00;
assign rand_sel_2_101 = random_i[7] ? 2'b10 : 2'b00;
assign rand_sel_2_110 = random_i[7] ? 2'b10 : 2'b01;
assign rand_sel_2  = bvv_011 ? rand_sel_2_011 :
                    bvv_101 ? rand_sel_2_101 :
                    bvv_110 ? rand_sel_2_110 : 
                    2'b11;
assign rand_sel_3  = random_i[5:0] % NSAT;

// combinational logic for deterministic selection
wire [NSAT_BITS-1:0] num_valid, det_sel_1, det_sel_2, det_sel_3;
wire [NSAT_BITS-1:0] det_sel_2_110, det_sel_2_101, det_sel_2_011;
assign num_valid = break_values_valid_i[0] + break_values_valid_i[1] + break_values_valid_i[2];
assign det_sel_1 =  bvv_001 ? 2'b00 :
                    bvv_010 ? 2'b01 : 
                    bvv_100 ? 2'b10 : 
                    2'b11;
assign det_sel_2_011 = (break_values[0] <  break_values[1]) ? 2'b00 : 2'b01;
assign det_sel_2_101 = (break_values[0] <  break_values[2]) ? 2'b00 : 2'b10;
assign det_sel_2_110 = (break_values[1] <= break_values[2]) ? 2'b01 : 2'b10;
assign det_sel_2 =  bvv_011 ? det_sel_2_011 :
                    bvv_101 ? det_sel_2_101 :
                    bvv_110 ? det_sel_2_110 : 
                    2'b11;
assign det_sel_3 =  (break_values[0] <  break_values[1] && break_values[0] <  break_values[2]) ? 2'b00 :
                    (break_values[1] <= break_values[0] && break_values[1] <= break_values[2]) ? 2'b01 :
                    (break_values[2] <= break_values[0] && break_values[2] <= break_values[1]) ? 2'b10 : 
                    2'b11;

always @(posedge clk) begin
    if(reset) begin
        select_o <= 2'b11; // invalid value for reset to catch bugs potentially
        hasZero <= 0;
        random_selection_o <= 0;
    end else begin
        for(i = 0; i < NSAT; i = i + 1) begin   
            if((break_values[i] == 0) && (break_values_valid_i[i])) begin  // if a break value is zero and valid, we want to select it
                hasZero <= 1;
                select_o <= i;
            end
        end
        if(hasZero == 0) begin
            // assign output based on the number of valid inputs
            case(num_valid)
                0: select_o <= 2'b11;
                1: select_o <= det_sel_1;
                2: begin
                    if(random_walk) begin
                        random_selection_o <= 1;
                        select_o <= rand_sel_2;
                    end else begin
                        random_selection_o <= 0;
                        select_o <= det_sel_2;
                    end
                end 
                3: begin 
                    if(random_walk) begin
                        random_selection_o <= 1;
                        select_o <= rand_sel_3;
                    end else begin
                        random_selection_o <= 0;
                        select_o <= det_sel_3;
                    end
                end 
            endcase
        end
        hasZero <= 0;
    end
end

endmodule