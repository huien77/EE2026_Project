`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2021 07:56:25 PM
// Design Name: 
// Module Name: simon_says
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


module simon_says(
    input clock,up,down,left,right,
    input [6:0] x,
    input [5:0] y,
    input [2:0] option,
    output reg [15:0] oled_simon
    );
    
    reg [1:0] m[0:4];
    wire [1:0] num;
    reg [1:0] in[0:4];
    reg rst = 0;
    reg print_flag = 0;
    reg [2:0] curr,curr1;
    reg [4:0] count,count1,check,rand_count,count2;
    reg yes,no;
    
    lfsr rand0(rand_count, rst, num);
    
    wire clk_500hz,clk_48hz,clk_2hz;
    
    clock_divider unit_clk500hz(clock,99999,clk_500hz);
    clock_divider unit_clk50hz(clock,1041666,clk_48hz);
    clock_divider unit_clk1hz(clock,24999999,clk_2hz);
    
    wire b0,b1,b2,b3;
    wire c0,c1,c2,c3;
    
    assign b0 = ((y == 5 || y == 21) && x >= 45 && x <= 49) ||
                ((x == 39 || x == 55) && y >= 11 && y <= 15) ||
                ((y == 6 || y == 20) && (x == 43 || x == 44 || x == 50 || x == 51)) ||
                ((y == 7 || y == 19) && (x == 42 || x == 52)) ||
                ((y == 8 || y == 18) && (x == 41 || x == 53)) ||
                ((y == 9 || y == 10 || y == 16 || y == 17) && (x == 40 || x == 54));
    
    assign b1 = ((y == 5 + 19 || y == 21 + 19) && x >= 45 - 24 && x <= 49 - 24) ||
                ((x == 39 - 24 || x == 55 - 24) && y >= 11 + 19 && y <= 15 + 19) ||
                ((y == 6 + 19 || y == 20 + 19) && (x == 43 - 24 || x == 44 - 24 || x == 50 - 24 || x == 51 - 24)) ||
                ((y == 7 + 19 || y == 19 + 19) && (x == 42 - 24 || x == 52 - 24)) ||
                ((y == 8 + 19 || y == 18 + 19) && (x == 41 - 24 || x == 53 - 24)) ||
                ((y == 9 + 19 || y == 10 + 19 || y == 16 + 19 || y == 17 + 19) && (x == 40 - 24 || x == 54 - 24));
    
    assign b2 = ((y == 5 + 19 || y == 21 + 19) && x >= 45 + 24 && x <= 49 + 24) ||
                ((x == 39 + 24 || x == 55 + 24) && y >= 11 + 19 && y <= 15 + 19) ||
                ((y == 6 + 19 || y == 20 + 19) && (x == 43 + 24 || x == 44 + 24 || x == 50 + 24 || x == 51 + 24)) ||
                ((y == 7 + 19 || y == 19 + 19) && (x == 42 + 24 || x == 52 + 24)) ||
                ((y == 8 + 19 || y == 18 + 19) && (x == 41 + 24 || x == 53 + 24)) ||
                ((y == 9 + 19 || y == 10 + 19 || y == 16 + 19 || y == 17 + 19) && (x == 40 + 24 || x == 54 + 24));
    
    assign b3 = ((y == 5 + 38 || y == 21 + 38) && x >= 45 && x <= 49) ||
                ((x == 39 || x == 55) && y >= 11 + 38 && y <= 15 + 38) ||
                ((y == 6 + 38 || y == 20 + 38) && (x == 43 || x == 44 || x == 50 || x == 51)) ||
                ((y == 7 + 38 || y == 19 + 38) && (x == 42 || x == 52)) ||
                ((y == 8 + 38 || y == 18 + 38) && (x == 41 || x == 53)) ||
                ((y == 9 + 38 || y == 10 + 38 || y == 16 + 38 || y == 17 + 38) && (x == 40 || x == 54));
                
    assign c0 = ((y == 6 || y == 20) && x >= 45 && x <= 49) ||
                ((y == 7 || y == 19) && x >= 43 && x <= 51) ||
                ((y == 8 || y == 18) && x >= 42 && x <= 52) ||
                ((y == 9 || y == 10 || y == 16 || y == 17) && x >= 41 && x <= 53) ||
                (y >= 11 && y <= 15 && x >= 40 && x <= 54);
                
    assign c1 = ((y == 6 + 19 || y == 20 + 19) && x >= 45 - 24 && x <= 49 - 24) ||
                ((y == 7 + 19 || y == 19 + 19) && x >= 43 - 24 && x <= 51 - 24) ||
                ((y == 8 + 19 || y == 18 + 19) && x >= 42 - 24 && x <= 52 - 24) ||
                ((y == 9 + 19 || y == 10 + 19 || y == 16 + 19 || y == 17 + 19) && x >= 41 - 24 && x <= 53 - 24) ||
                (y >= 11 + 19 && y <= 15 + 19 && x >= 40 - 24 && x <= 54 - 24);

    assign c2 = ((y == 6 + 19 || y == 20 + 19) && x >= 45 + 24 && x <= 49 + 24) ||
                ((y == 7 + 19 || y == 19 + 19) && x >= 43 + 24 && x <= 51 + 24) ||
                ((y == 8 + 19 || y == 18 + 19) && x >= 42 + 24 && x <= 52 + 24) ||
                ((y == 9 + 19 || y == 10 + 19 || y == 16 + 19 || y == 17 + 19) && x >= 41 + 24 && x <= 53 + 24) ||
                (y >= 11 + 19 && y <= 15 + 19 && x >= 40 + 24 && x <= 54 + 24);

    assign c3 = ((y == 6 + 38 || y == 20 + 38) && x >= 45 && x <= 49) ||
                ((y == 7 + 38 || y == 19 + 38) && x >= 43 && x <= 51) ||
                ((y == 8 + 38 || y == 18 + 38) && x >= 42 && x <= 52) ||
                ((y == 9 + 38 || y == 10 + 38 || y == 16 + 38 || y == 17 + 38) && x >= 41 && x <= 53) ||
                (y >= 11 + 38 && y <= 15 + 38 && x >= 40 && x <= 54);
                
 
    always @(posedge clk_2hz)
    begin
        rand_count <= rand_count + 1;
        
        if (print_flag == 0 && option == 4)
        begin  
            if (count <= 16)
                count <= count + 1;
        end
        
        else
            count <= 0;
            
        if ((yes == 1 || no == 1) && count2 <= 3)
            count2 <= count2 + 1;
            
        else
            count2 <= 0;
            
    end
    
    always @(posedge clock)
    begin
        oled_simon <= 16'hFFFF;
        
        if (yes == 1)
            oled_simon <= 16'h5EAE;
            
        if (no == 1)
            oled_simon <= 16'hD2CB;
    
        if (b0 || b1 || b2 || b3)
            oled_simon <= 0;
            
        if (c0 && curr == 1 && print_flag == 1)
            oled_simon <= 16'hF800;
            
        if (c1 && curr == 2 && print_flag == 1)
            oled_simon <= 16'h1FE0;
            
        if (c2 && curr == 3 && print_flag == 1)
            oled_simon <= 16'h027F;
            
        if (c3 && curr == 4 && print_flag == 1)
            oled_simon <= 16'hF7E0;
            
        if (c0 && curr1 == 1 && print_flag == 0)
            oled_simon <= 16'hF800;
            
        if (c1 && curr1 == 2 && print_flag == 0)
            oled_simon <= 16'h1FE0;
            
        if (c2 && curr1 == 3 && print_flag == 0)
            oled_simon <= 16'h027F;
            
        if (c3 && curr1 == 4 && print_flag == 0)
            oled_simon <= 16'hF7E0;
    end
    
    always @(posedge clock)
    begin
        if (option != 4)
            print_flag <= 0;
        
        if (print_flag == 0)
        begin
            case(count)
                1:  begin
                    m[0] = num;
                    curr1 <= m[0] + 1;
                    end
                3:  curr1 <= 0;
                4:  begin
                    m[1] = num;
                    curr1 <= m[1] + 1;
                    end
                6:  curr1 <= 0;
                7:  begin
                    m[2] = num;
                    curr1 <= m[2] + 1;
                    end
                9:  curr1 <= 0;
                10: begin
                    m[3] = num;
                    curr1 <= m[3] + 1;
                    end
                12: curr1 <= 0;
                13: begin
                    m[4] = num;
                    curr1 <= m[4] + 1;
                    end
                16: print_flag <= 1;
            endcase
        end
        
        else
        begin
            curr1 <= 0;
        end
        
        case(count1)
            1:  begin
                if (in[count1 - 1] == m[0])
                    check[count1 - 1] <= 1;
                end
            2:  begin
                if (in[count1 - 1] == m[1])
                    check[count1 - 1] <= 1;
                end
            3:  begin
                if (in[count1 - 1] == m[2])
                    check[count1 - 1] <= 1;
                end
            4:  begin
                if (in[count1 - 1] == m[3])
                    check[count1 - 1] <= 1;
                end
            5:  begin
                if (in[count1 - 1] == m[4])
                    check[count1 - 1] = 1;
                    
                if (check == 5'b11111)
                    yes = 1;
                
                else
                    no = 1;
                end
        endcase
        
        if (yes == 1 || no == 1)
        begin
            case(count2)
                3:  begin
                    yes = 0;
                    no = 0;
                    print_flag <= 0;
                    check <= 0;
                    end
            endcase
        end
    end
    
    always @(posedge clk_48hz)
    begin
        if (option != 4)
            curr <= 0;
            
        if (print_flag == 0)
        begin
            curr <= 0;
            count1 <= 0;
        end
            
        else
        begin
            if (up == 1)
            begin
                curr <= 1;
                in[count1] = 0;
                count1 <= count1 + 1;
            end
            
            if (left == 1)
            begin
                curr <= 2;
                in[count1] = 1;
                count1 <= count1 + 1;
            end
            
            if (right == 1)
            begin
                curr <= 3;
                in[count1] = 2;
                count1 <= count1 + 1;
            end
                
            if (down == 1)
            begin
                curr <= 4;
                in[count1] = 3;
                count1 <= count1 + 1;
            end
        end
    end
    
endmodule

module lfsr(
    input flag, rst,
    output [1:0] Q
    );
    
    reg [7:0] Q1 = 0;
    
    assign Q = Q1 % 4;
    
    always @(posedge flag, posedge rst)
    begin
        if (rst)
            Q1 <= 0;
        
        else
        begin
            Q1 <= {Q1[6:0],~(Q1[6]^Q1[7])};
        end
    end
    
endmodule