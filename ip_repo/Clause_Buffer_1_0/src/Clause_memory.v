`timescale 1ns / 1ps

module Clause_memory #
    (
        parameter integer CLAUSE_WIDTH = 36,
        parameter integer CLAUSE_DEPTH = 2048
    )
    (
        input wire clk_i,
        input wire rst_i,
        
        // axi side I/O
        input wire [$clog2(CLAUSE_DEPTH) - 1 : 0] data_address_i,
        input wire [31:0] data_low_i,
        input wire [31:0] data_high_i,
        input wire wren_low_i,
        input wire wren_high_i,
        output reg [31:0] data_low_o,
        output reg [31:0] data_high_o,
        
        // PL side I/O
        input wire [$clog2(CLAUSE_DEPTH) - 1 : 0] clause_address_i,
        input wire [CLAUSE_WIDTH  - 1 : 0] clause_i,
        input wire clause_wren_i,
        output reg [CLAUSE_WIDTH  - 1 : 0] clause_o
    );
    
    integer i;
    
    // clause memory
    reg [CLAUSE_WIDTH  - 1 : 0] clause_mem [0 : CLAUSE_DEPTH - 1];
    
    // axi side output generation
    always @(*)
    begin
        data_low_o  <= clause_mem[data_address_i][31:0];
        data_high_o <= clause_mem[data_address_i][CLAUSE_WIDTH - 1 : 32];
    end
    
    // PL side output generation
    always @(*)
    begin
        clause_o <= clause_mem[clause_address_i];
    end

    // input handling
    always @(posedge clk_i)
      begin
        if (rst_i)
          begin
            for (i = 0; i < CLAUSE_DEPTH; i = i + 1)
              begin
                clause_mem[i] <= 0;
              end
          end
        else
          begin
            if (wren_low_i | wren_high_i)
              begin
                // axi write lower
                if (wren_low_i)
                  begin
                    clause_mem[data_address_i][31:0] <= data_low_i;
                  end
                // axi write upper
                if (wren_high_i)
                  begin
                    clause_mem[data_address_i][CLAUSE_WIDTH - 1 : 32] <= data_high_i[CLAUSE_WIDTH - 33 : 0];
                  end
              end
            else
              begin
                // PL write
                if (clause_wren_i)
                  begin
                    clause_mem[clause_address_i] <= clause_i;
                  end
              end
          end
      end

endmodule
