/* ----------------------------------------------------
Version: 1.0
Variable Table.v

V1.0 Author: Barry Wang

Description:
    This is a cluster of variable tables for packing

Notes:
    For a 3-SAT solver, each clause evaluator in the
    clause evaluator cluster requires 2 variable tables
    
Testing:
    None

Change Log:

2024/07/25 - Barry Wang
    Created Variable_Table_Cluster.v

-----------------------------------------------------*/

module Variable_Table_Cluster #(
    parameter VARIABLE_ADDRESS_WIDTH = 11,
    // Total number of variable tables will be CLUSTER_SIZE,
    parameter CLUSTER_SIZE = 20 * 2
)(
    input   clk,
    input   [CLUSTER_SIZE - 1 : 0] en_a, en_b, 
    input   [(VARIABLE_ADDRESS_WIDTH * CLUSTER_SIZE) - 1 : 0] addr_a, addr_b,
    input   [CLUSTER_SIZE - 1 : 0] we_a, we_b,
    input   [CLUSTER_SIZE - 1 : 0] din_a, din_b,
    output  [CLUSTER_SIZE - 1 : 0] dout_a, dout_b
);
    genvar i;
    generate
        for (i = 0; i < CLUSTER_SIZE; i = i + 1)
        begin
            Variable_Table # (VARIABLE_ADDRESS_WIDTH) (
                .clk(clk),
                .en_a(en_a[i]),
                .en_b(en_b[i]),
                .we_a(we_a[i]),
                .we_b(we_b[i]),
                .addr_a(addr_a[i * VARIABLE_ADDRESS_WIDTH +: VARIABLE_ADDRESS_WIDTH]),
                .addr_b(addr_b[i * VARIABLE_ADDRESS_WIDTH +: VARIABLE_ADDRESS_WIDTH]),
                .din_a(din_a[i]),
                .din_b(din_b[i]),
                .dout_a(dout_a[i]),
                .dout_b(dout_b[i])
            );
        end
    endgenerate
endmodule
