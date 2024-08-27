/*
SAT_Solver_Top.v
V1.0 Author: Daniel A. Espinosa Gonzalez 2024
V2.0 Author: Barry Wang
Description:
A mock SAT solver using the modules of this project to get area and logic estimates.
*/

module SAT_Solver_Top #(
    parameter MAX_CLAUSES_PER_VARIABLE = 20,    // Maximum number of clauses associated with a variable
    parameter NSAT = 3,                         // Number of variables in the SAT problem
    parameter LITERAL_ADDRESS_WIDTH = 11,       // Bit width for literal addresses
    parameter CLAUSE_TABLE_ADDRESS_WIDTH = 12,  // Bit width for clause table addresses (pessimistic without packing)
    parameter CLAUSE_COUNT = 20,                // MAX MEMBERSHIP (20) CHANGE number of clauses in the SAT problem
    parameter CLUSTER_SIZE_VT = 20 * 2 + 2 * 3, // Size of the cluster for Variable_Table_Cluster (20 in CE1 and 3 in each of CE2, CE3)
    parameter CLUSTER_SIZE_CE1 = 20,            // Size of the cluster for Clause Evaluator 1
    parameter NUM_CLAUSES = 20,                 // Number of clauses being processed (corresponds to cluster size)
    parameter REDUCE = 1,                       // Reduction factor
    parameter FIFO_DATA_WIDTH = 36,             // Data width for the FIFO buffers (12*3)
    parameter FIFO_BUFFER_ADDR_WIDTH = 5,       // Address width for the FIFO buffer
    parameter MAX_CLAUSES_PER_VARIABLE_BITS = 5,// Bit width to represent max clauses per variable    
    parameter P = 'h6E147AE0,                   // Parameter used for the PRNG (pseudo-random number generator)
    parameter DEPTH = 2048,                     // Depth of UNSAT buffer
    parameter MCPV = MAX_CLAUSES_PER_VARIABLE,  // Alias for MAX_CLAUSES_PER_VARIABLE for consistency
    parameter CLAUSE_WIDTH = 36,                // Width of each clause in the FIFO tree
    parameter BUFFER_DEPTH = 3,                 // Depth of the FIFO buffer in the FIFO tree 
    parameter DATA_WIDTH = 36                   // Matches FIFO_DATA_WIDTH
)(
    // global signals
    input   clk, reset,
    // ATT
    input                                                       ATT_wren,
    input   [LITERAL_ADDRESS_WIDTH:0]                           ATT_waddr, ATT_raddr,
    input   [CLAUSE_TABLE_ADDRESS_WIDTH + CLAUSE_COUNT - 1 : 0] ATT_din,
    output  [CLAUSE_TABLE_ADDRESS_WIDTH - 1:0]                  ATT_ct_addr_field,
    output  [CLAUSE_COUNT-1:0]                                  ATT_mask_field,
    // VTC
    input   [CLUSTER_SIZE_VT - 1 : 0]                           VTC_en_a, VTC_en_b, VTC_we_a, VTC_we_b,
    input   [(LITERAL_ADDRESS_WIDTH * CLUSTER_SIZE_VT) - 1 : 0] VTC_addr_a, VTC_addr_b,
    input   [CLUSTER_SIZE_VT - 1 : 0]                           VTC_din_a, VTC_din_b,
    output  [CLUSTER_SIZE_VT - 1 : 0]                           VTC_dout_a, VTC_dout_b,
    // CEC
    input   [((NSAT - REDUCE) * CLUSTER_SIZE_CE1 - 1) : 0]      CEC_var_val_i,
    input   [((NSAT - REDUCE) * CLUSTER_SIZE_CE1 - 1) : 0]      CEC_var_neg_i,
    output  [CLUSTER_SIZE_CE1 - 1 : 0]                          CEC_break_o,
    // VFS
    input   [MAX_CLAUSES_PER_VARIABLE - 1 : 0]                  VFS_clause_broken_i,
    input   [MAX_CLAUSES_PER_VARIABLE - 1 : 0]                  VFS_mask_bits_i,
    input   [NSAT - 1 : 0]                                      VFS_break_values_valid_i,
    input   [31:0]                                              VFS_random_i,
    input   [$clog2(NSAT) - 1 : 0]                              VFS_wren_i,
    output  [$clog2(NSAT) - 1 : 0]                              VFS_selected_o,
    output  [MAX_CLAUSES_PER_VARIABLE - 1 : 0]                  VFS_clause_broken_bits_o,
    // TB
    input   [$clog2(NSAT)-1:0]                                  TB_write_index_i,      
    input                                                       TB_write_en_i,         
    input   [(NSAT-1)*MCPV*(LITERAL_ADDRESS_WIDTH+1)-1:0]       TB_literals_multi_i,   
    input   [$clog2(NSAT)-1:0]                                  TB_read_index_i,       
    output  [(NSAT-1)*MCPV*(LITERAL_ADDRESS_WIDTH+1)-1:0]       TB_literals_multi_o,    
    // FT
    input   [CLAUSE_WIDTH * CLAUSE_COUNT - 1 : 0]               FT_clauses_i,
    input   [CLAUSE_COUNT - 1 : 0]                              FT_clause_valid_i,
    input                                                       FT_wren,
    input                                                       FT_rden,
    input                                                       FT_cOF,
    output                                                      FT_empty,
    output                                                      FT_OF,
    output  [CLAUSE_WIDTH - 1 : 0]                              FT_clause_o,
    // UCB
    input                                                       UCB_en_a, UCB_en_b, UCB_we_a, UCB_we_b,
    input   [$clog2(DEPTH) - 1 : 0]                             UCB_addr_a, UCB_addr_b,
    input   [(LITERAL_ADDRESS_WIDTH + 1) * NSAT - 1 : 0]        UCB_din_a, UCB_din_b,
    output  [(LITERAL_ADDRESS_WIDTH + 1) * NSAT - 1 : 0]        UCB_dout_a, UCB_dout_b,
    // CR
    input                                                       CR_we,
    input   [(LITERAL_ADDRESS_WIDTH + 1) * NSAT - 1 : 0]        CR_din,
    output  [(LITERAL_ADDRESS_WIDTH + 1) * NSAT - 1 : 0]        CR_dout,
    // CT
    input                                                                       CT_we,
    input   [LITERAL_ADDRESS_WIDTH-1:0]                                         CT_waddr, CT_raddr,
    input   [(LITERAL_ADDRESS_WIDTH + 1) * (NSAT - 1) * CLAUSE_COUNT - 1 : 0]   CT_clauses_i,
    output  [(LITERAL_ADDRESS_WIDTH + 1) * (NSAT - 1) * CLAUSE_COUNT - 1 : 0]   CT_clauses_o,
    // RNG
    input                                                       RNG_reset,
    output  [31:0]                                              RNG_out,
    // CE2
    input   [NSAT - 1 : 0]                                      CE2_var_val_i,
    input   [NSAT - 1 : 0]                                      CE2_var_neg_i,
    output                                                      CE2_break_o,
    // CE3
    input   [NSAT - 1 : 0]                                      CE3_var_val_i,
    input   [NSAT - 1 : 0]                                      CE3_var_neg_i,
    output                                                      CE3_break_o
);

    // Instantiate Address_Translation_Table module
    Address_Translation_Table address_translation_table_inst (
        .clk(clk),
        .wren(ATT_wren),
        .waddr(ATT_waddr),
        .raddr(ATT_raddr),
        .din(ATT_din),
        .ct_addr_field(ATT_ct_addr_field),
        .mask_field(ATT_mask_field)
    );

    // Instantiate Variable_Table_Cluster module
    Variable_Table_Cluster # (
        .CLUSTER_SIZE(CLUSTER_SIZE_VT)
    ) variable_table_cluster_inst (
        .clk(clk),
        .en_a(VTC_en_a),
        .en_b(VTC_en_b),
        .we_a(VTC_we_a),
        .we_b(VTC_we_b),
        .addr_a(VTC_addr_a),
        .addr_b(VTC_addr_b),
        .din_a(VTC_din_a),
        .din_b(VTC_din_b),
        .dout_a(VTC_dout_a),
        .dout_b(VTC_dout_b)
    );

    // Instantiate Clause_Evaluator_Cluster module
    Clause_Evaluator_Cluster clause_evaluator_cluster_inst (
        .clk_i(clk),
        .reset_i(reset),
        .var_val_i(CEC_var_val_i),
        .var_neg_i(CEC_var_neg_i),
        .break_o(CEC_break_o)
    );

    // Instantiate Variable_Flip_Selector module
    Variable_Flip_Selector variable_flip_selector_inst (
        .clk(clk),
        .reset(reset),
        .clause_broken_i(VFS_clause_broken_i),
        .mask_bits_i(VFS_mask_bits_i),
        .break_values_valid_i(VFS_break_values_valid_i),
        .random_i(VFS_random_i),
        .wren_i(VFS_wren_i),
        .selected_o(VFS_selected_o),
        .clause_broken_bits_o(VFS_clause_broken_bits_o)
    );

    // Instantiate Temporal_Buffer_Wrapper module
    Temporal_Buffer_Wrapper temporal_buffer_wrapper_inst (
        .clk(clk),
        .reset(reset),
        .write_index_i(TB_write_index_i),
        .write_en_i(TB_write_en_i),
        .literals_multi_i(TB_literals_multi_i),
        .read_index_i(TB_read_index_i),
        .literals_multi_o(TB_literals_multi_o)
    );

    // Instantiate FIFO_Tree module
    FIFO_tree fifo_tree_inst (
        .clk(clk),
        .reset(reset),
        .clauses_i(FT_clauses_i),
        .clause_valid_i(FT_clause_valid_i),
        .wren(FT_wren),
        .rden(FT_rden),
        .cOF(FT_cOF),
        .empty(FT_empty),
        .OF(FT_OF),
        .clause_o(FT_clause_o)
    );

    // Instantiate Unsat_Clause_Buffer module
    Unsat_Clause_Buffer unsat_clause_buffer_inst (
        .clk_a(clk),
        .clk_b(clk),
        .en_a(UCB_en_a),
        .en_b(UCB_en_b),
        .we_a(UCB_we_a),
        .we_b(UCB_we_b),
        .addr_a(UCB_addr_a),
        .addr_b(UCB_addr_b),
        .din_a(UCB_din_a),
        .din_b(UCB_din_b),
        .dout_a(UCB_dout_a),
        .dout_b(UCB_dout_b)
    );

    // Instantiate Clause_Register module
    Clause_Register clause_register_inst (
        .clk(clk),
        .reset(reset),
        .we(CR_we),
        .din(CR_din),
        .dout(CR_dout)
    );

    // Instantiate Clause_Table module
    Clause_Table clause_table_inst (
        .clk(clk),
        .we(CT_we),
        .waddr(CT_waddr),
        .raddr(CT_raddr),
        .clauses_i(CT_clauses_i),
        .clauses_o(CT_clauses_o)
    );

    // Instantiate the LFSR PRNG module
    lfsr_prng prng_inst (
        .clk(clk),
        .reset(RNG_reset),
        .out(RNG_out)
    );
    
    // Instantiate CE2
    Clause_Evaluator ce2 (
        .clk_i(clk),
        .reset_i(reset),
        .var_val_i(CE2_var_val_i),
        .var_neg_i(CE2_var_neg_i),
        .break_o(CE2_break_o)
    );
    
    // Instantiate CE3
    Clause_Evaluator ce3 (
        .clk_i(clk),
        .reset_i(reset),
        .var_val_i(CE3_var_val_i),
        .var_neg_i(CE3_var_neg_i),
        .break_o(CE3_break_o)
    );
    
endmodule