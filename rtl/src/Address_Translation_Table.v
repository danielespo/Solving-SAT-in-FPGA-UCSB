/* ----------------------------------------------------
Version: 2.0
Address_Translation_Table.v

V1.0 Author: Dan Espinosa
V2.0 Author: Barry Wang
V2.5 Author: Harim Choe

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

2024/09/11 - Zeiler Randall-Reed
    Changed "VARIABLE_ADDRESS_WIDTH" to "LITERAL_ADDRESS_WIDTH" to match naming in other modules
    naming convention parity

2025/01/14 - Harim Choe
    Initalize mask_out and addr_out as 0

-----------------------------------------------------*/

module Address_Translation_Table # (
    parameter CLAUSE_COUNT = 20,
    parameter LITERAL_ADDRESS_WIDTH = 12,
    parameter CLAUSE_TABLE_ADDRESS_WIDTH = 11
)(
    input       clk_i, 

    // setup write io  
    input                                                           axi_wr_en_i,
    input       [LITERAL_ADDRESS_WIDTH : 0]                         axi_wr_addr_i, 
    input       [CLAUSE_TABLE_ADDRESS_WIDTH + CLAUSE_COUNT - 1 : 0] axi_wr_data_i,

    // runtime read io
    input       [LITERAL_ADDRESS_WIDTH-2 : 0]          rd_addr_i,
    output wire [CLAUSE_TABLE_ADDRESS_WIDTH - 1 : 0] addr_o,
    output wire [CLAUSE_COUNT - 1 : 0]               mask_o
);

    localparam DEPTH = 2 ** (LITERAL_ADDRESS_WIDTH);
    localparam WIDTH = CLAUSE_TABLE_ADDRESS_WIDTH + CLAUSE_COUNT;
    
    reg [WIDTH - 1 : 0] ram [0 : DEPTH - 1];
    reg [WIDTH - 1 : 0] dout;
    
    // assign {addr_o, mask_o} = dout; // potential alternative, but unclear
    integer i;
    initial begin
        dout = {WIDTH{1'b0}};
        for (i = 0; i < DEPTH; i = i + 1)
            ram[i] = {WIDTH{1'b0}};
        $display("Address Translation Table Initialized.");
    end

    assign mask_o = dout[CLAUSE_COUNT - 1 : 0];
    assign addr_o = dout[WIDTH - 1 : CLAUSE_COUNT];
    
    always @(posedge clk_i)
    begin
        // Handle write operations
        if (axi_wr_en_i) begin
            ram[axi_wr_addr_i] <= axi_wr_data_i;
            $display("Write operation: Address = %0h, Data = %0h", axi_wr_addr_i, axi_wr_data_i);
        end

        // Handle read operations
        dout <= ram[rd_addr_i];
        $display("Read operation: Address = %0h, Data = %0h (Addr_o = %0h, Mask_o = %0h)", 
                 rd_addr_i, dout, addr_o, mask_o);
    end

endmodule