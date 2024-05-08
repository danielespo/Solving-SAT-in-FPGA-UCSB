// SKELETON FILE FOR HEURISTIC_SELECTOR MODULE

module Heuristic_Selector #(
    parameter MAX_CLAUSES_PER_VARIABLE = 20,
    parameter NSAT = 3,
    parameter MAX_CLAUSES_PER_VARIABLE_BITS = 5,
    parameter NSAT_BITS = 2
)(
    input clk,
    input reset,
    input [MAX_CLAUSES_PER_VARIABLE_BITS-1:0] break_value_i,
    input [NSAT_BITS-1:0] current_flip_i,
    input [/*not sure how bit*/] random_i, // not sure how many bits this is

    output reg [NSAT_BITS-1:0] selected_flip_o
);

reg [MAX_CLAUSES_PER_VARIABLE_BITS-1:0] break_values [NSAT-1:0];
reg zero_found;

always @(posedge clk) begin
    if(reset) begin
        selected_flip_o <= 3; // invalid value for reset to catch bugs potentially
    end else begin
        if(0 <= current_flip_i && current_flip_i < NSAT) begin
            break_values[current_flip_i] <= break_value_i;
            if (break_value_i == 0) begin
                zero_found <= 1;
                selected_flip_o <= current_flip_i;
            end
        end 
        if(current_flip_i == NSAT - 1) begin
            if(zero_found == 0) begin
                if(probability) begin       // don't know how to find this
                    selected_flip_o <= random_i % NSAT;  // figure out best way to chose random flip
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
        end
    end
end

endmodule