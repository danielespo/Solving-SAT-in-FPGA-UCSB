module BreakValueCounter #(
    parameter NUM_CLAUSES = 20,
    parameter NUM_ROWS = 3,
    parameter BREAK_VALUE_ADDRESS_WIDTH = clog2(NUM_CLAUSES);
)
(
    input                               clk,        // Clock signal
    input                               reset,      // Reset signal
    input [BREAK_VALUE_ADDRESS_WIDTH-1:0]    address,    // n-bit number to address the break value counter
    output reg [(BREAK_VALUE_ADDRESS_WIDTH+1)*2-1:0] break_value [NUM_BREAK_VALUES-1:0]    // break value output
);


endmodule