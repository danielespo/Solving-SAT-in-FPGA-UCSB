`timescale 1ns/1ps

module kanazawa_solver_tb;

  parameter NSAT                    = 3;
  parameter NUM_VARIABLES           = 2048;
  parameter MAX_CLAUSE_MEMBERSHIP   = 20;
  parameter FIFO_DEPTH              = 32;
  parameter UNSAT_CLAUSE_BUFFER_DEPTH = 2048;
  parameter CONTROLLER_SIGNAL_WIDTH = 14;
  parameter MAX_FLIPS               = 32'h00FF_FFFF;
  
  localparam VARIABLE_ADDRESS_WIDTH = $clog2(NUM_VARIABLES);
  localparam LITERAL_ADDRESS_WIDTH  = VARIABLE_ADDRESS_WIDTH + 1;
  localparam CLAUSE_WIDTH           = NSAT * LITERAL_ADDRESS_WIDTH;
  localparam CT_WIDTH               = (LITERAL_ADDRESS_WIDTH * (NSAT - 1) * MAX_CLAUSE_MEMBERSHIP);

  reg clk = 0, rst = 0;
  reg cpu_start = 0, load_end = 0;
  wire cpu_done;
  
  // Clock generation.
  always #5 clk = ~clk;
  
  // Overlord load interface signals.
  reg att_load_valid;
  reg [LITERAL_ADDRESS_WIDTH:0] att_load_addr;
  reg [(VARIABLE_ADDRESS_WIDTH+MAX_CLAUSE_MEMBERSHIP)-1:0] att_load_data;
  
  reg ct_load_valid;
  reg [VARIABLE_ADDRESS_WIDTH-1:0] ct_load_addr;
  reg [CT_WIDTH-1:0] ct_load_data;
  
  reg ucb_load_valid;
  reg [$clog2(UNSAT_CLAUSE_BUFFER_DEPTH)-1:0] ucb_load_addr;
  reg [CLAUSE_WIDTH-1:0] ucb_load_data;
  
  // unsat_buffer_count comes from the datapath.
  wire [10:0] unsat_buffer_count;
  
  // Instantiate Overlord.
  Overlord #(
      .NSAT(NSAT),
      .NUM_VARIABLES(NUM_VARIABLES),
      .MAX_CLAUSE_MEMBERSHIP(MAX_CLAUSE_MEMBERSHIP),
      .FIFO_DEPTH(FIFO_DEPTH),
      .UNSAT_CLAUSE_BUFFER_DEPTH(UNSAT_CLAUSE_BUFFER_DEPTH),
      .CONTROLLER_SIGNAL_WIDTH(CONTROLLER_SIGNAL_WIDTH),
      .MAX_FLIPS(MAX_FLIPS)
  ) i_overlord (
      .clk(clk),
      .rst(rst),
      .cpu_start(cpu_start),
      .load_end(load_end),
      .att_load_valid(att_load_valid),
      .att_load_addr(att_load_addr),
      .att_load_data(att_load_data),
      .ct_load_valid(ct_load_valid),
      .ct_load_addr(ct_load_addr),
      .ct_load_data(ct_load_data),
      .ucb_load_valid(ucb_load_valid),
      .ucb_load_addr(ucb_load_addr),
      .ucb_load_data(ucb_load_data),
      .unsat_buffer_count(unsat_buffer_count),
      .cpu_done(cpu_done)
  );
  
  // Instantiate Datapath.
  Datapath #(
      .NSAT(NSAT),
      .NUM_VARIABLES(NUM_VARIABLES),
      .MAX_CLAUSE_MEMBERSHIP(MAX_CLAUSE_MEMBERSHIP),
      .FIFO_DEPTH(FIFO_DEPTH),
      .UNSAT_CLAUSE_BUFFER_DEPTH(UNSAT_CLAUSE_BUFFER_DEPTH),
      .CONTROLLER_SIGNAL_WIDTH(CONTROLLER_SIGNAL_WIDTH)
  ) i_datapath (
      .clk_i(clk),
      .rst_i(rst),
      .control_signal_i(),  // Not required for this testbench
      .att_wr_en_i(),       
      .att_wr_addr_i(),     
      .att_wr_data_i(),     
      .ct_wr_en_i(),        
      .ct_wr_addr_i(),      
      .ct_wr_data_i(),      
      .ucb_setup_wr_en_i(), 
      .ucb_setup_addr_i(),  
      .ucb_setup_data_i(),  
      .ucb_setup_i(),       
      .unsat_buffer_count_o(unsat_buffer_count)
  );
  
  // Memory for clause table.
  reg [31:0] memfile_data [0:2047];
  
  // Task: load clause table data into ct memory.
  task load_clause_table_from_mem(input reg [8*128-1:0] memfilename);
    integer j;
    begin
      $display("Loading Clause Table from %0s ...", memfilename);
      $readmemh(memfilename, memfile_data);
      // Allow some cycles before starting.
      repeat(5) @(negedge clk);
      for (j = 0; j < 2048; j = j + 1) begin
         ct_load_valid = 1'b1;
         ct_load_addr  = j[VARIABLE_ADDRESS_WIDTH-1:0];
         ct_load_data  = memfile_data[j];
         @(negedge clk);
      end
      ct_load_valid = 1'b0;
      @(negedge clk);
    end
  endtask
  
  // Task: signal end of load for current thread.
  task do_load_end;
    begin
      load_end = 1'b1;
      @(negedge clk);
      load_end = 1'b0;
      @(negedge clk);
    end
  endtask
  
  // Task: reset the system.
  task do_reset;
    begin
      rst          = 1;
      cpu_start    = 0;
      load_end     = 0;
      ct_load_valid = 0;
      att_load_valid = 0;
      ucb_load_valid = 0;
      repeat(2) @(negedge clk);
      rst = 0;
    end
  endtask
  
  integer i;
  initial begin
    // Initialize load interface signals.
    ct_load_valid  = 0; ct_load_addr  = 0; ct_load_data  = 0;
    att_load_valid = 0; att_load_addr = 0; att_load_data = 0;
    ucb_load_valid = 0; ucb_load_addr = 0; ucb_load_data = 0;
    
    do_reset;
    
    // Load each thread serially.
    for (i = 0; i < 4; i = i + 1) begin
      $display("\n=== LOADING clause table for thread %0d ===", i);
      load_clause_table_from_mem("/home/harim_choe/Solving-SAT-in-FPGA-UCSB/rtl/mem/minunsat.mem");
      // (Similarly, other memories can be loaded here.)
      do_load_end;
    end
    
    // Start the solver.
    $display("=== START solver for minunsat (UNSAT) ===");
    cpu_start = 1'b1;
    @(negedge clk);
    cpu_start = 1'b0;
    
    // Wait until the Overlord signals completion.
    wait(cpu_done);
    $display("Solver done for minunsat. unsat_buffer_count=%0d", unsat_buffer_count);
    if (unsat_buffer_count === 0)
      $display("SUCCESS: UNSAT problem did not reach 0 unsatisfied clauses after %0d flips.", MAX_FLIPS);
    else
      $display("ERROR: UNSAT problem unexpectedly reached 0 unsatisfied clauses.");
      
    do_reset;
    
    // Load SAT problem (e.g., 4_queens) for each thread.
    for (i = 0; i < 4; i = i + 1) begin
      $display("\n=== LOADING clause table for thread %0d (4_queens) ===", i);
      load_clause_table_from_mem("/home/harim_choe/Solving-SAT-in-FPGA-UCSB/rtl/mem/4_queens.mem");
      do_load_end;
    end
    
    $display("=== START solver for 4_queens (SAT) ===");
    cpu_start = 1'b1;
    @(negedge clk);
    cpu_start = 1'b0;
    
    wait(cpu_done);
    $display("Solver done for 4_queens. unsat_buffer_count=%0d", unsat_buffer_count);
    if (unsat_buffer_count === 0)
      $display("SUCCESS: 4_queens is SAT and the solver found a satisfying assignment.");
    else
      $display("ERROR: 4_queens ended with %0d unsatisfied clauses.", unsat_buffer_count);
    
    $display("\nAll tests complete. Finishing simulation...");
    $finish;
  end

endmodule