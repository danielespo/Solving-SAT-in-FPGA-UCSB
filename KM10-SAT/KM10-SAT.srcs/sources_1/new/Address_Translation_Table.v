`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UCSB
// Engineer: Dan Espinosa
// 
// Create Date: 03/11/2024 04:24:24 PM
// Design Name: 
// Module Name: AddressTranslationTable
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Translate address_o from clause register to clause_address width size
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Testbench made 05/02/2024 passed
// 
//////////////////////////////////////////////////////////////////////////////////

module Address_Translation_Table # (
    parameter MAX_CLAUSES_PER_VARIABLE = 20,
    parameter LITERAL_ADDRESS_WIDTH = 11,  
    parameter Nv = 32, // Number of variables
    parameter NvLog2 = 5, // Log2(Nv), adjust based on Nv
    parameter AT_SIZE = Nv * 2 // Twice the number of variables for negation bit
)(
    input wire clk,
    input wire reset,
    input wire [LITERAL_ADDRESS_WIDTH:0] index_i, // Input index_i to select an entry, assuming 11 bits for variable number + 1 bit for negation
    output reg [LITERAL_ADDRESS_WIDTH-1:0] address_o, // Output address_o field corresponding to the index_i (11b)
    output reg [MAX_CLAUSES_PER_VARIABLE:0] mask_o // Output mask_o field corresponding to the index_i (20b)
);



// Internal storage for the address_o and mask_o fields
reg [10:0] internal_address_field[0:AT_SIZE-1]; // 11 bits for address_o
reg [19:0] internal_mask_field[0:AT_SIZE-1]; // 20 bits for mask_o

// Loop variable
integer i;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // If we reset, all entries to default values
        for (i = 0; i < AT_SIZE; i = i + 1) begin
            internal_address_field[i] <= 11'b0; // 11 bits to 0
            internal_mask_field[i] <= 20'b0; // 20 bits to 0
        end
    end else begin
        // On each clock cycle, update the output address_o and mask_o based on the input index_i
        address_o <= internal_address_field[index_i];
        mask_o <= internal_mask_field[index_i];
    end
end

endmodule