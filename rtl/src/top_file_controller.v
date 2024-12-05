/*
Version: 0.0
top_file_controller.v

V0.0 Author: Harim Choe

Description:
This is the controller for the datapath.v file 

Notes:
    A: Select unsatisfied clauses and read the address table
    B: Read clause table
    C: Read variable table
    D: Evaluate clause and store if unsatisfied
    E: Count the number of unsatisfied clauses
    F: Gather unsatisfied clauses
    G: Select unsatisfied clauses

    States:
        IDLE:
            Wait for the start signal
            No control signals
        LOAD:
            Initialize or load data
        SELECT_UNSAT_CLAUSES (Step A)
            cr_wr_en (CR_WR_EN_BIT): Set to 1 to write to the clause register
            ucs_request (UCS_REQUEST_BIT): Set to 1 to request an unsatisfied clause
        READ_CLAUSE_TABLE (Step B)
            att_src (ATT_SRC_BITS): Select which literal from the clause register to use. 2'b00 selects the first literal
        READ_VARIABLE_TABLE (Step C)
            vt_en (VT_EN_BIT): Enable the variable table
            vt_wr_en (VT_WR_EN_BIT): Set to 0 for read operation
            vt_addr_src (VT_ADDR_SRC_BIT): Select the address source for the variable table
        EVALUATE_CLAUSE (Step D)
            vfs_wr_en (VFS_WR_EN_BITS): Enable writing to the Variable Flip Selector. 2'b01 enables it
            cflb_wr_en (CFLB_WR_EN_BIT): Write enable for the Clause Negated Literals Buffer
        COUNT_UNSAT_CLAUSES (Step E)
            Counting might be an internal operation
        GATHER_UNSAT_CLAUSES (Step F)
            fifo_wr_en (FIFO_WR_EN_BIT): Enable writing unsatisfied clauses to the FIFO
        SELECT_UNSAT_CLAUSES_AGAIN (Step G)
            fifo_rd_en (FIFO_RD_EN_BIT): Enable reading clauses from the FIFO
        DONE
            done = 1'b1.

Change Log:
12/04/2024:
    Started working on the controller
*/

module top_file_controller #(
    parameter NSAT = 3,
    parameter NUM_VARIABLES = 2048,
    parameter MAX_CLAUSE_MEMBERSHIP = 20,
    parameter FIFO_DEPTH = 32,
    parameter UNSAT_CLAUSE_BUFFER_DEPTH = 2048,
    parameter CONTROLLER_SIGNAL_WIDTH = 14 // will change
) (
    input clk, 
    input rst,
    input start,
    output reg done,
    output reg [CONTROLLER_SIGNAL_WIDTH - 1:0] control_signal_o
);

localparam IDLE                      = 4'd0,
           LOAD                      = 4'd1,
           SELECT_UNSAT_CLAUSES      = 4'd2,  // Step A
           READ_CLAUSE_TABLE         = 4'd3,  // Step B
           READ_VARIABLE_TABLE       = 4'd4,  // Step C
           EVALUATE_CLAUSE           = 4'd5,  // Step D
           COUNT_UNSAT_CLAUSES       = 4'd6,  // Step E
           GATHER_UNSAT_CLAUSES      = 4'd7,  // Step F
           SELECT_UNSAT_CLAUSES_AGAIN= 4'd8,  // Step G
           DONE                      = 4'd9;

reg [3:0] state, next_state;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        done <= 1'b0;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    next_state = state;
    done = 1'b0;
    control_signal_o = {CONTROLLER_SIGNAL_WIDTH{1'b0}}; // Default all signals to 0

    case (state)
        IDLE: begin
            if (start) begin
                next_state = LOAD;
            end
        end
        LOAD: begin
            next_state = SELECT_UNSAT_CLAUSES;
        end
        SELECT_UNSAT_CLAUSES: begin // Step A
            control_signal_o[13] = 1'b1;   // CR_WR_EN_BIT
            control_signal_o[0] = 1'b1;    // UCS_REQUEST_BIT
            next_state = READ_CLAUSE_TABLE;
        end
        READ_CLAUSE_TABLE: begin // Step B
            control_signal_o[12:11] = 2'b00; // ATT_SRC_BITS
            next_state = READ_VARIABLE_TABLE;
        end
        READ_VARIABLE_TABLE: begin // Step C
            control_signal_o[9] = 1'b1;     // VT_EN_BIT
            control_signal_o[8] = 1'b0;     // VT_WR_EN_BIT
            control_signal_o[10] = 1'b0;    // VT_ADDR_SRC_BIT
            next_state = EVALUATE_CLAUSE;
        end
        EVALUATE_CLAUSE: begin // Step D
            control_signal_o[7:6] = 2'b01;  // VFS_WR_EN_BITS
            control_signal_o[5] = 1'b1;     // CFLB_WR_EN_BIT
            next_state = COUNT_UNSAT_CLAUSES;
        end
        COUNT_UNSAT_CLAUSES: begin // Step E
            control_signal_o[7:6] = 2'b00; // Low VFS_WR_EN_BITS
            next_state = GATHER_UNSAT_CLAUSES;
        end
        GATHER_UNSAT_CLAUSES: begin // Step F
            control_signal_o[2] = 1'b1;     // FIFO_WR_EN_BIT
            next_state = SELECT_UNSAT_CLAUSES_AGAIN;
        end
        SELECT_UNSAT_CLAUSES_AGAIN: begin // Step G
            control_signal_o[1] = 1'b1;     // FIFO_RD_EN_BIT
            next_state = DONE;
        end
        DONE: begin
            done = 1'b1;
            if (!start) begin
                next_state = IDLE;
            end
        end
        default: next_state = IDLE;
    endcase
end

endmodule