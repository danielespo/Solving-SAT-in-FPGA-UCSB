/*
Version: 1.0
Break_Counter_Selector.v

Author V1.0: Zeiler Randall-Reed

Description:
This module is where the break value counter and heuristic selector are combined. There is also an
included register to hold the break values for the first two cycles. This helps to ensure that all
of the data that is needed for the heuristic selector is available.

Notes:

Testing:
- 8/16 : module in progress, no testing yet

*/

module Break_Counter_Selector #(
    parameter MAX_CLAUSES_PER_VARIABLE = 20,
    parameter NSAT = 3,
    parameter MAX_CLAUSES_PER_VARIABLE_BITS = 5,
    parameter NSAT_BITS = 2,
    parameter P = 'h6E147AE0
)(
    input clk,
    input reset,
    input [NUM_CLAUSES - 1 : 0] clause_broken_i,
    input [NUM_CLAUSES - 1 : 0] mask_bits_i,
    input [NSAT - 1 : 0] break_values_valid_i,
    input [31:0] random_i,

    input [NSAT_BITS - 1 : 0] wren_i,   // controller signal 
                                        // (all zeros = idle, 1 hot = write to respective bv reg, all ones = heurstic select)

    output     [NSAT_BITS - 1 : 0] select_o,
    output reg [MC - 1 : 0] clause_broken_bits_o
);

// localparams
localparam MC = MAX_CLAUSES_PER_VARIABLE;
localparam MCB = MAX_CLAUSES_PER_VARIABLE_BITS;

// integer vars
integer i, j;

// internal registers
reg [MCB - 1 : 0] break_values_reg  [NSAT - 2 : 0];
reg [MC  - 1 : 0] break_bits_reg    [NSAT - 1 : 0];

reg [NSAT_BITS - 1 : 0] wren_last;

// internal wires
wire [       MCB - 1 : 0] break_value;
wire [       MC  - 1 : 0] break_bits;

wire [NSAT * MCB - 1 : 0] all_break_values;

genvar n;
generate
    for(n = 0; n < NSAT - 1; n = n + 1) begin
        assign all_break_values[n * MCB +: MCB] = break_values_reg[n];
    end
    assign all_break_values[(NSAT - 1) * MCB +: MCB] = break_value;
endgenerate

// nice simple logic to check onehot
wire one_hot = ~|(wren_i & (wren_i - 1)) & |wren_i;


// initialize break_value_counter and heuristic_selector
Break_Value_Counter #(
    .NUM_CLAUSES(NUM_CLAUSES),
    .NUM_ROWS(NSAT),
    .NUM_CLAUSES_BITS(NSAT_BITS)
) break_value_counter (
    .clk(clk),
    .reset(reset),
    .clause_broken_i(clause_broken_i),
    .mask_bits_i(mask_bits_i),
    .break_value_o(break_value),
    .clause_broken_o(break_bits)
);

Heuristic_Selector #(
    .MAX_CLAUSES_PER_VARIABLE(MAX_CLAUSES_PER_VARIABLE),
    .NSAT(NSAT),
    .MAX_CLAUSES_PER_VARIABLE_BITS(MAX_CLAUSES_PER_VARIABLE_BITS),
    .NSAT_BITS(NSAT_BITS),
    .P(P)
) heuristic_selector (
    .clk(clk),
    .reset(reset),
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
        end
        for(i = 0; i < NSAT; i = i + 1) begin
            break_bits_reg[i] <= 0;
        end
        clause_broken_bits_o <= 0;
    end else begin
        for(i = 0; i < NSAT - 1; i = i + 1) begin // assign break_values_reg if wren_i is one hot
            if(wren_i[i] == 1 && one_hot) begin
                break_values_reg[i] <= break_value;
                break_bits_reg[i] <= break_bits;
            end
        end
        if(&wren_i) begin // when we are using the data (all ones)
            break_bits_reg[NSAT - 1] <= break_bits;
        end
        if(&wren_last && ~|wren_i) begin // cycle after we use the data (all ones to all zeros)
            clause_broken_bits_o <= break_bits_reg[select_o];
        end
    end
end

// wren_last
always @(posedge clk) begin
    if(reset) begin
        wren_last <= 0;
    end else begin
        wren_last <= wren_i;
    end
end

endmodule