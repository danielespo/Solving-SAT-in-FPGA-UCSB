/*
Version: 2.0
FIFO_Buffer.v

V1.0 Author: Zeiler Randall-Reed
V2.0 Author: Barry Wang

Description:
This module contains the implementation of a single FIFO buffer used in the FIFO tree. 
The buffer is implemented as a circular buffer with a power of 2 size. It supports r/w
and concurrent rw operations.

If the buffer is full, write operations are ignored. If the buffer is empty, read 
operations are ignored. The user is responsible for checking the full and empty flags
before performing non concurrent read and writes. Concurrent rw is always valid. An
invalid r/w is considered to be UB.

Notes:
- if, during testing, data is being lost in the FIFO tree, it is possible that the
    buffers are full and the data is being ignored. This can be fixed by increasing the 
    buffer size but Kanazawa's paper claims that a buffer size of 32 is sufficient.

Testing: 
- V1.0 tested with FIFO_Tree_tb.v
- V2.0 test passed
*/

module FIFO_Buffer #(
    parameter DATA_WIDTH = 36,
    parameter BUFFER_ADDR_WIDTH = 5
)(
    input                       clk_i,
    input                       rst_i,
    input      [DATA_WIDTH-1:0] data_i,
    input                       rd_en_i,
    input                       wr_en_i,
    output reg [DATA_WIDTH-1:0] data_o,
    output                      empty_o,
    output                      full_o
);
    
    reg [DATA_WIDTH - 1 : 0] buffer [0 : 2 ** BUFFER_ADDR_WIDTH - 1];
    reg [BUFFER_ADDR_WIDTH - 1 : 0] read_ptr, write_ptr, counter;
    
    assign empty_o  = (counter == 0);
    assign full_o   = (counter == (2 ** BUFFER_ADDR_WIDTH));
    
    always @ (posedge clk_i) begin
        if (rst_i) begin
            read_ptr  <= 0;
            write_ptr <= 0;
            counter   <= 0;
            data_o    <= 0;
            // $display("FIFO_Buffer Reset at time %0t", $time);
        end else if (wr_en_i && rd_en_i) begin
            buffer[write_ptr] <= data_i;
            data_o <= buffer[read_ptr];
            write_ptr <= write_ptr + 1;
            read_ptr  <= read_ptr + 1;
            // $display("FIFO_Buffer RW at time %0t: data_i=0x%0h, data_o=0x%0h", $time, data_i, data_o);
        end else begin
            if (wr_en_i && !full_o) begin
                buffer[write_ptr] <= data_i;
                write_ptr <= write_ptr + 1;
                counter <= counter + 1;
                // $display("FIFO_Buffer WRITE at time %0t: data_i=0x%0h, counter=%0d", $time, data_i, counter+1);
            end
            if (rd_en_i && !empty_o) begin
                data_o <= buffer[read_ptr];
                read_ptr <= read_ptr + 1;
                counter <= counter - 1;
                // $display("FIFO_Buffer READ at time %0t: data_o=0x%0h, counter=%0d", $time, data_o, counter-1);
            end
        end
    end

endmodule

