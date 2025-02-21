/* ----------------------------------------------------
Version: 1.0
Clause_Register.v

V1.0 Author: Barry Wang

Description:
    This is a width configurable register for holding
    or buffering a clause.

Notes:
    Simple is better.

Testing:
    None

Change Log:

2024/07/24 - Barry Wang
    Remake Clause_Register

2024/09/11 - Zeiler Randall-Reed
    naming changes

-----------------------------------------------------*/

module Clause_Register# (
    parameter NSAT = 3,
    parameter LITERAL_ADDRESS_WIDTH = 12
)(
    input       clk_i, rst_i, 
    input       wr_en_i,
    input       [LITERAL_ADDRESS_WIDTH * NSAT - 1 : 0] data_i,
    output reg  [LITERAL_ADDRESS_WIDTH * NSAT - 1 : 0] data_o
);
    
    always @ (posedge clk_i or posedge rst_i)
    begin
        if (rst_i) begin 
            data_o <= 0;
            // $display("Clause_Register Reset at time %0t", $time);
        end else if (wr_en_i) begin 
            data_o <= data_i;
            // $display("Clause_Register Write at time %0t: data_i=0x%0h", $time, data_i);
        end
    end
    
endmodule

