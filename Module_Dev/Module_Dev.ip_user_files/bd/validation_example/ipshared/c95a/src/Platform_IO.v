`timescale 1ns / 1ps

module Platform_IO # (
    parameter integer C_S_AXI_DATA_WIDTH        = 32,
    parameter integer READ_BUFFER_ADDR_WIDTH    = 7,
    parameter integer WRITE_BUFFER_ADDR_WIDTH   = 7
)
(
    // Reset
    input wire rst_i,
    // Global clock
    input  wire axi_aclk_i,
    // Output clk mode
    input  wire out_clk_mode_i,
    input  wire out_clk_val_i,
    output wire clk_o,
    
    // Write strobes. This signal indicates which byte lanes hold
        // valid data. There is one write strobe bit for each eight
        // bits of the write data bus.
    input  wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] wstrb,
    
    input  wire read_mode_i,
    input  wire read_capture_i,
    
    output wire [(2 ** WRITE_BUFFER_ADDR_WIDTH) * 8 - 1 : 0]  perph_o,
    input  wire [(2 ** READ_BUFFER_ADDR_WIDTH) * 8  - 1 : 0]  perph_i,
    
    input  wire output_buffer_wren_i,
    input  wire [C_S_AXI_DATA_WIDTH - 1: 0] axi_data_i,
    input  wire [C_S_AXI_DATA_WIDTH - 1: 0] axi_addr_i,
    output reg  [C_S_AXI_DATA_WIDTH - 1: 0] axi_read_buffer_o,
    output reg  [C_S_AXI_DATA_WIDTH - 1: 0] axi_write_buffer_o
);
    integer byte_index;
    genvar  byte_index_gen;
    
    reg [7:0] read_buffer  [2 ** READ_BUFFER_ADDR_WIDTH  - 1 : 0];
    reg [7:0] write_buffer [2 ** WRITE_BUFFER_ADDR_WIDTH - 1 : 0];
    
    wire [READ_BUFFER_ADDR_WIDTH - 1  : 0] read_addr;
    wire [WRITE_BUFFER_ADDR_WIDTH - 1 : 0] write_addr;
    assign read_addr = axi_addr_i[READ_BUFFER_ADDR_WIDTH - 1 : 0];
    assign write_addr = axi_addr_i[WRITE_BUFFER_ADDR_WIDTH - 1 : 0];
    
    // output clock generation
    assign clk_o = (axi_aclk_i & ~out_clk_mode_i) | (out_clk_val_i & out_clk_mode_i);
    
    // async axi read data output generation
    always @(*)
    begin
        if (read_mode_i == 1'b0)
          begin
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 ) 
              begin
                axi_read_buffer_o[byte_index*8 +: 8] <= perph_i[(read_addr + byte_index)*8 +: 8];
              end
          end
        else
          begin
            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 ) 
              begin
                axi_read_buffer_o[byte_index*8 +: 8] <= read_buffer[read_addr + byte_index];
              end
          end
    end
    
    // async axi write data output generation
    always @(*)
    begin
        for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 ) 
          begin
            axi_write_buffer_o[byte_index*8 +: 8] <= write_buffer[write_addr + byte_index];
          end
    end
    
    // read capture
    always @(posedge axi_aclk_i)
    begin
        if (rst_i == 1'b1)
          begin
            for (byte_index = 0; byte_index < (2**READ_BUFFER_ADDR_WIDTH); byte_index = byte_index + 1)
              begin
                read_buffer[byte_index] <= 0;
              end
          end
        else if (read_capture_i == 1'b1)
          begin
            for (byte_index = 0; byte_index < (2**READ_BUFFER_ADDR_WIDTH); byte_index = byte_index + 1)
              begin
                read_buffer[byte_index] <= perph_i[byte_index*8 +: 8];
              end
          end
    end
    
    // peripheral output generation
    for ( byte_index_gen = 0; byte_index_gen < (2**WRITE_BUFFER_ADDR_WIDTH); byte_index_gen = byte_index_gen + 1 )
      begin 
        assign perph_o[byte_index_gen*8 +: 8] = write_buffer[byte_index_gen];
      end
    
    // sync write to output buffer
    always @(posedge axi_aclk_i)
    begin
        if (rst_i == 1'b1)
          begin
            for (byte_index = 0; byte_index < (2**WRITE_BUFFER_ADDR_WIDTH); byte_index = byte_index + 1)
              begin
                write_buffer[byte_index] <= 0;
              end
          end
        else
          begin
            if (output_buffer_wren_i == 1'b1)
              begin
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( wstrb[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Buffer address axi_addr_i
                    write_buffer[write_addr + byte_index] <= axi_data_i[(byte_index*8) +: 8];
                  end  
              end
          end
    end

endmodule
