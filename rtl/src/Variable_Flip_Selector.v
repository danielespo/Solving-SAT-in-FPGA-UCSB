/*
Version: 1.1
Variable_Flip_Selector.v

Author V1.0: Zeiler Randall-Reed
Author V1.1: Zeiler Randall-Reed

Description:
This module is where the break value counter and heuristic selector are combined. There is also an
included register to hold the break values for the first two cycles. This helps to ensure that all
of the data that is needed for the heuristic selector is available.

Notes:
- this module encapsulates the Break_Value_Counter and Heuristic_Selector modules, along with some
    additional logic and registers to handle control signals. 

Testing:
V1.0 : module in progress, no testing yet
    (8/16) : module draft complete, testbench in progress
V1.0 : module draft complete, no testing yet (8/18)
V1.1 : all tests passed (8/19)

*/

module Variable_Flip_Selector #(
    parameter MAX_CLAUSES_PER_VARIABLE = 20,
    parameter NSAT = 3,
    parameter P = 'h6E147AE0
)(
    input clk,
    input reset,
    input [MAX_CLAUSES_PER_VARIABLE - 1 : 0] clause_broken_i,
    input [MAX_CLAUSES_PER_VARIABLE - 1 : 0] mask_bits_i,
    input [NSAT - 1 : 0] break_values_valid_i,
    input [31:0] random_i,

    input [$clog2(NSAT) - 1 : 0] wren_i,    // controller signal 
    // (all zeros = idle, 1 hot = write to respective bv reg, all ones = heurstic select)
    
    output reg [$clog2(NSAT) - 1 : 0] selected_o,
    output reg [MAX_CLAUSES_PER_VARIABLE - 1 : 0] clause_broken_bits_o
);

// localparams
localparam MC = MAX_CLAUSES_PER_VARIABLE;
localparam MCB = $clog2(MAX_CLAUSES_PER_VARIABLE);
localparam NSAT_BITS = $clog2(NSAT);

// integer vars
integer i, j;

// internal registers
reg [MCB - 1 : 0] break_values_reg  [NSAT - 2 : 0];
reg [MC  - 1 : 0] break_bits_reg    [NSAT - 2 : 0];

// internal wires
wire [       MCB - 1 : 0] break_value;
wire [       MC  - 1 : 0] break_bits;

wire [NSAT * MCB - 1 : 0] all_break_values;

wire [NSAT_BITS - 1 : 0] select_o;

genvar n;
generate
    for(n = 0; n < NSAT - 1; n = n + 1) begin
        assign all_break_values[n * MCB +: MCB] = break_values_reg[n];
    end
    assign all_break_values[(NSAT - 1) * MCB +: MCB] = break_value;
endgenerate

// nice simple logic to check onehot
wire control_one_hot = ~|(wren_i & (wren_i - 1)) & |wren_i;


// initialize break_value_counter and heuristic_selector
Break_Value_Counter #(
    .NUM_CLAUSES(MC),
    .NUM_ROWS(NSAT)
) bvc (
    .clause_broken_i(clause_broken_i),
    .mask_bits_i(mask_bits_i),
    .break_value_o(break_value),
    .clause_broken_o(break_bits)
);

Heuristic_Selector #(
    .MAX_CLAUSES_PER_VARIABLE(MC),
    .NSAT(NSAT),
    .P(P)
) hs (
    .break_values_i(all_break_values),
    .break_values_valid_i(&wren_i ? break_values_valid_i : {NSAT * MCB{1'b0}}),
    .random_i(random_i),
    .enable_i(&wren_i),
    .select_o(select_o)
);

// break_values_reg and break_bits_reg
always @(posedge clk) begin
    if(reset) begin
        for(i = 0; i < NSAT - 1; i = i + 1) begin
            break_values_reg[i] <= 0;
            break_bits_reg[i] <= 0;
        end
        selected_o <= 2'b11;
        clause_broken_bits_o <= 0;
    end else begin
        for(i = 0; i < NSAT - 1; i = i + 1) begin // assign break_values_reg if wren_i is one hot
            if(wren_i[i] == 1 && control_one_hot) begin
                break_values_reg[i] <= break_value;
                break_bits_reg[i] <= break_bits;
            end
        end
        if(&wren_i) begin // when we are using the data (all ones)
            break_bits_reg[NSAT - 1] <= break_bits;
            selected_o <= select_o;
            clause_broken_bits_o <= select_o == 2'b10 ? break_bits : break_bits_reg[select_o];
        end
    end
end

endmodule