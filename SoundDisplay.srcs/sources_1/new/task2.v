`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.03.2021 10:35:15
// Design Name: 
// Module Name: task2
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


module peak_algorithm(
    input [11:0] current,
    input CLOCK,
    output reg [11:0] peak
    );
    
    wire clk_20khz;
    clock_divider unit_clk_20khz(CLOCK, 2499, clk_20khz);
    reg [11:0] int_peak = 0;
    reg [31:0] COUNT = 0;
    
    always @ (posedge clk_20khz)
    begin       
        COUNT <= COUNT + 1;
        
        if (COUNT == 0)
            int_peak = 0;
        
        if (current > int_peak)
            int_peak <= current;
            
        if (COUNT == 1999) 
        begin
            peak <= int_peak;
            COUNT <= 0; 
        end
    end
    
endmodule

module light_up(
    input CLOCK,
    input [11:0] original, peak,
    input SW,
    output reg [15:0] led_config = 0
    );
    
    wire clk_10hz;
    clock_divider unit_clk_10hz(CLOCK, 4999999, clk_10hz);
    
    wire [11:0] mic_in;
    assign mic_in = (SW == 1) ? peak : original;
    
    always @ (posedge clk_10hz)
    begin
        if (mic_in >= 2048 && mic_in < 2176)
            led_config <= 16'b0000_0000_0000_0001;
        else if (mic_in >= 2176 && mic_in < 2304)
            led_config <= 16'b0000_0000_0000_0011;
        else if (mic_in >= 2304 && mic_in < 2432)
            led_config <= 16'b0000_0000_0000_0111;
        else if (mic_in >= 2432 && mic_in < 2560)
            led_config <= 16'b0000_0000_0000_1111;
        else if (mic_in >= 2560 && mic_in < 2688)
            led_config <= 16'b0000_0000_0001_1111;
        else if (mic_in >= 2688 && mic_in < 2816)
            led_config <= 16'b0000_0000_0011_1111;
        else if (mic_in >= 2816 && mic_in < 2944)
            led_config <= 16'b0000_0000_0111_1111;
        else if (mic_in >= 2944 && mic_in < 3072)
            led_config <= 16'b0000_0000_1111_1111;
        else if (mic_in >= 3072 && mic_in < 3200)
            led_config <= 16'b0000_0001_1111_1111;
        else if (mic_in >= 3200 && mic_in < 3328)
            led_config <= 16'b0000_0011_1111_1111;
        else if (mic_in >= 3328 && mic_in < 3456)
            led_config <= 16'b0000_0111_1111_1111;
        else if (mic_in >= 3456 && mic_in <= 3584)
            led_config <= 16'b0000_1111_1111_1111;
        else if (mic_in >= 3584 && mic_in <= 3712)
            led_config <= 16'b0001_1111_1111_1111;
        else if (mic_in >= 3712 && mic_in <= 3840)
            led_config <= 16'b0011_1111_1111_1111;
        else if (mic_in >= 3840 && mic_in <= 3968)
            led_config <= 16'b0111_1111_1111_1111;
        else if (mic_in >= 3968 && mic_in <= 4096)
            led_config <= 16'b1111_1111_1111_1111;
    end
    
endmodule

module seven_seg(
    input [11:0] peak,
    input SW,
    input CLOCK,
    output reg [3:0] an = 4'b1111,
    output reg [6:0] seg = 7'b1111111,
    output reg [3:0] volume = 0
    );
    
    wire clk_381hz, clk_10hz;
    clock_divider unit_clk_381hz(CLOCK, 146626, clk_381hz);
    clock_divider unit_clk_10hz(CLOCK, 4999999, clk_10hz);
    reg [1:0] COUNT = 0;
    
    // Volume will be updated once every 1s
    always @ (posedge clk_10hz)
    begin
        if (peak >= 2048 && peak < 2176)
            volume <= 0;
        else if (peak >= 2176 && peak < 2304)
            volume <= 1;
        else if (peak >= 2304 && peak < 2432)
            volume <= 2;
        else if (peak >= 2432 && peak < 2560)
            volume <= 3;
        else if (peak >= 2560 && peak < 2688)
            volume <= 4;
        else if (peak >= 2688 && peak < 2816)
            volume <= 5;
        else if (peak >= 2816 && peak < 2944)
            volume <= 6;
        else if (peak >= 2944 && peak < 3072)
            volume <= 7;
        else if (peak >= 3072 && peak < 3200)
            volume <= 8;
        else if (peak >= 3200 && peak < 3328)
            volume <= 9;
        else if (peak >= 3328 && peak < 3456)
            volume <= 10;
        else if (peak >= 3456 && peak <= 3584)
            volume <= 11;
        else if (peak >= 3584 && peak <= 3712)
            volume <= 12;
        else if (peak >= 3712 && peak <= 3840)
            volume <= 13;
        else if (peak >= 3840 && peak <= 3968)
            volume <= 14;
        else if (peak >= 3968 && peak <= 4096)
            volume <= 15;
    end
    
    always @ (posedge clk_381hz)
    begin
        COUNT <= COUNT + 1;
        case(COUNT)
            0: 
            begin
                if (SW == 1)
                begin
                    an <= 4'b1110;
                    if (volume >= 0 && volume <= 5)
                        seg <= 7'b1000111;                  // Prints 'L'
                    else if (volume >= 6 && volume <= 10)
                        seg <= 7'b1101010;                  // Prints 'M'
                    else if (volume >= 11 && volume <- 15)
                        seg <= 7'b0001001;                  // Prints 'H"
                end 
                else if (SW == 0)
                    an <= 4'b1111;
            end
            1:
            begin
                if (SW == 1)
                begin
                    an <= 4'b1101;
//                    if (volume >= 0 && volume <= 5)
//                        seg <= 7'b1000111;                  // Prints 'L'
                    if (volume >= 6 && volume <= 10)
                        seg <= 7'b1101010;                  // Prints 'M'
//                    else if (volume >= 11 && volume <- 15)
//                        seg <= 7'b0001001;                  // Prints 'H'
                end 
                else if (SW == 0)
                    an <= 4'b1111;       
            end
            2:
            begin
                if (SW == 1)
                begin
                    an <= 4'b1011;
                    if (volume == 0 || volume == 10)
                        seg <= 7'b1000000;                  // Prints '0'
                    else if (volume == 1 || volume == 11)
                        seg <= 7'b1111001;                  // Prints '1'
                    else if (volume == 2 || volume == 12)
                        seg <= 7'b0100100;                  // Prints '2'
                    else if (volume == 3 || volume == 13)
                        seg <= 7'b0110000;                  // Prints '3'
                    else if (volume == 4 || volume == 14)
                        seg <= 7'b0011001;                  // Prints '4'
                    else if (volume == 5 || volume == 15)
                        seg <= 7'b0010010;                  // Prints '5'
                    else if (volume == 6)
                        seg <= 7'b0000010;                  // Prints '6'
                    else if (volume == 7)
                        seg <= 7'b1111000;                  // Prints '7'
                    else if (volume == 8)
                        seg <= 7'b0000000;                  // Prints '8'
                    else if (volume == 9)
                        seg <= 7'b0010000;                  // Prints '9'
                end 
                else if (SW == 0)
                    an <= 4'b1111;
            end
            3:
            begin
                if (SW == 1)
                begin
                    an <= 4'b0111;
                    if (volume >= 0 && volume <= 9)
                        seg <= 7'b1111111;                  // Prints blank
                    else if (volume >= 10 && volume <= 15)
                        seg <= 7'b1111001;                  // Prints '1'
                end 
                else if (SW == 0)
                    an <= 4'b1111;
            end
        endcase
    end 
endmodule
