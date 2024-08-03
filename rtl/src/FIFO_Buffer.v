/*
FIFO_Buffer.v
Author: Zeiler Randall-Reed
        Barry Wang

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
- this module is simple enough that its functionality is tested during the test of 
    the FIFO tree module
*/

module FIFO_Buffer #(
    parameter DATA_WIDTH = 36,
    parameter BUFFER_ADDR_WIDTH = 5
)(
    input                       clk,            // Clock signal
    input                       reset,          // Reset signal
    input      [DATA_WIDTH-1:0] data_i,         // Data input
    input                       read_en_i,      // Read signal
    input                       write_en_i,     // Write signal
    
    output reg [DATA_WIDTH-1:0] data_o,         // Data output
    output                      empty_o,        // Empty flag
    output                      full_o          // Full flag
);
    
    reg [DATA_WIDTH - 1 : 0] buffer [BUFFER_ADDR_WIDTH ** 2 - 1 : 0];
    reg [BUFFER_ADDR_WIDTH - 1 : 0] read_ptr, write_ptr, counter;
    
    // We require a power of 2 address space.
    assign empty_o  = |counter;
    assign full_o   = &counter;
    
    always @ (posedge clk) begin
        if (reset) begin
            read_ptr        <= 0;
            write_ptr       <= 0;
            counter         <= 0;
            data_o          <= 0;
        end else if (write_en_i && read_en_i) begin         // concurrent rw is always valid
            buffer[write_ptr]   <= data_i;
            data_o              <= buffer[read_ptr];
            write_ptr           <= write_ptr + 1;
            read_ptr            <= read_ptr + 1;
        end else begin
            if (write_en_i && !full_o) begin                // if write enable is high and the buffer is not full
                buffer[write_ptr]   <= data_i;              // write the data to buffer at the write_ptr index
                write_ptr           <= write_ptr + 1;       // increment write_ptr
                counter             <= counter + 1;         // increment counter
            end
            if (read_en_i && !empty_o) begin                // if read enable is high and the buffer is not empty
                data_o          <= buffer[read_ptr];        // output the data at the read_ptr index
                read_ptr        <= read_ptr + 1;            // increment read_ptr
                counter         <= counter - 1;             // decrement counter
            end
        end
    end


endmodule
