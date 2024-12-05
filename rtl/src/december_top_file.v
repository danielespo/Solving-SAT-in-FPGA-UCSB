/*
Version: 0.0
Datapath.v

V0.0 Author: Zeiler Randall-Reed

Description:
This is the top module for the datapath. It instantiates all of the modules that are needed for the
SAT solver and connects them together. It has I/O for interaction with the controller and for 
loading the problem data into the solver.

Notes:
- This module is a work in progress and is missing UNSAT Clause Buffer and Selector, and more
- Naming Convention:
    - module names are Camel_Snake_Case
    - parameters and localparams are UPPER_CASE
    - defines and other compiler directives are UPPER_CASE
    - signals are snake_case
        - active low signals are suffixed with _n
        - ALL module I/O signals are suffixed with _i, _o, _io, and those suffixes are reserved
            for module I/O only. Instantiated module signals can include _in, _out, but not _i, _o
        - writing interface signals are prefixed with wr_
        - reading interface signals are prefixed with rd_
        - signals with multiple suffixes should omit underscores between suffixes
            (i.e. rst_ni)
        - clock should be clk (clk_i) and have a prefix if not the primary clock (axi_clk_i)
        - reset should be rst (rst_i) 
    - datapath internal signals should include an abbreviation of the module where their value is 
        derived as a prefix (i.e. cr_selected_clause)
        - signals created/assigned in the datapath should be prefixed with an underscore
    - non-datapath modules that instantiate other modules should prefix associated signals with the 
        instantiated module and omit I/O suffixes for those signals (i.e. mt_en, ucb_addr)
    - cluster and wrapper modules that have combined I/O for the various modules inside should add
        an 'm' to the suffix (i.e. data_mo, addr_mi) of the combined port
        

    -TLDR: 
        wr_en_i : write enable input
        rd_addr_i : read address input
        clk_i : clock input

Change Log:
8/19/2024 - Zeiler Randall-Reed
    Created Datapath.v
    Skeleton of the module created

9/11/2024 - Zeiler Randall-Reed 
    Added all modules and signals
    Naming convention fixes

12/04/2024 - Harim Choe
    Added controller
*/
module Datapath #(
    parameter NSAT = 3,
    parameter NUM_VARIABLES = 2048,
    parameter MAX_CLAUSE_MEMBERSHIP = 20,
    parameter FIFO_DEPTH = 32,
    parameter UNSAT_CLAUSE_BUFFER_DEPTH = 2048,
    parameter CONTROLLER_SIGNAL_WIDTH = 14 // will change
) (
    input clk_i, rst_i,
    // controller signal : [x_xx_x_x_x_xx_x_xx_x_x]
    // CR_wren, ATT_src(2), VT_rden, VT_addr_src, VT_wren, VFS_wren(2), CFLB_wren, TB_wr_index(2), FIFO_wren, FIFO_rden 
    input [CONTROLLER_SIGNAL_WIDTH - 1 : 0] control_signal_i
    // in progress
);

// local parameters
localparam VARIABLE_ADDRESS_WIDTH = $clog2(NUM_VARIABLES);      // naming change
localparam LITERAL_ADDRESS_WIDTH = VARIABLE_ADDRESS_WIDTH + 1;  // naming change
localparam CLAUSE_WIDTH = NSAT * LITERAL_ADDRESS_WIDTH;

localparam MC = MAX_CLAUSE_MEMBERSHIP;
localparam MC_BITS = $clog2(MC);
localparam NSAT_BITS = $clog2(NSAT);

// integer vars
integer i, j;
genvar n, m;

/* --- control signals --- */
    wire         cr_wr_en;
    wire [1 : 0] att_src;
    wire         vt_addr_src;
    wire         vt_en;
    wire         vt_wr_en;
    wire [1 : 0] vfs_wr_en;
    wire         cflb_wr_en;
    wire [1 : 0] tb_wr_index;
    wire         fifo_wr_en;
    wire         fifo_rd_en;
    wire         ucs_request;

    assign {cr_wr_en, att_src, vt_addr_src, vt_en, vt_wr_en, vfs_wr_en, cflb_wr_en, tb_wr_index, fifo_wr_en, fifo_rd_en, ucs_request} = control_signal_i;

