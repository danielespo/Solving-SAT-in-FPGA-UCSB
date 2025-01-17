// Filename: Dummy_Mem.v
module dummy_mem #(
    parameter WIDTH = 32,
    parameter DEPTH = 8,
    parameter MEM_INIT_FILE = "../mem/att_dummy.mem"
)(
    input  wire                 clk,
    input  wire [$clog2(DEPTH)-1:0] addr,
    input  wire                 read_en,
    output reg  [WIDTH-1:0]     data_o
);
    // The RAM
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Load memory from external file
    initial begin
        $display("Loading memory from %s ...", MEM_INIT_FILE);
        $readmemh(MEM_INIT_FILE, mem); // read the entire file into mem[0..DEPTH-1]
    end

    // Simple read logic
    always @(posedge clk) begin
        if (read_en) begin
            data_o <= mem[addr];
            $display("Dummy_Mem: read mem[%0d] = 0x%h", addr, mem[addr]);
        end
    end
endmodule