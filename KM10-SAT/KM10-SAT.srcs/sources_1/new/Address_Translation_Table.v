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
// Description: Translate address from clause register to clause_address width size
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: NEEDS TESTBENCH
// 
//////////////////////////////////////////////////////////////////////////////////

module Address_Translation_Table(
    input wire clk,
    input wire reset,
    input wire [5:0] index, // Input index to select an entry, assuming NvLog2 bits for variable number + 1 bit for negation
    output reg [10:0] address, // Output address field corresponding to the index (11b)
    output reg [19:0] mask // Output mask field corresponding to the index (20b)
);

parameter Nv = 32; // Number of variables
parameter NvLog2 = 5; // Log2(Nv), adjust based on Nv
parameter AT_SIZE = Nv * 2; // Twice the number of variables for negation bit

// Internal storage for the address and mask fields
reg [10:0] internal_address_field[0:AT_SIZE-1]; // 11 bits for address
reg [19:0] internal_mask_field[0:AT_SIZE-1]; // 20 bits for mask

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
        // On each clock cycle, update the output address and mask based on the input index
        address <= internal_address_field[index];
        mask <= internal_mask_field[index];
    end
end

endmodule