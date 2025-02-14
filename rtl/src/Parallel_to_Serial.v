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
    parameter DATA_WIDTH    = 36,
    parameter NUM_PARALLEL  = 5,
    parameter BITS_PARALLEL = $clog2(NUM_PARALLEL)
)(
    input                                clk,             // Clock
    input                                reset,           // Reset
    // Flatten the two-dimensional data input into one dimension:
    input  [DATA_WIDTH*NUM_PARALLEL - 1:0] data_i,         // Flattened data input
    input  [NUM_PARALLEL-1:0]              data_valid_i,   // Valid bits
    input                                  write_en_i,     // Write signal

    output reg [DATA_WIDTH-1:0]           data_o,         // Data output
    output reg                            data_valid_o     // Data valid flag
);
    // Internally re-create data_i as a convenient 2D array:
    wire [DATA_WIDTH-1:0] data_i_array [0:NUM_PARALLEL-1];

    genvar g;
    generate
        for (g = 0; g < NUM_PARALLEL; g = g + 1) begin : UNPACK_DATA
            assign data_i_array[g] = data_i[g*DATA_WIDTH +: DATA_WIDTH];
        end
    endgenerate

    integer i;
    reg [DATA_WIDTH-1:0] buffer [NUM_PARALLEL-1:0];
    reg [BITS_PARALLEL-1:0] counter, write_counter;

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < NUM_PARALLEL; i = i + 1) begin
                buffer[i] <= {DATA_WIDTH{1'b0}};
            end
            counter       <= {BITS_PARALLEL{1'b0}};
            write_counter <= {BITS_PARALLEL{1'b0}};
            data_o        <= {DATA_WIDTH{1'b0}};
            data_valid_o  <= 1'b0;
        end else begin
            // Example logic showing how to use data_i_array:
            counter <= 0;
            write_counter <= 0;
            if (write_en_i) begin               
                counter <= 0;                   
                write_counter <= 0;             
                for (i = 0; i < NUM_PARALLEL; i = i + 1) begin
                    if (data_valid_i[i]) begin
                        // Reconstructed data_i_array[i]
                        buffer[write_counter] <= data_i_array[i]; 
                        write_counter <= write_counter + 1; 
                    end
                end
                data_valid_o <= 1;              
                data_o <= buffer[0];            
                counter <= counter + 1;         
            end else if (counter <= NUM_PARALLEL) begin
                data_valid_o <= 1;                          
                data_o <= buffer[counter];                  
                counter <= counter + 1;                     
            end else begin
                data_valid_o <= 0;              
            end
        end
    end

endmodule