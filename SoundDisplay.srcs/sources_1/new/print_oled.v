`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.03.2021 15:52:53
// Design Name: 
// Module Name: print_oled
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


module print_oled(
    input SW15,SW14,SW13,SW12,SW11,SW1,clock,left,right,
    input [3:0] volume,
    input [6:0] x_coor,
    input [5:0] y_coor,
    output reg [15:0] oled_data
    );
    
    //SW15: select 1 or 3 pixel border
    //SW14: turn on or off border
    //SW13: change colour theme
    //SW12: show or hide volume bar
    //SW11: show or hide words
    
    reg [6:0] shift = 40;
    
    wire clk_48hz, clk_6p25mhz;
    
    clock_divider unit_clk_20khz(clock, 1041666, clk_48hz);
    clock_divider unit_clk_6p25mhz(clock, 7, clk_6p25mhz);
    
    always @(posedge clk_48hz)
    begin
        if (SW1 == 1)
            shift <= 40;
        
        if (left == 1 && shift != 0)
            shift <= shift - 1;
        
        if (right == 1 && shift != 80)
            shift <= shift + 1;
    end
    
    always @(posedge clk_6p25mhz)
    begin
        if (SW13 == 0)
        begin  //the original colour theme
            if (SW12 == 0)
            begin  //show volume bar                            
                if ((x_coor >= (43 + (shift - 40))) && (x_coor <= (52 + (shift - 40))))
                begin
                    if ((y_coor == 50 || y_coor == 51) && volume >= 0)  //bar 0
                        oled_data <= 16'h07E0;
                    else if ((y_coor == 47 || y_coor == 48) && volume >= 1)  //bar 1
                        oled_data <= 16'h07E0;
                    else if ((y_coor == 44 || y_coor == 45) && volume >= 2)  //bar 2
                        oled_data <= 16'h07E0;
                    else if ((y_coor == 41 || y_coor == 42) && volume >= 3)  //bar 3
                        oled_data <= 16'h07E0;
                    else if ((y_coor == 38 || y_coor == 39) && volume >= 4)  //bar 4
                        oled_data <= 16'h07E0;
                    else if ((y_coor == 35 || y_coor == 36) && volume >= 5)  //bar 5
                        oled_data <= 16'h07E0;
                    else if ((y_coor == 32 || y_coor == 33) && volume >= 6)  //bar 6
                        oled_data <= 16'hFFE0;
                    else if ((y_coor == 29 || y_coor == 30) && volume >= 7)  //bar 7
                        oled_data <= 16'hFFE0;
                    else if ((y_coor == 26 || y_coor == 27) && volume >= 8)  //bar 8
                        oled_data <= 16'hFFE0;
                    else if ((y_coor == 23 || y_coor == 24) && volume >= 9)  //bar 9
                        oled_data <= 16'hFFE0;
                    else if ((y_coor == 20 || y_coor == 21) && volume >= 10)  //bar 10
                        oled_data <= 16'hFFE0;
                    else if ((y_coor == 17 || y_coor == 18) && volume >= 11)  //bar 11
                        oled_data <= 16'hF800;
                    else if ((y_coor == 14 || y_coor == 15) && volume >= 12)  //bar 12
                        oled_data <= 16'hF800;
                    else if ((y_coor == 11 || y_coor == 12) && volume >= 13)  //bar 13
                        oled_data <= 16'hF800;
                    else if ((y_coor == 8 || y_coor == 9) && volume >= 14)  //bar 14
                        oled_data <= 16'hF800;
                    else if ((y_coor == 5 || y_coor == 6) && volume == 15)  //bar 15
                        oled_data <= 16'hF800;
                    else
                        oled_data <= 0;
                end
                
                else
                    oled_data <= 0;
                    
                if (SW14 == 0)
                begin  //show border
                    if (SW15 == 0)  //1 pixel border
                    begin
                        if (x_coor == 0 || x_coor == 95 || y_coor == 0 || y_coor == 63)
                            oled_data <= 16'hFFFF;
                    end
                    
                    else
                    begin  //3 pixel border
                        if (x_coor <= 2 || x_coor >= 93 || y_coor <= 2 || y_coor >= 61)
                            oled_data <= 16'hFFFF;
                    end
                end
                
                if (SW11 == 1)
                begin  //show words
                    if (y_coor == 53)
                    begin
                        if (x_coor == 29 || x_coor == 35 || (x_coor >= 37 && x_coor <= 41) || x_coor == 43 ||
                            x_coor == 49 || x_coor == 53 || x_coor == 55 || x_coor == 56 || x_coor == 60 ||
                            x_coor == 61 || (x_coor >= 63 && x_coor <= 67))
                            oled_data <= 16'hFFFF;
                    end
                    
                    else if (y_coor == 54)
                    begin
                        if (x_coor == 29 || x_coor == 30 || x_coor == 34 || x_coor == 35 || x_coor == 37 ||
                            x_coor == 41 || x_coor == 43 || x_coor == 49 || x_coor == 53 || x_coor == 55 ||
                            x_coor == 57 || x_coor == 59 || x_coor == 61 || x_coor == 63)
                            oled_data <= 16'hFFFF;
                    end
                    
                    else if (y_coor == 55)
                    begin
                        if (x_coor == 30 || x_coor == 34 || x_coor == 37 || x_coor == 41 || x_coor == 43 ||
                            x_coor == 49 || x_coor == 53 || x_coor == 55 || (x_coor >= 57 && x_coor <= 59) ||
                            x_coor == 61 || x_coor == 63)
                            oled_data <= 16'hFFFF;
                    end
                    
                    else if (y_coor == 56)
                    begin
                        if (x_coor == 30 || x_coor == 31 || x_coor == 33 || x_coor == 34 || x_coor == 37 ||
                            x_coor == 41 || x_coor == 43 || x_coor == 49 || x_coor == 53 || x_coor == 55 ||
                            x_coor == 61 || (x_coor >= 63 && x_coor <= 65))
                            oled_data <= 16'hFFFF;
                    end
                    
                    else if (y_coor == 57)
                    begin
                        if (x_coor == 31 || x_coor == 33 || x_coor == 37 || x_coor == 41 || x_coor == 43 ||
                            x_coor == 49 || x_coor == 53 || x_coor == 55 || x_coor == 61 || x_coor == 63)
                            oled_data <= 16'hFFFF;
                    end
                    
                    else if (y_coor == 58)
                    begin
                        if ((x_coor >= 31 && x_coor <= 33) || x_coor == 37 || x_coor == 41 || x_coor == 43 ||
                            x_coor == 49 || x_coor == 53 || x_coor == 55 || x_coor == 61 || x_coor == 63)
                            oled_data <= 16'hFFFF;
                    end
                    
                    else if (y_coor == 59)
                    begin
                        if ((x_coor >= 31 && x_coor <= 33) || (x_coor >= 37 && x_coor <= 41) ||
                            (x_coor >= 43 && x_coor <= 47) || (x_coor >= 49 && x_coor <= 53) ||
                            x_coor == 55 || x_coor == 61 || (x_coor >= 63 && x_coor <= 67))
                            oled_data <= 16'hFFFF;
                    end
                end
            end
                    
            else
            begin  //hide volume bar
                if (SW14 == 0)
                begin  //show border
                    if (SW15 == 0)  //1 pixel border
                    begin
                        if (x_coor == 0 || x_coor == 95 || y_coor == 0 || y_coor == 63)
                            oled_data <= 16'hFFFF;
                        
                        else
                            oled_data <= 0;
                    end
                    
                    else
                    begin  //3 pixel border
                        if (x_coor <= 2 || x_coor >= 93 || y_coor <= 2 || y_coor >= 61)
                            oled_data <= 16'hFFFF;
                        else
                            oled_data <= 0;
                    end
                end
                
                else
                    oled_data <= 0; 
                
                if (SW11 == 1)
                begin  //show words
                    if (y_coor == 53)
                    begin
                        if (x_coor == 29 || x_coor == 35 || (x_coor >= 37 && x_coor <= 41) || x_coor == 43 ||
                            x_coor == 49 || x_coor == 53 || x_coor == 55 || x_coor == 56 || x_coor == 60 ||
                            x_coor == 61 || (x_coor >= 63 && x_coor <= 67))
                            oled_data <= 16'hFFFF;
                    end
                    
                    else if (y_coor == 54)
                    begin
                        if (x_coor == 29 || x_coor == 30 || x_coor == 34 || x_coor == 35 || x_coor == 37 ||
                            x_coor == 41 || x_coor == 43 || x_coor == 49 || x_coor == 53 || x_coor == 55 ||
                            x_coor == 57 || x_coor == 59 || x_coor == 61 || x_coor == 63)
                            oled_data <= 16'hFFFF;
                    end
                    
                    else if (y_coor == 55)
                    begin
                        if (x_coor == 30 || x_coor == 34 || x_coor == 37 || x_coor == 41 || x_coor == 43 ||
                            x_coor == 49 || x_coor == 53 || x_coor == 55 || (x_coor >= 57 && x_coor <= 59) ||
                            x_coor == 61 || x_coor == 63)
                            oled_data <= 16'hFFFF;
                    end
                    
                    else if (y_coor == 56)
                    begin
                        if (x_coor == 30 || x_coor == 31 || x_coor == 33 || x_coor == 34 || x_coor == 37 ||
                            x_coor == 41 || x_coor == 43 || x_coor == 49 || x_coor == 53 || x_coor == 55 ||
                            x_coor == 61 || (x_coor >= 63 && x_coor <= 65))
                            oled_data <= 16'hFFFF;
                    end
                    
                    else if (y_coor == 57)
                    begin
                        if (x_coor == 31 || x_coor == 33 || x_coor == 37 || x_coor == 41 || x_coor == 43 ||
                            x_coor == 49 || x_coor == 53 || x_coor == 55 || x_coor == 61 || x_coor == 63)
                            oled_data <= 16'hFFFF;
                    end
                    
                    else if (y_coor == 58)
                    begin
                        if ((x_coor >= 31 && x_coor <= 33) || x_coor == 37 || x_coor == 41 || x_coor == 43 ||
                            x_coor == 49 || x_coor == 53 || x_coor == 55 || x_coor == 61 || x_coor == 63)
                            oled_data <= 16'hFFFF;
                    end
                    
                    else if (y_coor == 59)
                    begin
                        if ((x_coor >= 31 && x_coor <= 33) || (x_coor >= 37 && x_coor <= 41) ||
                            (x_coor >= 43 && x_coor <= 47) || (x_coor >= 49 && x_coor <= 53) ||
                            x_coor == 55 || x_coor == 61 || (x_coor >= 63 && x_coor <= 67))
                            oled_data <= 16'hFFFF;
                    end
                end        
            end
        end
        
        else
        begin  //complementary colour theme
            if (SW12 == 0)
            begin  //show volume bar                            
                if ((x_coor >= (43 + (shift - 40))) && (x_coor <= (52 + (shift - 40))))
                begin
                    if ((y_coor == 50 || y_coor == 51) && volume <= 15)  //bar 0
                        oled_data <= 16'h4208;
                    else if ((y_coor == 47 || y_coor == 48) && volume <= 15 && volume >= 1)  //bar 1
                        oled_data <= 16'h4208;
                    else if ((y_coor == 44 || y_coor == 45) && volume <= 15 && volume >= 2)  //bar 2
                        oled_data <= 16'h4208;
                    else if ((y_coor == 41 || y_coor == 42) && volume <= 15 && volume >= 3)  //bar 3
                        oled_data <= 16'h4208;
                    else if ((y_coor == 38 || y_coor == 39) && volume <= 15 && volume >= 4)  //bar 4
                        oled_data <= 16'h4208;
                    else if ((y_coor == 35 || y_coor == 36) && volume <= 15 && volume >= 5)  //bar 5
                        oled_data <= 16'h4208;
                    else if ((y_coor == 32 || y_coor == 33) && volume <= 15 && volume >= 6)  //bar 6
                        oled_data <= 16'h02BF;
                    else if ((y_coor == 29 || y_coor == 30) && volume <= 15 && volume >= 7)  //bar 7
                        oled_data <= 16'h02BF;
                    else if ((y_coor == 26 || y_coor == 27) && volume <= 15 && volume >= 8)  //bar 8
                        oled_data <= 16'h02BF;
                    else if ((y_coor == 23 || y_coor == 24) && volume <= 15 && volume >= 9)  //bar 9
                        oled_data <= 16'h02BF;
                    else if ((y_coor == 20 || y_coor == 21) && volume <= 15 && volume >= 10)  //bar 10
                        oled_data <= 16'h02BF;
                    else if ((y_coor == 17 || y_coor == 18) && volume <= 15 && volume >= 11)  //bar 11
                        oled_data <= 16'hFA20;
                    else if ((y_coor == 14 || y_coor == 15) && volume <= 15 && volume >= 12)  //bar 12
                        oled_data <= 16'hFA20;
                    else if ((y_coor == 11 || y_coor == 12) && volume <= 15&& volume >= 13)  //bar 13
                        oled_data <= 16'hFA20;
                    else if ((y_coor == 8 || y_coor == 9) && volume <= 15 && volume >= 14)  //bar 14
                        oled_data <= 16'hFA20;
                    else if ((y_coor == 5 || y_coor == 6) && volume == 15)  //bar 15
                        oled_data <= 16'hFA20;
                    else
                        oled_data <= 16'hFFFF;
                end
                
                else
                    oled_data <= 16'hFFFF;
                    
                if (SW14 == 0)
                begin  //show border
                    if (SW15 == 0)  //1 pixel border
                    begin
                        if (x_coor == 0 || x_coor == 95 || y_coor == 0 || y_coor == 63)
                            oled_data <= 16'hF800;
                    end
                    
                    else
                    begin  //3 pixel border
                        if (x_coor <= 2 || x_coor >= 93 || y_coor <= 2 || y_coor >= 61)
                            oled_data <= 16'hF800;
                    end
                end
                
                if (SW11 == 1)
                begin  //show words
                    if (y_coor == 53)
                    begin
                        if (x_coor == 29 || x_coor == 35 || (x_coor >= 37 && x_coor <= 41) || x_coor == 43 ||
                            x_coor == 49 || x_coor == 53 || x_coor == 55 || x_coor == 56 || x_coor == 60 ||
                            x_coor == 61 || (x_coor >= 63 && x_coor <= 67))
                            oled_data <= 0;
                    end
                    
                    else if (y_coor == 54)
                    begin
                        if (x_coor == 29 || x_coor == 30 || x_coor == 34 || x_coor == 35 || x_coor == 37 ||
                            x_coor == 41 || x_coor == 43 || x_coor == 49 || x_coor == 53 || x_coor == 55 ||
                            x_coor == 57 || x_coor == 59 || x_coor == 61 || x_coor == 63)
                            oled_data <= 0;
                    end
                    
                    else if (y_coor == 55)
                    begin
                        if (x_coor == 30 || x_coor == 34 || x_coor == 37 || x_coor == 41 || x_coor == 43 ||
                            x_coor == 49 || x_coor == 53 || x_coor == 55 || (x_coor >= 57 && x_coor <= 59) ||
                            x_coor == 61 || x_coor == 63)
                            oled_data <= 0;
                    end
                    
                    else if (y_coor == 56)
                    begin
                        if (x_coor == 30 || x_coor == 31 || x_coor == 33 || x_coor == 34 || x_coor == 37 ||
                            x_coor == 41 || x_coor == 43 || x_coor == 49 || x_coor == 53 || x_coor == 55 ||
                            x_coor == 61 || (x_coor >= 63 && x_coor <= 65))
                            oled_data <= 0;
                    end
                    
                    else if (y_coor == 57)
                    begin
                        if (x_coor == 31 || x_coor == 33 || x_coor == 37 || x_coor == 41 || x_coor == 43 ||
                            x_coor == 49 || x_coor == 53 || x_coor == 55 || x_coor == 61 || x_coor == 63)
                            oled_data <= 0;
                    end
                    
                    else if (y_coor == 58)
                    begin
                        if ((x_coor >= 31 && x_coor <= 33) || x_coor == 37 || x_coor == 41 || x_coor == 43 ||
                            x_coor == 49 || x_coor == 53 || x_coor == 55 || x_coor == 61 || x_coor == 63)
                            oled_data <= 0;
                    end
                    
                    else if (y_coor == 59)
                    begin
                        if ((x_coor >= 31 && x_coor <= 33) || (x_coor >= 37 && x_coor <= 41) ||
                            (x_coor >= 43 && x_coor <= 47) || (x_coor >= 49 && x_coor <= 53) ||
                            x_coor == 55 || x_coor == 61 || (x_coor >= 63 && x_coor <= 67))
                            oled_data <= 0;
                    end
                end
            end
                    
            else
            begin  //hide volume bar
                if (SW14 == 0)
                begin  //show border
                    if (SW15 == 0)  //1 pixel border
                    begin
                        if (x_coor == 0 || x_coor == 95 || y_coor == 0 || y_coor == 63)
                            oled_data <= 16'hF800;
                        
                        else
                            oled_data <= 16'hFFFF;
                    end
                    
                    else
                    begin  //3 pixel border
                        if (x_coor <= 2 || x_coor >= 93 || y_coor <= 2 || y_coor >= 61)
                            oled_data <= 16'hF800;
                        else
                            oled_data <= 16'hFFFF;
                    end
                end
                
                else
                    oled_data <= 16'hFFFF;
                
                if (SW11 == 1)
                begin  //show words
                    if (y_coor == 53)
                    begin
                        if (x_coor == 29 || x_coor == 35 || (x_coor >= 37 && x_coor <= 41) || x_coor == 43 ||
                            x_coor == 49 || x_coor == 53 || x_coor == 55 || x_coor == 56 || x_coor == 60 ||
                            x_coor == 61 || (x_coor >= 63 && x_coor <= 67))
                            oled_data <= 0;
                    end
                    
                    else if (y_coor == 54)
                    begin
                        if (x_coor == 29 || x_coor == 30 || x_coor == 34 || x_coor == 35 || x_coor == 37 ||
                            x_coor == 41 || x_coor == 43 || x_coor == 49 || x_coor == 53 || x_coor == 55 ||
                            x_coor == 57 || x_coor == 59 || x_coor == 61 || x_coor == 63)
                            oled_data <= 0;
                    end
                    
                    else if (y_coor == 55)
                    begin
                        if (x_coor == 30 || x_coor == 34 || x_coor == 37 || x_coor == 41 || x_coor == 43 ||
                            x_coor == 49 || x_coor == 53 || x_coor == 55 || (x_coor >= 57 && x_coor <= 59) ||
                            x_coor == 61 || x_coor == 63)
                            oled_data <= 0;
                    end
                    
                    else if (y_coor == 56)
                    begin
                        if (x_coor == 30 || x_coor == 31 || x_coor == 33 || x_coor == 34 || x_coor == 37 ||
                            x_coor == 41 || x_coor == 43 || x_coor == 49 || x_coor == 53 || x_coor == 55 ||
                            x_coor == 61 || (x_coor >= 63 && x_coor <= 65))
                            oled_data <= 0;
                    end
                    
                    else if (y_coor == 57)
                    begin
                        if (x_coor == 31 || x_coor == 33 || x_coor == 37 || x_coor == 41 || x_coor == 43 ||
                            x_coor == 49 || x_coor == 53 || x_coor == 55 || x_coor == 61 || x_coor == 63)
                            oled_data <= 0;
                    end
                    
                    else if (y_coor == 58)
                    begin
                        if ((x_coor >= 31 && x_coor <= 33) || x_coor == 37 || x_coor == 41 || x_coor == 43 ||
                            x_coor == 49 || x_coor == 53 || x_coor == 55 || x_coor == 61 || x_coor == 63)
                            oled_data <= 0;
                    end
                    
                    else if (y_coor == 59)
                    begin
                        if ((x_coor >= 31 && x_coor <= 33) || (x_coor >= 37 && x_coor <= 41) ||
                            (x_coor >= 43 && x_coor <= 47) || (x_coor >= 49 && x_coor <= 53) ||
                            x_coor == 55 || x_coor == 61 || (x_coor >= 63 && x_coor <= 67))
                            oled_data <= 0;
                    end
                end        
            end
        end
    end
    
endmodule
