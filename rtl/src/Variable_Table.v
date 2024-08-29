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

-----------------------------------------------------*/

module Variable_Table #(
    parameter VARIABLE_ADDRESS_WIDTH = 11
)(
    input       clk, en_a, en_b, we_a, we_b,
    input       [VARIABLE_ADDRESS_WIDTH - 1 : 0] addr_a, addr_b,
    input       din_a, din_b,
    output reg  dout_a, dout_b
);

    reg ram [0 : 2 ** VARIABLE_ADDRESS_WIDTH - 1];
    
    
    always @(posedge clk)
    begin
        if (en_a)
        begin
            if (we_a) ram[addr_a] <= din_a;
            dout_a <= ram[addr_a];
        end
    end
    
    always @(posedge clk)
    begin
        if (en_b)
        begin
            if (we_b) ram[addr_b] <= din_b;
            dout_b <= ram[addr_b];
        end
    end
    

endmodule