/* --- internal wires --- */
    wire [CLAUSE_WIDTH - 1 : 0] cr_selected_clause;

    wire [CLAUSE_WIDTH - 1 : 0] _selected_clause_negated;

    wire [LITERAL_ADDRESS_WIDTH - 1 : 0]    _cr_selected_literal;
    wire [LITERAL_ADDRESS_WIDTH - 1 : 0]    _cr_negated_literal;

    wire [MC - 1 : 0]                       att_mask_out; 
    wire [VARIABLE_ADDRESS_WIDTH - 1 : 0]   att_addr_out; // avoid using _out but att is ambiguous

    wire [(NSAT - 1) * MC * LITERAL_ADDRESS_WIDTH - 1 : 0]  ct_clauses;
    wire [(NSAT - 1) * MC - 1 : 0]                          ct_negation_bits;
    wire [(NSAT - 1) * MC * VARIABLE_ADDRESS_WIDTH - 1 : 0] ct_variable_addresses;

    wire [MC - 1 : 0] mb_mask_bits;

    wire [CLAUSE_WIDTH - 1 : 0] cnlb_clause;

    wire [LITERAL_ADDRESS_WIDTH - 1 : 0]    _selected_literal_negated;
    wire                                    _selected_literal_negated_neg_bit;
    wire [VARIABLE_ADDRESS_WIDTH - 1 : 0]   _selected_literal_negated_addr;

    wire [(NSAT - 1) * MC - 1 : 0] nb_negation_bits;

    wire [(NSAT - 1) * MC * VARIABLE_ADDRESS_WIDTH - 1 : 0] _vtc_address_m;
    wire                                                    _vtc_data;
    wire [(NSAT - 1) * MC - 1 : 0]                          vtc_value_bits;

    wire [(NSAT - 1) * MC * LITERAL_ADDRESS_WIDTH - 1 : 0] tbw_literals_multi_out;

    wire [31 : 0] prng_random_number;

    wire [NSAT - 1 : 0] nb2_negation_bits;

    wire [NSAT * VARIABLE_ADDRESS_WIDTH - 1 : 0] _vtc2_address_m;
    wire                                         _vtc2_data;
    wire [NSAT - 1 : 0]                          vtc2_value_bits;

    wire [MC - 1 : 0] ce1_break_bits;

    wire ce2_break;

    wire [MC * CLAUSE_WIDTH - 1 : 0] _broken_clauses;

    wire [NSAT_BITS - 1 : 0] vfs_selected;
    wire [MC - 1 : 0]        vfs_clause_valid_bits;

    wire [CLAUSE_WIDTH - 1 : 0] fifo_clause;
    wire                        fifo_empty;

    wire [NSAT * LITERAL_ADDRESS_WIDTH - 1 : 0]  ucs_selected_clause;
    wire [NSAT - 1 : 0]                          ucs_selected_clause_negation_bits;
    wire [NSAT * VARIABLE_ADDRESS_WIDTH - 1 : 0] usc_selected_clause_addresses;

    wire [CLAUSE_WIDTH - 1 : 0] _selected_unsatisfied_clause;

/* --- clause register --- */
    Clause_Register #(
        .NSAT(NSAT),
        .LITERAL_ADDRESS_WIDTH(LITERAL_ADDRESS_WIDTH)
    ) clause_register (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .wr_en_i(cr_wr_en),
        .data_i(ucs_selected_clause),
        .data_o(cr_selected_clause)
    );

