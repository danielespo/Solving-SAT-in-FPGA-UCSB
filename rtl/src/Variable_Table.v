/* ----------------------------------------------------
Version: 2.0
Variable Table.v

V1.0 Author: Unknown
V2.0 Author: Barry Wang

Description:
    This is a single DEPTH * 1b true dual port read
    first variable table.

Notes:
    None
    
Testing:
    None

Change Log:

2024/07/25 - Barry Wang
    Remake variable table

2024/09/11 - Zeiler Randall-Reed
    naming changes
    separate axi interface 

-----------------------------------------------------*/

module Variable_Table #(
    parameter VARIABLE_ADDRESS_WIDTH = 11,
    parameter THREAD_ID_WIDTH        = 4
)(
    input       clk_i, 
    input       axi_en_i,
    input       axi_wr_en_i,
    input       [VARIABLE_ADDRESS_WIDTH - 1 : 0] axi_addr_i,
    input       axi_data_i,
    //output reg  axi_data_o, // unused in this version

    input       en_i,
    input       wr_en_i,
    input       [THREAD_ID_WIDTH + VARIABLE_ADDRESS_WIDTH - 1 : 0] addr_i,
    input       data_i,
    output reg  data_o 
);
    localparam RUNTIME_ADDRESS_WIDTH = THREAD_ID_WIDTH + VARIABLE_ADDRESS_WIDTH;
    reg ram [0 : 2 ** RUNTIME_ADDRESS_WIDTH - 1];

    wire [THREAD_ID_WIDTH-1:0]        thread_id = addr_i[RUNTIME_ADDRESS_WIDTH-1 : VARIABLE_ADDRESS_WIDTH];
    wire [VARIABLE_ADDRESS_WIDTH-1:0] var_addr  = addr_i[VARIABLE_ADDRESS_WIDTH-1 : 0];
    
    integer i;
    initial begin
        data_o = 1'b0;
        for (i = 0; i < 2 ** RUNTIME_ADDRESS_WIDTH; i = i + 1) begin
            ram[i] = 1'b0;
        end
    end

    // Runtime port: read & write at combined address
    always @(posedge clk_i) begin
        if (en_i) begin
            if (wr_en_i) 
                ram[addr_i] <= data_i;
            data_o <= ram[addr_i];
        end
    end
    
    // AXI port: only has VARIABLE_ADDRESS_WIDTH
    always @(posedge clk_i) begin
        if (axi_en_i) begin
            if (axi_wr_en_i)
                ram[axi_addr_i] <= axi_data_i; 
            // axi_data_o <= ram[axi_addr_i]; // if needed
        end
    end

endmodule