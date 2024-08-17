/*
Parallel_to_Serial.v
Author: Zeiler Randall-Reed

Description:
This module contains the implementation of a parallel to serial converter. It consists
of a small buffer that stores the data from the parallel inputs and outputs the data
one by one in subsequent clock cycles. 

This module starts outputting data in the same clock cycle that the write signal is high. 
It also outputs data in the subsequent clock cycles until all the data in the buffer has 
been output. There is no read_enable signal for this module as it merely outputs the data
in the buffer one by one. 

The module does have a data_valid signal that is high when there is data to output and low
when there is no data to output. It also accepts data_valid signals for each of the parallel 
inputs and only stores parallel data when the data_valid signal is high.

Notes:
- this is a parallel to serial converter that is fully parameterized and is not specific to 
    this project. The default parameters are set so it can be used in FIFO_Tree.v

Testing:
- this module is simple enough that its functionality should be apparent during tests for 
    the FIFO tree
*/

module Parallel_to_Serial #(
    parameter DATA_WIDTH = 36,
    parameter NUM_PARALLEL = 5,
    parameter BITS_PARALLEL = $clog2(NUM_PARALLEL)
)(
    input                       clk,            // Clock signal
    input                       reset,          // Reset signal
    input [DATA_WIDTH-1:0]      data_i          [NUM_PARALLEL-1:0], // Data input
    input                       data_valid_i    [NUM_PARALLEL-1:0], // Data input valid flag
    input                       write_en_i,     // Write signal
    
    output reg [DATA_WIDTH-1:0] data_o,         // Data output
    output reg                  data_valid_o    // Data output valid flag
);

integer i;

reg [DATA_WIDTH-1:0] buffer [NUM_PARALLEL-1:0];
reg [BITS_PARALLEL-1:0] counter, write_counter;

always @ (posedge clk) begin
    if (reset) begin
        for (i = 0; i < NUM_PARALLEL; i = i + 1) begin
            buffer[i] <= 0;
        end
        counter <= 0;
    end else begin
        counter <= 0;
        write_counter <= 0;
        if (write_en_i) begin               // when write enable is high, 
            counter <= 0;                   // reset counter
            write_counter <= 0;             // reset write counter
            for (i = 0; i < NUM_PARALLEL; i = i + 1) begin
                if(data_valid_i[i]) begin   // if the data is valid
                    buffer[write_counter] <= data_i[i]; // input data to the buffer
                    write_counter <= write_counter + 1; // increment write counter
                end
            end
            data_valid_o <= 1;              // signal that there is data to output
            data_o <= buffer[0];            // output the first data in the buffer
            counter <= counter + 1;         // increment counter
        end else if (counter <= NUM_PARALLEL) begin     // if the counter has not reached the end of the buffer
            data_valid_o <= 1;                          // signal that there is data to output
            data_o <= buffer[counter];                  // output the data at the counter index
            counter <= counter + 1;                     // increment counter
        end else begin                      // when the counter has reached the end of the buffer
            data_valid_o <= 0;              // signal that there is no data to output
        end
    end
end


endmodule


