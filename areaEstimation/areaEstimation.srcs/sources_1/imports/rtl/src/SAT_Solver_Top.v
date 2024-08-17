/*
SAT_Solver_Top.v
Author: Daniel A. Espinosa Gonzalez 2024

Description:
A mock SAT solver using the modules of this project to get area and logic estimates.
This does nothing.
*/

module SAT_Solver_Top #(
    parameter MAX_CLAUSES_PER_VARIABLE = 20, // Maximum number of clauses associated with a variable
    parameter NSAT = 3, // Number of variables in the SAT problem
    parameter LITERAL_ADDRESS_WIDTH = 11, // Bit width for literal addresses
    parameter CLAUSE_TABLE_ADDRESS_WIDTH = 11, // Bit width for clause table addresses
    parameter CLAUSE_COUNT = 20, // Total number of clauses in the SAT problem
    parameter CLUSTER_SIZE = 20 * 2,  // Size of the cluster for Variable_Table_Cluster
    parameter NUM_CLAUSES = 20, // Number of clauses being processed
    parameter NUM_CLAUSES_BITS = 5, // Bit width needed to represent the number of clauses
    parameter IMPLEMENTATION = "OUTPUT_GATED", // Type of implementation used in the design
    parameter REDUCE = 1, // Reduction factor for certain calculations
    parameter FIFO_DATA_WIDTH = 36, // Data width for the FIFO buffers
    parameter FIFO_BUFFER_ADDR_WIDTH = 5, // Address width for the FIFO buffer
    parameter MAX_CLAUSES_PER_VARIABLE_BITS = 5, // Bit width to represent max clauses per variable
    parameter NSAT_BITS = 2, // Bit width to represent the NSAT value
    parameter P = 'h6E147AE0, // Parameter used for the PRNG (pseudo-random number generator)
    parameter DEPTH = 2048, // Depth of the memory or buffers used in the design
    parameter NUM_PARALLEL = 5, // Number of parallel inputs for the Parallel_to_Serial module
    parameter MCPV = MAX_CLAUSES_PER_VARIABLE, // Alias for MAX_CLAUSES_PER_VARIABLE for consistency
    parameter CLAUSE_WIDTH = 36,  // Width of each clause in the FIFO tree
    parameter BUFFER_DEPTH = 32   // Depth of the FIFO buffer in the FIFO tree
)(
    input wire clk,                       // Global clock signal 
    input wire reset,                     // Global reset
    input wire wren,                      // Write enable signal for Address_Translation_Table
    input wire [LITERAL_ADDRESS_WIDTH:0] waddr, raddr,  // Addresses for writing and reading the Address_Translation_Table
    input wire [CLAUSE_TABLE_ADDRESS_WIDTH + CLAUSE_COUNT - 1:0] din,  // Data input for Address_Translation_Table
    input wire [NUM_CLAUSES-1:0] clause,  // Clause bits indicating if a clause is broken
    input wire [(NSAT - REDUCE) * CLUSTER_SIZE - 1:0] var_val,  // Variable values input for Clause_Evaluator_Cluster
    input wire [(NSAT - REDUCE) * CLUSTER_SIZE - 1:0] var_neg,  // Variable negations input for Clause_Evaluator_Cluster
    input wire [FIFO_DATA_WIDTH-1:0] fifo_data_i,  // Data input for FIFO_Buffer
    input wire fifo_rden_i,             // Read enable signal for FIFO_Buffer
    input wire fifo_wren_i,             // Write enable signal for FIFO_Buffer
    input wire [(NSAT - 1) * MCPV * (LITERAL_ADDRESS_WIDTH + 1) - 1:0] literals_multi_i,  // Input literals for Temporal_Buffer_Wrapper
    input wire [NSAT_BITS-1:0] write_index_i,  // Write index for Temporal_Buffer_Wrapper
    input wire write_en_i,  // Write enable signal for Temporal_Buffer_Wrapper
    input wire [NSAT_BITS-1:0] read_index_i,  // Read index for Temporal_Buffer_Wrapper
    input wire [CLAUSE_WIDTH * CLAUSE_COUNT - 1 : 0] clauses_i,  // Input clauses for the FIFO tree
    input wire [CLAUSE_COUNT - 1 : 0] clause_valid_i, // Validity flags for each clause in the FIFO tree
    input wire fifo_tree_wren,  // Write enable signal for FIFO tree
    input wire fifo_tree_rden,  // Read enable signal for FIFO tree
    input wire fifo_tree_cOF,   // Clear overflow flag signal for FIFO tree
    output wire fifo_tree_empty,  // Empty flag output from FIFO tree
    output wire fifo_tree_OF,   // Overflow flag output from FIFO tree
    output wire [CLAUSE_WIDTH - 1 : 0] fifo_tree_clause_o,  // Output clause from the FIFO tree
    input wire [(LITERAL_ADDRESS_WIDTH + 1) * NSAT - 1 : 0] clause_reg_din, // Data input for Clause_Register
    input wire clause_reg_we,            // Write enable signal for Clause_Register
    input wire [LITERAL_ADDRESS_WIDTH-1:0] clause_table_waddr, clause_table_raddr, // Addresses for writing and reading the Clause_Table
    input wire clause_table_we,          // Write enable signal for Clause_Table
    input wire [(LITERAL_ADDRESS_WIDTH + 1) * (NSAT - 1) * CLAUSE_COUNT - 1 : 0] clause_table_clauses_i, // Input clauses for Clause_Table
    input wire [DATA_WIDTH-1:0] parallel_data_i [NUM_PARALLEL-1:0], // Parallel data input for Parallel_to_Serial
    input wire data_valid_i [NUM_PARALLEL-1:0], // Validity flags for parallel data inputs
    input wire write_en_parallel,        // Write enable signal for Parallel_to_Serial
    output wire [CLAUSE_TABLE_ADDRESS_WIDTH - 1:0] ct_addr_field,  // Clause table address output
    output wire [CLAUSE_COUNT-1:0] mask_field,  // Mask field output
    output wire [NUM_CLAUSES_BITS-1:0] break_value,  // Output indicating the number of broken clauses
    output wire [NSAT_BITS-1:0] select_o,  // Selected variable index output from Heuristic_Selector
    output wire random_selection_o,      // Random selection indicator from Heuristic_Selector
    output wire sat_result,               // Output SAT result indicating if the problem is satisfiable
    output wire done,                     // Output indicating completion of the SAT solving process
    output wire [FIFO_DATA_WIDTH-1:0] fifo_data_o,  // Data output from FIFO_Buffer
    output wire fifo_empty_o,            // Empty flag output from FIFO_Buffer
    output wire fifo_full_o,              // Full flag output from FIFO_Buffer
    output wire [(NSAT-1)*MAX_CLAUSES_PER_VARIABLE*(LITERAL_ADDRESS_WIDTH+1)-1:0] literals_multi_o, // Output literals from Temporal_Buffer_Wrapper
    output wire [(LITERAL_ADDRESS_WIDTH + 1) * NSAT - 1 : 0] clause_reg_dout, // Data output from Clause_Register
    output wire [(LITERAL_ADDRESS_WIDTH + 1) * (NSAT - 1) * CLAUSE_COUNT - 1 : 0] clause_table_clauses_o, // Output clauses from Clause_Table
    output wire [DATA_WIDTH-1:0] serial_data_o, // Serial data output from Parallel_to_Serial
    output wire data_valid_o                // Data valid output from Parallel_to_Serial
);

    // Internal wires and registers
    wire [31:0] random_out; // Output from the LFSR (Linear Feedback Shift Register) PRNG module
    wire [CLUSTER_SIZE-1:0] en_a, en_b, we_a, we_b; // Enable and write enable signals for Variable_Table_Cluster
    wire [(LITERAL_ADDRESS_WIDTH * CLUSTER_SIZE) - 1:0] addr_a, addr_b; // Addresses for Variable_Table_Cluster
    wire [CLUSTER_SIZE-1:0] din_a, din_b; // Data input for Variable_Table_Cluster
    wire [CLUSTER_SIZE-1:0] dout_a, dout_b; // Data output for Variable_Table_Cluster
    wire [CLUSTER_SIZE-1:0] break_o; // Output from Clause_Evaluator_Cluster to Break_Value_Counter

    // Instantiate Address_Translation_Table module
    Address_Translation_Table #(
        .CLAUSE_COUNT(CLAUSE_COUNT),
        .LITERAL_ADDRESS_WIDTH(LITERAL_ADDRESS_WIDTH),
        .CLAUSE_TABLE_ADDRESS_WIDTH(CLAUSE_TABLE_ADDRESS_WIDTH)
    ) address_translation_table_inst (
        .clk(clk),
        .wren(wren),
        .waddr(waddr),
        .raddr(raddr),
        .din(din),
        .ct_addr_field(ct_addr_field),
        .mask_field(mask_field)
    );

    // Instantiate Variable_Table_Cluster module
    Variable_Table_Cluster #(
        .LITERAL_ADDRESS_WIDTH(LITERAL_ADDRESS_WIDTH),
        .CLUSTER_SIZE(CLUSTER_SIZE)
    ) variable_table_cluster_inst (
        .clk(clk),
        .en_a(en_a),
        .en_b(en_b),
        .we_a(we_a),
        .we_b(we_b),
        .addr_a(addr_a),
        .addr_b(addr_b),
        .din_a(din_a),
        .din_b(din_b),
        .dout_a(dout_a),
        .dout_b(dout_b)
    );

    // Instantiate Clause_Evaluator_Cluster module
    Clause_Evaluator_Cluster #(
        .CLUSTER_SIZE(CLUSTER_SIZE),
        .NSAT(NSAT),
        .IMPLEMENTATION(IMPLEMENTATION),
        .REDUCE(REDUCE)
    ) clause_evaluator_cluster_inst (
        .clk_i(clk),
        .reset_i(reset),
        .var_val_i(var_val),
        .var_neg_i(var_neg),
        .break_o(break_o)
    );

    // Instantiate Break_Value_Counter module
    Break_Value_Counter #(
        .NUM_CLAUSES(NUM_CLAUSES),
        .NUM_CLAUSES_BITS(NUM_CLAUSES_BITS)
    ) break_value_counter_inst (
        .clk(clk),
        .reset(reset),
        .clause(break_o),  // Clause bits from Clause_Evaluator_Cluster
        .break_value(break_value)
    );

    // Instantiate Heuristic_Selector module
    Heuristic_Selector #(
        .MAX_CLAUSES_PER_VARIABLE(MAX_CLAUSES_PER_VARIABLE),
        .NSAT(NSAT),
        .MAX_CLAUSES_PER_VARIABLE_BITS(MAX_CLAUSES_PER_VARIABLE_BITS),
        .NSAT_BITS(NSAT_BITS),
        .P(P)
    ) heuristic_selector_inst (
        .clk(clk),
        .reset(reset),
        .break_values_i(break_value),
        .break_values_valid_i(/* Connect to the valid signal source */),
        .random_i(random_out),  // Use the LFSR output as the random input
        .select_o(select_o),
        .random_selection_o(random_selection_o)
    );

    // Instantiate Temporal_Buffer_Wrapper module
    Temporal_Buffer_Wrapper #(
        .NSAT(NSAT),
        .LAW(LITERAL_ADDRESS_WIDTH),
        .MCPV(MAX_CLAUSES_PER_VARIABLE),
        .NSAT_BITS(NSAT_BITS)
    ) temporal_buffer_wrapper_inst (
        .clk(clk),
        .reset(reset),
        .write_index_i(write_index_i),
        .write_en_i(write_en_i),
        .literals_multi_i(literals_multi_i),
        .read_index_i(read_index_i),
        .literals_multi_o(literals_multi_o)
    );

    // Instantiate FIFO_Tree module
    FIFO_tree #(
        .CLAUSE_COUNT(CLAUSE_COUNT),
        .CLAUSE_WIDTH(CLAUSE_WIDTH),
        .BUFFER_DEPTH(BUFFER_DEPTH)
    ) fifo_tree_inst (
        .clk(clk),
        .reset(reset),
        .clauses_i(clauses_i),
        .clause_valid_i(clause_valid_i),
        .wren(fifo_tree_wren),
        .rden(fifo_tree_rden),
        .cOF(fifo_tree_cOF),
        .empty(fifo_tree_empty),
        .OF(fifo_tree_OF),
        .clause_o(fifo_tree_clause_o)
    );

    // Instantiate UNSAT_Clause_Buffer module (assuming similar ports)
    UNSAT_Clause_Buffer #(
        .LITERAL_ADDRESS_WIDTH(LITERAL_ADDRESS_WIDTH),
        .CLAUSE_COUNT(CLAUSE_COUNT)
    ) unsat_clause_buffer_inst (
        .clk(clk),
        .reset(reset)
        // anything else here?
    );

    // Instantiate Variable_Table module
    Variable_Table #(
        .LITERAL_ADDRESS_WIDTH(LITERAL_ADDRESS_WIDTH),
        .CLUSTER_SIZE(CLUSTER_SIZE)
    ) variable_table_inst (
        .clk(clk),
        .reset(reset)
        // anything else here?
    );

    // Instantiate FIFO_Buffer module
    FIFO_Buffer #(
        .DATA_WIDTH(FIFO_DATA_WIDTH),
        .BUFFER_ADDR_WIDTH(FIFO_BUFFER_ADDR_WIDTH)
    ) fifo_buffer_inst (
        .clk(clk),
        .reset(reset),
        .data_i(fifo_data_i),
        .rden_i(fifo_rden_i),
        .wren_i(fifo_wren_i),
        .data_o(fifo_data_o),
        .empty_o(fifo_empty_o),
        .full_o(fifo_full_o)
    );

    // Instantiate Clause_Register module
    Clause_Register #(
        .NSAT(NSAT),
        .LITERAL_ADDRESS_WIDTH(LITERAL_ADDRESS_WIDTH)
    ) clause_register_inst (
        .clk(clk),
        .reset(reset),
        .we(clause_reg_we),
        .din(clause_reg_din),
        .dout(clause_reg_dout)
    );

    // Instantiate Clause_Table module
    Clause_Table #(
        .CLAUSE_COUNT(CLAUSE_COUNT),
        .DEPTH(DEPTH),
        .LITERAL_ADDRESS_WIDTH(LITERAL_ADDRESS_WIDTH),
        .NSAT(NSAT)
    ) clause_table_inst (
        .clk(clk),
        .we(clause_table_we),
        .waddr(clause_table_waddr),
        .raddr(clause_table_raddr),
        .clauses_i(clause_table_clauses_i),
        .clauses_o(clause_table_clauses_o)
    );

    // Instantiate Parallel_to_Serial module
    Parallel_to_Serial #(
        .DATA_WIDTH(FIFO_DATA_WIDTH),
        .NUM_PARALLEL(NUM_PARALLEL)
    ) parallel_to_serial_inst (
        .clk(clk),
        .reset(reset),
        .data_i(parallel_data_i),
        .data_valid_i(data_valid_i),
        .write_en_i(write_en_parallel),
        .data_o(serial_data_o),
        .data_valid_o(data_valid_o)
    );

    // Instantiate the LFSR PRNG module
    lfsr_prng prng_inst (
        .clk(clk),
        .reset(reset),
        .out(random_out)  // Connect to the Heuristic_Selector
    );

    // Logic in SAT result solver determined to be negibigle compared to the memories
    // Hence we give an estimate of the memories 

endmodule
