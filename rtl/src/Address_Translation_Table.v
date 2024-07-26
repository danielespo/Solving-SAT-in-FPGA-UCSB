/* ----------------------------------------------------
Version: 2.0
Address_Translation_Table.v

V1.0 Author: Dan Espinosa
V2.0 Author: Barry Wang

Description:
    This is a configurable width/depth memory with a
    literal address field and a mask field. Lower
    data output bits `[CLAUSE_COUNT-1:0]` is the mask
    field and the upper bits are clause table address.

Notes: 
    This table is simple dual port since it is a static
    table that only needs to be written once per problem.
    
Testing:
    None

Change Log:

2024/07/24 - Barry Wang
    Remake Address_Translation_Table.v

-----------------------------------------------------*/

module Address_Translation_Table # (
    parameter CLAUSE_COUNT = 20,
    parameter LITERAL_ADDRESS_WIDTH = 11,
    parameter CLAUSE_TABLE_ADDRESS_WIDTH = 11
)(
    input       clk, wren,
    input       [LITERAL_ADDRESS_WIDTH:0] waddr, raddr,
    input       [CLAUSE_TABLE_ADDRESS_WIDTH + CLAUSE_COUNT - 1 : 0] din,
    output wire [CLAUSE_TABLE_ADDRESS_WIDTH - 1:0] ct_addr_field,
    output wire [CLAUSE_COUNT-1:0] mask_field
);

    localparam DEPTH = 2 ** (LITERAL_ADDRESS_WIDTH);
    localparam WIDTH = CLAUSE_TABLE_ADDRESS_WIDTH + CLAUSE_COUNT;
    
    reg [WIDTH - 1 : 0] ram [0 : DEPTH - 1];
    
    reg [WIDTH - 1 : 0] dout;
    
    assign mask_field = dout[CLAUSE_COUNT - 1 : 0];
    assign ct_addr_field = dout[WIDTH - 1 : CLAUSE_COUNT];
    
    always @(posedge clk)
    begin
        if (wren) ram[waddr] <= din;
        dout <= ram[raddr];
    end

endmodule
