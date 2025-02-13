`timescale 1ns/1ps

module kanazawa_solver_tb;

  parameter NSAT                    = 3;
  parameter NUM_VARIABLES           = 2048;
  parameter MAX_CLAUSE_MEMBERSHIP   = 20;
  parameter FIFO_DEPTH              = 32;
  parameter UNSAT_CLAUSE_BUFFER_DEPTH = 2048;
  parameter CONTROLLER_SIGNAL_WIDTH = 14;
  parameter MAX_FLIPS = 32'h00FF_FFFF;
  
  localparam VARIABLE_ADDRESS_WIDTH = $clog2(NUM_VARIABLES);
  localparam LITERAL_ADDRESS_WIDTH  = VARIABLE_ADDRESS_WIDTH + 1;
  localparam CLAUSE_WIDTH           = NSAT * LITERAL_ADDRESS_WIDTH;
  localparam CT_WIDTH               = (LITERAL_ADDRESS_WIDTH * (NSAT - 1) * MAX_CLAUSE_MEMBERSHIP);

  reg clk = 0, rst = 0, start = 0;
  wire done;
  always #5 clk = ~clk;
  
  task do_reset;
    begin
      rst   = 1;
      start = 0;
      repeat(2) @(negedge clk);
      rst   = 0;
    end
  endtask
  
  wire [CONTROLLER_SIGNAL_WIDTH-1:0] control_signal_bus;
  wire [10:0] unsat_buffer_count_o;
  wire att_wr_en;
  wire [LITERAL_ADDRESS_WIDTH : 0] att_wr_addr;
  wire [(VARIABLE_ADDRESS_WIDTH + MAX_CLAUSE_MEMBERSHIP)-1 : 0] att_wr_data;
  wire ct_wr_en;
  wire [VARIABLE_ADDRESS_WIDTH-1:0] ct_wr_addr;
  wire [CT_WIDTH - 1:0] ct_wr_data;
  wire ucb_setup_wr_en;
  wire [$clog2(UNSAT_CLAUSE_BUFFER_DEPTH)-1:0] ucb_setup_addr;
  wire [CLAUSE_WIDTH-1:0] ucb_setup_data;
  wire ucb_setup_mode;
  
  reg                                 att_load_valid_i;
  reg  [LITERAL_ADDRESS_WIDTH:0]      att_load_addr_i;
  reg  [(VARIABLE_ADDRESS_WIDTH + MAX_CLAUSE_MEMBERSHIP)-1:0] att_load_data_i;
  
  reg                                 ct_load_valid_i;
  reg  [VARIABLE_ADDRESS_WIDTH-1:0]   ct_load_addr_i;
  reg  [CT_WIDTH-1:0]                 ct_load_data_i;
  
  reg                                 ucb_load_valid_i;
  reg  [$clog2(UNSAT_CLAUSE_BUFFER_DEPTH)-1:0] ucb_load_addr_i;
  reg  [CLAUSE_WIDTH-1:0]             ucb_load_data_i;
  
  Controller #(
      .NSAT(NSAT),
      .NUM_VARIABLES(NUM_VARIABLES),
      .MAX_CLAUSE_MEMBERSHIP(MAX_CLAUSE_MEMBERSHIP),
      .FIFO_DEPTH(FIFO_DEPTH),
      .UNSAT_CLAUSE_BUFFER_DEPTH(UNSAT_CLAUSE_BUFFER_DEPTH),
      .CONTROLLER_SIGNAL_WIDTH(CONTROLLER_SIGNAL_WIDTH),
      .MAX_FLIPS(MAX_FLIPS)
  ) i_controller (
      .clk(clk),
      .rst(rst),
      .start(start),
      .unsat_buffer_count_i(unsat_buffer_count_o),
      .done(done),
      .control_signal_o(control_signal_bus),
  
      .att_load_valid_i  (att_load_valid_i),
      .att_load_addr_i   (att_load_addr_i),
      .att_load_data_i   (att_load_data_i),
  
      .ct_load_valid_i   (ct_load_valid_i),
      .ct_load_addr_i    (ct_load_addr_i),
      .ct_load_data_i    (ct_load_data_i),
  
      .ucb_load_valid_i  (ucb_load_valid_i),
      .ucb_load_addr_i   (ucb_load_addr_i),
      .ucb_load_data_i   (ucb_load_data_i),
  
      .att_wr_en_o(att_wr_en),
      .att_wr_addr_o(att_wr_addr),
      .att_wr_data_o(att_wr_data),
  
      .ct_wr_en_o(ct_wr_en),
      .ct_wr_addr_o(ct_wr_addr),
      .ct_wr_data_o(ct_wr_data),
  
      .ucb_setup_wr_en_o(ucb_setup_wr_en),
      .ucb_setup_addr_o(ucb_setup_addr),
      .ucb_setup_data_o(ucb_setup_data),
      .ucb_setup_o(ucb_setup_mode)
  );
  
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
      .control_signal_i(control_signal_bus),
  
      .att_wr_en_i(att_wr_en),
      .att_wr_addr_i(att_wr_addr),
      .att_wr_data_i(att_wr_data),
  
      .ct_wr_en_i(ct_wr_en),
      .ct_wr_addr_i(ct_wr_addr),
      .ct_wr_data_i(ct_wr_data),
  
      .ucb_setup_wr_en_i(ucb_setup_wr_en),
      .ucb_setup_addr_i(ucb_setup_addr),
      .ucb_setup_data_i(ucb_setup_data),
      .ucb_setup_i(ucb_setup_mode),
  
      .unsat_buffer_count_o(unsat_buffer_count_o)
  );
  
  reg [31:0] memfile_data [0:2047];
  
  task load_clause_table_from_mem(input reg [8*128-1:0] memfilename);
    integer j;
    begin
       $display("Loading Clause Table from %0s ...", memfilename);
       $readmemh(memfilename, memfile_data);
       repeat(5) @(negedge clk);
       for (j=0; j<2048; j=j+1) begin
          ct_load_valid_i = 1'b1;
          ct_load_addr_i  = j[VARIABLE_ADDRESS_WIDTH-1:0]; 
          ct_load_data_i  = memfile_data[j];
          @(negedge clk);
       end
       ct_load_valid_i = 1'b0;
       @(negedge clk);
    end
  endtask
  
  integer i;
  initial begin
    ct_load_valid_i   = 0; ct_load_addr_i = 0; ct_load_data_i = 0;
    att_load_valid_i  = 0; att_load_addr_i  = 0; att_load_data_i  = 0;
    ucb_load_valid_i  = 0; ucb_load_addr_i  = 0; ucb_load_data_i  = 0;
  
    do_reset;
    $display("\n=== LOAD minunsat.mem (UNSAT) ===");
    load_clause_table_from_mem("/home/harim_choe/Z_KSAT/rtl/mem/minunsat.mem");
  
    $display("=== START solver for minunsat (UNSAT) ===");
    start = 1'b1;
    @(negedge clk);
    start = 1'b0;
  
    wait(done);
    $display("Solver done for minunsat. unsat_buffer_count_o=%0d", unsat_buffer_count_o);
    if(unsat_buffer_count_o === 0)
      $display("SUCCESS: UNSAT problem did not reach 0 unsatisfied clauses after %0d flips (as expected).", MAX_FLIPS);
    else
      $display("ERROR: UNSAT problem unexpectedly reached 0 unsatisfied clauses.");
  
    do_reset;
    $display("\n=== LOAD 4_queens.mem (SAT) ===");
    load_clause_table_from_mem("/home/harim_choe/Z_KSAT/rtl/mem/4_queens.mem");
  
    $display("=== START solver for 4_queens (SAT) ===");
    start = 1'b1;
    @(negedge clk);
    start = 1'b0;
  
    wait(done);
    $display("Solver done for 4_queens. unsat_buffer_count_o=%0d", unsat_buffer_count_o);
    if(unsat_buffer_count_o === 0)
      $display("SUCCESS: 4_queens is SAT and the solver found a satisfying assignment.");
    else
      $display("ERROR: 4_queens ended with %0d unsatisfied clauses.", unsat_buffer_count_o);
  
    $display("\nAll tests complete. Finishing simulation...");
    $finish;
  end

endmodule