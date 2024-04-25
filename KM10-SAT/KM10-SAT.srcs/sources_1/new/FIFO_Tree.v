// SKELETON FILE FOR FIFO_TREE MODULE

module FIFO_tree #(
    parameter MAX_CLAUSES_PER_VARIABLE = 20,
    parameter DATA_WIDTH = 36,
    parameter BUFFER_SIZE = 32,
    parameter TREE_LEAVES = MAX_CLAUSES_PER_VARIABLE / 5,
    parameter TREE_DEPTH = 3    // unused parameter
)(
    input                       clk,
    input                       reset,
    input [DATA_WIDTH - 1 : 0]  clauses_i [MAX_CLAUSES_PER_VARIABLE-1:0],
    input                       write_en_i [MAX_CLAUSES_PER_VARIABLE-1:0],

    output reg [DATA_WIDTH - 1 : 0] clause_o,
    
);

// unsure exactly how to parameterize this - what does each level of the tree look like?
//  - I'm assuming the MAX_CLAUSES_PER_VARIABLE is a multiple of 5
//  - the top layer of the tree is just TREE_LEAVES parallel_to_serial modules feeding into that many buffers
//  - the second layer of the tree is 2 parallel_to_serial modules feeding into 2 buffers
//  - the third layer is trivial, just a parallel_to_serial module feeding into a buffer (FIFO_Last)
// internal signals/registers
wire [DATA_WIDTH - 1 : 0] serial_level_1        [TREE_LEAVES - 1:0];
wire                      serial_level_1_valid  [TREE_LEAVES - 1:0];

wire [DATA_WIDTH - 1 : 0] serial_level_2        [TREE_LEAVES / 2 - 1:0];
wire                      serial_level_2_valid  [TREE_LEAVES / 2 - 1:0];

wire [DATA_WIDTH - 1 : 0] serial_level_3;
wire                      serial_level_3_valid;

wire [DATA_WIDTH - 1 : 0] buffer_level_1        [TREE_LEAVES - 1:0];
wire                      buffer_level_1_valid  [TREE_LEAVES - 1:0];

wire [Data_WIDTH - 1 : 0] buffer_level_2        [TREE_LEAVES / 2 - 1:0];
wire                      buffer_level_2_valid  [TREE_LEAVES / 2 - 1:0];

reg buffer_read_en_level_1  [TREE_LEAVES - 1:0];
reg buffer_empty_level_1    [TREE_LEAVES - 1:0];

reg p2s_write_en_level_2    [TREE_LEAVES / 2 - 1:0];
reg buffer_read_en_level_2  [TREE_LEAVES / 2 - 1:0];

wire level_1_to_2_enable    [TREE_LEAVES / 2 - 1:0];

// TODO: fix this
reg [] clk_counter;

genvar i, j;
generate
    // top level of tree
    for(i = 0; i < TREE_LEAVES; i = i + 1) begin
        Parallel_to_Serial #(
            .DATA_WIDTH(DATA_WIDTH),
            .NUM_PARALLEL(5)
        ) parallel_to_serial (
            .clk(clk),
            .reset(reset),
            .data_i(clauses_i[i*5 +: 5]),
            .write_en_i(write_en_i[5*i +: 5]),
            .data_o(serial_level_1[i]),
            .data_valid_o(serial_level_1_valid[i])
        );
        FIFO_Buffer #(
            .DATA_WIDTH(DATA_WIDTH),
            .BUFFER_SIZE(BUFFER_SIZE)
        ) fifo_buffer (
            .clk(clk),
            .reset(reset),
            .data_i(serial_level_1[i]),
            .read_en_i(~serial_level_2_valid[(i >> 1)]), // use the inverse of the valid signal from the next layer to signal read
            .write_en_i(serial_level_1_valid[i]),
            .data_o(buffer_level_1[i]),
            .data_valid_o(buffer_level_1_valid[i]),
            .empty_o(), // unused
            .full_o()   // unused
        );
    end
    // second level of tree
    // the parallel to serial for this part is currently forced to have 2 parallel inputs
    for(j = 0; j < TREE_LEAVES / 2; j = j + 1) begin
        Parallel_to_Serial #(
            .DATA_WIDTH(DATA_WIDTH),
            .NUM_PARALLEL(TREE_LEAVES / 2)
        ) parallel_to_serial_2 (
            .clk(clk),
            .reset(reset),
            .data_i({buffer_level_1[j*(TREE_LEAVES / 2)], buffer_level_1[j*(TREE_LEAVES / 2) + 1]}),
            .write_en_i(), // TODO
            .data_o(serial_level_2[j]),
            .data_valid_o(serial_level_2_valid[j])
        );
        FIFO_Buffer #(
            .DATA_WIDTH(DATA_WIDTH),
            .BUFFER_SIZE(BUFFER_SIZE)
        ) fifo_buffer_2 (
            .clk(clk),
            .reset(reset),
            .data_i(serial_level_2[j]),
            .read_en_i(1),  // TODO
            .write_en_i(serial_level_2_valid[j]),
            .data_o(buffer_level_2[j]),
            .data_valid_o(buffer_level_2_valid[j]),
            .empty_o(), // unused
            .full_o()   // unused
        );
    end
endgenerate

Parallel_to_Serial #(
    .DATA_WIDTH(DATA_WIDTH),
    .NUM_PARALLEL(2)
) parallel_to_serial_3 (
    .clk(clk),
    .reset(reset),
    .data_i(buffer_level_2),
    .write_en_i(), // TODO
    .data_o(serial_level_3),
    .data_valid_o(serial_level_3_valid)
);

FIFO_Buffer #(
    .DATA_WIDTH(DATA_WIDTH),
    .BUFFER_SIZE(BUFFER_SIZE)
) fifo_buffer_3 (
    .clk(clk),
    .reset(reset),
    .data_i(serial_level_3),
    .read_en_i(1'b1),              // try always on
    .write_en_i(serial_level_3_valid),
    .data_o(clause_o),
    .data_valid_o(clause_o),
    .empty_o(), // unused
    .full_o()   // unused
);

// TODO: implement the rest of the logic


endmodule