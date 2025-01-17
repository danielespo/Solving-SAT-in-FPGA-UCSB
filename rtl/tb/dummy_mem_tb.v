// Filename: tb_dummy_mem.v
`timescale 1ns/1ps

module dummy_mem_tb();

  reg clk;
  reg [2:0] addr;     // 3 bits for DEPTH=8
  reg read_en;
  wire [31:0] data_o;

  // Instantiate dummy memory
  dummy_mem #(
    .WIDTH(32),
    .DEPTH(8),
    .MEM_INIT_FILE("../mem/att_dummy.mem")  // match your .mem filename
  ) dut (
    .clk     (clk),
    .addr    (addr),
    .read_en (read_en),
    .data_o  (data_o)
  );

  // Clock gen
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Drive the signals
  initial begin
    read_en = 0;
    addr    = 3'b000;
    // Wait for memory to load
    #20;

    // read mem[0]
    read_en = 1;
    addr = 3'b000;  
    @(posedge clk);
    #1;

    // read mem[1]
    addr = 3'b001;
    @(posedge clk);
    #1;

    // read mem[2]
    addr = 3'b010;
    @(posedge clk);
    #1;

    // read mem[3]
    addr = 3'b011;
    @(posedge clk);
    #1;

    // read mem[4]
    addr = 3'b100;
    @(posedge clk);
    #1;

    // done
    $display("Done with dummy mem test!");
    $finish;
  end

endmodule