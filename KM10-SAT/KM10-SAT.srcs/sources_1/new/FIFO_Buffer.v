/*
FIFO_Buffer.v

This module contains the implementation of a single FIFO buffer used in the FIFO tree. 
The buffer is implemented as a circular buffer with a fixed size. It supports read and
write operations. 

This buffer uses more logic than is necessary to avoid complications related to 
evaluating fullness with the read and write pointers. Instead, there is a counter that
keeps track of the number of elements in the buffer.

If the buffer is full, write operations are ignored. If the buffer is empty, read 
operations are ignored. No flags are set to indicate this, but the empty and full 
signals can be used to determine the state of the buffer.

NOTE: if, during testing, data is being lost in the FIFO tree, it is possible that the
buffers are full and the data is being ignored. This can be fixed by increasing the 
buffer size but Kanazawa's paper claims that a buffer size of 32 is sufficient.
*/

module FIFO_Buffer #(
    parameter DATA_WIDTH = 36
    parameter BUFFER_SIZE = 32
    parameter BUFFER_BITS = $clog2(BUFFER_SIZE)
)(
    input                       clk,            // Clock signal
    input                       reset,          // Reset signal
    input      [DATA_WIDTH-1:0] data_i,         // Data input
    input                       read_en_i,      // Read signal
    input                       write_en_i,     // Write signal
    
    output reg [DATA_WIDTH-1:0] data_o,         // Data output
    output                      data_valid_o,   // Data valid flag
    output                      empty_o,        // Empty flag
    output                      full_o,         // Full flag
)

/* Internal Signals 
 * buffer: register to store the data
 * > buffer[i] can be used to access the ith data
 * counter: register to store the number of data in the buffer
 * read_ptr: pointer to the next data to be read
 * write_ptr: pointer to the next data to be written
 * full: flag to indicate if the buffer is full
 * empty: flag to indicate if the buffer is empty
 */

reg [DATA_WIDTH-1:0] buffer [BUFFER_SIZE-1:0];
reg [BUFFER_BITS-1:0] read_ptr, write_ptr, counter;

assign empty_o = (counter == 0);
assign full_o = (counter == BUFFER_SIZE - 1);

// replaced all <= with = in the always block (non-blocking assignments with blocking assignments)
always @ (posedge clk) begin
    if (reset) begin
        for (int i = 0; i < BUFFER_SIZE; i = i + 1) begin
            buffer[i] = 0;
        end
        read_ptr = 0;
        write_ptr = 0;
        counter = 0;
        data_valid_o = 0;
    end else begin
        data_valid_o = 0;  // default: no data to output
        if (write_en_i && !full_o) begin    // if write enable is high and the buffer is not full
            buffer[write_ptr] = data_i;    // write the data to buffer at the write_ptr index
            write_ptr = write_ptr + 1;     // increment write_ptr
            counter = counter + 1;         // increment counter
        end
        if (read_en_i && !empty_o) begin    // if read enable is high and the buffer is not empty
            data_o = buffer[read_ptr];     // output the data at the read_ptr index
            data_valid_o = 1;              // signal that there is data to output
            read_ptr = read_ptr + 1;       // increment read_ptr
            counter = counter - 1;         // decrement counter
        end else if (read_en_i && empty_o) begin
            data_o = 0;                    // output 0 if the buffer is empty
            data_valid_o = 0;              // signal that there is no data to output
        end
    end
end


endmodule