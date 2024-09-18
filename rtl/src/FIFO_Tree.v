/* ----------------------------------------------------
Version: 2.0
FIFO_Tree.v

V1.0 Author: Zeiler Randall-Reed
V2.0 Author: Barry Wang

Description:
    This is the FIFO tree implementation as specified in
    the KM paper. This FIFO tree supports smart source
    selection to minimize the possibility of an overflow.
    It has an OF_o flag which will be raised whenever an
    overflow occurs in any of its buffer.

Notes: 
    This FIFO tree:
    - Will immediately start writing to its first level L0
    buffers on the clock cycle when wr_en_i is raised. It
    will then spend the next 4 clock cycles to write the
    remaining 4 clauses in its imputs.
    - Does not define r/w during when OF_o is raised or when
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

module FIFO_Tree #(
    parameter CLAUSE_COUNT = 20,
    parameter CLAUSE_WIDTH = 36,
    parameter BUFFER_DEPTH = 32
)(
    input clk_i,
    input rst_i,
    input [CLAUSE_WIDTH * CLAUSE_COUNT - 1 : 0] clauses_i,
    input [CLAUSE_COUNT - 1 : 0]                clauses_valid_i,
    input wr_en_i,          // write enable
    input rd_en_i,          // read enable
    input cOF_i,            // clear overflow flag
    output wire empty_o,    // empty flag
    output reg  OF_o,       // overflow flag
    output [CLAUSE_WIDTH - 1 : 0] clause_o
);

    localparam CW = CLAUSE_WIDTH;
    genvar i;
    integer j;
    
    // L0 4x 5-1 fifo buffers signals
    wire [3:0] L0E, L0F, L0wr_en, L0rd_en;
    reg  [3:0] L0rd_en_delay;
    wire [CLAUSE_WIDTH * 4 - 1 : 0] L0dout, L0din;
    reg  [2:0] L0src;
    // L0 MUX generation
    for (i = 0; i < 4; i = i + 1)
    begin
        assign L0din[CW * i +: CW] = clauses_i[CW * ( (wr_en_i ? 0 : L0src) + i * 5) +: CW];
    end
    generate
        for (i = 0; i < 4; i = i + 1) begin : L0_FIFO
            FIFO_Buffer # (
                .DATA_WIDTH(CLAUSE_WIDTH),
                .BUFFER_ADDR_WIDTH($clog2(BUFFER_DEPTH))
            ) L0_FIFO_inst (
                .clk_i  (clk_i),
                .rst_i  (rst_i),
                .data_i (L0din[CW * i +: CW]),
                .rd_en_i (L0rd_en[i]),
                .wr_en_i (L0wr_en[i]),
                .data_o (L0dout[CW * i +: CW]),
                .empty_o(L0E[i]),
                .full_o (L0F[i])
            );
        end    
    endgenerate
    
    // L1 2x 2-1 fifo buffers signals
    wire [1:0] L1E, L1F, L1rd_en;
    reg  [1:0] L1rd_en_delay;
    reg  [1:0] L1wr_en;
    wire [CLAUSE_WIDTH * 2 - 1 : 0] L1dout;
    reg  [CLAUSE_WIDTH * 2 - 1 : 0] L1din;
    reg  [1:0] L1src;
    
    // L1din MUX
    always @ (*) begin
        for (j = 0; j < 2; j = j + 1) begin
            L1din[CW * j +: CW] <= L0rd_en_delay[j * 2] ?
                L0dout[CW * (j * 2) +: CW] : L0dout[CW * (j * 2 + 1) +: CW];
        end
    end

    generate
        for (i = 0; i < 2; i = i + 1) begin : L1_FIFO
            FIFO_Buffer # (
                .DATA_WIDTH(CLAUSE_WIDTH),
                .BUFFER_ADDR_WIDTH($clog2(BUFFER_DEPTH))
            ) L1_FIFO_inst (
                .clk_i    (clk_i),
                .rst_i  (rst_i),
                .data_i (L1din[CW * i +: CW]),
                .rd_en_i (L1rd_en[i]),
                .wr_en_i (L1wr_en[i]),
                .data_o (L1dout[CW * i +: CW]),
                .empty_o(L1E[i]),
                .full_o (L1F[i])
            );
        end    
    endgenerate
    
    // L2 1x 2-1 fifo buffer signals
    wire L2E, L2F;
    wire L2rd_en;
    reg  L2wr_en;
    wire [CLAUSE_WIDTH - 1 : 0] L2dout;
    reg  [CLAUSE_WIDTH - 1 : 0] L2din;
    reg  L2src;
    
    // L2din MUX
    always @ (*) begin
        L2din <= L1rd_en_delay[0] ? L1dout[0 +: CW] : L1dout[CW +: CW];
    end
    
    FIFO_Buffer # (
        .DATA_WIDTH(CLAUSE_WIDTH),
        .BUFFER_ADDR_WIDTH($clog2(BUFFER_DEPTH))
    ) FIFO_last (
        .clk_i    (clk_i),
        .rst_i  (rst_i),
        .data_i (L2din),
        .rd_en_i (L2rd_en),
        .wr_en_i (L2wr_en),
        .data_o (L2dout),
        .empty_o(L2E),
        .full_o (L2F)
    );
    
    // controller logic    
    always @ (posedge clk_i) begin
        if (rst_i) begin
            L0src <= 0;
        end else if (wr_en_i) begin
            L0src <= 1;
        end else if (L0src < 5) begin
            L0src <= L0src + 1;
        end else begin
            L0src <= L0src;
        end
    end
        
    // L0 controls --------------------------------------------------
    always @ (posedge clk_i) begin
        L0rd_en_delay <= rst_i ? 0 : L0rd_en;
    end
    // L0 read and write enables
    // These signals are mostly combinational
    for (i = 0; i < 4; i = i + 1) begin
        assign L0wr_en[i] = wr_en_i ? clauses_valid_i[i * 5] :
            clauses_valid_i[i * 5 + L0src] & (L0src < 5);
    end
    
    for (i = 0; i < 2; i = i + 1) begin
        // read from L0 if 
        // 1. this buffer is not empty and
        // 2. if this buffer should be read or the other buffer is empty
        // This signal is combinationally generated but it uses L1src_delay
        // which is sequential.
        assign L0rd_en[i * 2]        = ~L0E[i * 2] && (L1src[i] ? L0E[i * 2 + 1] : 1);
        assign L0rd_en[i * 2 + 1]    = ~L0E[i * 2 + 1] && (L1src[i] ? 1 : L0E[i * 2]);
    end
    
    // L1 controls --------------------------------------------------
    always @ (posedge clk_i) begin
        if(rst_i) begin
            L1src           <= 0;
            L1wr_en          <= 0;
            L1rd_en_delay    <= 0;
        end else begin
            L1rd_en_delay    <= L1rd_en;
            for (j = 0; j < 2; j = j + 1) begin
                // toggle L1src if the target fifo is not empty
                L1src[j]    <= L1src ^ (~L0E[L1src[j] ? j * 2 + 1 : j * 2]);
                // if L0rd_en was high for either src buffer then write to L1 next rising edge
                L1wr_en[j]   <= |L0rd_en[j * 2 +: 2];
            end 
        end
    end
    
    assign L1rd_en[0] = ~L1E[0] && (L2src ? L1E[1] : 1);
    assign L1rd_en[1] = ~L1E[1] && (L2src ? 1 : L1E[0]);
    
    // L2 controls --------------------------------------------------
    always @ (posedge clk_i) begin
        if(rst_i) begin
            L2src       <= 0;
            L2wr_en      <= 0;
        end else begin
            // toggle L2src if the target fifo is not empty
            L2src       <= L2src ^ (~L1E[~L2src]);
            // if L1rd_en was high for either src buffer then write to L2 next rising edge
            L2wr_en  <= |L1rd_en;
        end
    end
    
    assign L2rd_en   = rd_en_i;
    assign clause_o = L2dout;
    assign empty_o    = L2E;
    
    always @ (posedge clk_i) begin
        if (rst_i | cOF_i) begin
            OF_o <= 0;
        end else begin
            OF_o <= OF_o | (|(L0F & L0wr_en)) | (|(L1F & L1wr_en)) | (L2F & L2wr_en);
        end
end

endmodule