/* --- address translation table --- */     // [TODO] - write interface
    assign _cr_selected_literal = att_src[1] ? 
        (att_src[0] ? 
            {LITERAL_ADDRESS_WIDTH{1'bx}} : // potential errors by propagating x
            cr_selected_clause[LITERAL_ADDRESS_WIDTH * 2 +: LITERAL_ADDRESS_WIDTH]) 
        : 
        (att_src[0] ? 
            cr_selected_clause[LITERAL_ADDRESS_WIDTH * 1 +: LITERAL_ADDRESS_WIDTH] : 
            cr_selected_clause[LITERAL_ADDRESS_WIDTH * 0 +: LITERAL_ADDRESS_WIDTH]);

    assign _cr_negated_literal = {~_cr_selected_literal[LITERAL_ADDRESS_WIDTH - 1], _cr_selected_literal[LITERAL_ADDRESS_WIDTH - 2 : 0]};

    Address_Translation_Table #(
        .CLAUSE_COUNT(MAX_CLAUSE_MEMBERSHIP),
        .LITERAL_ADDRESS_WIDTH(LITERAL_ADDRESS_WIDTH),
        .CLAUSE_TABLE_ADDRESS_WIDTH(VARIABLE_ADDRESS_WIDTH)
    ) address_translation_table (
        .clk_i(clk_i),
        .axi_wr_en_i(),
        .axi_wr_addr_i(),
        .axi_wr_data_i(),
        .rd_addr_i(_cr_negated_literal),
        .addr_o(att_addr_out),
        .mask_o(att_mask_out)
    );

/* --- clause negated literals buffer --- */
    generate
        for(n = 0; n < NSAT; n = n + 1) begin
            assign _selected_clause_negated[LITERAL_ADDRESS_WIDTH * n +: LITERAL_ADDRESS_WIDTH] = {cr_selected_clause[LITERAL_ADDRESS_WIDTH * (n + 1) - 1], cr_selected_clause[LITERAL_ADDRESS_WIDTH * n +: VARIABLE_ADDRESS_WIDTH]};
        end
    endgenerate

    reg [CLAUSE_WIDTH - 1 : 0] clause_negated_literals_buffer;
    always @ (posedge clk_i) begin
        if (rst_i) begin
            clause_negated_literals_buffer <= 0;
        end else begin
            if(cflb_wr_en) clause_negated_literals_buffer <= _selected_clause_negated;
        end
    end

    assign cnlb_clause = clause_negated_literals_buffer;

    assign {_selected_literal_negated_neg_bit, _selected_literal_negated_addr} = _selected_literal_negated;
    assign _selected_literal_negated = vfs_selected[1] ? 
        (vfs_selected[0] ? 
            {LITERAL_ADDRESS_WIDTH{1'bx}} : 
            {cnlb_clause[LITERAL_ADDRESS_WIDTH * 2 +: LITERAL_ADDRESS_WIDTH]}) 
        : 
        (vfs_selected[0] ? 
            {cnlb_clause[LITERAL_ADDRESS_WIDTH * 1 +: LITERAL_ADDRESS_WIDTH]} : 
            {cnlb_clause[LITERAL_ADDRESS_WIDTH * 0 +: LITERAL_ADDRESS_WIDTH]});

/* --- clause table --- */                 // [TODO] - write interface
    // wire [LITERAL_ADDRESS_WIDTH - 1 : 0] ct_clauses_packed [NSAT - 2 : 0][MC - 1 : 0];
    // generate
    //     for(n = 0; n < MC; n = n + 1) for(m = 0; m < NSAT - 1; m = m + 1) begin
    //         assign ct_clauses_packed[m][n] = ct_clauses[((NSAT - 1) * n + m) * LITERAL_ADDRESS_WIDTH +: LITERAL_ADDRESS_WIDTH];
    //     end
    // endgenerate

    Clause_Table #(
        .CLAUSE_COUNT(MAX_CLAUSE_MEMBERSHIP),
        .DEPTH(NUM_VARIABLES),
        .VARIABLE_ADDRESS_WIDTH(VARIABLE_ADDRESS_WIDTH),
        .NSAT(NSAT)
    ) clause_table (
        .clk_i(clk_i),
        .axi_wr_en_i(),
        .axi_wr_addr_i(),
        .axi_wr_clauses_i(),
        .rd_addr_i(att_addr_out),
        .clauses_o(ct_clauses)
    );

    generate
        for(n = 0; n < MC - 1; n = n + 1) begin
            for(m = 0; m < NSAT - 1; m = m + 1) begin
                assign ct_negation_bits     [n * (NSAT - 1) + m]                                                      = ct_clauses[((NSAT - 1) * n + m + 1) * LITERAL_ADDRESS_WIDTH - 1];
                assign ct_variable_addresses[(n * (NSAT - 1) + m) * VARIABLE_ADDRESS_WIDTH +: VARIABLE_ADDRESS_WIDTH] = ct_clauses[((NSAT - 1) * n + m) * LITERAL_ADDRESS_WIDTH +: VARIABLE_ADDRESS_WIDTH];
                //assign ct_negation_bits[n * (NSAT - 1) + m] = ct_clauses_packed[n][m][LITERAL_ADDRESS_WIDTH - 1];
                //assign ct_variable_addresses[(n * (NSAT - 1) + m) * LITERAL_ADDRESS_WIDTH +: VARIABLE_ADDRESS_WIDTH] = ct_clauses_packed[n][m][VARIABLE_ADDRESS_WIDTH - 1 : 0];
            end
        end
    endgenerate

/* --- mask buffer --- */
    reg [MC - 1 : 0] mask_buffer_0;
    reg [MC - 1 : 0] mask_buffer_1;
    reg [MC - 1 : 0] mask_buffer_2;
    always @ (posedge clk_i) begin
        if (rst_i) begin
            mask_buffer_0 <= 0;
            mask_buffer_1 <= 0;
            mask_buffer_2 <= 0;
        end else begin 
            mask_buffer_0 <= att_mask_out;
            mask_buffer_1 <= mask_buffer_0;
            mask_buffer_2 <= mask_buffer_1;
        end
    end
    assign mb_mask_bits = mask_buffer_2;

/* --- negation buffer --- */
    reg [(NSAT - 1) * MC - 1 : 0] negation_buffer;
    always @ (posedge clk_i) begin
        if (rst_i) begin
            negation_buffer <= 0;
        end else begin
            negation_buffer <= ct_negation_bits;
        end
    end
    assign nb_negation_bits = negation_buffer;

/* --- variable table cluster --- */       // [TODO] - write interface
    assign _vtc_address_m = vt_addr_src ? {(NSAT - 1) * MC{_selected_literal_negated_addr}} : ct_variable_addresses;
    assign _vtc_data = _selected_literal_negated_neg_bit;

    Variable_Table_Cluster #(
        .VARIABLE_ADDRESS_WIDTH(VARIABLE_ADDRESS_WIDTH),
        .CLUSTER_SIZE((NSAT - 1) * MC)
    ) variable_table_cluster (
        .clk_i(clk_i),
        .axi_en_i(),
        .axi_wr_en_i(),
        .axi_addr_i(),
        .axi_data_i(),
        .en_i(vt_en),
        .wr_en_i(vt_wr_en),
        .addr_mi(_vtc_address_m),
        .data_i(_vtc_data),
        .data_mo(vtc_value_bits)
    );

/* --- temporal buffer wrapper --- */
    Temporal_Buffer_Wrapper #(
        .NSAT(NSAT),
        .LITERAL_ADDRESS_WIDTH(LITERAL_ADDRESS_WIDTH),
        .MAX_CLAUSE_MEMBERSHIP(MC)
    ) temporal_buffer_wrapper (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .wr_index_i(tb_wr_index),
        .wr_en_i(~(&tb_wr_index)),
        .wr_literals_mi(ct_clauses),
        .rd_index_i(vfs_selected),
        .literals_mo(tbw_literals_multi_out)
    );

    generate
        for(n = 0; n < MC; n = n + 1) begin
            assign _broken_clauses[n * CLAUSE_WIDTH +: CLAUSE_WIDTH] = {tbw_literals_multi_out[n * (NSAT - 1) * LITERAL_ADDRESS_WIDTH +: (NSAT - 1) * LITERAL_ADDRESS_WIDTH], _selected_literal_negated};
        end
    endgenerate

