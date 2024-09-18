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

2024/09/11 - Zeiler Randall-Reed
    update for changes in Variable Table
    unify runtime write signals (Variable Table changes are synced)
    axi interface 

-----------------------------------------------------*/

module Variable_Table_Cluster #(
    parameter VARIABLE_ADDRESS_WIDTH = 11,
    // Total number of variable tables will be CLUSTER_SIZE,
    parameter CLUSTER_SIZE = 20 * 2
)(
    input  clk_i,
    
    // axi interface (should write simultaneously)
    input  axi_en_i, axi_wr_en_i,
    input  [VARIABLE_ADDRESS_WIDTH - 1 : 0] axi_addr_i,
    input  axi_data_i, // common data input

    // runtime interface
    input  en_i, wr_en_i,
    input  [CLUSTER_SIZE * VARIABLE_ADDRESS_WIDTH - 1 : 0] addr_mi, 
    input                                                  data_i, // common runtime data input
    output [CLUSTER_SIZE - 1 : 0]                          data_mo
);
    genvar i;
    generate
        for (i = 0; i < CLUSTER_SIZE; i = i + 1)
        begin
            Variable_Table # (VARIABLE_ADDRESS_WIDTH) (
                .clk_i(clk_i),
                .axi_en_i(axi_en_i),
                .axi_wr_en_i(axi_wr_en_i),
                .axi_addr_i(axi_addr_i),
                .axi_data_i(axi_data_i),
                //.axi_data_o(),
                .en_i(en_i),
                .wr_en_i(wr_en_i),
                .addr_i(addr_mi[i * VARIABLE_ADDRESS_WIDTH +: VARIABLE_ADDRESS_WIDTH]),
                .data_i(data_i),
                .data_o(data_mo[i])
            );
        end
    endgenerate
endmodule
