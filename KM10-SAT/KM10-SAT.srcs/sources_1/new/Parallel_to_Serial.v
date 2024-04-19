module Parallel_to_Serial #(
    parameter DATA_WIDTH = 36,
    parameter NUM_PARALLEL = 5,
    parameter BITS_PARALLEL = $clog2(NUM_PARALLEL)
)(
    input                       clk,            // Clock signal
    input                       reset,          // Reset signal
    input [DATA_WIDTH-1:0]      data_i [NUM_PARALLEL-1:0],  // Data input
    input                       write_en_i,     // Write signal
    
    output reg [DATA_WIDTH-1:0] data_o          // Data output
    output reg                  data_valid_o    // Data valid flag
)

reg [DATA_WIDTH-1:0] buffer [NUM_PARALLEL-1:0];
reg [BITS_PARALLEL-1:0] counter;

always @ (posedge clk) begin
    if (reset) begin
        for (int i = 0; i < NUM_PARALLEL; i = i + 1) begin
            buffer[i] <= 0;
        end
        counter <= 0;
    end else begin
        if (write_en_i) begin
            counter <= 0;
            for (int i = 0; i < NUM_PARALLEL; i = i + 1) begin
                buffer[i] <= data_i[i];
            end
            data_valid_o <= 1;
            data_o <= buffer[0]
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


