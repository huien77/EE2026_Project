`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2021 03:30:08 PM
// Design Name: 
// Module Name: main_menu
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


module main_menu(
    input CLOCK, left, right, confirm, SW1,
    input [12:0] pixel_index,
    output [15:0] oled_data,
    output reg [3:0] task_id = 0
    );
    
    // Clock divider
    wire clk_48hz, clk_6p25mhz;
    clock_divider unit_clk48hz(CLOCK, 1041666, clk_48hz);
    clock_divider unit_clk6p25mhz(CLOCK, 7, clk_6p25mhz);
    
    // Variable to store current screen of menu
    reg [1:0] menu_id = 0;
    
    // Import BRAM images
    reg [15:0] menu1[6143:0];
    reg [15:0] menu2[6143:0];
    reg [15:0] menu3[6143:0];
    reg [15:0] menu4[6143:0];
    
    initial begin
        $readmemh("menu1.mem", menu1);
        $readmemh("menu2.mem", menu2);
        $readmemh("menu3.mem", menu3);
        $readmemh("menu4.mem", menu4);
    end
    
    always @ (posedge clk_48hz)
    begin
        // Hard Reset to Menu Screen when Switch 1 is flicked on
        // Turn off Switch 1 to resume operations
        if (SW1 == 1)
            task_id <= 0; 
        
        // Change task_id based on confirmation button
        if (confirm == 1)
            task_id <= menu_id + 2;
        
        if (task_id == 0)
        begin
            // Navigate between the different menus
            if (left == 1)
                menu_id <= menu_id - 1;
            if (right == 1)
                menu_id <= menu_id + 1;          
        end
    end
    
    // Assigning Menu Display to the OLED   
    assign oled_data = (menu_id == 0) ? menu1[pixel_index] :
                       (menu_id == 1) ? menu2[pixel_index] :
                       (menu_id == 2) ? menu3[pixel_index] :
                        menu4[pixel_index];
    
endmodule
