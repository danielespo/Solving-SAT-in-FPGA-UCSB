/* ----------------------------------------------------
Version: 2.1
Address_Translation_Table.v

V1.0 Author: Dan Espinosa
V2.0 Author: Barry Wang
V2.1 Author: [Your Name]

Description:
    This is a configurable width/depth memory with a literal address field and a
    mask field. The lower data output bits `[CLAUSE_COUNT-1:0]` form the mask
    field and the upper bits are the clause table address.
    
    Now, the module supports loading its memory from a mem file using $readmemh.

Notes: 
    This table is simple dual port since it is a static table that only needs to be 
    written once per problem.
    
-----------------------------------------------------*/

module Address_Translation_Table # (
    parameter CLAUSE_COUNT = 20,
    parameter LITERAL_ADDRESS_WIDTH = 12,   // address width for reading/writing
    parameter CLAUSE_TABLE_ADDRESS_WIDTH = 11,
    parameter MEM_DEPTH = (1 << LITERAL_ADDRESS_WIDTH), // number of entries in AT
    parameter AT_MEM_FILE = "../../Python-Code/at.mem"          // mem file name for initialization
)(
    input       clk_i, 
    // setup write io  
    input       wr_en_i,
    input       [LITERAL_ADDRESS_WIDTH : 0] wr_addr_i, 
    input       [CLAUSE_TABLE_ADDRESS_WIDTH + CLAUSE_COUNT - 1 : 0] wr_data_i,
    // runtime read io
    input       [LITERAL_ADDRESS_WIDTH-1 : 0] rd_addr_i,
    output wire [CLAUSE_TABLE_ADDRESS_WIDTH - 1 : 0] addr_o,
    output wire [CLAUSE_COUNT - 1 : 0] mask_o
);

    localparam WIDTH = CLAUSE_TABLE_ADDRESS_WIDTH + CLAUSE_COUNT;
    
    reg [WIDTH - 1 : 0] ram [0 : MEM_DEPTH - 1];
    reg [WIDTH - 1 : 0] dout;
    
    assign mask_o = dout[CLAUSE_COUNT - 1 : 0];
    assign addr_o = dout[WIDTH - 1 : CLAUSE_COUNT];

    integer i;
    initial begin
        // Initialize all entries to 0 (for simulation safety)
        for (i = 0; i < MEM_DEPTH; i = i + 1)
            ram[i] = {WIDTH{1'b0}};
        // Load memory contents from file
        $readmemh(AT_MEM_FILE, ram);
        // $display("Address Translation Table: Loaded mem file %s at time %0t", AT_MEM_FILE, $time);
    end
    
    always @(posedge clk_i) begin
        if (wr_en_i) begin
            ram[wr_addr_i] <= wr_data_i;
            // $display("ATT WRITE at time %0t: wr_addr=0x%0h, wr_data=0x%0h", $time, wr_addr_i, wr_data_i);
        end
        dout <= ram[rd_addr_i];
        // $display("ATT READ at time %0t: rd_addr=0x%0h, dout=0x%0h (addr_o=0x%0h, mask_o=0x%0h)", $time, rd_addr_i, dout, addr_o, mask_o);
    end

endmodule
