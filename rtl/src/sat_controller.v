module sat_controller (
    input  wire         clk,
    input  wire         reset,
    // Handshake inputs from datapath modules
    input  wire         init_done,       // Initialization complete
    input  wire         eval_done,       // Evaluation done
    input  wire         fifo_empty,      // Unsatisfied clause FIFO empty
    input  wire         ce2_break,       // Clause Evaluator 2 result
    input  wire [1:0]   vfs_selected_in, // Flip decision from selector
    // Control outputs to drive the datapath
    output reg          ucs_request,     // Request unsatisfied clause
    output reg          temp_flip_en,    // Trigger temporary flip
    output reg          eval_en,         // Start evaluation
    output reg          flip_en,         // Commit flip
    output reg          fifo_rd_en,      // Pop clause from FIFO
    output reg          fifo_wr_en,      // Push new clauses into FIFO
    output reg          reinit,          // Signal new try when MAX_FLIPS reached
    output reg [1:0]    thread_sel,      // For multithreading (round-robin)
    output reg [1:0]    flip_decision,   // Captured flip decision
    // Extra datapath control signals:
    output reg          cr_wr_en,        // Clause register write enable
    output reg [1:0]    att_src,         // ATT source selector
    output reg          vt_addr_src,     // Variable table address source
    output reg          vt_en,           // Variable table enable
    output reg          vt_wr_en,        // Variable table write enable
    output reg [1:0]    vfs_wr_en,       // Flip selector write enable
    output reg          cflb_wr_en,      // Clause negated literals buffer write enable
    output reg [$clog2(3)-1:0] tb_wr_index, // Temporal buffer write index
    // NEW: Controller forces mode
    output reg          done
);
    //-------------------------------------------------------------------------
    // FSM States
    //-------------------------------------------------------------------------
    localparam STATE_INIT        = 4'd0;
    localparam STATE_CLAUSE_SEL  = 4'd1;
    localparam STATE_TEMP_FLIP   = 4'd2;
    localparam STATE_WAIT_TFLIP  = 4'd3;
    localparam STATE_EVALUATE    = 4'd4;
    localparam STATE_DECISION    = 4'd5;
    localparam STATE_FLIP        = 4'd6;
    localparam STATE_WAIT_FLIP   = 4'd7;
    localparam STATE_UPDATE      = 4'd8;
    localparam STATE_WAIT_UPDATE = 4'd9;
    localparam STATE_CHECK       = 4'd10;
    localparam STATE_TRY_REINIT  = 4'd11;
    localparam STATE_DONE        = 4'd12;
    
    //-------------------------------------------------------------------------
    // Pipeline Delay Parameters
    //-------------------------------------------------------------------------
    localparam TEMP_FLIP_DELAY = 3;
    localparam FLIP_DELAY      = 1;
    localparam UPDATE_DELAY    = 2;
    
    localparam MAX_FLIPS = 16'd65535;
    
    //-------------------------------------------------------------------------
    // State and Counter Registers
    //-------------------------------------------------------------------------
    reg [3:0] state, next_state;
    reg [3:0] pipe_counter;
    reg [15:0] flip_count;
    reg [15:0] try_count;

    reg done_reg;
    
    //-------------------------------------------------------------------------
    // Next-State Logic and Output Combinational Block
    //-------------------------------------------------------------------------
    always @(*) begin
        // Default assignments:
        next_state      = state;
        ucs_request     = 1'b0;
        temp_flip_en    = 1'b0;
        eval_en         = 1'b0;
        flip_en         = 1'b0;
        fifo_rd_en      = 1'b0;
        fifo_wr_en      = 1'b0;
        reinit          = 1'b0;
        done            = 1'b0;
        flip_decision   = 2'b00;
        thread_sel      = 2'b00;
        // Extra signals:
        cr_wr_en        = 1'b0;
        att_src         = 2'b00;
        vt_addr_src     = 1'b0;
        vt_en           = 1'b0;
        vt_wr_en        = 1'b0;
        vfs_wr_en       = 2'b00;
        cflb_wr_en      = 1'b0;
        tb_wr_index     = 0;
        // Default forced_mode: active (1) by default.
        done_reg     = 1'b1;
        
        case (state)
            STATE_INIT: begin
                if (init_done)
                    next_state = STATE_CLAUSE_SEL;
                else
                    next_state = STATE_INIT;
                // During INIT, force mode remains active.
                done_reg = 1'b1;
            end

            STATE_CLAUSE_SEL: begin
                ucs_request = 1'b1;
                fifo_rd_en  = 1'b1;
                cr_wr_en    = 1'b1;
                cflb_wr_en  = 1'b1;
                att_src     = 2'b00;
                next_state  = STATE_TEMP_FLIP;
                done_reg = 1'b1;  // Force clause selection.
            end

            STATE_TEMP_FLIP: begin
                temp_flip_en = 1'b1;
                tb_wr_index  = 0;
                next_state   = STATE_WAIT_TFLIP;
                done_reg  = 1'b1;  // Still forcing.
            end

            STATE_WAIT_TFLIP: begin
                if (pipe_counter == (TEMP_FLIP_DELAY - 1))
                    next_state = STATE_WAIT_TFLIP;
                else
                    next_state = STATE_EVALUATE;
                done_reg = 1'b1;
            end

            STATE_EVALUATE: begin
                eval_en = 1'b1;
                if (eval_done)
                    next_state = STATE_EVALUATE;
                else
                    next_state = STATE_DECISION;
                done_reg = 1'b1;
            end

            STATE_DECISION: begin
                flip_decision = vfs_selected_in;
                att_src       = vfs_selected_in;
                tb_wr_index   = vfs_selected_in;
                vfs_wr_en     = 2'b11;
                next_state    = STATE_FLIP;
                // At decision, clear forced_mode so the datapath would normally
                // select from its own sources.
                done_reg   = 1'b0;
            end

            STATE_FLIP: begin
                flip_en     = 1'b1;
                vt_addr_src = 1'b1;
                vt_en       = 1'b1;
                vt_wr_en    = 1'b1;
                next_state  = STATE_WAIT_FLIP;
                done_reg = 1'b0;
            end

            STATE_WAIT_FLIP: begin
                if (pipe_counter == (FLIP_DELAY - 1))
                    next_state = STATE_WAIT_FLIP;
                else
                    next_state = STATE_UPDATE;
                done_reg = 1'b0;
            end

            STATE_UPDATE: begin
                fifo_wr_en = 1'b1;
                next_state = STATE_WAIT_UPDATE;
                done_reg = 1'b0;
            end

            STATE_WAIT_UPDATE: begin
                if (pipe_counter == (UPDATE_DELAY - 1))
                    next_state = STATE_WAIT_UPDATE;
                else
                    next_state = STATE_CHECK;
                done_reg = 1'b0;
            end

            STATE_CHECK: begin
                if (flip_count >= MAX_FLIPS)
                    next_state = STATE_DONE;
                else
                    next_state = STATE_CLAUSE_SEL;
                done_reg = 1'b0;
            end

            STATE_TRY_REINIT: begin
                reinit = 1'b1;
                next_state = STATE_INIT;
                done_reg = 1'b1;  // Force reinitialization.
            end

            STATE_DONE: begin
                next_state = STATE_DONE;
                done_reg = 1'b1;
            end
            default: next_state = STATE_INIT;
        endcase
        done = done_reg;
    end

    //-------------------------------------------------------------------------
    // Sequential Logic: State, Pipeline, and Counters
    //-------------------------------------------------------------------------
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state        <= STATE_INIT;
            pipe_counter <= 4'd0;
            flip_count   <= 16'd0;
            try_count    <= 16'd0;
            thread_sel   <= 2'd0;
            flip_decision<= 2'd0;
            done_reg     <= 1'b0;
            $display("sat_controller: RESET at time %0t", $time);
        end else begin
            if (state != next_state)
                pipe_counter <= 4'd0;
            else
                pipe_counter <= pipe_counter + 1;
            state <= next_state;
            
            if (state == STATE_FLIP && next_state == STATE_WAIT_FLIP) begin
                flip_count <= flip_count + 1;
                $display("sat_controller: Flip committed; flip_count = %0d at time %0t", flip_count+1, $time);
            end
            
            if (state == STATE_CHECK && next_state == STATE_TRY_REINIT) begin
                flip_count <= 16'd0;
                try_count  <= try_count + 1;
                $display("sat_controller: MAX_FLIPS reached; reinitializing (try_count = %0d) at time %0t", try_count+1, $time);
            end
            
            if (state == STATE_UPDATE && next_state == STATE_WAIT_UPDATE) begin
                thread_sel <= thread_sel + 1;
                $display("sat_controller: FIFO update; thread_sel advanced to %0d at time %0t", thread_sel+1, $time);
            end

            if (state != next_state) begin
                $display("sat_controller: State transition from %0d to %0d at time %0t", state, next_state, $time);
            end

            $display("sat_controller: [Time=%0t] State=%0d, done_reg=%b, ucs_req=%b, temp_flip=%b, eval=%b, flip=%b, fifo_rd=%b, fifo_wr=%b, reinit=%b, done=%b, thread_sel=%b, flip_decision=%b, cr_wr_en=%b, att_src=%b, vt_addr_src=%b, vt_en=%b, vt_wr_en=%b, vfs_wr_en=%b, cflb_wr_en=%b, tb_wr_index=%b", 
                      $time, state, done_reg, ucs_request, temp_flip_en, eval_en, flip_en, fifo_rd_en, fifo_wr_en, reinit, done, thread_sel, flip_decision, cr_wr_en, att_src, vt_addr_src, vt_en, vt_wr_en, vfs_wr_en, cflb_wr_en, tb_wr_index);
        end
    end

endmodule