/* --- XOR PRNG --- */
    XOR_PRNG prng (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_o(prng_random_number)
    );

/* --- negation buffer 2 --- */
    reg [NSAT - 1 : 0] negation_buffer_2;
    always @ (posedge clk_i) begin
        if (rst_i) begin
            negation_buffer_2 <= 0;
        end else begin
            negation_buffer_2 <= ucs_selected_clause_negation_bits;
        end
    end
    assign nb2_negation_bits = negation_buffer_2;

/* --- variable table cluster 2 --- */     // [TODO] - write interface
    assign _vtc2_address_m = vt_addr_src ? {NSAT{_selected_literal_negated_addr}} : usc_selected_clause_addresses;
    assign _vtc2_data = _selected_literal_negated_neg_bit;

    Variable_Table_Cluster #(
        .VARIABLE_ADDRESS_WIDTH(VARIABLE_ADDRESS_WIDTH),
        .CLUSTER_SIZE(NSAT)
    ) variable_table_cluster_2 (
        .clk_i(clk_i),
        .en_i(vt_en),
        .wr_en_i(vt_wr_en),
        .addr_mi(_vtc2_address_m),
        .data_i(_vtc2_data),
        .data_mo(vtc2_value_bits),
        .axi_en_i(),
        .axi_wr_en_i(),
        .axi_addr_i(),
        .axi_data_i()
    );

/* --- clause evaluator cluster --- */
    Clause_Evaluator_Cluster #(
        .CLUSTER_SIZE(MAX_CLAUSE_MEMBERSHIP),
        .NSAT(NSAT),
        .IMPLEMENTATION("OUTPUT_GATED"),
        .REDUCE(1)
    ) clause_evaluator_cluster (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .var_val_mi(vtc_value_bits),
        .var_neg_mi(nb_negation_bits),
        .break_mo(ce1_break_bits)
    );

