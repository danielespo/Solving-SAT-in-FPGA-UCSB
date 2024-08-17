/* ----------------------------------------------------
Version: 2.0
FIFO_Tree.v

V1.0 Author: Zeiler Randall-Reed
V2.0 Author: Barry Wang

Description:
    This is the FIFO tree implementation as specified in
    the KM paper. This FIFO tree supports smart source
    selection to minimize the possibility of an overflow.
    It has an OF flag which will be raised whenever an
    overflow occurs in any of its buffer.

Notes: 
    This FIFO tree:
    - Will immediately start writing to its first level L0
    buffers on the clock cycle when wren is raised. It
    will then spend the next 4 clock cycles to write the
    remaining 4 clauses in its imputs.
    - Does not define r/w during when OF is raised or when
    empty/full flags are raised.

Testing:
    V1.0 test passed
    V2.0 test passed

Change Log:

2024/08/5  - Barry Wang
    Created V2.0
2024/08/12 - Barry Wang
    Fixed I/O timing


-----------------------------------------------------*/

module FIFO_tree #(
    parameter CLAUSE_COUNT = 20,
    parameter CLAUSE_WIDTH = 36,
    parameter BUFFER_DEPTH = 32
)(
    input clk,
    input reset,
    input [CLAUSE_WIDTH * CLAUSE_COUNT - 1 : 0] clauses_i,
    input [CLAUSE_COUNT - 1 : 0]                clause_valid_i,
    input wren,           // write enable
    input rden,           // read enable
    input cOF,            // clear overflow flag
    output wire empty,    // empty flag
    output reg  OF,       // overflow flag
    output [CLAUSE_WIDTH - 1 : 0] clause_o
);

    localparam CW = CLAUSE_WIDTH;
    genvar i;
    integer j;
    
    // L0 4x 5-1 fifo buffers signals
    wire [3:0] L0E, L0F, L0wren, L0rden;
    reg  [3:0] L0rden_delay;
    wire [CLAUSE_WIDTH * 4 - 1 : 0] L0dout, L0din;
    reg  [2:0] L0src;
    // L0 MUX generation
    for (i = 0; i < 4; i = i + 1)
    begin
        assign L0din[CW * i +: CW] = clauses_i[CW * ( (wren ? 0 : L0src) + i * 5) +: CW];
    end
    generate
        for (i = 0; i < 4; i = i + 1) begin : L0_FIFO
            FIFO_Buffer # (
                .DATA_WIDTH(CLAUSE_WIDTH),
                .BUFFER_ADDR_WIDTH($clog2(BUFFER_DEPTH))
            ) L0_FIFO_inst (
                .clk    (clk),
                .reset  (reset),
                .data_i (L0din[CW * i +: CW]),
                .rden_i (L0rden[i]),
                .wren_i (L0wren[i]),
                .data_o (L0dout[CW * i +: CW]),
                .empty_o(L0E[i]),
                .full_o (L0F[i])
            );
        end    
    endgenerate
    
    // L1 2x 2-1 fifo buffers signals
    wire [1:0] L1E, L1F, L1rden;
    reg  [1:0] L1rden_delay;
    reg  [1:0] L1wren;
    wire [CLAUSE_WIDTH * 2 - 1 : 0] L1dout;
    reg  [CLAUSE_WIDTH * 2 - 1 : 0] L1din;
    reg  [1:0] L1src;
    
    // L1din MUX
    always @ (*) begin
        for (j = 0; j < 2; j = j + 1) begin
            L1din[CW * j +: CW] <= L0rden_delay[j * 2] ?
                L0dout[CW * (j * 2) +: CW] : L0dout[CW * (j * 2 + 1) +: CW];
        end
    end

    generate
        for (i = 0; i < 2; i = i + 1) begin : L1_FIFO
            FIFO_Buffer # (
                .DATA_WIDTH(CLAUSE_WIDTH),
                .BUFFER_ADDR_WIDTH($clog2(BUFFER_DEPTH))
            ) L1_FIFO_inst (
                .clk    (clk),
                .reset  (reset),
                .data_i (L1din[CW * i +: CW]),
                .rden_i (L1rden[i]),
                .wren_i (L1wren[i]),
                .data_o (L1dout[CW * i +: CW]),
                .empty_o(L1E[i]),
                .full_o (L1F[i])
            );
        end    
    endgenerate
    
    // L2 1x 2-1 fifo buffer signals
    wire L2E, L2F;
    wire L2rden;
    reg  L2wren;
    wire [CLAUSE_WIDTH - 1 : 0] L2dout;
    reg  [CLAUSE_WIDTH - 1 : 0] L2din;
    reg  L2src;
    
    // L2din MUX
    always @ (*) begin
        L2din <= L1rden_delay[0] ? L1dout[0 +: CW] : L1dout[CW +: CW];
    end
    
    FIFO_Buffer # (
        .DATA_WIDTH(CLAUSE_WIDTH),
        .BUFFER_ADDR_WIDTH($clog2(BUFFER_DEPTH))
    ) FIFO_last (
        .clk    (clk),
        .reset  (reset),
        .data_i (L2din),
        .rden_i (L2rden),
        .wren_i (L2wren),
        .data_o (L2dout),
        .empty_o(L2E),
        .full_o (L2F)
    );
    
    // controller logic
    
    reg overflow;
    
    always @ (posedge clk) begin
        if (reset) begin
            overflow <= 0;
            L0src <= 0;
        end else if (wren) begin
            L0src <= 1;
        end else if (L0src < 5) begin
            L0src <= L0src + 1;
        end else begin
            L0src <= L0src;
        end
    end
        
    // L0 controls --------------------------------------------------
    always @ (posedge clk) begin
        L0rden_delay <= reset ? 0 : L0rden;
    end
    // L0 read and write enables
    // These signals are mostly combinational
    for (i = 0; i < 4; i = i + 1) begin
        assign L0wren[i] = wren ? clause_valid_i[i * 5] :
            clause_valid_i[i * 5 + L0src] & (L0src < 5);
    end
    
    for (i = 0; i < 2; i = i + 1) begin
        // read from L0 if 
        // 1. this buffer is not empty and
        // 2. if this buffer should be read or the other buffer is empty
        // This signal is combinationally generated but it uses L1src_delay
        // which is sequential.
        assign L0rden[i * 2]        = ~L0E[i * 2] && (L1src[i] ? L0E[i * 2 + 1] : 1);
        assign L0rden[i * 2 + 1]    = ~L0E[i * 2 + 1] && (L1src[i] ? 1 : L0E[i * 2]);
    end
    
    // L1 controls --------------------------------------------------
    always @ (posedge clk) begin
        if(reset) begin
            L1src           <= 0;
            L1wren          <= 0;
            L1rden_delay    <= 0;
        end else begin
            L1rden_delay    <= L1rden;
            for (j = 0; j < 2; j = j + 1) begin
                // toggle L1src if the target fifo is not empty
                L1src[j]    <= L1src ^ (~L0E[L1src[j] ? j * 2 + 1 : j * 2]);
                // if L0rden was high for either src buffer then write to L1 next rising edge
                L1wren[j]   <= |L0rden[j * 2 +: 2];
            end 
        end
    end
    
    assign L1rden[0] = ~L1E[0] && (L2src ? L1E[1] : 1);
    assign L1rden[1] = ~L1E[1] && (L2src ? 1 : L1E[0]);
    
    // L2 controls --------------------------------------------------
    always @ (posedge clk) begin
        if(reset) begin
            L2src       <= 0;
            L2wren      <= 0;
        end else begin
            // toggle L2src if the target fifo is not empty
            L2src       <= L2src ^ (~L1E[~L2src]);
            // if L1rden was high for either src buffer then write to L2 next rising edge
            L2wren  <= |L1rden;
        end
    end
    
    assign L2rden   = rden;
    assign clause_o = L2dout;
    assign empty    = L2E;
    
    always @ (posedge clk) begin
        if (reset | cOF) begin
            OF <= 0;
        end else begin
            OF <= OF | (|(L0F & L0wren)) | (|(L1F & L1wren)) | (L2F & L2wren);
        end
end

endmodule