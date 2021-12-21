`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.03.2021 15:58:19
// Design Name: 
// Module Name: index_coordinate
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module index_coordinate(
    input [12:0] pixel_index,
    output [5:0] y,
    output [6:0] x
    );
    
    assign y = pixel_index / 96;
    assign x = pixel_index % 96;
    
endmodule
