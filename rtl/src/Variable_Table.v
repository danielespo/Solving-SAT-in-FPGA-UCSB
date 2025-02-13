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
    parameter VARIABLE_ADDRESS_WIDTH = 11
)(
    input       clk_i, 

    // runtime interface
    input       en_i, wr_en_i,
    input       [VARIABLE_ADDRESS_WIDTH - 1 : 0] addr_i, 
    input       data_i,
    output reg  data_o 
);

    reg ram [0 : 2 ** VARIABLE_ADDRESS_WIDTH - 1];
    
    always @(posedge clk_i)
    begin
        if (en_i)
        begin
            if (wr_en_i) ram[addr_i] <= data_i;
            data_o <= ram[addr_i];
        end
    end
    

endmodule