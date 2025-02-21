/*
  Complete Heuristic Selector for WSAT/SKC
  -----------------------------------------
  1) If any valid variable has break=0, pick randomly among those zero-break variables.
  2) Otherwise, with probability p (random_walk), pick any valid variable at random.
  3) Otherwise, pick the variable(s) with the minimum break value among valid ones,
     and if there's a tie, pick among them uniformly at random.

  This module is purely combinational and matches the Kanazawa WSAT/SKC approach
  as typically described in FPGA-accelerated local search.
*/

module Heuristic_Selector #(
    parameter MAX_CLAUSES_PER_VARIABLE = 20,
    parameter NSAT = 3,                     
    parameter P = 32'h6E147AE0             
)(
    input  [NSAT * $clog2(MAX_CLAUSES_PER_VARIABLE) - 1:0] break_values_i,
    input  [NSAT - 1 : 0] break_values_valid_i,
    input  [31:0] random_i,
    input         enable_i,

    output reg [$clog2(NSAT) - 1 : 0] select_o,
    output reg                        random_selection_o
);

    localparam MCB = $clog2(MAX_CLAUSES_PER_VARIABLE);
    wire [MCB-1:0] break_value [NSAT-1:0];
    genvar gv;
    generate
        for (gv = 0; gv < NSAT; gv = gv + 1) begin : UNPACK_BV
            assign break_value[gv] 
                 = break_values_i[gv * MCB +: MCB];
        end
    endgenerate

    // Identify zero-break among valid
    wire [NSAT-1:0] zero_mask;
    genvar i;
    generate
        for (i = 0; i < NSAT; i = i + 1) begin
            assign zero_mask[i] = break_values_valid_i[i] 
                               && (break_value[i] == {MCB{1'b0}});
        end    
    endgenerate

    // Are there any zero-break variables?
    wire has_zero = |zero_mask;

    //-----------------------------------------
    // Random-walk check
    //-----------------------------------------
    // If random_i > P, we go to random walk.
    // Probability p = (4294967296 - P)/4294967296
    wire random_walk = (random_i > P);

    //-----------------------------------------
    // Utility: pickRandomMask_3
    //   Picks exactly one bit from 'mask'
    //   if multiple bits set, random among them
    //   if only one set, pick that one
    //   if none set, return 3'b000 (or invalid)
    //-----------------------------------------
    function [1:0] pickRandomMask_3(
        input [2:0] mask,
        input [31:0] rnd
    );
        reg [1:0] out;
        reg [1:0] count;
        begin
            count = mask[0] + mask[1] + mask[2];
            // Default invalid
            out = 2'b11; 
            case (count)
                2'd0: begin
                    // No bits => invalid
                    out = 2'b11;
                end
                2'd1: begin
                    // Exactly one set
                    if (mask[0]) out = 2'b00;
                    else if (mask[1]) out = 2'b01;
                    else out = 2'b10;
                end
                2'd2: begin
                    // Two bits set => pick with 1-bit toss
                    // We'll figure out which 2 bits are set
                    // For example:
                    if (mask[0] && mask[1]) begin
                        out = (rnd[0]) ? 2'b00 : 2'b01;
                    end else if (mask[0] && mask[2]) begin
                        out = (rnd[0]) ? 2'b00 : 2'b10;
                    end else /* (mask[1] && mask[2]) */ begin
                        out = (rnd[0]) ? 2'b01 : 2'b10;
                    end
                end
                2'd3: begin
                    // Three bits set => pick among 3 with 2-bit random
                    // 2'b00 => pick 0, 2'b01 => pick 1, 2'b10 => pick 2
                    // 2'b11 => pick 0 (or any default you want)
                    case (rnd[1:0])
                        2'b00: out = 2'b00;
                        2'b01: out = 2'b01;
                        2'b10: out = 2'b10;
                        default: out = 2'b00;
                    endcase
                end
            endcase
            pickRandomMask_3 = out;
        end
    endfunction

    //-----------------------------------------
    // If no zero-break but not random-walk, pick the variable(s) with min break
    //-----------------------------------------
    reg [MCB-1:0] min_bv;
    integer j;
    always @* begin
        // Initialize to 'max' so any valid smaller break will override
        min_bv = {MCB{1'b1}};
        for (j=0; j<NSAT; j=j+1) begin
            if (break_values_valid_i[j] && (break_value[j] < min_bv)) begin
                min_bv = break_value[j];
            end
        end
    end

    // Collect tie bits
    wire [NSAT-1:0] min_mask;
    genvar k;
    generate
      for (k=0; k<NSAT; k=k+1) begin : MIN_MASK_LOOP
         assign min_mask[k] = break_values_valid_i[k] 
                              && (break_value[k] == min_bv);
      end
    endgenerate

    //-----------------------------------------
    // 4) If random-walk => pick among all valid
    //-----------------------------------------
    wire [1:0] random_walk_choice;
    assign random_walk_choice = pickRandomMask_3(break_values_valid_i, random_i);

    reg [1:0] final_sel;
    reg       final_rand_sel;

    always @* begin
        // Defaults
        final_sel      = 2'b11;
        final_rand_sel = 1'b0;

        if (!enable_i) begin
            // If disabled => set outputs to X
            final_sel      = 2'b00;
            final_rand_sel = 1'b0;
        end
        else begin
            if (has_zero) begin
                // (1) If there's a zero-break, pick among zero_mask
                final_sel      = pickRandomMask_3(zero_mask, random_i);
                final_rand_sel = 1'b0;
            end
            else begin
                // (2) No zero-break
                if (random_walk) begin
                    // With probability p, pick random among *all valid*
                    final_sel      = random_walk_choice;
                    final_rand_sel = 1'b1;
                end
                else begin
                    // (3) Greedy => pick min among valid, random among ties
                    final_sel      = pickRandomMask_3(min_mask, random_i);
                    final_rand_sel = 1'b0;
                end
            end
        end
    end

    // Finally wire up outputs
    always @* begin
        select_o           = final_sel;
        random_selection_o = final_rand_sel;
        // $display("Heuristic_Selector: break_values=0x%0h, valid=0x%0h, random=0x%0h -> select=%0d, random_sel=%b at time %0t", 
                //   break_values_i, break_values_valid_i, random_i, select_o, random_selection_o, $time);
    end

endmodule