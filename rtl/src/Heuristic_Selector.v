/*
Version: 1.1
Heuristic_Selector.v

V1.0 Author: Zeiler Randall-Reed
V1.1 Author: Zeiler Randall-Reed
V2.0 Author: Zeiler Randall-Reed

Description: 
This module is where the specific SAT solver algorithm is implemented. 

Notes:
8/05 : want to make the heuristic selector accept all of the break values at the same time and make a choice by the next posedge of the clock
8/13 : want to add valid signal to input break values in the case we decide a flip is illegal or unwanted
8/16 : made purely combinational, no clock signal

Testing:
- V1.1 testbench complete, all tests passed
- V2.0 testbench not yet created
*/

// comment out the following line to remove the simulation-specific code
// `define SIM

module Heuristic_Selector #(
    parameter MAX_CLAUSES_PER_VARIABLE = 20,
    parameter NSAT = 3,
    parameter P = 'h6E147AE0, // can be assigned any value 0 to 4294967295 
                            // - if the LSFR input is above this number, the selector will random walk
                            // - if we want greedy move probability around 4.3, we can use 1846835936
    parameter MAX_CLAUSES_PER_VARIABLE_BITS = 5
)(
    input [NSAT * MAX_CLAUSES_PER_VARIABLE_BITS - 1 : 0] break_values_i,
    input [NSAT - 1 : 0] break_values_valid_i, // this is a vector of valid bits for each break value
    input [31 : 0] random_i, 

    input enable_i,

    output wire [$clog2(NSAT) - 1:0] select_o,
    output wire random_selection_o
);
    
    localparam NSAT_BITS = $clog2(NSAT);
    localparam MC = MAX_CLAUSES_PER_VARIABLE;
    localparam MCB = MAX_CLAUSES_PER_VARIABLE_BITS;
    
    wire [MCB - 1 : 0] break_values [NSAT - 1 : 0];
    wire [NSAT - 1 : 0] is_zero;
    wire has_zero;
    
    integer i, j;
    
    genvar index;
    generate
        for(index = 0; index < NSAT; index = index + 1) begin
            // assign break_values[index] = {(~break_values_valid_i[index]), break_values_i[index*MCB+:MCB]};
            assign break_values[index] = break_values_i[index*MCB+:MCB];
            assign is_zero[index] = ~(|break_values[index]);
        end
    endgenerate
    
    assign has_zero = |(is_zero & break_values_valid_i);
    
    wire /*bvv_000,*/ bvv_001, bvv_010, bvv_100, bvv_011, bvv_101, bvv_110/*, bvv_111*/;
    // assign bvv_000 = (break_values_valid_i[2] == 0 && break_values_valid_i[1] == 0 && break_values_valid_i[0] == 0);
    assign bvv_001 = (break_values_valid_i[2] == 0 && break_values_valid_i[1] == 0 && break_values_valid_i[0] == 1);
    assign bvv_010 = (break_values_valid_i[2] == 0 && break_values_valid_i[1] == 1 && break_values_valid_i[0] == 0);
    assign bvv_011 = (break_values_valid_i[2] == 0 && break_values_valid_i[1] == 1 && break_values_valid_i[0] == 1);
    assign bvv_100 = (break_values_valid_i[2] == 1 && break_values_valid_i[1] == 0 && break_values_valid_i[0] == 0);
    assign bvv_101 = (break_values_valid_i[2] == 1 && break_values_valid_i[1] == 0 && break_values_valid_i[0] == 1);
    assign bvv_110 = (break_values_valid_i[2] == 1 && break_values_valid_i[1] == 1 && break_values_valid_i[0] == 0);
    // assign bvv_111 = (break_values_valid_i[2] == 1 && break_values_valid_i[1] == 1 && break_values_valid_i[0] == 1);
    
    // combinational logic for random walk and random selection determination
    wire random_walk;
    wire [NSAT_BITS-1:0] rand_sel_2, rand_sel_3;
    assign random_walk = random_i > P;
    assign rand_sel_2 = bvv_011 ? (random_i[7] ? 2'b01 : 2'b00) :
                        bvv_101 ? (random_i[7] ? 2'b10 : 2'b00) :
                        bvv_110 ? (random_i[7] ? 2'b10 : 2'b01) : 
                        2'b11;
    assign rand_sel_3  = random_i[5:0] % NSAT;
    
    // combinational logic for deterministic selection
    wire [NSAT_BITS-1:0] num_valid, det_sel_1, det_sel_2, det_sel_3;
    assign num_valid = break_values_valid_i[0] + break_values_valid_i[1] + break_values_valid_i[2];
    assign det_sel_1 =  bvv_001 ? 2'b00 :
                        bvv_010 ? 2'b01 : 
                        bvv_100 ? 2'b10 : 
                        2'b11;
    assign det_sel_2 =  bvv_011 ? ((break_values[0] <  break_values[1]) ? 2'b00 : 2'b01) :
                        bvv_101 ? ((break_values[0] <  break_values[2]) ? 2'b00 : 2'b10) :
                        bvv_110 ? ((break_values[2] <= break_values[1]) ? 2'b10 : 2'b01) : 
                        2'b11;
    assign det_sel_3 =  (break_values[0] <  break_values[1] && break_values[0] <  break_values[2]) ? 2'b00 :
                        (break_values[1] <= break_values[0] && break_values[1] <= break_values[2]) ? 2'b01 :
                        (break_values[2] <= break_values[0] && break_values[2] <= break_values[1]) ? 2'b10 : 
                        2'b11;
    
    // combinational logic for selection if there is a valid zero
    wire [NSAT_BITS-1:0] zero_sel_2, zero_sel_3;
    assign zero_sel_2 = bvv_011 ? (is_zero[1] ? 2'b01 : 2'b00) :
                        bvv_101 ? (is_zero[2] ? 2'b10 : 2'b00) :
                        bvv_110 ? (is_zero[2] ? 2'b10 : 2'b01) : 
                        2'b11;
    assign zero_sel_3 = is_zero[2] ? 2'b10 : 
                        is_zero[1] ? 2'b01 :
                        is_zero[0] ? 2'b00 :
                        2'b11;
    
    // combinatorial logic for output selection
    wire [NSAT_BITS-1:0] sel_1, sel_2, sel_3, sel;
    assign sel_1 = det_sel_1;
    assign sel_2 = has_zero ? zero_sel_2 : (random_walk ? rand_sel_2 : det_sel_2);
    assign sel_3 = has_zero ? zero_sel_3 : (random_walk ? rand_sel_3 : det_sel_3);
    assign sel = num_valid[1] ? (num_valid[0] ? sel_3 : sel_2) : (num_valid[0] ? sel_1 : 2'b11);
    
    assign select_o = enable_i ? sel : 2'bxx;
    assign random_selection_o = enable_i ? ((num_valid[1] && ~has_zero) ? random_walk : 0) : 1'bx;

endmodule