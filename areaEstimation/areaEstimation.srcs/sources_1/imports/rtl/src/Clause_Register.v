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

-----------------------------------------------------*/

module Clause_Register# (
    parameter NSAT = 3,
    parameter LITERAL_ADDRESS_WIDTH = 11
)(
    input       clk, reset, we,
    input       [(LITERAL_ADDRESS_WIDTH + 1) * NSAT - 1 : 0] din,
    output reg  [(LITERAL_ADDRESS_WIDTH + 1) * NSAT - 1 : 0] dout
    );
    
    always @ (posedge clk)
    begin
        if (reset) dout <= 0;
        else if (we) dout <= din;
    end
    
endmodule
