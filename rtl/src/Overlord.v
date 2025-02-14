module Controller #(
    parameter NSAT = 3,
    parameter NUM_VARIABLES = 2048,
    parameter MAX_CLAUSE_MEMBERSHIP = 20,
    parameter FIFO_DEPTH = 32,
    parameter UNSAT_CLAUSE_BUFFER_DEPTH = 2048,
    parameter CONTROLLER_SIGNAL_WIDTH = 14,
    parameter MAX_FLIPS = 32'h00FF_FFFF,
    parameter VARIABLE_ADDRESS_WIDTH = $clog2(NUM_VARIABLES),
    parameter LITERAL_ADDRESS_WIDTH = $clog2(NUM_VARIABLES)+1,
    parameter CT_WIDTH = (LITERAL_ADDRESS_WIDTH * (NSAT - 1) * MAX_CLAUSE_MEMBERSHIP)
) (
    input wire clk, 
    input wire rst,
    input wire start,

    input  wire [LITERAL_ADDRESS_WIDTH : 0]  att_load_addr_i,
    input  wire [(VARIABLE_ADDRESS_WIDTH + MAX_CLAUSE_MEMBERSHIP) - 1 : 0] att_load_data_i,
    input  wire att_load_valid_i,
    input  wire [VARIABLE_ADDRESS_WIDTH - 1 : 0] ct_load_addr_i,
    input  wire [CT_WIDTH - 1 : 0]              ct_load_data_i,
    input  wire ct_load_valid_i,
    input  wire [$clog2(UNSAT_CLAUSE_BUFFER_DEPTH) - 1 : 0] ucb_load_addr_i,
    input  wire [NSAT * LITERAL_ADDRESS_WIDTH - 1 : 0]      ucb_load_data_i,
    input  wire ucb_load_valid_i,
    input  wire [10:0] unsat_buffer_count_i,

    output reg [CONTROLLER_SIGNAL_WIDTH - 1:0] control_signal_o,
    output reg        att_wr_en_o,
    output reg [LITERAL_ADDRESS_WIDTH : 0] att_wr_addr_o,
    output reg [(VARIABLE_ADDRESS_WIDTH + MAX_CLAUSE_MEMBERSHIP) - 1 : 0] att_wr_data_o,
    output reg        ct_wr_en_o,
    output reg [VARIABLE_ADDRESS_WIDTH - 1 : 0] ct_wr_addr_o,
    output reg [CT_WIDTH - 1 : 0]              ct_wr_data_o,
    output reg        ucb_setup_wr_en_o,
    output reg [$clog2(UNSAT_CLAUSE_BUFFER_DEPTH) - 1 : 0] ucb_setup_addr_o,
    output reg [NSAT * LITERAL_ADDRESS_WIDTH - 1 : 0]      ucb_setup_data_o,
    output reg        ucb_setup_o,

    output reg done
);

localparam IDLE            = 4'd0,
           LOAD            = 4'd1,
        //    LOAD_CLAUSETAB  = 4'd2,
        //    LOAD_UCB        = 4'd3,
           SELECT_UNSAT    = 4'd2,
        //    WAIT_SELECT     = 4'd3,
           READ_CLAUSETAB  = 4'd3,
           READ_VARTAB     = 4'd4,
           EVAL_CLAUSE     = 4'd5,
           WAIT_EVAL       = 4'd6,
           GATHER_UNSAT    = 4'd7,
           WAIT_GATHER     = 4'd8,
           CHECK_SOL       = 4'd9,
           DONE            = 4'd10;

reg [3:0] state, next_state;
reg [31:0] att_load_count, ct_load_count, ucb_load_count;
reg [31:0] flip_count, next_flip_count;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state          <= IDLE;
        flip_count     <= 0;
        att_load_count <= 0;
        ct_load_count  <= 0;
        ucb_load_count <= 0;
    end else begin
        state      <= next_state;
        flip_count <= next_flip_count;
    end
end

always @(*) begin
    next_state       = state;
    next_flip_count  = flip_count;
    control_signal_o = {CONTROLLER_SIGNAL_WIDTH{1'b0}};
    done             = 1'b0;

    att_wr_en_o      = 1'b0;
    att_wr_addr_o    = { (LITERAL_ADDRESS_WIDTH+1){1'b0} };
    att_wr_data_o    = { (VARIABLE_ADDRESS_WIDTH + MAX_CLAUSE_MEMBERSHIP){1'b0} };

    ct_wr_en_o       = 1'b0;
    ct_wr_addr_o     = { VARIABLE_ADDRESS_WIDTH{1'b0} };
    ct_wr_data_o     = { CT_WIDTH{1'b0} };

    ucb_setup_wr_en_o = 1'b0;
    ucb_setup_addr_o  = { $clog2(UNSAT_CLAUSE_BUFFER_DEPTH){1'b0} };
    ucb_setup_data_o  = { (NSAT * LITERAL_ADDRESS_WIDTH){1'b0} };
    ucb_setup_o       = 1'b0;

    case (state)
      IDLE: begin
         if (start) begin
            next_state = LOAD;
            next_flip_count = 0;
         end
      end
      LOAD: begin
         if (att_load_valid_i) begin
            att_wr_en_o   = 1'b1;
            att_wr_addr_o = att_load_addr_i;
            att_wr_data_o = att_load_data_i;
         end
         else if (ct_load_valid_i) begin
            ct_wr_en_o   = 1'b1;
            ct_wr_addr_o = ct_load_addr_i;
            ct_wr_data_o = ct_load_data_i;
         end
         else if (ucb_load_valid_i) begin
            ucb_setup_o = 1'b1;
            ucb_setup_wr_en_o = 1'b1;
            ucb_setup_addr_o  = ucb_load_addr_i;
            ucb_setup_data_o  = ucb_load_data_i;
         end
         else begin
            next_state = SELECT_UNSAT;
         end
      end
 endmodule