/* --- clause evaluator 2 --- */
    Clause_Evaluator #(
        .NSAT(NSAT),
        .IMPLEMENTATION("OUTPUT_GATED"),
        .REDUCE(0)
    ) clause_evaluator_2 (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .var_val_i(vtc2_value_bits),
        .var_neg_i(nb2_negation_bits),
        .break_o(ce2_break)
    );

/* --- variable flip selector --- */
    Variable_Flip_Selector #(
        .MAX_CLAUSES_PER_VARIABLE(MC),
        .NSAT(NSAT),
        .P('h6E147AE0)
    ) variable_flip_selector (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .clause_broken_i(ce1_break_bits),
        .mask_bits_i(mb_mask_bits),
        .break_values_valid_i(),
        .random_i(prng_random_number),
        .wr_en_i(vfs_wr_en),
        .selected_o(vfs_selected),
        .clause_valid_bits_o(vfs_clause_valid_bits)
    );

/* --- fifo_tree --- */
    FIFO_Tree #(
        .CLAUSE_COUNT(MC),
        .CLAUSE_WIDTH(CLAUSE_WIDTH),
        .BUFFER_DEPTH(FIFO_DEPTH)
    ) fifo_tree (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .clauses_i(_broken_clauses),
        .clauses_valid_i(vfs_clause_valid_bits),
        .wr_en_i(fifo_wr_en),
        .rd_en_i(fifo_rd_en),
        .cOF_i(),
        .empty_o(fifo_empty),
        .OF_o(),
        .clause_o(fifo_clause)
    );

/* --- unsat clause selector --- */       // [TODO] - write interface
    localparam RANDOM_NUM_WIDTH = 18;
    localparam RANDOM_OFFSET = 10;
    Unsat_Clause_Selector #(
        .BUFFER_DEPTH(UNSAT_CLAUSE_BUFFER_DEPTH),
        .RANDOM_NUM_WIDTH(RANDOM_NUM_WIDTH),
        .M_TABLE_WIDTH(32),
        .NSAT(NSAT),
        .LITERAL_ADDRESS_WIDTH(LITERAL_ADDRESS_WIDTH)
    ) unsat_clause_selector (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .setup_i(),
        // .ready_o(),
        .ucb_setup_wr_en_i(),
        .ucb_setup_addr_i(),
        .ucb_setup_data_i(),
        .request_i(ucs_request),
        .write_disable_i(~ce2_break),
        .clear_debug_DIV_BY_ZERO_i(),
        .debug_DIV_BY_ZERO_o(),
        .fifo_empty_i(fifo_empty),
        .fifo_clause_i(fifo_clause),
        .random_i(prng_random_number[RANDOM_OFFSET +: RANDOM_NUM_WIDTH]),
        .buffer_count_o(),
        .selected_o(ucs_selected_clause),
        .ucb_overflow_o()
    );

    /* --- datapath controller --- */
    top_file_controller #(
        .NSAT(NSAT),
        .NUM_VARIABLES(NUM_VARIABLES),
        .MAX_CLAUSE_MEMBERSHIP(MAX_CLAUSE_MEMBERSHIP),
        .FIFO_DEPTH(FIFO_DEPTH),
        .UNSAT_CLAUSE_BUFFER_DEPTH(UNSAT_CLAUSE_BUFFER_DEPTH),
        .CONTROLLER_SIGNAL_WIDTH(CONTROLLER_SIGNAL_WIDTH)
    ) controller_inst (
        .clk(clk_i), 
        .rst(rst_i),
        .start(start_i),
        .done(done_signal),
        .control_signal_o(control_signal_i)
    );
    
    generate
        for(n = 0; n < NSAT; n = n + 1) begin
            assign ucs_selected_clause_negation_bits[n] = ucs_selected_clause[LITERAL_ADDRESS_WIDTH * (n + 1) - 1];
            assign usc_selected_clause_addresses[n * VARIABLE_ADDRESS_WIDTH +: VARIABLE_ADDRESS_WIDTH] = ucs_selected_clause[LITERAL_ADDRESS_WIDTH * n +: VARIABLE_ADDRESS_WIDTH];
        end
    endgenerate
    assign _selected_unsatisfied_clause = ce2_break ? ucs_selected_clause : fifo_clause;

endmodule