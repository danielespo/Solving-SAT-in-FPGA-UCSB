/************ Clause Processor ************
Clause_Processor.v
Author: Zeiler Randall-Reed

Description:
The clause processor is one of the two main modules in the SAT solver.
It interfaces with the Clause Selector module to receive clauses for processing.
Internally, the clause processor contains instances of the following modules:
- Clause_Evaluator
- Break_Value_Counter
- Address_Translation_Table
- Clause_Table
- Heuristic_Selector
- Temporal_Buffer
- FIFO_Tree

Notes:
- currently unused due to block diagram construction in Vivado
- may be helpful to keep the two sub-top modules (this and Clause_Selector.v) in some form for pipelining

Testing: N/A
*/

module clause_processor #(
    parameter MAX_CLAUSES_PER_VARIABLE = 20,
    parameter NSAT = 3,
    parameter LITERAL_ADDRESS_WIDTH = 11,
    parameter MAX_CLAUSES_PER_VARIABLE_BITS = $clog2(MAX_CLAUSES_PER_VARIABLE)
)
(
    input clk,
    input reset,
    input [LITERAL_ADDRESS_WIDTH:0] literal_i,

    output [(LITERAL_ADDRESS_WIDTH+1)*NSAT - 1:0] clause_o
);
// Internal Signals
wire [LITERAL_ADDRESS_WIDTH-1:0] ATT_address;
wire [MAX_CLAUSES_PER_VARIABLE:0] ATT_mask;
wire [LITERAL_ADDRESS_WIDTH:0] CT_clauses [MAX_CLAUSES_PER_VARIABLE-1:0][NSAT-2:0];

wire CE_isBroken [MAX_CLAUSES_PER_VARIABLE-1:0];
wire [MAX_CLAUSES_PER_VARIABLE_BITS-1:0] BVC_break_value;
wire [NSAT_BITS-1:0] HS_selected_flip;

wire [(LITERAL_ADDRESS_WIDTH+1)*NSAT - 1:0] TB_clause [MAX_CLAUSES_PER_VARIABLE-1:0];


// Module Instantiations
Address_Translation_Table #(
    MAX_CLAUSES_PER_VARIABLE = MAX_CLAUSES_PER_VARIABLE,
    LITERAL_ADDRESS_WIDTH = LITERAL_ADDRESS_WIDTH
) ATT (
    .clk(clk),
    .reset(reset),
    .index_i(literal_i),
    .address_o(ATT_address)
    .mask_o(ATT_mask)
);

Clause_Table #(
    MAX_CLAUSES_PER_VARIABLE = MAX_CLAUSES_PER_VARIABLE,
    NSAT = NSAT,
    LITERAL_ADDRESS_WIDTH = LITERAL_ADDRESS_WIDTH
) CT (
    .clk(clk),
    .reset(reset),
    .address_i(ATT_address),
    .clauses_o(CT_clauses)
);

// TODO: finish this module instantiation  -  unsure how Ben expects this to work
Clause_Evaluator #(
    MAX_CLAUSES_PER_VARIABLE = MAX_CLAUSES_PER_VARIABLE,
    NUM_VARIABLES = NSAT - 1,
    VARIABLE_ADDRESS_WIDTH = LITERAL_ADDRESS_WIDTH
) CE (
    .clk(clk),
    .reset(reset),
    .clauses_i(CT_clauses),

);

Break_Value_Counter #(
    MAX_CLAUSES_PER_VARIABLE = MAX_CLAUSES_PER_VARIABLE,
    NSAT = NSAT,
) BVC (
    .clk(clk),
    .reset(reset),
    .clause_sat_i(CE_isBroken),
    .break_value_o(BVC_break_value)
);

Heuristic_Selector #(
    MAX_CLAUSES_PER_VARIABLE = MAX_CLAUSES_PER_VARIABLE,
    NSAT = NSAT,
    MAX_CLAUSES_PER_VARIABLE_BITS = MAX_CLAUSES_PER_VARIABLE_BITS,
    NSAT_BITS = $clog2(NSAT)
) HS (
    .clk(clk),
    .reset(reset),
    .break_value_i(BVC_break_value),
    .selected_flip_o(HS_selected_flip)
);


generate
    genvar i;
    for(i = 0; i < MAX_CLAUSES_PER_VARIABLE; i = i + 1) begin: clause_generate
        Temporal_Buffer #(
            NSAT = NSAT,
            LITERAL_ADDRESS_WIDTH = LITERAL_ADDRESS_WIDTH,
            NSAT_BITS = $clog2(NSAT)
        ) TB (
            .clk(clk),
            .reset(reset),
            .literals_i(CT_clauses[i][NSAT-1:0]),
            .isBroken_i(CE_isBroken[i]),
            .heuristic_selection_i(HS_selected_flip),
            .clause_o(TB_clause[i])
        );
    end
endgenerate

FIFO_tree #(
    MAX_CLAUSES_PER_VARIABLE = MAX_CLAUSES_PER_VARIABLE,
    LITERAL_ADDRESS_WIDTH = LITERAL_ADDRESS_WIDTH,
    NSAT = NSAT
) FT (
    .clk(clk),
    .reset(reset),
    .clauses_i(TB_clause),
    .clause_o(clause_o)
);


endmodule