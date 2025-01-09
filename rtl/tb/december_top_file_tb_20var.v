// december_top_file_tb_20var.v
`timescale 1ns/1ps

module december_top_file_tb_20var;

   // ------------------------------------------------------------------------
   // 1) Override the solver’s parameters for a 20-variable scenario
   // ------------------------------------------------------------------------
   parameter NSAT                     = 3;      // still 3-literal clauses
   parameter NUM_VARIABLES            = 2048;     // <= We want exactly 20 variables
   parameter MAX_CLAUSE_MEMBERSHIP    = 20;     // can remain the same or larger
   parameter FIFO_DEPTH               = 32;     // typically the same or bigger
   parameter UNSAT_CLAUSE_BUFFER_DEPTH= 128;    // can reduce for small tests
   parameter CONTROLLER_SIGNAL_WIDTH  = 14;     // unchanged from your design

   localparam VARIABLE_ADDRESS_WIDTH  = $clog2(NUM_VARIABLES);  
   localparam LITERAL_ADDRESS_WIDTH   = VARIABLE_ADDRESS_WIDTH + 1;  
   localparam CLAUSE_WIDTH            = NSAT * 8; // each literal is 8 bits: [neg_bit, var_index(6:0)]

   // ------------------------------------------------------------------------
   // 2) Signals and references
   // ------------------------------------------------------------------------
   reg  clk_i;
   reg  rst_i;
   reg  start_i;
   wire done_signal;

   // The controller inside the solver sets these signals, we don't drive them:
   wire [CONTROLLER_SIGNAL_WIDTH - 1 : 0] control_signal_i;

   // Clock generation
   parameter CLK_PERIOD = 10;
   always #(CLK_PERIOD / 2) clk_i = ~clk_i;

   // ------------------------------------------------------------------------
   // 3) Instantiate the SAT solver top-level (december_top_file)
   // ------------------------------------------------------------------------
   december_top_file #(
       .NSAT(NSAT),
       .NUM_VARIABLES(NUM_VARIABLES),
       .MAX_CLAUSE_MEMBERSHIP(MAX_CLAUSE_MEMBERSHIP),
       .FIFO_DEPTH(FIFO_DEPTH),
       .UNSAT_CLAUSE_BUFFER_DEPTH(UNSAT_CLAUSE_BUFFER_DEPTH),
       .CONTROLLER_SIGNAL_WIDTH(CONTROLLER_SIGNAL_WIDTH)
   ) dut (
       .clk_i           (clk_i),
       .rst_i           (rst_i),
       .start_i         (start_i),
       .control_signal_i(control_signal_i),
       .done_signal     (done_signal)
   );

   // ------------------------------------------------------------------------
   // 4) Example: Hardcode a few clauses referencing variables in [0..19]
   // ------------------------------------------------------------------------
   reg [CLAUSE_WIDTH-1 : 0] test_clauses [0:4];  // A few sample clauses

   initial begin
       // Clause 0: (x3 OR NOT x0 OR x10)
       //   x3   => 0x03
       //  ~x0   => 0x80
       //   x10  => 0x0A
       test_clauses[0] = {8'h0A, 8'h80, 8'h03};

       // Clause 1: (NOT x7 OR x19 OR x1)
       //  ~x7   => 0x87
       //   x19  => 0x13  (19 decimal)
       //   x1   => 0x01
       test_clauses[1] = {8'h01, 8'h13, 8'h87};

       // Clause 2: (x2 OR x5 OR x11)
       test_clauses[2] = {8'h0B, 8'h05, 8'h02};

       // Clause 3: (x0 OR NOT x0 OR x7) 
       test_clauses[3] = {8'h07, 8'h80, 8'h00};

       // Clause 4: (NOT x19 OR NOT x18 OR x0)
       // 19 decimal => 0x13 => with neg_bit => 0x93
       // 18 decimal => 0x12 => with neg_bit => 0x92
       // x0 => 0x00
       test_clauses[4] = {8'h00, 8'h92, 8'h93};
   end

   // ------------------------------------------------------------------------
   // 5) Minimal tasks to load variable table + clause table
   // ------------------------------------------------------------------------
   task initialize_variable_table;
       integer i;
       begin
         $display("Initializing variable table with 0s ...");
         // If your solver needs explicit writes, do them here
         // Otherwise, this might be enough for the design’s default startup
       end
   endtask

   task load_clauses_into_clause_table;
       integer i;
       begin
           $display("Loading 5 test clauses into Clause_Table ...");
           // If your design supports AXI writes to Clause_Table, do it here.
           // This might be pseudo-code:
           /*
           force dut.clause_table.axi_wr_en_i = 1'b1;
           for (i = 0; i < 5; i = i + 1) begin
               force dut.clause_table.axi_wr_addr_i    = i;
               force dut.clause_table.axi_wr_clauses_i = test_clauses[i];
               @(posedge clk_i);
           end
           force dut.clause_table.axi_wr_en_i = 1'b0;
           */
       end
   endtask

   // ------------------------------------------------------------------------
   // 6) Test flow
   // ------------------------------------------------------------------------
   initial begin
       clk_i   = 0;
       rst_i   = 1;
       start_i = 0;

       // Deassert reset after a few cycles
       #(CLK_PERIOD*5);
       rst_i = 0;

       // Possibly wait a bit more
       #(CLK_PERIOD*5);

       // Initialize variable table if needed
       initialize_variable_table();
       #(CLK_PERIOD*5);

       // Load clauses
       load_clauses_into_clause_table();
       #(CLK_PERIOD*5);

       // Start the solver
       $display("Starting solver on 20-var problem ...");
       start_i = 1;
       @(posedge clk_i);
       start_i = 0;

       // If solver doesn't time out in 10000 cycles, we give up
       repeat(10000) begin
         @(posedge clk_i);
         if (done_signal) begin
           $display("Solver finished or reached done state!");
           // We'll do a final check in another block that waits on done_signal
           #10;
           $finish;
         end
       end

       $display("Timed out waiting for solver to finish.");
       $finish;
   end

   // ------------------------------------------------------------------------
   // 7) Read back final variable assignments and check clauses
   // ------------------------------------------------------------------------
   reg [NUM_VARIABLES-1:0] final_assignments;
   integer var_i, clause_i, lit_i;
   reg [7:0] literal;
   reg neg_bit;
   reg [6:0] var_index;
   reg clause_satisfied, literal_value;

   // Wait for done_signal, then do the clause check
   initial begin
       @(posedge done_signal);

       // 1) Read out final variable bits from the solver
       //    Adjust this path to match your solver’s actual signal name
       //    For example, if your solver cluster outputs 'vtc_value_bits' as a bus:
       for (var_i = 0; var_i < NUM_VARIABLES; var_i = var_i + 1) begin
           final_assignments[var_i] = dut.vtc_value_bits[var_i];
       end

       $display("\n--- SOLVER COMPLETED ---");
       $display("Final variable assignments:");
       for (var_i = 0; var_i < NUM_VARIABLES; var_i = var_i + 1) begin
           $display("  x%0d = %b", var_i, final_assignments[var_i]);
       end

       // 2) Check each clause in test_clauses
       for (clause_i = 0; clause_i < 5; clause_i = clause_i + 1) begin
           clause_satisfied = 1'b0;
           // Each clause has NSAT=3 literals
           for (lit_i = 0; lit_i < NSAT; lit_i = lit_i + 1) begin
               literal   = test_clauses[clause_i][lit_i*8 +: 8];
               neg_bit   = literal[7]; 
               var_index = literal[6:0];

               if (var_index >= NUM_VARIABLES) begin
                   $display("Warning: Clause %0d references var %0d out-of-range!",
                             clause_i, var_index);
               end

               // Evaluate literal: Value = (final_assignments[var_index] XOR neg_bit)
               literal_value = final_assignments[var_index] ^ neg_bit;

               if (literal_value == 1'b1) begin
                   clause_satisfied = 1'b1;
               end
           end // for lit_i

           if (clause_satisfied) begin
               $display("Clause %0d is SATISFIED", clause_i);
           end
           else begin
               $display("Clause %0d is NOT satisfied --> UNSAT", clause_i);
           end
       end // for clause_i

       $finish;
   end

   // ------------------------------------------------------------------------
   // 8) Optional wave dumps
   // ------------------------------------------------------------------------
   initial begin
       $dumpfile("december_top_file_tb_20var.vcd");
       $dumpvars(0, december_top_file_tb_20var);
   end

endmodule