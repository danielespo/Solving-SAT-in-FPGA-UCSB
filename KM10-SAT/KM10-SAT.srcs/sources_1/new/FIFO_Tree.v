/*
FIFO_Tree.v

This module contains the FIFO Tree implementation. The FIFO tree is a tree of FIFO buffers 
connected via parallel to serial converters. The tree is used to store the clauses that are
left unsatisfied after a flip in the SAT solver. The tree is used primarily to consolidate
the data from the parallel clause processors.

This implementation is parameterized to allow for different buffer sizes, data widths, and
level of parallelism. The tree depth is currently fixed at 3 and the parameter is unused. 

The tree has inputs for the clauses and whether they are valid. It also has an input to 
write the data to the tree. The tree outputs a single clause at a time. 
*/

module FIFO_tree #(
    parameter MAX_CLAUSES_PER_VARIABLE = 20,
    parameter DATA_WIDTH = 36,
    parameter BUFFER_SIZE = 32,
    parameter FIRST_LEVEL_PARALLEL = 5,
    parameter TREE_LEAVES = MAX_CLAUSES_PER_VARIABLE / FIRST_LEVEL_PARALLEL, // a bit risky I would just hardcode this everytime as MAX_CLAUSES_PER_VARIABLE / FIRST_LEVEL_PARALLEL
    parameter TREE_DEPTH = 3    // unused parameter
)(
    input                       clk,
    input                       reset,
    input [DATA_WIDTH - 1 : 0]  clauses_i       [MAX_CLAUSES_PER_VARIABLE-1:0],
    input                       clause_valid_i  [MAX_CLAUSES_PER_VARIABLE-1:0],
    input                       write_en_i,

    output reg [DATA_WIDTH - 1 : 0] clause_o,
    
); // syntax error here I have no idea how to fix

// unsure exactly how to parameterize this - what does each level of the tree look like?
//  - I'm assuming the MAX_CLAUSES_PER_VARIABLE is a multiple of FIRST_LEVEL_PARALLEL
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

// wire buffer_read_en_level_1  [TREE_LEAVES - 1:0];
// wire buffer_empty_level_1    [TREE_LEAVES - 1:0];

// wire p2s_write_en_level_2    [TREE_LEAVES / 2 - 1:0];
// wire buffer_read_en_level_2  [TREE_LEAVES / 2 - 1:0];

wire level_1_to_2_enable    [TREE_LEAVES - 1:0]; // needs FSM controller 

// half and quarter speed clocks (high for one clock cycle every 2 and 4 clock cycles respectively)
reg clk2, clk4;
reg [1:0] counter;

genvar i, j;
generate
    // top level of tree
    for(i = 0; i < TREE_LEAVES; i = i + 1) begin
        Parallel_to_Serial #(
            .DATA_WIDTH(DATA_WIDTH),
            .NUM_PARALLEL(FIRST_LEVEL_PARALLEL)
        ) parallel_to_serial (
            .clk(clk),
            .reset(reset),
            .data_i(clauses_i[i*FIRST_LEVEL_PARALLEL +: FIRST_LEVEL_PARALLEL]),
            .data_valid_i(clause_valid_i[i*FIRST_LEVEL_PARALLEL +: FIRST_LEVEL_PARALLEL]),
            .write_en_i(write_en_i),
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
    // this is because the data_i and data_valid_i ports are arrays of size 2 and I am unsure how to parameterize this
    for(j = 0; j < TREE_LEAVES / 2; j = j + 1) begin
        Parallel_to_Serial #(
            .DATA_WIDTH(DATA_WIDTH),
            .NUM_PARALLEL(TREE_LEAVES / 2)
        ) parallel_to_serial_2 (
            .clk(clk),
            .reset(reset),
            .data_i({buffer_level_1[j*(TREE_LEAVES / 2)], buffer_level_1[j*(TREE_LEAVES / 2) + 1]}),
            .data_valid_i({buffer_level_1_valid[j*(TREE_LEAVES / 2)], buffer_level_1_valid[j*(TREE_LEAVES / 2) + 1]}),
            .write_en_i(clk2), 
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
            .read_en_i(~serial_level_3_valid),  // use the inverse of the valid signal from the next layer to signal read
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
    .data_valid_i(buffer_level_2_valid),
    .write_en_i(clk4), 
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
    .read_en_i(1'b1),   // try always on - means the next module needs to expect data always
    .write_en_i(serial_level_3_valid),
    .data_o(clause_o),
    .data_valid_o(clause_o),
    .empty_o(), // unused
    .full_o()   // unused
);

// TODO: implement the rest of the logic
always @ (posedge clk) begin
    if (reset) begin
        clk2 <= 0;
        clk4 <= 0;
        counter <= 2'b0;
    end else begin
        if(counter[0]) begin
            clk2 <= 1;
            if(counter[1]) begin
                clk4 <= 1;
            end
        end else begin
            clk2 <= 0;
            clk4 <= 0;
        end
        counter <= counter + 1;
    end
end


endmodule