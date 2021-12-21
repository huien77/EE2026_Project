`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2021 08:11:52 PM
// Design Name: 
// Module Name: ultimate_TTT
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Simulates the game Ultimate Tic-Tac-Toe
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ultimate_TTT(
    input CLOCK, up, down, left, right, confirm, SW1,
    input [3:0] task_id,
    input [12:0] pixel_index,
    output reg [15:0] oled_data,
    output reg [3:0] an,
    output reg [6:0] seg
    );
    
    //Variables to represent the state of the board
    //There are two boards, one for each player representation
    reg [80:0] board0 = 0;
    reg [80:0] board1 = 0;
    reg [80:0] visited = 0;
    
    // Variable to keep track of indicator's position
    reg [6:0] current_pos = 0;
    
    // Variable to keep track of which person's turn it is
    reg player = 0;
    
    // Clock divider
    wire clk_48hz, clk_6p25mhz, clk_381hz, clk_4hz;
    clock_divider unit_clk48hz(CLOCK, 1041666, clk_48hz);
    clock_divider unit_clk6p25mhz(CLOCK, 7, clk_6p25mhz);
    clock_divider unit_clk381hz(CLOCK, 146627, clk_381hz);
    clock_divider unit_clk4hz(CLOCK, 12499999, clk_4hz);
    
    reg [8:0] win0 = 0;
    reg [8:0] win1 = 0;
    reg [8:0] win01 = 0;

    reg [4:0] whichCell = 9;
    reg continue = 0;
    
    // Delay before the game starts
    reg start = 0;
    reg [1:0] start_count = 0;
    always @ (posedge clk_4hz)
    begin
        if (SW1 == 1)
            start <= 0;
        if (task_id == 5)
            start_count <= start_count + 1;
        if (task_id == 5 && start_count == 3)
            start <= 1;
    end
    
    // Update Board and Visited
    always @ (posedge clk_48hz)
    begin
        if (SW1 == 1)
        begin
            board0 <= 0;
            board1 <= 0;
            visited <= 0;
            player <= 0;
            current_pos <= 0;
            continue <= 0;
            whichCell <= 9;
            win0 = 0;
            win1 = 0;
            win01 = 0;
        end
        if (task_id == 5 && start == 1)
        begin
            if (confirm == 1)
            begin
                visited[current_pos] = 1;
                if (player == 0) begin
                    board0[current_pos] = 1;
                    player = 1;
                end else if (player == 1) begin
                    board1[current_pos] = 1;
                    player = 0;
                end
            end
            if (win0[0] == 1 || win1[0] == 1)
            begin
                visited[0] = 1; visited[1] = 1; visited[2] = 1;
                visited[9] = 1; visited[10] = 1; visited[11] = 1;
                visited[18] = 1; visited[19] = 1; visited[20] = 1;
            end
            if (win0[1] == 1 || win1[1] == 1)
            begin
                visited[3] = 1; visited[4] = 1; visited[5] = 1;
                visited[12] = 1; visited[13] = 1; visited[14] = 1;
                visited[21] = 1; visited[22] = 1; visited[23] = 1;
            end
            if (win0[2] == 1 || win1[2] == 1)
            begin
                visited[6] = 1; visited[7] = 1; visited[8] = 1;
                visited[15] = 1; visited[16] = 1; visited[17] = 1;
                visited[24] = 1; visited[25] = 1; visited[26] = 1;
            end
            if (win0[3] == 1 || win1[3] == 1)
            begin
                visited[27] = 1; visited[28] = 1; visited[29] = 1;
                visited[36] = 1; visited[37] = 1; visited[38] = 1;
                visited[45] = 1; visited[46] = 1; visited[47] = 1;
            end
            if (win0[4] == 1 || win1[4] == 1)
            begin
                visited[30] = 1; visited[31] = 1; visited[32] = 1;
                visited[39] = 1; visited[40] = 1; visited[41] = 1;
                visited[48] = 1; visited[49] = 1; visited[50] = 1;
            end
            if (win0[5] == 1 || win1[5] == 1)
            begin
                visited[33] = 1; visited[34] = 1; visited[35] = 1;
                visited[42] = 1; visited[43] = 1; visited[44] = 1;
                visited[51] = 1; visited[52] = 1; visited[53] = 1;
            end
            if (win0[6] == 1 || win1[6] == 1)
            begin
                visited[54] = 1; visited[55] = 1; visited[56] = 1;
                visited[63] = 1; visited[64] = 1; visited[65] = 1;
                visited[72] = 1; visited[73] = 1; visited[74] = 1;
            end
            if (win0[7] == 1 || win1[7] == 1)
            begin
                visited[57] = 1; visited[58] = 1; visited[59] = 1;
                visited[66] = 1; visited[67] = 1; visited[68] = 1;
                visited[75] = 1; visited[76] = 1; visited[77] = 1;
            end
            if (win0[8] == 1 || win1[8] == 1)
            begin
                visited[60] = 1; visited[61] = 1; visited[62] = 1;
                visited[69] = 1; visited[70] = 1; visited[71] = 1;
                visited[78] = 1; visited[79] = 1; visited[80] = 1;
            end
        
        // Check win for player 0 and update board
        if ((board0[0] == 1 && board0[1] == 1 && board0[2] == 1) ||
            (board0[9] == 1 && board0[10] == 1 && board0[11] == 1) ||
            (board0[18] == 1 && board0[19] == 1 && board0[20] == 1) ||
            (board0[0] == 1 && board0[9] == 1 && board0[18] == 1) ||
            (board0[1] == 1 && board0[10] == 1 && board0[19] == 1) ||
            (board0[2] == 1 && board0[11] == 1 && board0[20] == 1) ||
            (board0[0] == 1 && board0[10] == 1 && board0[20] == 1) ||
            (board0[2] == 1 && board0[10] == 1 && board0[18] == 1))
        begin
            win0[0] = 1; win01[0] = 1;
        end
        if ((board0[3] == 1 && board0[4] == 1 && board0[5] == 1) ||
            (board0[12] == 1 && board0[13] == 1 && board0[14] == 1) ||
            (board0[21] == 1 && board0[22] == 1 && board0[23] == 1) ||
            (board0[3] == 1 && board0[12] == 1 && board0[21] == 1) ||
            (board0[4] == 1 && board0[13] == 1 && board0[22] == 1) ||
            (board0[5] == 1 && board0[14] == 1 && board0[23] == 1) ||
            (board0[3] == 1 && board0[13] == 1 && board0[23] == 1) ||
            (board0[5] == 1 && board0[13] == 1 && board0[21] == 1))
        begin
            win0[1] = 1; win01[1] = 1;
        end
        if ((board0[6] == 1 && board0[7] == 1 && board0[8] == 1) ||
            (board0[15] == 1 && board0[16] == 1 && board0[17] == 1) ||
            (board0[24] == 1 && board0[25] == 1 && board0[26] == 1) ||
            (board0[6] == 1 && board0[15] == 1 && board0[24] == 1) ||
            (board0[7] == 1 && board0[16] == 1 && board0[25] == 1) ||
            (board0[8] == 1 && board0[17] == 1 && board0[26] == 1) ||
            (board0[6] == 1 && board0[16] == 1 && board0[26] == 1) ||
            (board0[8] == 1 && board0[16] == 1 && board0[24] == 1))
        begin
            win0[2] = 1; win01[2] = 1;
        end
        if ((board0[27] == 1 && board0[28] == 1 && board0[29] == 1) ||
            (board0[36] == 1 && board0[37] == 1 && board0[38] == 1) ||
            (board0[45] == 1 && board0[46] == 1 && board0[47] == 1) ||
            (board0[27] == 1 && board0[36] == 1 && board0[45] == 1) ||
            (board0[28] == 1 && board0[37] == 1 && board0[46] == 1) ||
            (board0[29] == 1 && board0[38] == 1 && board0[47] == 1) ||
            (board0[27] == 1 && board0[37] == 1 && board0[47] == 1) ||
            (board0[29] == 1 && board0[37] == 1 && board0[45] == 1))
        begin
            win0[3] = 1; win01[3] = 1;
        end
        if ((board0[30] == 1 && board0[31] == 1 && board0[32] == 1) ||
            (board0[39] == 1 && board0[40] == 1 && board0[41] == 1) ||
            (board0[48] == 1 && board0[49] == 1 && board0[50] == 1) ||
            (board0[30] == 1 && board0[39] == 1 && board0[48] == 1) ||
            (board0[31] == 1 && board0[40] == 1 && board0[49] == 1) ||
            (board0[32] == 1 && board0[41] == 1 && board0[50] == 1) ||
            (board0[30] == 1 && board0[40] == 1 && board0[50] == 1) ||
            (board0[32] == 1 && board0[40] == 1 && board0[48] == 1))
        begin
            win0[4] = 1; win01[4] = 1;
        end
        if ((board0[33] == 1 && board0[34] == 1 && board0[35] == 1) ||
            (board0[42] == 1 && board0[43] == 1 && board0[44] == 1) ||
            (board0[51] == 1 && board0[52] == 1 && board0[53] == 1) ||
            (board0[33] == 1 && board0[42] == 1 && board0[51] == 1) ||
            (board0[34] == 1 && board0[43] == 1 && board0[52] == 1) ||
            (board0[35] == 1 && board0[44] == 1 && board0[53] == 1) ||
            (board0[33] == 1 && board0[43] == 1 && board0[53] == 1) ||
            (board0[35] == 1 && board0[43] == 1 && board0[51] == 1))
        begin
            win0[5] = 1; win01[5] = 1;
        end
        if ((board0[54] == 1 && board0[55] == 1 && board0[56] == 1) ||
            (board0[63] == 1 && board0[64] == 1 && board0[65] == 1) ||
            (board0[72] == 1 && board0[73] == 1 && board0[74] == 1) ||
            (board0[54] == 1 && board0[63] == 1 && board0[72] == 1) ||
            (board0[55] == 1 && board0[64] == 1 && board0[73] == 1) ||
            (board0[56] == 1 && board0[65] == 1 && board0[74] == 1) ||
            (board0[54] == 1 && board0[64] == 1 && board0[74] == 1) ||
            (board0[56] == 1 && board0[64] == 1 && board0[72] == 1))
        begin
            win0[6] = 1; win01[6] = 1;
        end
        if ((board0[57] == 1 && board0[58] == 1 && board0[59] == 1) ||
            (board0[66] == 1 && board0[67] == 1 && board0[68] == 1) ||
            (board0[75] == 1 && board0[76] == 1 && board0[77] == 1) ||
            (board0[57] == 1 && board0[66] == 1 && board0[75] == 1) ||
            (board0[58] == 1 && board0[67] == 1 && board0[76] == 1) ||
            (board0[59] == 1 && board0[68] == 1 && board0[77] == 1) ||
            (board0[57] == 1 && board0[67] == 1 && board0[77] == 1) ||
            (board0[59] == 1 && board0[64] == 1 && board0[72] == 1))
        begin
            win0[7] = 1; win01[7] = 1;
        end
        if ((board0[60] == 1 && board0[61] == 1 && board0[62] == 1) ||
            (board0[69] == 1 && board0[70] == 1 && board0[71] == 1) ||
            (board0[78] == 1 && board0[79] == 1 && board0[80] == 1) ||
            (board0[60] == 1 && board0[69] == 1 && board0[78] == 1) ||
            (board0[61] == 1 && board0[70] == 1 && board0[79] == 1) ||
            (board0[62] == 1 && board0[71] == 1 && board0[80] == 1) ||
            (board0[60] == 1 && board0[70] == 1 && board0[80] == 1) ||
            (board0[62] == 1 && board0[70] == 1 && board0[78] == 1))
        begin
            win0[8] = 1; win01[8] = 1;
        end
        
        // Check win for player 1 and update board
        if ((board1[0] == 1 && board1[1] == 1 && board1[2] == 1) ||
            (board1[9] == 1 && board1[10] == 1 && board1[11] == 1) ||
            (board1[18] == 1 && board1[19] == 1 && board1[20] == 1) ||
            (board1[0] == 1 && board1[9] == 1 && board1[18] == 1) ||
            (board1[1] == 1 && board1[10] == 1 && board1[19] == 1) ||
            (board1[2] == 1 && board1[11] == 1 && board1[20] == 1) ||
            (board1[0] == 1 && board1[10] == 1 && board1[20] == 1) ||
            (board1[2] == 1 && board1[10] == 1 && board1[18] == 1))
        begin
            win1[0] = 1; win01[0] = 1;
        end
        if ((board1[3] == 1 && board1[4] == 1 && board1[5] == 1) ||
            (board1[12] == 1 && board1[13] == 1 && board1[14] == 1) ||
            (board1[21] == 1 && board1[22] == 1 && board1[23] == 1) ||
            (board1[3] == 1 && board1[12] == 1 && board1[21] == 1) ||
            (board1[4] == 1 && board1[13] == 1 && board1[22] == 1) ||
            (board1[5] == 1 && board1[14] == 1 && board1[23] == 1) ||
            (board1[3] == 1 && board1[13] == 1 && board1[23] == 1) ||
            (board1[5] == 1 && board1[13] == 1 && board1[21] == 1))
        begin
            win1[1] = 1; win01[1] = 1;
        end
        if ((board1[6] == 1 && board1[7] == 1 && board1[8] == 1) ||
            (board1[15] == 1 && board1[16] == 1 && board1[17] == 1) ||
            (board1[24] == 1 && board1[25] == 1 && board1[26] == 1) ||
            (board1[6] == 1 && board1[15] == 1 && board1[24] == 1) ||
            (board1[7] == 1 && board1[16] == 1 && board1[25] == 1) ||
            (board1[8] == 1 && board1[17] == 1 && board1[26] == 1) ||
            (board1[6] == 1 && board1[16] == 1 && board1[26] == 1) ||
            (board1[8] == 1 && board1[16] == 1 && board1[24] == 1))
        begin
            win1[2] = 1; win01[2] = 1;
        end
        if ((board1[27] == 1 && board1[28] == 1 && board1[29] == 1) ||
            (board1[36] == 1 && board1[37] == 1 && board1[38] == 1) ||
            (board1[45] == 1 && board1[46] == 1 && board1[47] == 1) ||
            (board1[27] == 1 && board1[36] == 1 && board1[45] == 1) ||
            (board1[28] == 1 && board1[37] == 1 && board1[46] == 1) ||
            (board1[29] == 1 && board1[38] == 1 && board1[47] == 1) ||
            (board1[27] == 1 && board1[37] == 1 && board1[47] == 1) ||
            (board1[29] == 1 && board1[37] == 1 && board1[45] == 1))
        begin
            win1[3] = 1; win01[3] = 1;
        end
        if ((board1[30] == 1 && board1[31] == 1 && board1[32] == 1) ||
            (board1[39] == 1 && board1[40] == 1 && board1[41] == 1) ||
            (board1[48] == 1 && board1[49] == 1 && board1[50] == 1) ||
            (board1[30] == 1 && board1[39] == 1 && board1[48] == 1) ||
            (board1[31] == 1 && board1[40] == 1 && board1[49] == 1) ||
            (board1[32] == 1 && board1[41] == 1 && board1[50] == 1) ||
            (board1[30] == 1 && board1[40] == 1 && board1[50] == 1) ||
            (board1[32] == 1 && board1[40] == 1 && board1[48] == 1))
        begin
            win1[4] = 1; win01[4] = 1;
        end
        if ((board1[33] == 1 && board1[34] == 1 && board1[35] == 1) ||
            (board1[42] == 1 && board1[43] == 1 && board1[44] == 1) ||
            (board1[51] == 1 && board1[52] == 1 && board1[53] == 1) ||
            (board1[33] == 1 && board1[42] == 1 && board1[51] == 1) ||
            (board1[34] == 1 && board1[43] == 1 && board1[52] == 1) ||
            (board1[35] == 1 && board1[44] == 1 && board1[53] == 1) ||
            (board1[33] == 1 && board1[43] == 1 && board1[53] == 1) ||
            (board1[35] == 1 && board1[43] == 1 && board1[51] == 1))
        begin
            win1[5] = 1; win01[5] = 1;
        end
        if ((board1[54] == 1 && board1[55] == 1 && board1[56] == 1) ||
            (board1[63] == 1 && board1[64] == 1 && board1[65] == 1) ||
            (board1[72] == 1 && board1[73] == 1 && board1[74] == 1) ||
            (board1[54] == 1 && board1[63] == 1 && board1[72] == 1) ||
            (board1[55] == 1 && board1[64] == 1 && board1[73] == 1) ||
            (board1[56] == 1 && board1[65] == 1 && board1[74] == 1) ||
            (board1[54] == 1 && board1[64] == 1 && board1[74] == 1) ||
            (board1[56] == 1 && board1[64] == 1 && board1[72] == 1))
        begin
            win1[6] = 1; win01[6] = 1;
        end
        if ((board1[57] == 1 && board1[58] == 1 && board1[59] == 1) ||
            (board1[66] == 1 && board1[67] == 1 && board1[68] == 1) ||
            (board1[75] == 1 && board1[76] == 1 && board1[77] == 1) ||
            (board1[57] == 1 && board1[66] == 1 && board1[75] == 1) ||
            (board1[58] == 1 && board1[67] == 1 && board1[76] == 1) ||
            (board1[59] == 1 && board1[68] == 1 && board1[77] == 1) ||
            (board1[57] == 1 && board1[67] == 1 && board1[77] == 1) ||
            (board1[59] == 1 && board1[64] == 1 && board1[72] == 1))
        begin
            win1[7] = 1; win01[7] = 1;
        end
        if ((board1[60] == 1 && board1[61] == 1 && board1[62] == 1) ||
            (board1[69] == 1 && board1[70] == 1 && board1[71] == 1) ||
            (board1[78] == 1 && board1[79] == 1 && board1[80] == 1) ||
            (board1[60] == 1 && board1[69] == 1 && board1[78] == 1) ||
            (board1[61] == 1 && board1[70] == 1 && board1[79] == 1) ||
            (board1[62] == 1 && board1[71] == 1 && board1[80] == 1) ||
            (board1[60] == 1 && board1[70] == 1 && board1[80] == 1) ||
            (board1[62] == 1 && board1[70] == 1 && board1[78] == 1))
        begin
            win1[8] = 1; win01[8] = 1;
        end

        // Check for draw in cell           
        if (visited[0] == 1 && visited[1] == 1 && visited[2] == 1 && visited[9] == 1 && visited[10] == 1 && visited[11] == 1 &&    visited[18] == 1 && visited[19] == 1 && visited[20] == 1 && win0[0] == 0 && win1[0] == 0)
            win01[0] = 1;
        if (visited[3] == 1 && visited[4] == 1 && visited[5] == 1 && visited[12] == 1 && visited[13] == 1 && visited[14] == 1 && visited[21] == 1 && visited[22] == 1 && visited[23] == 1 && win0[1] == 0 && win1[1] == 0)
            win01[1] = 1;
        if (visited[6] == 1 && visited[7] == 1 && visited[8] == 1 && visited[15] == 1 && visited[16] == 1 && visited[17] == 1 && visited[24] == 1 && visited[25] == 1 && visited[26] == 1 && win0[2] == 0 && win1[2] == 0)
            win01[2] = 1;
        if (visited[27] == 1 && visited[28] == 1 && visited[29] == 1 && visited[36] == 1 && visited[37] == 1 && visited[38] == 1 && visited[45] == 1 && visited[46] == 1 && visited[47] == 1 && win0[3] == 0 && win1[3] == 0)
            win01[3] = 1;
        if (visited[30] == 1 && visited[31] == 1 && visited[32] == 1 && visited[39] == 1 && visited[40] == 1 && visited[41] == 1 && visited[48] == 1 && visited[49] == 1 && visited[50] == 1 && win0[4] == 0 && win1[4] == 0)
            win01[4] = 1;
        if (visited[33] == 1 && visited[34] == 1 && visited[35] == 1 && visited[42] == 1 && visited[43] == 1 && visited[44] == 1 && visited[51] == 1 && visited[52] == 1 && visited[53] == 1 && win0[5] == 0 && win1[5] == 0)
            win01[5] = 1;
        if (visited[54] == 1 && visited[55] == 1 && visited[56] == 1 && visited[63] == 1 && visited[64] == 1 && visited[65] == 1 && visited[72] == 1 && visited[73] == 1 && visited[74] == 1 && win0[6] == 0 && win1[6] == 0)
            win01[6] = 1;
        if (visited[57] == 1 && visited[58] == 1 && visited[59] == 1 && visited[66] == 1 && visited[67] == 1 && visited[68] == 1 && visited[75] == 1 && visited[76] == 1 && visited[77] == 1 && win0[7] == 0 && win1[7] == 0)
            win01[7] = 1;
        if (visited[60] == 1 && visited[61] == 1 && visited[62] == 1 && visited[69] == 1 && visited[70] == 1 && visited[71] == 1 && visited[78] == 1 && visited[79] == 1 && visited[80] == 1 && win0[8] == 0 && win1[8] == 0)
            win01[8] = 1;
            
//            if (confirm == 1)
//            begin
//                visited[current_pos] = 1;
//                if (player == 0) begin
//                    board0[current_pos] = 1;
//                    player = 1;
//                end else if (player == 1) begin
//                    board1[current_pos] = 1;
//                    player = 0;
//                end
//            end
//            if (win0[0] == 1 || win1[0] == 1)
//            begin
//                visited[0] = 1; visited[1] = 1; visited[2] = 1;
//                visited[9] = 1; visited[10] = 1; visited[11] = 1;
//                visited[18] = 1; visited[19] = 1; visited[20] = 1;
//            end
//            if (win0[1] == 1 || win1[1] == 1)
//            begin
//                visited[3] = 1; visited[4] = 1; visited[5] = 1;
//                visited[12] = 1; visited[13] = 1; visited[14] = 1;
//                visited[21] = 1; visited[22] = 1; visited[23] = 1;
//            end
//            if (win0[2] == 1 || win1[2] == 1)
//            begin
//                visited[6] = 1; visited[7] = 1; visited[8] = 1;
//                visited[15] = 1; visited[16] = 1; visited[17] = 1;
//                visited[24] = 1; visited[25] = 1; visited[26] = 1;
//            end
//            if (win0[3] == 1 || win1[3] == 1)
//            begin
//                visited[27] = 1; visited[28] = 1; visited[29] = 1;
//                visited[36] = 1; visited[37] = 1; visited[38] = 1;
//                visited[45] = 1; visited[46] = 1; visited[47] = 1;
//            end
//            if (win0[4] == 1 || win1[4] == 1)
//            begin
//                visited[30] = 1; visited[31] = 1; visited[32] = 1;
//                visited[39] = 1; visited[40] = 1; visited[41] = 1;
//                visited[48] = 1; visited[49] = 1; visited[50] = 1;
//            end
//            if (win0[5] == 1 || win1[5] == 1)
//            begin
//                visited[33] = 1; visited[34] = 1; visited[35] = 1;
//                visited[42] = 1; visited[43] = 1; visited[44] = 1;
//                visited[51] = 1; visited[52] = 1; visited[53] = 1;
//            end
//            if (win0[6] == 1 || win1[6] == 1)
//            begin
//                visited[54] = 1; visited[55] = 1; visited[56] = 1;
//                visited[63] = 1; visited[64] = 1; visited[65] = 1;
//                visited[72] = 1; visited[73] = 1; visited[74] = 1;
//            end
//            if (win0[7] == 1 || win1[7] == 1)
//            begin
//                visited[57] = 1; visited[58] = 1; visited[59] = 1;
//                visited[66] = 1; visited[67] = 1; visited[68] = 1;
//                visited[75] = 1; visited[76] = 1; visited[77] = 1;
//            end
//            if (win0[8] == 1 || win1[8] == 1)
//            begin
//                visited[60] = 1; visited[61] = 1; visited[62] = 1;
//                visited[69] = 1; visited[70] = 1; visited[71] = 1;
//                visited[78] = 1; visited[79] = 1; visited[80] = 1;
//            end

            if (right == 1)
            begin
                if (whichCell == 0)
                begin
                if (current_pos == 0)
                begin
                    current_pos = 1; continue = 1;
                    if (visited[1] == 0 && continue == 1) begin current_pos = 1; continue = 0; end  
                    if (visited[2] == 0 && continue == 1) begin current_pos = 2; continue = 0; end  
                    if (visited[9] == 0 && continue == 1) begin current_pos = 9; continue = 0; end  
                    if (visited[10] == 0 && continue == 1) begin current_pos = 10; continue = 0; end
                    if (visited[11] == 0 && continue == 1) begin current_pos = 11; continue = 0; end
                    if (visited[18] == 0 && continue == 1) begin current_pos = 18; continue = 0; end
                    if (visited[19] == 0 && continue == 1) begin current_pos = 19; continue = 0; end
                    if (visited[20] == 0 && continue == 1) begin current_pos = 20; continue = 0; end
                end else if (current_pos == 1)
                begin
                    current_pos = 2; continue = 1;
                    if (visited[2] == 0 && continue == 1) begin current_pos = 2; continue = 0; end  
                    if (visited[9] == 0 && continue == 1) begin current_pos = 9; continue = 0; end  
                    if (visited[10] == 0 && continue == 1) begin current_pos = 10; continue = 0; end
                    if (visited[11] == 0 && continue == 1) begin current_pos = 11; continue = 0; end
                    if (visited[18] == 0 && continue == 1) begin current_pos = 18; continue = 0; end
                    if (visited[19] == 0 && continue == 1) begin current_pos = 19; continue = 0; end
                    if (visited[20] == 0 && continue == 1) begin current_pos = 20; continue = 0; end
                    if (visited[0] == 0 && continue == 1) begin current_pos = 0; continue = 0; end
                end else if (current_pos == 2)
                begin
                    current_pos = 9; continue = 1;
                    if (visited[9] == 0 && continue == 1) begin current_pos = 9; continue = 0; end
                    if (visited[10] == 0 && continue == 1) begin current_pos = 10; continue = 0; end
                    if (visited[11] == 0 && continue == 1) begin current_pos = 11; continue = 0; end
                    if (visited[18] == 0 && continue == 1) begin current_pos = 18; continue = 0; end
                    if (visited[19] == 0 && continue == 1) begin current_pos = 19; continue = 0; end
                    if (visited[20] == 0 && continue == 1) begin current_pos = 20; continue = 0; end
                    if (visited[0] == 0 && continue == 1) begin current_pos = 0; continue = 0; end
                    if (visited[1] == 0 && continue == 1) begin current_pos = 1; continue = 0; end
                end else if (current_pos == 9)
                begin
                    current_pos = 10; continue = 1;
                    if (visited[10] == 0 && continue == 1) begin current_pos = 10; continue = 0; end
                    if (visited[11] == 0 && continue == 1) begin current_pos = 11; continue = 0; end
                    if (visited[18] == 0 && continue == 1) begin current_pos = 18; continue = 0; end
                    if (visited[19] == 0 && continue == 1) begin current_pos = 19; continue = 0; end
                    if (visited[20] == 0 && continue == 1) begin current_pos = 20; continue = 0; end
                    if (visited[0] == 0 && continue == 1) begin current_pos = 0; continue = 0; end
                    if (visited[1] == 0 && continue == 1) begin current_pos = 1; continue = 0; end
                    if (visited[2] == 0 && continue == 1) begin current_pos = 2; continue = 0; end
                end else if (current_pos == 10)
                begin
                    current_pos = 11; continue = 1;
                    if (visited[11] == 0 && continue == 1) begin current_pos = 11; continue = 0; end
                    if (visited[18] == 0 && continue == 1) begin current_pos = 18; continue = 0; end
                    if (visited[19] == 0 && continue == 1) begin current_pos = 19; continue = 0; end
                    if (visited[20] == 0 && continue == 1) begin current_pos = 20; continue = 0; end
                    if (visited[0] == 0 && continue == 1) begin current_pos = 0; continue = 0; end
                    if (visited[1] == 0 && continue == 1) begin current_pos = 1; continue = 0; end
                    if (visited[2] == 0 && continue == 1) begin current_pos = 2; continue = 0; end
                    if (visited[9] == 0 && continue == 1) begin current_pos = 9; continue = 0; end
                end else if (current_pos == 11)
                begin
                    current_pos = 18; continue = 1;
                    if (visited[18] == 0 && continue == 1) begin current_pos = 18; continue = 0; end
                    if (visited[19] == 0 && continue == 1) begin current_pos = 19; continue = 0; end
                    if (visited[20] == 0 && continue == 1) begin current_pos = 20; continue = 0; end
                    if (visited[0] == 0 && continue == 1) begin current_pos = 0; continue = 0; end
                    if (visited[1] == 0 && continue == 1) begin current_pos = 1; continue = 0; end
                    if (visited[2] == 0 && continue == 1) begin current_pos = 2; continue = 0; end
                    if (visited[9] == 0 && continue == 1) begin current_pos = 9; continue = 0; end
                    if (visited[10] == 0 && continue == 1) begin current_pos = 10; continue = 0; end
                end else if (current_pos == 18)
                begin
                    current_pos = 19; continue = 1;
                    if (visited[19] == 0 && continue == 1) begin current_pos = 19; continue = 0; end
                    if (visited[20] == 0 && continue == 1) begin current_pos = 20; continue = 0; end
                    if (visited[0] == 0 && continue == 1) begin current_pos = 0; continue = 0; end
                    if (visited[1] == 0 && continue == 1) begin current_pos = 1; continue = 0; end
                    if (visited[2] == 0 && continue == 1) begin current_pos = 2; continue = 0; end
                    if (visited[9] == 0 && continue == 1) begin current_pos = 9; continue = 0; end
                    if (visited[10] == 0 && continue == 1) begin current_pos = 10; continue = 0; end
                    if (visited[11] == 0 && continue == 1) begin current_pos = 11; continue = 0; end
                end else if (current_pos == 19)
                begin
                    current_pos = 20; continue = 1;
                    if (visited[20] == 0 && continue == 1) begin current_pos = 20; continue = 0; end
                    if (visited[0] == 0 && continue == 1) begin current_pos = 0; continue = 0; end
                    if (visited[1] == 0 && continue == 1) begin current_pos = 1; continue = 0; end
                    if (visited[2] == 0 && continue == 1) begin current_pos = 2; continue = 0; end
                    if (visited[9] == 0 && continue == 1) begin current_pos = 9; continue = 0; end
                    if (visited[10] == 0 && continue == 1) begin current_pos = 10; continue = 0; end
                    if (visited[11] == 0 && continue == 1) begin current_pos = 11; continue = 0; end
                    if (visited[18] == 0 && continue == 1) begin current_pos = 18; continue = 0; end
                end else if (current_pos == 20)
                begin
                    current_pos = 0; continue = 1;
                    if (visited[0] == 0 && continue == 1) begin current_pos = 0; continue = 0; end
                    if (visited[1] == 0 && continue == 1) begin current_pos = 1; continue = 0; end
                    if (visited[2] == 0 && continue == 1) begin current_pos = 2; continue = 0; end
                    if (visited[9] == 0 && continue == 1) begin current_pos = 9; continue = 0; end
                    if (visited[10] == 0 && continue == 1) begin current_pos = 10; continue = 0; end
                    if (visited[11] == 0 && continue == 1) begin current_pos = 11; continue = 0; end
                    if (visited[18] == 0 && continue == 1) begin current_pos = 18; continue = 0; end
                    if (visited[19] == 0 && continue == 1) begin current_pos = 19; continue = 0; end
                end
                end else if (whichCell == 1)
                begin
                if (current_pos == 3)
                begin
                    current_pos = 4; continue = 1;
                    if (visited[4] == 0 && continue == 1) begin current_pos = 4; continue = 0; end  
                    if (visited[5] == 0 && continue == 1) begin current_pos = 5; continue = 0; end  
                    if (visited[12] == 0 && continue == 1) begin current_pos = 12; continue = 0; end
                    if (visited[13] == 0 && continue == 1) begin current_pos = 13; continue = 0; end
                    if (visited[14] == 0 && continue == 1) begin current_pos = 14; continue = 0; end
                    if (visited[21] == 0 && continue == 1) begin current_pos = 21; continue = 0; end
                    if (visited[22] == 0 && continue == 1) begin current_pos = 22; continue = 0; end
                    if (visited[23] == 0 && continue == 1) begin current_pos = 23; continue = 0; end
                end else if (current_pos == 4)
                begin
                    current_pos = 5; continue = 1;
                    if (visited[5] == 0 && continue == 1) begin current_pos = 5; continue = 0; end  
                    if (visited[12] == 0 && continue == 1) begin current_pos = 12; continue = 0; end
                    if (visited[13] == 0 && continue == 1) begin current_pos = 13; continue = 0; end
                    if (visited[14] == 0 && continue == 1) begin current_pos = 14; continue = 0; end
                    if (visited[21] == 0 && continue == 1) begin current_pos = 21; continue = 0; end
                    if (visited[22] == 0 && continue == 1) begin current_pos = 22; continue = 0; end
                    if (visited[23] == 0 && continue == 1) begin current_pos = 23; continue = 0; end
                    if (visited[3] == 0 && continue == 1) begin current_pos = 3; continue = 0; end
                end else if (current_pos == 5)
                begin
                    current_pos = 12; continue = 1;
                    if (visited[12] == 0 && continue == 1) begin current_pos = 12; continue = 0; end
                    if (visited[13] == 0 && continue == 1) begin current_pos = 13; continue = 0; end
                    if (visited[14] == 0 && continue == 1) begin current_pos = 14; continue = 0; end
                    if (visited[21] == 0 && continue == 1) begin current_pos = 21; continue = 0; end
                    if (visited[22] == 0 && continue == 1) begin current_pos = 22; continue = 0; end
                    if (visited[23] == 0 && continue == 1) begin current_pos = 23; continue = 0; end
                    if (visited[3] == 0 && continue == 1) begin current_pos = 3; continue = 0; end
                    if (visited[4] == 0 && continue == 1) begin current_pos = 4; continue = 0; end
                end else if (current_pos == 12)
                begin
                    current_pos = 13; continue = 1;
                    if (visited[13] == 0 && continue == 1) begin current_pos = 13; continue = 0; end
                    if (visited[14] == 0 && continue == 1) begin current_pos = 14; continue = 0; end
                    if (visited[21] == 0 && continue == 1) begin current_pos = 21; continue = 0; end
                    if (visited[22] == 0 && continue == 1) begin current_pos = 22; continue = 0; end
                    if (visited[23] == 0 && continue == 1) begin current_pos = 23; continue = 0; end
                    if (visited[3] == 0 && continue == 1) begin current_pos = 3; continue = 0; end
                    if (visited[4] == 0 && continue == 1) begin current_pos = 4; continue = 0; end
                    if (visited[5] == 0 && continue == 1) begin current_pos = 5; continue = 0; end
                end else if (current_pos == 13)
                begin
                    current_pos = 14; continue = 1;
                    if (visited[14] == 0 && continue == 1) begin current_pos = 14; continue = 0; end
                    if (visited[21] == 0 && continue == 1) begin current_pos = 21; continue = 0; end
                    if (visited[22] == 0 && continue == 1) begin current_pos = 22; continue = 0; end
                    if (visited[23] == 0 && continue == 1) begin current_pos = 23; continue = 0; end
                    if (visited[3] == 0 && continue == 1) begin current_pos = 3; continue = 0; end
                    if (visited[4] == 0 && continue == 1) begin current_pos = 4; continue = 0; end
                    if (visited[5] == 0 && continue == 1) begin current_pos = 5; continue = 0; end
                    if (visited[12] == 0 && continue == 1) begin current_pos = 12; continue = 0; end
                end else if (current_pos == 14)
                begin
                    current_pos = 21; continue = 1;
                    if (visited[21] == 0 && continue == 1) begin current_pos = 21; continue = 0; end
                    if (visited[22] == 0 && continue == 1) begin current_pos = 22; continue = 0; end
                    if (visited[23] == 0 && continue == 1) begin current_pos = 23; continue = 0; end
                    if (visited[3] == 0 && continue == 1) begin current_pos = 3; continue = 0; end
                    if (visited[4] == 0 && continue == 1) begin current_pos = 4; continue = 0; end
                    if (visited[5] == 0 && continue == 1) begin current_pos = 5; continue = 0; end
                    if (visited[12] == 0 && continue == 1) begin current_pos = 12; continue = 0; end
                    if (visited[13] == 0 && continue == 1) begin current_pos = 13; continue = 0; end
                end else if (current_pos == 21)
                begin
                    current_pos = 22; continue = 1;
                    if (visited[22] == 0 && continue == 1) begin current_pos = 22; continue = 0; end
                    if (visited[23] == 0 && continue == 1) begin current_pos = 23; continue = 0; end
                    if (visited[3] == 0 && continue == 1) begin current_pos = 3; continue = 0; end
                    if (visited[4] == 0 && continue == 1) begin current_pos = 4; continue = 0; end
                    if (visited[5] == 0 && continue == 1) begin current_pos = 5; continue = 0; end
                    if (visited[12] == 0 && continue == 1) begin current_pos = 12; continue = 0; end
                    if (visited[13] == 0 && continue == 1) begin current_pos = 13; continue = 0; end
                    if (visited[14] == 0 && continue == 1) begin current_pos = 14; continue = 0; end
                end else if (current_pos == 22)
                begin
                    current_pos = 23; continue = 1;
                    if (visited[23] == 0 && continue == 1) begin current_pos = 23; continue = 0; end
                    if (visited[3] == 0 && continue == 1) begin current_pos = 3; continue = 0; end
                    if (visited[4] == 0 && continue == 1) begin current_pos = 4; continue = 0; end
                    if (visited[5] == 0 && continue == 1) begin current_pos = 5; continue = 0; end
                    if (visited[12] == 0 && continue == 1) begin current_pos = 12; continue = 0; end
                    if (visited[13] == 0 && continue == 1) begin current_pos = 13; continue = 0; end
                    if (visited[14] == 0 && continue == 1) begin current_pos = 14; continue = 0; end
                    if (visited[21] == 0 && continue == 1) begin current_pos = 21; continue = 0; end
                end else if (current_pos == 23)
                begin
                    current_pos = 3; continue = 1;
                    if (visited[3] == 0 && continue == 1) begin current_pos = 3; continue = 0; end
                    if (visited[4] == 0 && continue == 1) begin current_pos = 4; continue = 0; end
                    if (visited[5] == 0 && continue == 1) begin current_pos = 5; continue = 0; end
                    if (visited[12] == 0 && continue == 1) begin current_pos = 12; continue = 0; end
                    if (visited[13] == 0 && continue == 1) begin current_pos = 13; continue = 0; end
                    if (visited[14] == 0 && continue == 1) begin current_pos = 14; continue = 0; end
                    if (visited[21] == 0 && continue == 1) begin current_pos = 21; continue = 0; end
                    if (visited[22] == 0 && continue == 1) begin current_pos = 22; continue = 0; end
                end
                end else if (whichCell == 2)
                begin
                if (current_pos == 6)
                begin
                    current_pos = 7; continue = 1;
                    if (visited[7] == 0 && continue == 1) begin current_pos = 7; continue = 0; end  
                    if (visited[8] == 0 && continue == 1) begin current_pos = 8; continue = 0; end  
                    if (visited[15] == 0 && continue == 1) begin current_pos = 15; continue = 0; end
                    if (visited[16] == 0 && continue == 1) begin current_pos = 16; continue = 0; end
                    if (visited[17] == 0 && continue == 1) begin current_pos = 17; continue = 0; end
                    if (visited[24] == 0 && continue == 1) begin current_pos = 24; continue = 0; end
                    if (visited[25] == 0 && continue == 1) begin current_pos = 25; continue = 0; end
                    if (visited[26] == 0 && continue == 1) begin current_pos = 26; continue = 0; end
                end else if (current_pos == 7)
                begin
                    current_pos = 8; continue = 1;
                    if (visited[8] == 0 && continue == 1) begin current_pos = 8; continue = 0; end  
                    if (visited[15] == 0 && continue == 1) begin current_pos = 15; continue = 0; end
                    if (visited[16] == 0 && continue == 1) begin current_pos = 16; continue = 0; end
                    if (visited[17] == 0 && continue == 1) begin current_pos = 17; continue = 0; end
                    if (visited[24] == 0 && continue == 1) begin current_pos = 24; continue = 0; end
                    if (visited[25] == 0 && continue == 1) begin current_pos = 25; continue = 0; end
                    if (visited[26] == 0 && continue == 1) begin current_pos = 26; continue = 0; end
                    if (visited[6] == 0 && continue == 1) begin current_pos = 6; continue = 0; end
                end else if (current_pos == 8)
                begin
                    current_pos = 15; continue = 1;
                    if (visited[15] == 0 && continue == 1) begin current_pos = 15; continue = 0; end
                    if (visited[16] == 0 && continue == 1) begin current_pos = 16; continue = 0; end
                    if (visited[17] == 0 && continue == 1) begin current_pos = 17; continue = 0; end
                    if (visited[24] == 0 && continue == 1) begin current_pos = 24; continue = 0; end
                    if (visited[25] == 0 && continue == 1) begin current_pos = 25; continue = 0; end
                    if (visited[26] == 0 && continue == 1) begin current_pos = 26; continue = 0; end
                    if (visited[6] == 0 && continue == 1) begin current_pos = 6; continue = 0; end
                    if (visited[7] == 0 && continue == 1) begin current_pos = 7; continue = 0; end
                end else if (current_pos == 15)
                begin
                    current_pos = 16; continue = 1;
                    if (visited[16] == 0 && continue == 1) begin current_pos = 16; continue = 0; end
                    if (visited[17] == 0 && continue == 1) begin current_pos = 17; continue = 0; end
                    if (visited[24] == 0 && continue == 1) begin current_pos = 24; continue = 0; end
                    if (visited[25] == 0 && continue == 1) begin current_pos = 25; continue = 0; end
                    if (visited[26] == 0 && continue == 1) begin current_pos = 26; continue = 0; end
                    if (visited[6] == 0 && continue == 1) begin current_pos = 6; continue = 0; end
                    if (visited[7] == 0 && continue == 1) begin current_pos = 7; continue = 0; end
                    if (visited[8] == 0 && continue == 1) begin current_pos = 8; continue = 0; end
                end else if (current_pos == 16)
                begin
                    current_pos = 17; continue = 1;
                    if (visited[17] == 0 && continue == 1) begin current_pos = 17; continue = 0; end
                    if (visited[24] == 0 && continue == 1) begin current_pos = 24; continue = 0; end
                    if (visited[25] == 0 && continue == 1) begin current_pos = 25; continue = 0; end
                    if (visited[26] == 0 && continue == 1) begin current_pos = 26; continue = 0; end
                    if (visited[6] == 0 && continue == 1) begin current_pos = 6; continue = 0; end
                    if (visited[7] == 0 && continue == 1) begin current_pos = 7; continue = 0; end
                    if (visited[8] == 0 && continue == 1) begin current_pos = 8; continue = 0; end
                    if (visited[15] == 0 && continue == 1) begin current_pos = 15; continue = 0; end
                end else if (current_pos == 17)
                begin
                    current_pos = 24; continue = 1;
                    if (visited[24] == 0 && continue == 1) begin current_pos = 24; continue = 0; end
                    if (visited[25] == 0 && continue == 1) begin current_pos = 25; continue = 0; end
                    if (visited[26] == 0 && continue == 1) begin current_pos = 26; continue = 0; end
                    if (visited[6] == 0 && continue == 1) begin current_pos = 6; continue = 0; end
                    if (visited[7] == 0 && continue == 1) begin current_pos = 7; continue = 0; end
                    if (visited[8] == 0 && continue == 1) begin current_pos = 8; continue = 0; end
                    if (visited[15] == 0 && continue == 1) begin current_pos = 15; continue = 0; end
                    if (visited[16] == 0 && continue == 1) begin current_pos = 16; continue = 0; end
                end else if (current_pos == 24)
                begin
                    current_pos = 25; continue = 1;
                    if (visited[25] == 0 && continue == 1) begin current_pos = 25; continue = 0; end
                    if (visited[26] == 0 && continue == 1) begin current_pos = 26; continue = 0; end
                    if (visited[6] == 0 && continue == 1) begin current_pos = 6; continue = 0; end
                    if (visited[7] == 0 && continue == 1) begin current_pos = 7; continue = 0; end
                    if (visited[8] == 0 && continue == 1) begin current_pos = 8; continue = 0; end
                    if (visited[15] == 0 && continue == 1) begin current_pos = 15; continue = 0; end
                    if (visited[16] == 0 && continue == 1) begin current_pos = 16; continue = 0; end
                    if (visited[17] == 0 && continue == 1) begin current_pos = 17; continue = 0; end
                end else if (current_pos == 25)
                begin
                    current_pos = 26; continue = 1;
                    if (visited[26] == 0 && continue == 1) begin current_pos = 26; continue = 0; end
                    if (visited[6] == 0 && continue == 1) begin current_pos = 6; continue = 0; end
                    if (visited[7] == 0 && continue == 1) begin current_pos = 7; continue = 0; end
                    if (visited[8] == 0 && continue == 1) begin current_pos = 8; continue = 0; end
                    if (visited[15] == 0 && continue == 1) begin current_pos = 15; continue = 0; end
                    if (visited[16] == 0 && continue == 1) begin current_pos = 16; continue = 0; end
                    if (visited[17] == 0 && continue == 1) begin current_pos = 17; continue = 0; end
                    if (visited[24] == 0 && continue == 1) begin current_pos = 24; continue = 0; end
                end else if (current_pos == 26)
                begin
                    current_pos = 6; continue = 1;
                    if (visited[6] == 0 && continue == 1) begin current_pos = 6; continue = 0; end
                    if (visited[7] == 0 && continue == 1) begin current_pos = 7; continue = 0; end
                    if (visited[8] == 0 && continue == 1) begin current_pos = 8; continue = 0; end
                    if (visited[15] == 0 && continue == 1) begin current_pos = 15; continue = 0; end
                    if (visited[16] == 0 && continue == 1) begin current_pos = 16; continue = 0; end
                    if (visited[17] == 0 && continue == 1) begin current_pos = 17; continue = 0; end
                    if (visited[24] == 0 && continue == 1) begin current_pos = 24; continue = 0; end
                    if (visited[25] == 0 && continue == 1) begin current_pos = 25; continue = 0; end
                end
                end else if (whichCell == 3)
                begin
                if (current_pos == 27)
                begin
                    current_pos = 28; continue = 1;
                    if (visited[28] == 0 && continue == 1) begin current_pos = 28; continue = 0; end
                    if (visited[29] == 0 && continue == 1) begin current_pos = 29; continue = 0; end
                    if (visited[36] == 0 && continue == 1) begin current_pos = 36; continue = 0; end
                    if (visited[37] == 0 && continue == 1) begin current_pos = 37; continue = 0; end
                    if (visited[38] == 0 && continue == 1) begin current_pos = 38; continue = 0; end
                    if (visited[45] == 0 && continue == 1) begin current_pos = 45; continue = 0; end
                    if (visited[46] == 0 && continue == 1) begin current_pos = 46; continue = 0; end
                    if (visited[47] == 0 && continue == 1) begin current_pos = 47; continue = 0; end
                end else if (current_pos == 28)
                begin
                    current_pos = 29; continue = 1;
                    if (visited[29] == 0 && continue == 1) begin current_pos = 29; continue = 0; end
                    if (visited[36] == 0 && continue == 1) begin current_pos = 36; continue = 0; end
                    if (visited[37] == 0 && continue == 1) begin current_pos = 37; continue = 0; end
                    if (visited[38] == 0 && continue == 1) begin current_pos = 38; continue = 0; end
                    if (visited[45] == 0 && continue == 1) begin current_pos = 45; continue = 0; end
                    if (visited[46] == 0 && continue == 1) begin current_pos = 46; continue = 0; end
                    if (visited[47] == 0 && continue == 1) begin current_pos = 47; continue = 0; end
                    if (visited[27] == 0 && continue == 1) begin current_pos = 27; continue = 0; end
                end else if (current_pos == 29)
                begin
                    current_pos = 36; continue = 1;
                    if (visited[36] == 0 && continue == 1) begin current_pos = 36; continue = 0; end
                    if (visited[37] == 0 && continue == 1) begin current_pos = 37; continue = 0; end
                    if (visited[38] == 0 && continue == 1) begin current_pos = 38; continue = 0; end
                    if (visited[45] == 0 && continue == 1) begin current_pos = 45; continue = 0; end
                    if (visited[46] == 0 && continue == 1) begin current_pos = 46; continue = 0; end
                    if (visited[47] == 0 && continue == 1) begin current_pos = 47; continue = 0; end
                    if (visited[27] == 0 && continue == 1) begin current_pos = 27; continue = 0; end
                    if (visited[28] == 0 && continue == 1) begin current_pos = 28; continue = 0; end
                end else if (current_pos == 36)
                begin
                    current_pos = 37; continue = 1;
                    if (visited[37] == 0 && continue == 1) begin current_pos = 37; continue = 0; end
                    if (visited[38] == 0 && continue == 1) begin current_pos = 38; continue = 0; end
                    if (visited[45] == 0 && continue == 1) begin current_pos = 45; continue = 0; end
                    if (visited[46] == 0 && continue == 1) begin current_pos = 46; continue = 0; end
                    if (visited[47] == 0 && continue == 1) begin current_pos = 47; continue = 0; end
                    if (visited[27] == 0 && continue == 1) begin current_pos = 27; continue = 0; end
                    if (visited[28] == 0 && continue == 1) begin current_pos = 28; continue = 0; end
                    if (visited[29] == 0 && continue == 1) begin current_pos = 29; continue = 0; end
                end else if (current_pos == 37)
                begin
                    current_pos = 38; continue = 1;
                    if (visited[38] == 0 && continue == 1) begin current_pos = 38; continue = 0; end
                    if (visited[45] == 0 && continue == 1) begin current_pos = 45; continue = 0; end
                    if (visited[46] == 0 && continue == 1) begin current_pos = 46; continue = 0; end
                    if (visited[47] == 0 && continue == 1) begin current_pos = 47; continue = 0; end
                    if (visited[27] == 0 && continue == 1) begin current_pos = 27; continue = 0; end
                    if (visited[28] == 0 && continue == 1) begin current_pos = 28; continue = 0; end
                    if (visited[29] == 0 && continue == 1) begin current_pos = 29; continue = 0; end
                    if (visited[36] == 0 && continue == 1) begin current_pos = 36; continue = 0; end
                end else if (current_pos == 38)
                begin
                    current_pos = 45; continue = 1;
                    if (visited[45] == 0 && continue == 1) begin current_pos = 45; continue = 0; end
                    if (visited[46] == 0 && continue == 1) begin current_pos = 46; continue = 0; end
                    if (visited[47] == 0 && continue == 1) begin current_pos = 47; continue = 0; end
                    if (visited[27] == 0 && continue == 1) begin current_pos = 27; continue = 0; end
                    if (visited[28] == 0 && continue == 1) begin current_pos = 28; continue = 0; end
                    if (visited[29] == 0 && continue == 1) begin current_pos = 29; continue = 0; end
                    if (visited[36] == 0 && continue == 1) begin current_pos = 36; continue = 0; end
                    if (visited[37] == 0 && continue == 1) begin current_pos = 37; continue = 0; end
                end else if (current_pos == 45)
                begin
                    current_pos = 46; continue = 1;
                    if (visited[46] == 0 && continue == 1) begin current_pos = 46; continue = 0; end
                    if (visited[47] == 0 && continue == 1) begin current_pos = 47; continue = 0; end
                    if (visited[27] == 0 && continue == 1) begin current_pos = 27; continue = 0; end
                    if (visited[28] == 0 && continue == 1) begin current_pos = 28; continue = 0; end
                    if (visited[29] == 0 && continue == 1) begin current_pos = 29; continue = 0; end
                    if (visited[36] == 0 && continue == 1) begin current_pos = 36; continue = 0; end
                    if (visited[37] == 0 && continue == 1) begin current_pos = 37; continue = 0; end
                    if (visited[38] == 0 && continue == 1) begin current_pos = 38; continue = 0; end
                end else if (current_pos == 46)
                begin
                    current_pos = 47; continue = 1;
                    if (visited[47] == 0 && continue == 1) begin current_pos = 47; continue = 0; end
                    if (visited[27] == 0 && continue == 1) begin current_pos = 27; continue = 0; end
                    if (visited[28] == 0 && continue == 1) begin current_pos = 28; continue = 0; end
                    if (visited[29] == 0 && continue == 1) begin current_pos = 29; continue = 0; end
                    if (visited[36] == 0 && continue == 1) begin current_pos = 36; continue = 0; end
                    if (visited[37] == 0 && continue == 1) begin current_pos = 37; continue = 0; end
                    if (visited[38] == 0 && continue == 1) begin current_pos = 38; continue = 0; end
                    if (visited[45] == 0 && continue == 1) begin current_pos = 45; continue = 0; end
                end else if (current_pos == 47)
                begin
                    current_pos = 27; continue = 1;
                    if (visited[27] == 0 && continue == 1) begin current_pos = 27; continue = 0; end
                    if (visited[28] == 0 && continue == 1) begin current_pos = 28; continue = 0; end
                    if (visited[29] == 0 && continue == 1) begin current_pos = 29; continue = 0; end
                    if (visited[36] == 0 && continue == 1) begin current_pos = 36; continue = 0; end
                    if (visited[37] == 0 && continue == 1) begin current_pos = 37; continue = 0; end
                    if (visited[38] == 0 && continue == 1) begin current_pos = 38; continue = 0; end
                    if (visited[45] == 0 && continue == 1) begin current_pos = 45; continue = 0; end
                    if (visited[46] == 0 && continue == 1) begin current_pos = 46; continue = 0; end
                end
                end else if (whichCell == 4)
                begin
                if (current_pos == 30)
                begin
                    current_pos = 31; continue = 1;
                    if (visited[31] == 0 && continue == 1) begin current_pos = 31; continue = 0; end
                    if (visited[32] == 0 && continue == 1) begin current_pos = 32; continue = 0; end
                    if (visited[39] == 0 && continue == 1) begin current_pos = 39; continue = 0; end
                    if (visited[40] == 0 && continue == 1) begin current_pos = 40; continue = 0; end
                    if (visited[41] == 0 && continue == 1) begin current_pos = 41; continue = 0; end
                    if (visited[48] == 0 && continue == 1) begin current_pos = 48; continue = 0; end
                    if (visited[49] == 0 && continue == 1) begin current_pos = 49; continue = 0; end
                    if (visited[50] == 0 && continue == 1) begin current_pos = 50; continue = 0; end
                end else if (current_pos == 31)
                begin
                    current_pos = 32; continue = 1;
                    if (visited[32] == 0 && continue == 1) begin current_pos = 32; continue = 0; end
                    if (visited[39] == 0 && continue == 1) begin current_pos = 39; continue = 0; end
                    if (visited[40] == 0 && continue == 1) begin current_pos = 40; continue = 0; end
                    if (visited[41] == 0 && continue == 1) begin current_pos = 41; continue = 0; end
                    if (visited[48] == 0 && continue == 1) begin current_pos = 48; continue = 0; end
                    if (visited[49] == 0 && continue == 1) begin current_pos = 49; continue = 0; end
                    if (visited[50] == 0 && continue == 1) begin current_pos = 50; continue = 0; end
                    if (visited[30] == 0 && continue == 1) begin current_pos = 30; continue = 0; end
                end else if (current_pos == 32)
                begin
                    current_pos = 39; continue = 1;
                    if (visited[39] == 0 && continue == 1) begin current_pos = 39; continue = 0; end
                    if (visited[40] == 0 && continue == 1) begin current_pos = 40; continue = 0; end
                    if (visited[41] == 0 && continue == 1) begin current_pos = 41; continue = 0; end
                    if (visited[48] == 0 && continue == 1) begin current_pos = 48; continue = 0; end
                    if (visited[49] == 0 && continue == 1) begin current_pos = 49; continue = 0; end
                    if (visited[50] == 0 && continue == 1) begin current_pos = 50; continue = 0; end
                    if (visited[30] == 0 && continue == 1) begin current_pos = 30; continue = 0; end
                    if (visited[31] == 0 && continue == 1) begin current_pos = 31; continue = 0; end
                end else if (current_pos == 39)
                begin
                    current_pos = 40; continue = 1;
                    if (visited[40] == 0 && continue == 1) begin current_pos = 40; continue = 0; end
                    if (visited[41] == 0 && continue == 1) begin current_pos = 41; continue = 0; end
                    if (visited[48] == 0 && continue == 1) begin current_pos = 48; continue = 0; end
                    if (visited[49] == 0 && continue == 1) begin current_pos = 49; continue = 0; end
                    if (visited[50] == 0 && continue == 1) begin current_pos = 50; continue = 0; end
                    if (visited[30] == 0 && continue == 1) begin current_pos = 30; continue = 0; end
                    if (visited[31] == 0 && continue == 1) begin current_pos = 31; continue = 0; end
                    if (visited[32] == 0 && continue == 1) begin current_pos = 32; continue = 0; end
                end else if (current_pos == 40)
                begin
                    current_pos = 41; continue = 1;
                    if (visited[41] == 0 && continue == 1) begin current_pos = 41; continue = 0; end
                    if (visited[48] == 0 && continue == 1) begin current_pos = 48; continue = 0; end
                    if (visited[49] == 0 && continue == 1) begin current_pos = 49; continue = 0; end
                    if (visited[50] == 0 && continue == 1) begin current_pos = 50; continue = 0; end
                    if (visited[30] == 0 && continue == 1) begin current_pos = 30; continue = 0; end
                    if (visited[31] == 0 && continue == 1) begin current_pos = 31; continue = 0; end
                    if (visited[32] == 0 && continue == 1) begin current_pos = 32; continue = 0; end
                    if (visited[39] == 0 && continue == 1) begin current_pos = 39; continue = 0; end
                end else if (current_pos == 41)
                begin
                    current_pos = 48; continue = 1;
                    if (visited[48] == 0 && continue == 1) begin current_pos = 48; continue = 0; end
                    if (visited[49] == 0 && continue == 1) begin current_pos = 49; continue = 0; end
                    if (visited[50] == 0 && continue == 1) begin current_pos = 50; continue = 0; end
                    if (visited[30] == 0 && continue == 1) begin current_pos = 30; continue = 0; end
                    if (visited[31] == 0 && continue == 1) begin current_pos = 31; continue = 0; end
                    if (visited[32] == 0 && continue == 1) begin current_pos = 32; continue = 0; end
                    if (visited[39] == 0 && continue == 1) begin current_pos = 39; continue = 0; end
                    if (visited[40] == 0 && continue == 1) begin current_pos = 40; continue = 0; end
                end else if (current_pos == 48)
                begin
                    current_pos = 49; continue = 1;
                    if (visited[49] == 0 && continue == 1) begin current_pos = 49; continue = 0; end
                    if (visited[50] == 0 && continue == 1) begin current_pos = 50; continue = 0; end
                    if (visited[30] == 0 && continue == 1) begin current_pos = 30; continue = 0; end
                    if (visited[31] == 0 && continue == 1) begin current_pos = 31; continue = 0; end
                    if (visited[32] == 0 && continue == 1) begin current_pos = 32; continue = 0; end
                    if (visited[39] == 0 && continue == 1) begin current_pos = 39; continue = 0; end
                    if (visited[40] == 0 && continue == 1) begin current_pos = 40; continue = 0; end
                    if (visited[41] == 0 && continue == 1) begin current_pos = 41; continue = 0; end
                end else if (current_pos == 49)
                begin
                    current_pos = 50; continue = 1;
                    if (visited[50] == 0 && continue == 1) begin current_pos = 50; continue = 0; end
                    if (visited[30] == 0 && continue == 1) begin current_pos = 30; continue = 0; end
                    if (visited[31] == 0 && continue == 1) begin current_pos = 31; continue = 0; end
                    if (visited[32] == 0 && continue == 1) begin current_pos = 32; continue = 0; end
                    if (visited[39] == 0 && continue == 1) begin current_pos = 39; continue = 0; end
                    if (visited[40] == 0 && continue == 1) begin current_pos = 40; continue = 0; end
                    if (visited[41] == 0 && continue == 1) begin current_pos = 41; continue = 0; end
                    if (visited[48] == 0 && continue == 1) begin current_pos = 48; continue = 0; end
                end else if (current_pos == 50)
                begin
                    current_pos = 30; continue = 1;
                    if (visited[30] == 0 && continue == 1) begin current_pos = 30; continue = 0; end
                    if (visited[31] == 0 && continue == 1) begin current_pos = 31; continue = 0; end
                    if (visited[32] == 0 && continue == 1) begin current_pos = 32; continue = 0; end
                    if (visited[39] == 0 && continue == 1) begin current_pos = 39; continue = 0; end
                    if (visited[40] == 0 && continue == 1) begin current_pos = 40; continue = 0; end
                    if (visited[41] == 0 && continue == 1) begin current_pos = 41; continue = 0; end
                    if (visited[48] == 0 && continue == 1) begin current_pos = 48; continue = 0; end
                    if (visited[49] == 0 && continue == 1) begin current_pos = 49; continue = 0; end
                end
                end else if (whichCell == 5)
                begin
                if (current_pos == 33)
                begin
                    current_pos = 34; continue = 1;
                    if (visited[34] == 0 && continue == 1) begin current_pos = 34; continue = 0; end
                    if (visited[35] == 0 && continue == 1) begin current_pos = 35; continue = 0; end
                    if (visited[42] == 0 && continue == 1) begin current_pos = 42; continue = 0; end
                    if (visited[43] == 0 && continue == 1) begin current_pos = 43; continue = 0; end
                    if (visited[44] == 0 && continue == 1) begin current_pos = 44; continue = 0; end
                    if (visited[51] == 0 && continue == 1) begin current_pos = 51; continue = 0; end
                    if (visited[52] == 0 && continue == 1) begin current_pos = 52; continue = 0; end
                    if (visited[53] == 0 && continue == 1) begin current_pos = 53; continue = 0; end
                end else if (current_pos == 34)
                begin
                    current_pos = 35; continue = 1;
                    if (visited[35] == 0 && continue == 1) begin current_pos = 35; continue = 0; end
                    if (visited[42] == 0 && continue == 1) begin current_pos = 42; continue = 0; end
                    if (visited[43] == 0 && continue == 1) begin current_pos = 43; continue = 0; end
                    if (visited[44] == 0 && continue == 1) begin current_pos = 44; continue = 0; end
                    if (visited[51] == 0 && continue == 1) begin current_pos = 51; continue = 0; end
                    if (visited[52] == 0 && continue == 1) begin current_pos = 52; continue = 0; end
                    if (visited[53] == 0 && continue == 1) begin current_pos = 53; continue = 0; end
                    if (visited[33] == 0 && continue == 1) begin current_pos = 33; continue = 0; end
                end else if (current_pos == 35)
                begin
                    current_pos = 42; continue = 1;
                    if (visited[42] == 0 && continue == 1) begin current_pos = 42; continue = 0; end
                    if (visited[43] == 0 && continue == 1) begin current_pos = 43; continue = 0; end
                    if (visited[44] == 0 && continue == 1) begin current_pos = 44; continue = 0; end
                    if (visited[51] == 0 && continue == 1) begin current_pos = 51; continue = 0; end
                    if (visited[52] == 0 && continue == 1) begin current_pos = 52; continue = 0; end
                    if (visited[53] == 0 && continue == 1) begin current_pos = 53; continue = 0; end
                    if (visited[33] == 0 && continue == 1) begin current_pos = 33; continue = 0; end
                    if (visited[34] == 0 && continue == 1) begin current_pos = 34; continue = 0; end
                end else if (current_pos == 42)
                begin
                    current_pos = 43; continue = 1;
                    if (visited[43] == 0 && continue == 1) begin current_pos = 43; continue = 0; end
                    if (visited[44] == 0 && continue == 1) begin current_pos = 44; continue = 0; end
                    if (visited[51] == 0 && continue == 1) begin current_pos = 51; continue = 0; end
                    if (visited[52] == 0 && continue == 1) begin current_pos = 52; continue = 0; end
                    if (visited[53] == 0 && continue == 1) begin current_pos = 53; continue = 0; end
                    if (visited[33] == 0 && continue == 1) begin current_pos = 33; continue = 0; end
                    if (visited[34] == 0 && continue == 1) begin current_pos = 34; continue = 0; end
                    if (visited[35] == 0 && continue == 1) begin current_pos = 35; continue = 0; end
                end else if (current_pos == 43)
                begin
                    current_pos = 44; continue = 1;
                    if (visited[44] == 0 && continue == 1) begin current_pos = 44; continue = 0; end
                    if (visited[51] == 0 && continue == 1) begin current_pos = 51; continue = 0; end
                    if (visited[52] == 0 && continue == 1) begin current_pos = 52; continue = 0; end
                    if (visited[53] == 0 && continue == 1) begin current_pos = 53; continue = 0; end
                    if (visited[33] == 0 && continue == 1) begin current_pos = 33; continue = 0; end
                    if (visited[34] == 0 && continue == 1) begin current_pos = 34; continue = 0; end
                    if (visited[35] == 0 && continue == 1) begin current_pos = 35; continue = 0; end
                    if (visited[42] == 0 && continue == 1) begin current_pos = 42; continue = 0; end
                end else if (current_pos == 44)
                begin
                    current_pos = 51; continue = 1;
                    if (visited[51] == 0 && continue == 1) begin current_pos = 51; continue = 0; end
                    if (visited[52] == 0 && continue == 1) begin current_pos = 52; continue = 0; end
                    if (visited[53] == 0 && continue == 1) begin current_pos = 53; continue = 0; end
                    if (visited[33] == 0 && continue == 1) begin current_pos = 33; continue = 0; end
                    if (visited[34] == 0 && continue == 1) begin current_pos = 34; continue = 0; end
                    if (visited[35] == 0 && continue == 1) begin current_pos = 35; continue = 0; end
                    if (visited[42] == 0 && continue == 1) begin current_pos = 42; continue = 0; end
                    if (visited[43] == 0 && continue == 1) begin current_pos = 43; continue = 0; end
                end else if (current_pos == 51)
                begin
                    current_pos = 52; continue = 1;
                    if (visited[52] == 0 && continue == 1) begin current_pos = 52; continue = 0; end
                    if (visited[53] == 0 && continue == 1) begin current_pos = 53; continue = 0; end
                    if (visited[33] == 0 && continue == 1) begin current_pos = 33; continue = 0; end
                    if (visited[34] == 0 && continue == 1) begin current_pos = 34; continue = 0; end
                    if (visited[35] == 0 && continue == 1) begin current_pos = 35; continue = 0; end
                    if (visited[42] == 0 && continue == 1) begin current_pos = 42; continue = 0; end
                    if (visited[43] == 0 && continue == 1) begin current_pos = 43; continue = 0; end
                    if (visited[44] == 0 && continue == 1) begin current_pos = 44; continue = 0; end
                end else if (current_pos == 52)
                begin
                    current_pos = 53; continue = 1;
                    if (visited[53] == 0 && continue == 1) begin current_pos = 53; continue = 0; end
                    if (visited[33] == 0 && continue == 1) begin current_pos = 33; continue = 0; end
                    if (visited[34] == 0 && continue == 1) begin current_pos = 34; continue = 0; end
                    if (visited[35] == 0 && continue == 1) begin current_pos = 35; continue = 0; end
                    if (visited[42] == 0 && continue == 1) begin current_pos = 42; continue = 0; end
                    if (visited[43] == 0 && continue == 1) begin current_pos = 43; continue = 0; end
                    if (visited[44] == 0 && continue == 1) begin current_pos = 44; continue = 0; end
                    if (visited[51] == 0 && continue == 1) begin current_pos = 51; continue = 0; end
                end else if (current_pos == 53)
                begin
                    current_pos = 33; continue = 1;
                    if (visited[33] == 0 && continue == 1) begin current_pos = 33; continue = 0; end
                    if (visited[34] == 0 && continue == 1) begin current_pos = 34; continue = 0; end
                    if (visited[35] == 0 && continue == 1) begin current_pos = 35; continue = 0; end
                    if (visited[42] == 0 && continue == 1) begin current_pos = 42; continue = 0; end
                    if (visited[43] == 0 && continue == 1) begin current_pos = 43; continue = 0; end
                    if (visited[44] == 0 && continue == 1) begin current_pos = 44; continue = 0; end
                    if (visited[51] == 0 && continue == 1) begin current_pos = 51; continue = 0; end
                    if (visited[52] == 0 && continue == 1) begin current_pos = 52; continue = 0; end
                end
                end else if (whichCell == 6)
                begin
                if (current_pos == 54)
                begin
                    current_pos = 55; continue = 1;
                    if (visited[55] == 0 && continue == 1) begin current_pos = 55; continue = 0; end
                    if (visited[56] == 0 && continue == 1) begin current_pos = 56; continue = 0; end
                    if (visited[63] == 0 && continue == 1) begin current_pos = 63; continue = 0; end
                    if (visited[64] == 0 && continue == 1) begin current_pos = 64; continue = 0; end
                    if (visited[65] == 0 && continue == 1) begin current_pos = 65; continue = 0; end
                    if (visited[72] == 0 && continue == 1) begin current_pos = 72; continue = 0; end
                    if (visited[73] == 0 && continue == 1) begin current_pos = 73; continue = 0; end
                    if (visited[74] == 0 && continue == 1) begin current_pos = 74; continue = 0; end
                end else if (current_pos == 55)
                begin
                    current_pos = 56; continue = 1;
                    if (visited[56] == 0 && continue == 1) begin current_pos = 56; continue = 0; end
                    if (visited[63] == 0 && continue == 1) begin current_pos = 63; continue = 0; end
                    if (visited[64] == 0 && continue == 1) begin current_pos = 64; continue = 0; end
                    if (visited[65] == 0 && continue == 1) begin current_pos = 65; continue = 0; end
                    if (visited[72] == 0 && continue == 1) begin current_pos = 72; continue = 0; end
                    if (visited[73] == 0 && continue == 1) begin current_pos = 73; continue = 0; end
                    if (visited[74] == 0 && continue == 1) begin current_pos = 74; continue = 0; end
                    if (visited[54] == 0 && continue == 1) begin current_pos = 54; continue = 0; end
                end else if (current_pos == 56)
                begin
                    current_pos = 63; continue = 1;
                    if (visited[63] == 0 && continue == 1) begin current_pos = 63; continue = 0; end
                    if (visited[64] == 0 && continue == 1) begin current_pos = 64; continue = 0; end
                    if (visited[65] == 0 && continue == 1) begin current_pos = 65; continue = 0; end
                    if (visited[72] == 0 && continue == 1) begin current_pos = 72; continue = 0; end
                    if (visited[73] == 0 && continue == 1) begin current_pos = 73; continue = 0; end
                    if (visited[74] == 0 && continue == 1) begin current_pos = 74; continue = 0; end
                    if (visited[54] == 0 && continue == 1) begin current_pos = 54; continue = 0; end
                    if (visited[55] == 0 && continue == 1) begin current_pos = 55; continue = 0; end
                end else if (current_pos == 63)
                begin
                    current_pos = 64; continue = 1;
                    if (visited[64] == 0 && continue == 1) begin current_pos = 64; continue = 0; end
                    if (visited[65] == 0 && continue == 1) begin current_pos = 65; continue = 0; end
                    if (visited[72] == 0 && continue == 1) begin current_pos = 72; continue = 0; end
                    if (visited[73] == 0 && continue == 1) begin current_pos = 73; continue = 0; end
                    if (visited[74] == 0 && continue == 1) begin current_pos = 74; continue = 0; end
                    if (visited[54] == 0 && continue == 1) begin current_pos = 54; continue = 0; end
                    if (visited[55] == 0 && continue == 1) begin current_pos = 55; continue = 0; end
                    if (visited[56] == 0 && continue == 1) begin current_pos = 56; continue = 0; end
                end else if (current_pos == 64)
                begin
                    current_pos = 65; continue = 1;
                    if (visited[65] == 0 && continue == 1) begin current_pos = 65; continue = 0; end
                    if (visited[72] == 0 && continue == 1) begin current_pos = 72; continue = 0; end
                    if (visited[73] == 0 && continue == 1) begin current_pos = 73; continue = 0; end
                    if (visited[74] == 0 && continue == 1) begin current_pos = 74; continue = 0; end
                    if (visited[54] == 0 && continue == 1) begin current_pos = 54; continue = 0; end
                    if (visited[55] == 0 && continue == 1) begin current_pos = 55; continue = 0; end
                    if (visited[56] == 0 && continue == 1) begin current_pos = 56; continue = 0; end
                    if (visited[63] == 0 && continue == 1) begin current_pos = 63; continue = 0; end
                end else if (current_pos == 65)
                begin
                    current_pos = 72; continue = 1;
                    if (visited[72] == 0 && continue == 1) begin current_pos = 72; continue = 0; end
                    if (visited[73] == 0 && continue == 1) begin current_pos = 73; continue = 0; end
                    if (visited[74] == 0 && continue == 1) begin current_pos = 74; continue = 0; end
                    if (visited[54] == 0 && continue == 1) begin current_pos = 54; continue = 0; end
                    if (visited[55] == 0 && continue == 1) begin current_pos = 55; continue = 0; end
                    if (visited[56] == 0 && continue == 1) begin current_pos = 56; continue = 0; end
                    if (visited[63] == 0 && continue == 1) begin current_pos = 63; continue = 0; end
                    if (visited[64] == 0 && continue == 1) begin current_pos = 64; continue = 0; end
                end else if (current_pos == 72)
                begin
                    current_pos = 73; continue = 1;
                    if (visited[73] == 0 && continue == 1) begin current_pos = 73; continue = 0; end
                    if (visited[74] == 0 && continue == 1) begin current_pos = 74; continue = 0; end
                    if (visited[54] == 0 && continue == 1) begin current_pos = 54; continue = 0; end
                    if (visited[55] == 0 && continue == 1) begin current_pos = 55; continue = 0; end
                    if (visited[56] == 0 && continue == 1) begin current_pos = 56; continue = 0; end
                    if (visited[63] == 0 && continue == 1) begin current_pos = 63; continue = 0; end
                    if (visited[64] == 0 && continue == 1) begin current_pos = 64; continue = 0; end
                    if (visited[65] == 0 && continue == 1) begin current_pos = 65; continue = 0; end
                end else if (current_pos == 73)
                begin
                    current_pos = 74; continue = 1;
                    if (visited[74] == 0 && continue == 1) begin current_pos = 74; continue = 0; end
                    if (visited[54] == 0 && continue == 1) begin current_pos = 54; continue = 0; end
                    if (visited[55] == 0 && continue == 1) begin current_pos = 55; continue = 0; end
                    if (visited[56] == 0 && continue == 1) begin current_pos = 56; continue = 0; end
                    if (visited[63] == 0 && continue == 1) begin current_pos = 63; continue = 0; end
                    if (visited[64] == 0 && continue == 1) begin current_pos = 64; continue = 0; end
                    if (visited[65] == 0 && continue == 1) begin current_pos = 65; continue = 0; end
                    if (visited[72] == 0 && continue == 1) begin current_pos = 72; continue = 0; end
                end else if (current_pos == 74)
                begin
                    current_pos = 54; continue = 1;
                    if (visited[54] == 0 && continue == 1) begin current_pos = 54; continue = 0; end
                    if (visited[55] == 0 && continue == 1) begin current_pos = 55; continue = 0; end
                    if (visited[56] == 0 && continue == 1) begin current_pos = 56; continue = 0; end
                    if (visited[63] == 0 && continue == 1) begin current_pos = 63; continue = 0; end
                    if (visited[64] == 0 && continue == 1) begin current_pos = 64; continue = 0; end
                    if (visited[65] == 0 && continue == 1) begin current_pos = 65; continue = 0; end
                    if (visited[72] == 0 && continue == 1) begin current_pos = 72; continue = 0; end
                    if (visited[73] == 0 && continue == 1) begin current_pos = 73; continue = 0; end
                end
                end else if (whichCell == 7)
                begin
                if (current_pos == 57)
                begin
                    current_pos = 58; continue = 1;
                    if (visited[58] == 0 && continue == 1) begin current_pos = 58; continue = 0; end
                    if (visited[59] == 0 && continue == 1) begin current_pos = 59; continue = 0; end
                    if (visited[66] == 0 && continue == 1) begin current_pos = 66; continue = 0; end
                    if (visited[67] == 0 && continue == 1) begin current_pos = 67; continue = 0; end
                    if (visited[68] == 0 && continue == 1) begin current_pos = 68; continue = 0; end
                    if (visited[75] == 0 && continue == 1) begin current_pos = 75; continue = 0; end
                    if (visited[76] == 0 && continue == 1) begin current_pos = 76; continue = 0; end
                    if (visited[77] == 0 && continue == 1) begin current_pos = 77; continue = 0; end
                end else if (current_pos == 58)
                begin
                    current_pos = 59; continue = 1;
                    if (visited[59] == 0 && continue == 1) begin current_pos = 59; continue = 0; end
                    if (visited[66] == 0 && continue == 1) begin current_pos = 66; continue = 0; end
                    if (visited[67] == 0 && continue == 1) begin current_pos = 67; continue = 0; end
                    if (visited[68] == 0 && continue == 1) begin current_pos = 68; continue = 0; end
                    if (visited[75] == 0 && continue == 1) begin current_pos = 75; continue = 0; end
                    if (visited[76] == 0 && continue == 1) begin current_pos = 76; continue = 0; end
                    if (visited[77] == 0 && continue == 1) begin current_pos = 77; continue = 0; end
                    if (visited[57] == 0 && continue == 1) begin current_pos = 57; continue = 0; end
                end else if (current_pos == 59)
                begin
                    current_pos = 66; continue = 1;
                    if (visited[66] == 0 && continue == 1) begin current_pos = 66; continue = 0; end
                    if (visited[67] == 0 && continue == 1) begin current_pos = 67; continue = 0; end
                    if (visited[68] == 0 && continue == 1) begin current_pos = 68; continue = 0; end
                    if (visited[75] == 0 && continue == 1) begin current_pos = 75; continue = 0; end
                    if (visited[76] == 0 && continue == 1) begin current_pos = 76; continue = 0; end
                    if (visited[77] == 0 && continue == 1) begin current_pos = 77; continue = 0; end
                    if (visited[57] == 0 && continue == 1) begin current_pos = 57; continue = 0; end
                    if (visited[58] == 0 && continue == 1) begin current_pos = 58; continue = 0; end
                end else if (current_pos == 66)
                begin
                    current_pos = 67; continue = 1;
                    if (visited[67] == 0 && continue == 1) begin current_pos = 67; continue = 0; end
                    if (visited[68] == 0 && continue == 1) begin current_pos = 68; continue = 0; end
                    if (visited[75] == 0 && continue == 1) begin current_pos = 75; continue = 0; end
                    if (visited[76] == 0 && continue == 1) begin current_pos = 76; continue = 0; end
                    if (visited[77] == 0 && continue == 1) begin current_pos = 77; continue = 0; end
                    if (visited[57] == 0 && continue == 1) begin current_pos = 57; continue = 0; end
                    if (visited[58] == 0 && continue == 1) begin current_pos = 58; continue = 0; end
                    if (visited[59] == 0 && continue == 1) begin current_pos = 59; continue = 0; end
                end else if (current_pos == 67)
                begin
                    current_pos = 68; continue = 1;
                    if (visited[68] == 0 && continue == 1) begin current_pos = 68; continue = 0; end
                    if (visited[75] == 0 && continue == 1) begin current_pos = 75; continue = 0; end
                    if (visited[76] == 0 && continue == 1) begin current_pos = 76; continue = 0; end
                    if (visited[77] == 0 && continue == 1) begin current_pos = 77; continue = 0; end
                    if (visited[57] == 0 && continue == 1) begin current_pos = 57; continue = 0; end
                    if (visited[58] == 0 && continue == 1) begin current_pos = 58; continue = 0; end
                    if (visited[59] == 0 && continue == 1) begin current_pos = 59; continue = 0; end
                    if (visited[66] == 0 && continue == 1) begin current_pos = 66; continue = 0; end
                end else if (current_pos == 68)
                begin
                    current_pos = 75; continue = 1;
                    if (visited[75] == 0 && continue == 1) begin current_pos = 75; continue = 0; end
                    if (visited[76] == 0 && continue == 1) begin current_pos = 76; continue = 0; end
                    if (visited[77] == 0 && continue == 1) begin current_pos = 77; continue = 0; end
                    if (visited[57] == 0 && continue == 1) begin current_pos = 57; continue = 0; end
                    if (visited[58] == 0 && continue == 1) begin current_pos = 58; continue = 0; end
                    if (visited[59] == 0 && continue == 1) begin current_pos = 59; continue = 0; end
                    if (visited[66] == 0 && continue == 1) begin current_pos = 66; continue = 0; end
                    if (visited[67] == 0 && continue == 1) begin current_pos = 67; continue = 0; end
                end else if (current_pos == 75)
                begin
                    current_pos = 76; continue = 1;
                    if (visited[76] == 0 && continue == 1) begin current_pos = 76; continue = 0; end
                    if (visited[77] == 0 && continue == 1) begin current_pos = 77; continue = 0; end
                    if (visited[57] == 0 && continue == 1) begin current_pos = 57; continue = 0; end
                    if (visited[58] == 0 && continue == 1) begin current_pos = 58; continue = 0; end
                    if (visited[59] == 0 && continue == 1) begin current_pos = 59; continue = 0; end
                    if (visited[66] == 0 && continue == 1) begin current_pos = 66; continue = 0; end
                    if (visited[67] == 0 && continue == 1) begin current_pos = 67; continue = 0; end
                    if (visited[68] == 0 && continue == 1) begin current_pos = 68; continue = 0; end
                end else if (current_pos == 76)
                begin
                    current_pos = 77; continue = 1;
                    if (visited[77] == 0 && continue == 1) begin current_pos = 77; continue = 0; end
                    if (visited[57] == 0 && continue == 1) begin current_pos = 57; continue = 0; end
                    if (visited[58] == 0 && continue == 1) begin current_pos = 58; continue = 0; end
                    if (visited[59] == 0 && continue == 1) begin current_pos = 59; continue = 0; end
                    if (visited[66] == 0 && continue == 1) begin current_pos = 66; continue = 0; end
                    if (visited[67] == 0 && continue == 1) begin current_pos = 67; continue = 0; end
                    if (visited[68] == 0 && continue == 1) begin current_pos = 68; continue = 0; end
                    if (visited[75] == 0 && continue == 1) begin current_pos = 75; continue = 0; end
                end else if (current_pos == 77)
                begin
                    current_pos = 57; continue = 1;
                    if (visited[57] == 0 && continue == 1) begin current_pos = 57; continue = 0; end
                    if (visited[58] == 0 && continue == 1) begin current_pos = 58; continue = 0; end
                    if (visited[59] == 0 && continue == 1) begin current_pos = 59; continue = 0; end
                    if (visited[66] == 0 && continue == 1) begin current_pos = 66; continue = 0; end
                    if (visited[67] == 0 && continue == 1) begin current_pos = 67; continue = 0; end
                    if (visited[68] == 0 && continue == 1) begin current_pos = 68; continue = 0; end
                    if (visited[75] == 0 && continue == 1) begin current_pos = 75; continue = 0; end
                    if (visited[76] == 0 && continue == 1) begin current_pos = 76; continue = 0; end
                end
                end else if (whichCell == 8) 
                begin
                if (current_pos == 60)
                begin
                    current_pos = 61; continue = 1;
                    if (visited[61] == 0 && continue == 1) begin current_pos = 61; continue = 0; end
                    if (visited[62] == 0 && continue == 1) begin current_pos = 62; continue = 0; end
                    if (visited[69] == 0 && continue == 1) begin current_pos = 69; continue = 0; end
                    if (visited[70] == 0 && continue == 1) begin current_pos = 70; continue = 0; end
                    if (visited[71] == 0 && continue == 1) begin current_pos = 71; continue = 0; end
                    if (visited[78] == 0 && continue == 1) begin current_pos = 78; continue = 0; end
                    if (visited[79] == 0 && continue == 1) begin current_pos = 79; continue = 0; end
                    if (visited[80] == 0 && continue == 1) begin current_pos = 80; continue = 0; end
                end else if (current_pos == 61)
                begin
                    current_pos = 62; continue = 1;
                    if (visited[62] == 0 && continue == 1) begin current_pos = 62; continue = 0; end
                    if (visited[69] == 0 && continue == 1) begin current_pos = 69; continue = 0; end
                    if (visited[70] == 0 && continue == 1) begin current_pos = 70; continue = 0; end
                    if (visited[71] == 0 && continue == 1) begin current_pos = 71; continue = 0; end
                    if (visited[78] == 0 && continue == 1) begin current_pos = 78; continue = 0; end
                    if (visited[79] == 0 && continue == 1) begin current_pos = 79; continue = 0; end
                    if (visited[80] == 0 && continue == 1) begin current_pos = 80; continue = 0; end
                    if (visited[60] == 0 && continue == 1) begin current_pos = 60; continue = 0; end
                end else if (current_pos == 62)
                begin
                    current_pos = 69; continue = 1;
                    if (visited[69] == 0 && continue == 1) begin current_pos = 69; continue = 0; end
                    if (visited[70] == 0 && continue == 1) begin current_pos = 70; continue = 0; end
                    if (visited[71] == 0 && continue == 1) begin current_pos = 71; continue = 0; end
                    if (visited[78] == 0 && continue == 1) begin current_pos = 78; continue = 0; end
                    if (visited[79] == 0 && continue == 1) begin current_pos = 79; continue = 0; end
                    if (visited[80] == 0 && continue == 1) begin current_pos = 80; continue = 0; end
                    if (visited[60] == 0 && continue == 1) begin current_pos = 60; continue = 0; end
                    if (visited[61] == 0 && continue == 1) begin current_pos = 61; continue = 0; end
                end else if (current_pos == 69)
                begin
                    current_pos = 70; continue = 1;
                    if (visited[70] == 0 && continue == 1) begin current_pos = 70; continue = 0; end
                    if (visited[71] == 0 && continue == 1) begin current_pos = 71; continue = 0; end
                    if (visited[78] == 0 && continue == 1) begin current_pos = 78; continue = 0; end
                    if (visited[79] == 0 && continue == 1) begin current_pos = 79; continue = 0; end
                    if (visited[80] == 0 && continue == 1) begin current_pos = 80; continue = 0; end
                    if (visited[60] == 0 && continue == 1) begin current_pos = 60; continue = 0; end
                    if (visited[61] == 0 && continue == 1) begin current_pos = 61; continue = 0; end
                    if (visited[62] == 0 && continue == 1) begin current_pos = 62; continue = 0; end
                end else if (current_pos == 70)
                begin
                    current_pos = 71; continue = 1;
                    if (visited[71] == 0 && continue == 1) begin current_pos = 71; continue = 0; end
                    if (visited[78] == 0 && continue == 1) begin current_pos = 78; continue = 0; end
                    if (visited[79] == 0 && continue == 1) begin current_pos = 79; continue = 0; end
                    if (visited[80] == 0 && continue == 1) begin current_pos = 80; continue = 0; end
                    if (visited[60] == 0 && continue == 1) begin current_pos = 60; continue = 0; end
                    if (visited[61] == 0 && continue == 1) begin current_pos = 61; continue = 0; end
                    if (visited[62] == 0 && continue == 1) begin current_pos = 62; continue = 0; end
                    if (visited[69] == 0 && continue == 1) begin current_pos = 69; continue = 0; end
                end else if (current_pos == 71)
                begin
                    current_pos = 78; continue = 1;
                    if (visited[78] == 0 && continue == 1) begin current_pos = 78; continue = 0; end
                    if (visited[79] == 0 && continue == 1) begin current_pos = 79; continue = 0; end
                    if (visited[80] == 0 && continue == 1) begin current_pos = 80; continue = 0; end
                    if (visited[60] == 0 && continue == 1) begin current_pos = 60; continue = 0; end
                    if (visited[61] == 0 && continue == 1) begin current_pos = 61; continue = 0; end
                    if (visited[62] == 0 && continue == 1) begin current_pos = 62; continue = 0; end
                    if (visited[69] == 0 && continue == 1) begin current_pos = 69; continue = 0; end
                    if (visited[70] == 0 && continue == 1) begin current_pos = 70; continue = 0; end
                end else if (current_pos == 78)
                begin
                    current_pos = 79; continue = 1;
                    if (visited[79] == 0 && continue == 1) begin current_pos = 79; continue = 0; end
                    if (visited[80] == 0 && continue == 1) begin current_pos = 80; continue = 0; end
                    if (visited[60] == 0 && continue == 1) begin current_pos = 60; continue = 0; end
                    if (visited[61] == 0 && continue == 1) begin current_pos = 61; continue = 0; end
                    if (visited[62] == 0 && continue == 1) begin current_pos = 62; continue = 0; end
                    if (visited[69] == 0 && continue == 1) begin current_pos = 69; continue = 0; end
                    if (visited[70] == 0 && continue == 1) begin current_pos = 70; continue = 0; end
                    if (visited[71] == 0 && continue == 1) begin current_pos = 71; continue = 0; end
                end else if (current_pos == 79)
                begin
                    current_pos = 80; continue = 1;
                    if (visited[80] == 0 && continue == 1) begin current_pos = 80; continue = 0; end
                    if (visited[60] == 0 && continue == 1) begin current_pos = 60; continue = 0; end
                    if (visited[61] == 0 && continue == 1) begin current_pos = 61; continue = 0; end
                    if (visited[62] == 0 && continue == 1) begin current_pos = 62; continue = 0; end
                    if (visited[69] == 0 && continue == 1) begin current_pos = 69; continue = 0; end
                    if (visited[70] == 0 && continue == 1) begin current_pos = 70; continue = 0; end
                    if (visited[71] == 0 && continue == 1) begin current_pos = 71; continue = 0; end
                    if (visited[78] == 0 && continue == 1) begin current_pos = 78; continue = 0; end
                end else if (current_pos == 80)
                begin
                    current_pos = 60; continue = 1;
                    if (visited[60] == 0 && continue == 1) begin current_pos = 60; continue = 0; end
                    if (visited[61] == 0 && continue == 1) begin current_pos = 61; continue = 0; end
                    if (visited[62] == 0 && continue == 1) begin current_pos = 62; continue = 0; end
                    if (visited[69] == 0 && continue == 1) begin current_pos = 69; continue = 0; end
                    if (visited[70] == 0 && continue == 1) begin current_pos = 70; continue = 0; end
                    if (visited[71] == 0 && continue == 1) begin current_pos = 71; continue = 0; end
                    if (visited[78] == 0 && continue == 1) begin current_pos = 78; continue = 0; end
                    if (visited[79] == 0 && continue == 1) begin current_pos = 79; continue = 0; end
                end
                end else if (whichCell == 9)
                begin
                    current_pos = current_pos + 1; continue = 1;
                    if (visited[(current_pos + 0) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 0) % 81); continue = 0; end
                    if (visited[(current_pos + 1) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 1) % 81); continue = 0; end
                    if (visited[(current_pos + 2) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 2) % 81); continue = 0; end
                    if (visited[(current_pos + 3) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 3) % 81); continue = 0; end
                    if (visited[(current_pos + 4) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 4) % 81); continue = 0; end
                    if (visited[(current_pos + 5) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 5) % 81); continue = 0; end
                    if (visited[(current_pos + 6) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 6) % 81); continue = 0; end
                    if (visited[(current_pos + 7) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 7) % 81); continue = 0; end
                    if (visited[(current_pos + 8) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 8) % 81); continue = 0; end
                    if (visited[(current_pos + 9) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 9) % 81); continue = 0; end
                    if (visited[(current_pos + 10) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 10) % 81); continue = 0; end
                    if (visited[(current_pos + 11) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 11) % 81); continue = 0; end
                    if (visited[(current_pos + 12) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 12) % 81); continue = 0; end
                    if (visited[(current_pos + 13) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 13) % 81); continue = 0; end
                    if (visited[(current_pos + 14) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 14) % 81); continue = 0; end
                    if (visited[(current_pos + 15) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 15) % 81); continue = 0; end
                    if (visited[(current_pos + 16) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 16) % 81); continue = 0; end
                    if (visited[(current_pos + 17) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 17) % 81); continue = 0; end
                    if (visited[(current_pos + 18) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 18) % 81); continue = 0; end
                    if (visited[(current_pos + 19) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 19) % 81); continue = 0; end
                    if (visited[(current_pos + 20) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 20) % 81); continue = 0; end
                    if (visited[(current_pos + 21) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 21) % 81); continue = 0; end
                    if (visited[(current_pos + 22) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 22) % 81); continue = 0; end
                    if (visited[(current_pos + 23) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 23) % 81); continue = 0; end
                    if (visited[(current_pos + 24) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 24) % 81); continue = 0; end
                    if (visited[(current_pos + 25) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 25) % 81); continue = 0; end
                    if (visited[(current_pos + 26) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 26) % 81); continue = 0; end
                    if (visited[(current_pos + 27) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 27) % 81); continue = 0; end
                    if (visited[(current_pos + 28) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 28) % 81); continue = 0; end
                    if (visited[(current_pos + 29) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 29) % 81); continue = 0; end
                    if (visited[(current_pos + 30) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 30) % 81); continue = 0; end
                    if (visited[(current_pos + 31) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 31) % 81); continue = 0; end
                    if (visited[(current_pos + 32) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 32) % 81); continue = 0; end
                    if (visited[(current_pos + 33) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 33) % 81); continue = 0; end
                    if (visited[(current_pos + 34) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 34) % 81); continue = 0; end
                    if (visited[(current_pos + 35) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 35) % 81); continue = 0; end
                    if (visited[(current_pos + 36) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 36) % 81); continue = 0; end
                    if (visited[(current_pos + 37) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 37) % 81); continue = 0; end
                    if (visited[(current_pos + 38) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 38) % 81); continue = 0; end
                    if (visited[(current_pos + 39) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 39) % 81); continue = 0; end
                    if (visited[(current_pos + 40) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 40) % 81); continue = 0; end
                    if (visited[(current_pos + 41) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 41) % 81); continue = 0; end
                    if (visited[(current_pos + 42) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 42) % 81); continue = 0; end
                    if (visited[(current_pos + 43) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 43) % 81); continue = 0; end
                    if (visited[(current_pos + 44) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 44) % 81); continue = 0; end
                    if (visited[(current_pos + 45) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 45) % 81); continue = 0; end
                    if (visited[(current_pos + 46) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 46) % 81); continue = 0; end
                    if (visited[(current_pos + 47) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 47) % 81); continue = 0; end
                    if (visited[(current_pos + 48) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 48) % 81); continue = 0; end
                    if (visited[(current_pos + 49) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 49) % 81); continue = 0; end
                    if (visited[(current_pos + 50) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 50) % 81); continue = 0; end
                    if (visited[(current_pos + 51) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 51) % 81); continue = 0; end
                    if (visited[(current_pos + 52) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 52) % 81); continue = 0; end
                    if (visited[(current_pos + 53) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 53) % 81); continue = 0; end
                    if (visited[(current_pos + 54) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 54) % 81); continue = 0; end
                    if (visited[(current_pos + 55) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 55) % 81); continue = 0; end
                    if (visited[(current_pos + 56) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 56) % 81); continue = 0; end
                    if (visited[(current_pos + 57) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 57) % 81); continue = 0; end
                    if (visited[(current_pos + 58) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 58) % 81); continue = 0; end
                    if (visited[(current_pos + 59) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 59) % 81); continue = 0; end
                    if (visited[(current_pos + 60) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 60) % 81); continue = 0; end
                    if (visited[(current_pos + 61) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 61) % 81); continue = 0; end
                    if (visited[(current_pos + 62) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 62) % 81); continue = 0; end
                    if (visited[(current_pos + 63) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 63) % 81); continue = 0; end
                    if (visited[(current_pos + 64) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 64) % 81); continue = 0; end
                    if (visited[(current_pos + 65) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 65) % 81); continue = 0; end
                    if (visited[(current_pos + 66) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 66) % 81); continue = 0; end
                    if (visited[(current_pos + 67) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 67) % 81); continue = 0; end
                    if (visited[(current_pos + 68) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 68) % 81); continue = 0; end
                    if (visited[(current_pos + 69) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 69) % 81); continue = 0; end
                    if (visited[(current_pos + 70) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 70) % 81); continue = 0; end
                    if (visited[(current_pos + 71) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 71) % 81); continue = 0; end
                    if (visited[(current_pos + 72) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 72) % 81); continue = 0; end
                    if (visited[(current_pos + 73) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 73) % 81); continue = 0; end
                    if (visited[(current_pos + 74) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 74) % 81); continue = 0; end
                    if (visited[(current_pos + 75) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 75) % 81); continue = 0; end
                    if (visited[(current_pos + 76) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 76) % 81); continue = 0; end
                    if (visited[(current_pos + 77) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 77) % 81); continue = 0; end
                    if (visited[(current_pos + 78) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 78) % 81); continue = 0; end
                    if (visited[(current_pos + 79) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 79) % 81); continue = 0; end
                    if (visited[(current_pos + 80) % 81] == 0 && continue == 1) begin current_pos = ((current_pos + 80) % 81); continue = 0; end
                end
            end    
            
            if (confirm == 1)
            begin
                if ((current_pos == 0 || current_pos == 3 || current_pos == 6 || current_pos == 27 || current_pos == 30 || current_pos == 33 ||
                     current_pos == 54 || current_pos == 57 || current_pos == 60) && win01[0] != 1)
                begin
                    whichCell = 0;
                    current_pos = 0; continue = 1;
                    if (visited[0] == 0 && continue == 1) begin current_pos = 0; continue = 0; end 
                    if (visited[1] == 0 && continue == 1) begin current_pos = 1; continue = 0; end
                    if (visited[2] == 0 && continue == 1) begin current_pos = 2; continue = 0; end
                    if (visited[9] == 0 && continue == 1) begin current_pos = 9; continue = 0; end
                    if (visited[10] == 0 && continue == 1) begin current_pos = 10; continue = 0; end
                    if (visited[11] == 0 && continue == 1) begin current_pos = 11; continue = 0; end
                    if (visited[18] == 0 && continue == 1) begin current_pos = 18; continue = 0; end
                    if (visited[19] == 0 && continue == 1) begin current_pos = 19; continue = 0; end
                    if (visited[20] == 0 && continue == 1) begin current_pos = 20; continue = 0; end
                end else if ((current_pos == 1 || current_pos == 4 || current_pos == 7 || current_pos == 28 || current_pos == 31 || current_pos == 34 ||
                              current_pos == 55 || current_pos == 58 || current_pos == 61) && win01[1] != 1)
                begin
                    whichCell = 1;
                    current_pos = 3; continue = 1;
                    if (visited[3] == 0 && continue == 1) begin current_pos = 3; continue = 0; end 
                    if (visited[4] == 0 && continue == 1) begin current_pos = 4; continue = 0; end
                    if (visited[5] == 0 && continue == 1) begin current_pos = 5; continue = 0; end
                    if (visited[12] == 0 && continue == 1) begin current_pos = 12; continue = 0; end
                    if (visited[13] == 0 && continue == 1) begin current_pos = 13; continue = 0; end
                    if (visited[14] == 0 && continue == 1) begin current_pos = 14; continue = 0; end
                    if (visited[21] == 0 && continue == 1) begin current_pos = 21; continue = 0; end
                    if (visited[22] == 0 && continue == 1) begin current_pos = 22; continue = 0; end
                    if (visited[23] == 0 && continue == 1) begin current_pos = 23; continue = 0; end
                end else if ((current_pos == 2 || current_pos == 5 || current_pos == 8 || current_pos == 29 || current_pos == 32 || current_pos == 35 ||
                              current_pos == 56 || current_pos == 59 || current_pos == 62) && win01[2] != 1)
                begin
                    whichCell = 2;
                    current_pos = 6; continue = 1;
                    if (visited[6] == 0 && continue == 1) begin current_pos = 6; continue = 0; end  
                    if (visited[7] == 0 && continue == 1) begin current_pos = 7; continue = 0; end
                    if (visited[8] == 0 && continue == 1) begin current_pos = 8; continue = 0; end
                    if (visited[15] == 0 && continue == 1) begin current_pos = 15; continue = 0; end
                    if (visited[16] == 0 && continue == 1) begin current_pos = 16; continue = 0; end
                    if (visited[17] == 0 && continue == 1) begin current_pos = 17; continue = 0; end
                    if (visited[24] == 0 && continue == 1) begin current_pos = 24; continue = 0; end
                    if (visited[25] == 0 && continue == 1) begin current_pos = 25; continue = 0; end
                    if (visited[26] == 0 && continue == 1) begin current_pos = 26; continue = 0; end
                end else if ((current_pos == 9 || current_pos == 12 || current_pos == 15 || current_pos == 36 || current_pos == 39 || current_pos == 42 ||
                              current_pos == 63 || current_pos == 66 || current_pos == 69) && win01[3] != 1)
                begin
                    whichCell = 3;
                    current_pos = 27; continue = 1;
                    if (visited[27] == 0 && continue == 1) begin current_pos = 27; continue = 0; end
                    if (visited[28] == 0 && continue == 1) begin current_pos = 28; continue = 0; end
                    if (visited[29] == 0 && continue == 1) begin current_pos = 29; continue = 0; end
                    if (visited[36] == 0 && continue == 1) begin current_pos = 36; continue = 0; end
                    if (visited[37] == 0 && continue == 1) begin current_pos = 37; continue = 0; end
                    if (visited[38] == 0 && continue == 1) begin current_pos = 38; continue = 0; end
                    if (visited[45] == 0 && continue == 1) begin current_pos = 45; continue = 0; end
                    if (visited[46] == 0 && continue == 1) begin current_pos = 46; continue = 0; end
                    if (visited[47] == 0 && continue == 1) begin current_pos = 47; continue = 0; end
                end else if ((current_pos == 10 || current_pos == 13 || current_pos == 16 || current_pos == 37 || current_pos == 40 || current_pos == 43 ||
                              current_pos == 64 || current_pos == 67 || current_pos == 70) && win01[4] != 1)
                begin
                    whichCell = 4;
                    current_pos = 30; continue = 1;
                    if (visited[30] == 0 && continue == 1) begin current_pos = 30; continue = 0; end
                    if (visited[31] == 0 && continue == 1) begin current_pos = 31; continue = 0; end
                    if (visited[32] == 0 && continue == 1) begin current_pos = 32; continue = 0; end
                    if (visited[39] == 0 && continue == 1) begin current_pos = 39; continue = 0; end
                    if (visited[40] == 0 && continue == 1) begin current_pos = 40; continue = 0; end
                    if (visited[41] == 0 && continue == 1) begin current_pos = 41; continue = 0; end
                    if (visited[48] == 0 && continue == 1) begin current_pos = 48; continue = 0; end
                    if (visited[49] == 0 && continue == 1) begin current_pos = 49; continue = 0; end
                    if (visited[50] == 0 && continue == 1) begin current_pos = 50; continue = 0; end
                end else if ((current_pos == 11 || current_pos == 14 || current_pos == 17 || current_pos == 38 || current_pos == 41 || current_pos == 44 ||
                      current_pos == 65 || current_pos == 68 || current_pos == 71) && win01[5] != 1)
                begin 
                    whichCell = 5;
                    current_pos = 33; continue = 1;
                    if (visited[33] == 0 && continue == 1) begin current_pos = 33; continue = 0; end
                    if (visited[34] == 0 && continue == 1) begin current_pos = 34; continue = 0; end
                    if (visited[35] == 0 && continue == 1) begin current_pos = 35; continue = 0; end
                    if (visited[42] == 0 && continue == 1) begin current_pos = 42; continue = 0; end
                    if (visited[43] == 0 && continue == 1) begin current_pos = 43; continue = 0; end
                    if (visited[44] == 0 && continue == 1) begin current_pos = 44; continue = 0; end
                    if (visited[51] == 0 && continue == 1) begin current_pos = 51; continue = 0; end
                    if (visited[52] == 0 && continue == 1) begin current_pos = 52; continue = 0; end
                    if (visited[53] == 0 && continue == 1) begin current_pos = 53; continue = 0; end    
                end else if ((current_pos == 18 || current_pos == 21 || current_pos == 24 || current_pos == 45 || current_pos == 48 || current_pos == 51 ||
                      current_pos == 72 || current_pos == 75 || current_pos == 78) && win01[6] != 1)
                begin
                    whichCell = 6;
                    current_pos = 54; continue = 1;
                    if (visited[54] == 0 && continue == 1) begin current_pos = 54; continue = 0; end
                    if (visited[55] == 0 && continue == 1) begin current_pos = 55; continue = 0; end
                    if (visited[56] == 0 && continue == 1) begin current_pos = 56; continue = 0; end
                    if (visited[63] == 0 && continue == 1) begin current_pos = 63; continue = 0; end
                    if (visited[64] == 0 && continue == 1) begin current_pos = 64; continue = 0; end
                    if (visited[65] == 0 && continue == 1) begin current_pos = 65; continue = 0; end
                    if (visited[72] == 0 && continue == 1) begin current_pos = 72; continue = 0; end
                    if (visited[73] == 0 && continue == 1) begin current_pos = 73; continue = 0; end
                    if (visited[74] == 0 && continue == 1) begin current_pos = 74; continue = 0; end                                           
                end else if ((current_pos == 19 || current_pos == 22 || current_pos == 25 || current_pos == 46 || current_pos == 49 || current_pos == 52 ||
                      current_pos == 73 || current_pos == 76 || current_pos == 79) && win01[7] != 1)
                begin
                    whichCell = 7;
                    current_pos = 57; continue = 1;
                    if (visited[57] == 0 && continue == 1) begin current_pos = 57; continue = 0; end
                    if (visited[58] == 0 && continue == 1) begin current_pos = 58; continue = 0; end
                    if (visited[59] == 0 && continue == 1) begin current_pos = 59; continue = 0; end
                    if (visited[66] == 0 && continue == 1) begin current_pos = 66; continue = 0; end
                    if (visited[67] == 0 && continue == 1) begin current_pos = 67; continue = 0; end
                    if (visited[68] == 0 && continue == 1) begin current_pos = 68; continue = 0; end
                    if (visited[75] == 0 && continue == 1) begin current_pos = 75; continue = 0; end
                    if (visited[76] == 0 && continue == 1) begin current_pos = 76; continue = 0; end
                    if (visited[77] == 0 && continue == 1) begin current_pos = 77; continue = 0; end                              
                end else if ((current_pos == 20 || current_pos == 23 || current_pos == 26 || current_pos == 47 || current_pos == 50 || current_pos == 53 ||
                      current_pos == 74 || current_pos == 77 || current_pos == 80) && win01[8] != 1)
                begin
                    whichCell = 8;
                    current_pos = 60; continue = 1;
                    if (visited[60] == 0 && continue == 1) begin current_pos = 60; continue = 0; end
                    if (visited[61] == 0 && continue == 1) begin current_pos = 61; continue = 0; end
                    if (visited[62] == 0 && continue == 1) begin current_pos = 62; continue = 0; end
                    if (visited[69] == 0 && continue == 1) begin current_pos = 69; continue = 0; end
                    if (visited[70] == 0 && continue == 1) begin current_pos = 70; continue = 0; end
                    if (visited[71] == 0 && continue == 1) begin current_pos = 71; continue = 0; end
                    if (visited[78] == 0 && continue == 1) begin current_pos = 78; continue = 0; end
                    if (visited[79] == 0 && continue == 1) begin current_pos = 79; continue = 0; end
                    if (visited[80] == 0 && continue == 1) begin current_pos = 80; continue = 0; end                           
                end else
                begin
                    whichCell = 9;
                    current_pos = 0; continue = 1;
                    if (visited[0] == 0 && continue == 1) begin current_pos = 0; continue = 0; end  
                    if (visited[1] == 0 && continue == 1) begin current_pos = 1; continue = 0; end  
                    if (visited[2] == 0 && continue == 1) begin current_pos = 2; continue = 0; end  
                    if (visited[3] == 0 && continue == 1) begin current_pos = 3; continue = 0; end  
                    if (visited[4] == 0 && continue == 1) begin current_pos = 4; continue = 0; end  
                    if (visited[5] == 0 && continue == 1) begin current_pos = 5; continue = 0; end  
                    if (visited[6] == 0 && continue == 1) begin current_pos = 6; continue = 0; end  
                    if (visited[7] == 0 && continue == 1) begin current_pos = 7; continue = 0; end  
                    if (visited[8] == 0 && continue == 1) begin current_pos = 8; continue = 0; end  
                    if (visited[9] == 0 && continue == 1) begin current_pos = 9; continue = 0; end  
                    if (visited[10] == 0 && continue == 1) begin current_pos = 10; continue = 0; end
                    if (visited[11] == 0 && continue == 1) begin current_pos = 11; continue = 0; end
                    if (visited[12] == 0 && continue == 1) begin current_pos = 12; continue = 0; end
                    if (visited[13] == 0 && continue == 1) begin current_pos = 13; continue = 0; end
                    if (visited[14] == 0 && continue == 1) begin current_pos = 14; continue = 0; end
                    if (visited[15] == 0 && continue == 1) begin current_pos = 15; continue = 0; end
                    if (visited[16] == 0 && continue == 1) begin current_pos = 16; continue = 0; end
                    if (visited[17] == 0 && continue == 1) begin current_pos = 17; continue = 0; end
                    if (visited[18] == 0 && continue == 1) begin current_pos = 18; continue = 0; end
                    if (visited[19] == 0 && continue == 1) begin current_pos = 19; continue = 0; end
                    if (visited[20] == 0 && continue == 1) begin current_pos = 20; continue = 0; end
                    if (visited[21] == 0 && continue == 1) begin current_pos = 21; continue = 0; end
                    if (visited[22] == 0 && continue == 1) begin current_pos = 22; continue = 0; end
                    if (visited[23] == 0 && continue == 1) begin current_pos = 23; continue = 0; end
                    if (visited[24] == 0 && continue == 1) begin current_pos = 24; continue = 0; end
                    if (visited[25] == 0 && continue == 1) begin current_pos = 25; continue = 0; end
                    if (visited[26] == 0 && continue == 1) begin current_pos = 26; continue = 0; end
                    if (visited[27] == 0 && continue == 1) begin current_pos = 27; continue = 0; end
                    if (visited[28] == 0 && continue == 1) begin current_pos = 28; continue = 0; end
                    if (visited[29] == 0 && continue == 1) begin current_pos = 29; continue = 0; end
                    if (visited[30] == 0 && continue == 1) begin current_pos = 30; continue = 0; end
                    if (visited[31] == 0 && continue == 1) begin current_pos = 31; continue = 0; end
                    if (visited[32] == 0 && continue == 1) begin current_pos = 32; continue = 0; end
                    if (visited[33] == 0 && continue == 1) begin current_pos = 33; continue = 0; end
                    if (visited[34] == 0 && continue == 1) begin current_pos = 34; continue = 0; end
                    if (visited[35] == 0 && continue == 1) begin current_pos = 35; continue = 0; end
                    if (visited[36] == 0 && continue == 1) begin current_pos = 36; continue = 0; end
                    if (visited[37] == 0 && continue == 1) begin current_pos = 37; continue = 0; end
                    if (visited[38] == 0 && continue == 1) begin current_pos = 38; continue = 0; end
                    if (visited[39] == 0 && continue == 1) begin current_pos = 39; continue = 0; end
                    if (visited[40] == 0 && continue == 1) begin current_pos = 40; continue = 0; end
                    if (visited[41] == 0 && continue == 1) begin current_pos = 41; continue = 0; end
                    if (visited[42] == 0 && continue == 1) begin current_pos = 42; continue = 0; end
                    if (visited[43] == 0 && continue == 1) begin current_pos = 43; continue = 0; end
                    if (visited[44] == 0 && continue == 1) begin current_pos = 44; continue = 0; end
                    if (visited[45] == 0 && continue == 1) begin current_pos = 45; continue = 0; end
                    if (visited[46] == 0 && continue == 1) begin current_pos = 46; continue = 0; end
                    if (visited[47] == 0 && continue == 1) begin current_pos = 47; continue = 0; end
                    if (visited[48] == 0 && continue == 1) begin current_pos = 48; continue = 0; end
                    if (visited[49] == 0 && continue == 1) begin current_pos = 49; continue = 0; end
                    if (visited[50] == 0 && continue == 1) begin current_pos = 50; continue = 0; end
                    if (visited[51] == 0 && continue == 1) begin current_pos = 51; continue = 0; end
                    if (visited[52] == 0 && continue == 1) begin current_pos = 52; continue = 0; end
                    if (visited[53] == 0 && continue == 1) begin current_pos = 53; continue = 0; end
                    if (visited[54] == 0 && continue == 1) begin current_pos = 54; continue = 0; end
                    if (visited[55] == 0 && continue == 1) begin current_pos = 55; continue = 0; end
                    if (visited[56] == 0 && continue == 1) begin current_pos = 56; continue = 0; end
                    if (visited[57] == 0 && continue == 1) begin current_pos = 57; continue = 0; end
                    if (visited[58] == 0 && continue == 1) begin current_pos = 58; continue = 0; end
                    if (visited[59] == 0 && continue == 1) begin current_pos = 59; continue = 0; end
                    if (visited[60] == 0 && continue == 1) begin current_pos = 60; continue = 0; end
                    if (visited[61] == 0 && continue == 1) begin current_pos = 61; continue = 0; end
                    if (visited[62] == 0 && continue == 1) begin current_pos = 62; continue = 0; end
                    if (visited[63] == 0 && continue == 1) begin current_pos = 63; continue = 0; end
                    if (visited[64] == 0 && continue == 1) begin current_pos = 64; continue = 0; end
                    if (visited[65] == 0 && continue == 1) begin current_pos = 65; continue = 0; end
                    if (visited[66] == 0 && continue == 1) begin current_pos = 66; continue = 0; end
                    if (visited[67] == 0 && continue == 1) begin current_pos = 67; continue = 0; end
                    if (visited[68] == 0 && continue == 1) begin current_pos = 68; continue = 0; end
                    if (visited[69] == 0 && continue == 1) begin current_pos = 69; continue = 0; end
                    if (visited[70] == 0 && continue == 1) begin current_pos = 70; continue = 0; end
                    if (visited[71] == 0 && continue == 1) begin current_pos = 71; continue = 0; end
                    if (visited[72] == 0 && continue == 1) begin current_pos = 72; continue = 0; end
                    if (visited[73] == 0 && continue == 1) begin current_pos = 73; continue = 0; end
                    if (visited[74] == 0 && continue == 1) begin current_pos = 74; continue = 0; end
                    if (visited[75] == 0 && continue == 1) begin current_pos = 75; continue = 0; end
                    if (visited[76] == 0 && continue == 1) begin current_pos = 76; continue = 0; end
                    if (visited[77] == 0 && continue == 1) begin current_pos = 77; continue = 0; end
                    if (visited[78] == 0 && continue == 1) begin current_pos = 78; continue = 0; end
                    if (visited[79] == 0 && continue == 1) begin current_pos = 79; continue = 0; end
                    if (visited[80] == 0 && continue == 1) begin current_pos = 80; continue = 0; end
                end
            end
        end
    end
    
    // Check for win in each of the small 9x9 cell 
//    always @ (posedge CLOCK)
//    begin
//        if (SW1 == 1)
//        begin
//            win0 = 0;
//            win1 = 0;
//            win01 = 0;
//        end
//        if (task_id == 5 && start == 1)
//        begin
//        // Check win for player 0 and update board
//        if ((board0[0] == 1 && board0[1] == 1 && board0[2] == 1) ||
//            (board0[9] == 1 && board0[10] == 1 && board0[11] == 1) ||
//            (board0[18] == 1 && board0[19] == 1 && board0[20] == 1) ||
//            (board0[0] == 1 && board0[9] == 1 && board0[18] == 1) ||
//            (board0[1] == 1 && board0[10] == 1 && board0[19] == 1) ||
//            (board0[2] == 1 && board0[11] == 1 && board0[20] == 1) ||
//            (board0[0] == 1 && board0[10] == 1 && board0[20] == 1) ||
//            (board0[2] == 1 && board0[10] == 1 && board0[18] == 1))
//        begin
//            win0[0] = 1; win01[0] = 1;
//        end
//        if ((board0[3] == 1 && board0[4] == 1 && board0[5] == 1) ||
//            (board0[12] == 1 && board0[13] == 1 && board0[14] == 1) ||
//            (board0[21] == 1 && board0[22] == 1 && board0[23] == 1) ||
//            (board0[3] == 1 && board0[12] == 1 && board0[21] == 1) ||
//            (board0[4] == 1 && board0[13] == 1 && board0[22] == 1) ||
//            (board0[5] == 1 && board0[14] == 1 && board0[23] == 1) ||
//            (board0[3] == 1 && board0[13] == 1 && board0[23] == 1) ||
//            (board0[5] == 1 && board0[13] == 1 && board0[21] == 1))
//        begin
//            win0[1] = 1; win01[1] = 1;
//        end
//        if ((board0[6] == 1 && board0[7] == 1 && board0[8] == 1) ||
//            (board0[15] == 1 && board0[16] == 1 && board0[17] == 1) ||
//            (board0[24] == 1 && board0[25] == 1 && board0[26] == 1) ||
//            (board0[6] == 1 && board0[15] == 1 && board0[24] == 1) ||
//            (board0[7] == 1 && board0[16] == 1 && board0[25] == 1) ||
//            (board0[8] == 1 && board0[17] == 1 && board0[26] == 1) ||
//            (board0[6] == 1 && board0[16] == 1 && board0[26] == 1) ||
//            (board0[8] == 1 && board0[16] == 1 && board0[24] == 1))
//        begin
//            win0[2] = 1; win01[2] = 1;
//        end
//        if ((board0[27] == 1 && board0[28] == 1 && board0[29] == 1) ||
//            (board0[36] == 1 && board0[37] == 1 && board0[38] == 1) ||
//            (board0[45] == 1 && board0[46] == 1 && board0[47] == 1) ||
//            (board0[27] == 1 && board0[36] == 1 && board0[45] == 1) ||
//            (board0[28] == 1 && board0[37] == 1 && board0[46] == 1) ||
//            (board0[29] == 1 && board0[38] == 1 && board0[47] == 1) ||
//            (board0[27] == 1 && board0[37] == 1 && board0[47] == 1) ||
//            (board0[29] == 1 && board0[37] == 1 && board0[45] == 1))
//        begin
//            win0[3] = 1; win01[3] = 1;
//        end
//        if ((board0[30] == 1 && board0[31] == 1 && board0[32] == 1) ||
//            (board0[39] == 1 && board0[40] == 1 && board0[41] == 1) ||
//            (board0[48] == 1 && board0[49] == 1 && board0[50] == 1) ||
//            (board0[30] == 1 && board0[39] == 1 && board0[48] == 1) ||
//            (board0[31] == 1 && board0[40] == 1 && board0[49] == 1) ||
//            (board0[32] == 1 && board0[41] == 1 && board0[50] == 1) ||
//            (board0[30] == 1 && board0[40] == 1 && board0[50] == 1) ||
//            (board0[32] == 1 && board0[40] == 1 && board0[48] == 1))
//        begin
//            win0[4] = 1; win01[4] = 1;
//        end
//        if ((board0[33] == 1 && board0[34] == 1 && board0[35] == 1) ||
//            (board0[42] == 1 && board0[43] == 1 && board0[44] == 1) ||
//            (board0[51] == 1 && board0[52] == 1 && board0[53] == 1) ||
//            (board0[33] == 1 && board0[42] == 1 && board0[51] == 1) ||
//            (board0[34] == 1 && board0[43] == 1 && board0[52] == 1) ||
//            (board0[35] == 1 && board0[44] == 1 && board0[53] == 1) ||
//            (board0[33] == 1 && board0[43] == 1 && board0[53] == 1) ||
//            (board0[35] == 1 && board0[43] == 1 && board0[51] == 1))
//        begin
//            win0[5] = 1; win01[5] = 1;
//        end
//        if ((board0[54] == 1 && board0[55] == 1 && board0[56] == 1) ||
//            (board0[63] == 1 && board0[64] == 1 && board0[65] == 1) ||
//            (board0[72] == 1 && board0[73] == 1 && board0[74] == 1) ||
//            (board0[54] == 1 && board0[63] == 1 && board0[72] == 1) ||
//            (board0[55] == 1 && board0[64] == 1 && board0[73] == 1) ||
//            (board0[56] == 1 && board0[65] == 1 && board0[74] == 1) ||
//            (board0[54] == 1 && board0[64] == 1 && board0[74] == 1) ||
//            (board0[56] == 1 && board0[64] == 1 && board0[72] == 1))
//        begin
//            win0[6] = 1; win01[6] = 1;
//        end
//        if ((board0[57] == 1 && board0[58] == 1 && board0[59] == 1) ||
//            (board0[66] == 1 && board0[67] == 1 && board0[68] == 1) ||
//            (board0[75] == 1 && board0[76] == 1 && board0[77] == 1) ||
//            (board0[57] == 1 && board0[66] == 1 && board0[75] == 1) ||
//            (board0[58] == 1 && board0[67] == 1 && board0[76] == 1) ||
//            (board0[59] == 1 && board0[68] == 1 && board0[77] == 1) ||
//            (board0[57] == 1 && board0[67] == 1 && board0[77] == 1) ||
//            (board0[59] == 1 && board0[64] == 1 && board0[72] == 1))
//        begin
//            win0[7] = 1; win01[7] = 1;
//        end
//        if ((board0[60] == 1 && board0[61] == 1 && board0[62] == 1) ||
//            (board0[69] == 1 && board0[70] == 1 && board0[71] == 1) ||
//            (board0[78] == 1 && board0[79] == 1 && board0[80] == 1) ||
//            (board0[60] == 1 && board0[69] == 1 && board0[78] == 1) ||
//            (board0[61] == 1 && board0[70] == 1 && board0[79] == 1) ||
//            (board0[62] == 1 && board0[71] == 1 && board0[80] == 1) ||
//            (board0[60] == 1 && board0[70] == 1 && board0[80] == 1) ||
//            (board0[62] == 1 && board0[70] == 1 && board0[78] == 1))
//        begin
//            win0[8] = 1; win01[8] = 1;
//        end
        
//        // Check win for player 1 and update board
//        if ((board1[0] == 1 && board1[1] == 1 && board1[2] == 1) ||
//            (board1[9] == 1 && board1[10] == 1 && board1[11] == 1) ||
//            (board1[18] == 1 && board1[19] == 1 && board1[20] == 1) ||
//            (board1[0] == 1 && board1[9] == 1 && board1[18] == 1) ||
//            (board1[1] == 1 && board1[10] == 1 && board1[19] == 1) ||
//            (board1[2] == 1 && board1[11] == 1 && board1[20] == 1) ||
//            (board1[0] == 1 && board1[10] == 1 && board1[20] == 1) ||
//            (board1[2] == 1 && board1[10] == 1 && board1[18] == 1))
//        begin
//            win1[0] = 1; win01[0] = 1;
//        end
//        if ((board1[3] == 1 && board1[4] == 1 && board1[5] == 1) ||
//            (board1[12] == 1 && board1[13] == 1 && board1[14] == 1) ||
//            (board1[21] == 1 && board1[22] == 1 && board1[23] == 1) ||
//            (board1[3] == 1 && board1[12] == 1 && board1[21] == 1) ||
//            (board1[4] == 1 && board1[13] == 1 && board1[22] == 1) ||
//            (board1[5] == 1 && board1[14] == 1 && board1[23] == 1) ||
//            (board1[3] == 1 && board1[13] == 1 && board1[23] == 1) ||
//            (board1[5] == 1 && board1[13] == 1 && board1[21] == 1))
//        begin
//            win1[1] = 1; win01[1] = 1;
//        end
//        if ((board1[6] == 1 && board1[7] == 1 && board1[8] == 1) ||
//            (board1[15] == 1 && board1[16] == 1 && board1[17] == 1) ||
//            (board1[24] == 1 && board1[25] == 1 && board1[26] == 1) ||
//            (board1[6] == 1 && board1[15] == 1 && board1[24] == 1) ||
//            (board1[7] == 1 && board1[16] == 1 && board1[25] == 1) ||
//            (board1[8] == 1 && board1[17] == 1 && board1[26] == 1) ||
//            (board1[6] == 1 && board1[16] == 1 && board1[26] == 1) ||
//            (board1[8] == 1 && board1[16] == 1 && board1[24] == 1))
//        begin
//            win1[2] = 1; win01[2] = 1;
//        end
//        if ((board1[27] == 1 && board1[28] == 1 && board1[29] == 1) ||
//            (board1[36] == 1 && board1[37] == 1 && board1[38] == 1) ||
//            (board1[45] == 1 && board1[46] == 1 && board1[47] == 1) ||
//            (board1[27] == 1 && board1[36] == 1 && board1[45] == 1) ||
//            (board1[28] == 1 && board1[37] == 1 && board1[46] == 1) ||
//            (board1[29] == 1 && board1[38] == 1 && board1[47] == 1) ||
//            (board1[27] == 1 && board1[37] == 1 && board1[47] == 1) ||
//            (board1[29] == 1 && board1[37] == 1 && board1[45] == 1))
//        begin
//            win1[3] = 1; win01[3] = 1;
//        end
//        if ((board1[30] == 1 && board1[31] == 1 && board1[32] == 1) ||
//            (board1[39] == 1 && board1[40] == 1 && board1[41] == 1) ||
//            (board1[48] == 1 && board1[49] == 1 && board1[50] == 1) ||
//            (board1[30] == 1 && board1[39] == 1 && board1[48] == 1) ||
//            (board1[31] == 1 && board1[40] == 1 && board1[49] == 1) ||
//            (board1[32] == 1 && board1[41] == 1 && board1[50] == 1) ||
//            (board1[30] == 1 && board1[40] == 1 && board1[50] == 1) ||
//            (board1[32] == 1 && board1[40] == 1 && board1[48] == 1))
//        begin
//            win1[4] = 1; win01[4] = 1;
//        end
//        if ((board1[33] == 1 && board1[34] == 1 && board1[35] == 1) ||
//            (board1[42] == 1 && board1[43] == 1 && board1[44] == 1) ||
//            (board1[51] == 1 && board1[52] == 1 && board1[53] == 1) ||
//            (board1[33] == 1 && board1[42] == 1 && board1[51] == 1) ||
//            (board1[34] == 1 && board1[43] == 1 && board1[52] == 1) ||
//            (board1[35] == 1 && board1[44] == 1 && board1[53] == 1) ||
//            (board1[33] == 1 && board1[43] == 1 && board1[53] == 1) ||
//            (board1[35] == 1 && board1[43] == 1 && board1[51] == 1))
//        begin
//            win1[5] = 1; win01[5] = 1;
//        end
//        if ((board1[54] == 1 && board1[55] == 1 && board1[56] == 1) ||
//            (board1[63] == 1 && board1[64] == 1 && board1[65] == 1) ||
//            (board1[72] == 1 && board1[73] == 1 && board1[74] == 1) ||
//            (board1[54] == 1 && board1[63] == 1 && board1[72] == 1) ||
//            (board1[55] == 1 && board1[64] == 1 && board1[73] == 1) ||
//            (board1[56] == 1 && board1[65] == 1 && board1[74] == 1) ||
//            (board1[54] == 1 && board1[64] == 1 && board1[74] == 1) ||
//            (board1[56] == 1 && board1[64] == 1 && board1[72] == 1))
//        begin
//            win1[6] = 1; win01[6] = 1;
//        end
//        if ((board1[57] == 1 && board1[58] == 1 && board1[59] == 1) ||
//            (board1[66] == 1 && board1[67] == 1 && board1[68] == 1) ||
//            (board1[75] == 1 && board1[76] == 1 && board1[77] == 1) ||
//            (board1[57] == 1 && board1[66] == 1 && board1[75] == 1) ||
//            (board1[58] == 1 && board1[67] == 1 && board1[76] == 1) ||
//            (board1[59] == 1 && board1[68] == 1 && board1[77] == 1) ||
//            (board1[57] == 1 && board1[67] == 1 && board1[77] == 1) ||
//            (board1[59] == 1 && board1[64] == 1 && board1[72] == 1))
//        begin
//            win1[7] = 1; win01[7] = 1;
//        end
//        if ((board1[60] == 1 && board1[61] == 1 && board1[62] == 1) ||
//            (board1[69] == 1 && board1[70] == 1 && board1[71] == 1) ||
//            (board1[78] == 1 && board1[79] == 1 && board1[80] == 1) ||
//            (board1[60] == 1 && board1[69] == 1 && board1[78] == 1) ||
//            (board1[61] == 1 && board1[70] == 1 && board1[79] == 1) ||
//            (board1[62] == 1 && board1[71] == 1 && board1[80] == 1) ||
//            (board1[60] == 1 && board1[70] == 1 && board1[80] == 1) ||
//            (board1[62] == 1 && board1[70] == 1 && board1[78] == 1))
//        begin
//            win1[8] = 1; win01[8] = 1;
//        end

//        // Check for draw in cell           
//        if (visited[0] == 1 && visited[1] == 1 && visited[2] == 1 && visited[9] == 1 && visited[10] == 1 && visited[11] == 1 &&	visited[18] == 1 && visited[19] == 1 && visited[20] == 1 && win0[0] == 0 && win1[0] == 0)
//            win01[0] = 1;
//        if (visited[3] == 1 && visited[4] == 1 && visited[5] == 1 && visited[12] == 1 && visited[13] == 1 && visited[14] == 1 && visited[21] == 1 && visited[22] == 1 && visited[23] == 1 && win0[1] == 0 && win1[1] == 0)
//            win01[1] = 1;
//        if (visited[6] == 1 && visited[7] == 1 && visited[8] == 1 && visited[15] == 1 && visited[16] == 1 && visited[17] == 1 && visited[24] == 1 && visited[25] == 1 && visited[26] == 1 && win0[2] == 0 && win1[2] == 0)
//            win01[2] = 1;
//        if (visited[27] == 1 && visited[28] == 1 && visited[29] == 1 && visited[36] == 1 && visited[37] == 1 && visited[38] == 1 && visited[45] == 1 && visited[46] == 1 && visited[47] == 1 && win0[3] == 0 && win1[3] == 0)
//            win01[3] = 1;
//        if (visited[30] == 1 && visited[31] == 1 && visited[32] == 1 && visited[39] == 1 && visited[40] == 1 && visited[41] == 1 && visited[48] == 1 && visited[49] == 1 && visited[50] == 1 && win0[4] == 0 && win1[4] == 0)
//            win01[4] = 1;
//        if (visited[33] == 1 && visited[34] == 1 && visited[35] == 1 && visited[42] == 1 && visited[43] == 1 && visited[44] == 1 && visited[51] == 1 && visited[52] == 1 && visited[53] == 1 && win0[5] == 0 && win1[5] == 0)
//            win01[5] = 1;
//        if (visited[54] == 1 && visited[55] == 1 && visited[56] == 1 && visited[63] == 1 && visited[64] == 1 && visited[65] == 1 && visited[72] == 1 && visited[73] == 1 && visited[74] == 1 && win0[6] == 0 && win1[6] == 0)
//            win01[6] = 1;
//        if (visited[57] == 1 && visited[58] == 1 && visited[59] == 1 && visited[66] == 1 && visited[67] == 1 && visited[68] == 1 && visited[75] == 1 && visited[76] == 1 && visited[77] == 1 && win0[7] == 0 && win1[7] == 0)
//            win01[7] = 1;
//        if (visited[60] == 1 && visited[61] == 1 && visited[62] == 1 && visited[69] == 1 && visited[70] == 1 && visited[71] == 1 && visited[78] == 1 && visited[79] == 1 && visited[80] == 1 && win0[8] == 0 && win1[8] == 0)
//            win01[8] = 1;
//        end         
//    end
    
    // Check for an overall winner
    reg [1:0] winner = 3; // Default: 3, Player 0 wins: 0, Player 1 wins: 1, Draw: 2
    always @ (posedge CLOCK)
    begin
        if (SW1 == 1)
            winner <= 3;
        
        if (task_id == 5 && start == 1)
        begin
        // Check for a player 0 win
        if ((win0[0] == 1 && win0[1] == 1 && win0[2] == 1) ||
            (win0[3] == 1 && win0[4] == 1 && win0[5] == 1) ||
            (win0[6] == 1 && win0[7] == 1 && win0[8] == 1) ||
            (win0[0] == 1 && win0[3] == 1 && win0[6] == 1) ||
            (win0[1] == 1 && win0[4] == 1 && win0[7] == 1) ||
            (win0[2] == 1 && win0[5] == 1 && win0[8] == 1) ||
            (win0[0] == 1 && win0[4] == 1 && win0[8] == 1) ||
            (win0[2] == 1 && win0[4] == 1 && win0[6] == 1))
            winner <= 0;
        
        // Check for a player 1 win
        if ((win1[0] == 1 && win1[1] == 1 && win1[2] == 1) ||
            (win1[3] == 1 && win1[4] == 1 && win1[5] == 1) ||
            (win1[6] == 1 && win1[7] == 1 && win1[8] == 1) ||
            (win1[0] == 1 && win1[3] == 1 && win1[6] == 1) ||
            (win1[1] == 1 && win1[4] == 1 && win1[7] == 1) ||
            (win1[2] == 1 && win1[5] == 1 && win1[8] == 1) ||
            (win1[0] == 1 && win1[4] == 1 && win1[8] == 1) ||
            (win1[2] == 1 && win1[4] == 1 && win1[6] == 1))
            winner <= 1;
        
        // Check for a draw
        if (win01[0] == 1 && win01[1] == 1 && win01[2] == 1 && win01[3] == 1 &&
            win01[4] == 1 && win01[5] == 1 && win01[6] == 1 && win01[7] == 1 && win01[8] == 1)
            winner <= 2;
        end        
    end
    
    // x and y coordinate
    reg [5:0] y = 0;
    reg [6:0] x = 0;
    
    // 7 segment display
    reg [1:0] seg_count = 0;
    always @ (posedge clk_381hz)
    begin
        seg_count <= seg_count + 1;
        case (seg_count)
        0: begin
            an <= 4'b1110;
            if (winner == 3)
                seg <= 7'b1111111;
            else if (winner == 0 || winner == 1 || winner == 2)
                seg <= 7'b1010101;
           end
        1: begin
            an <= 4'b1101;
            if (winner == 3)
                seg <= 7'b1111111;
            else if (winner == 0 || winner == 1)
                seg <= 7'b1010101;
            else if (winner == 2)
                seg <= 7'b0001000;
           end
        2: begin
            an <= 4'b1011;
            if (winner == 3)
                seg <= 7'b1111111;
            else if (winner == 0)
                seg <= 7'b1111001;
            else if (winner == 1)
                seg <= 7'b0100100;
            else if (winner == 2)
                seg <= 7'b0101111;
           end
        3: begin
            an <= 4'b0111;
            if (winner == 3)
                seg <= 7'b1111111;
            else if (winner == 0 || winner == 1)
                seg <= 7'b0001100;
            else if (winner == 2)
                seg <= 7'b0100001;
           end
        endcase
    end
    
    // Cell counter
    reg [6:0] cellCount = 0;
    reg [4:0] bigCellCount = 0;
    reg [20:0] indicatorCount = 0;
    
    // Colour change
    reg [15:0] colourOn = 16'hFFFF;
    
    // OLED display
    always @ (posedge clk_6p25mhz)
    begin
        // Set the coordinates
        y = pixel_index / 96;
        x = pixel_index % 96;
        
        // Increment cell counter till 80
        if (cellCount != 80)
            cellCount <= cellCount + 1;
        else
            cellCount <= 0;
        
        // Increment (big) cell counter till 8
        if (bigCellCount != 8)
            bigCellCount <= bigCellCount + 1;
        else
            bigCellCount <= 0;
        
        // Flip flashing of current pos colour every 0.25 seconds
        if (indicatorCount == 1562499)
        begin 
            indicatorCount <= 0; 
            if (colourOn == 16'hFFFF)
                colourOn <= 16'h0000;
            else if (colourOn == 16'h0000)
                colourOn <= 16'hFFFF;
        end else
            indicatorCount <= indicatorCount + 1;
               
        // Display the main board
        if (x == 0 || x == 95 || y == 0 || y == 63)
            oled_data <= 16'h07E0;
        else if (((x >= 2 && x <= 92) && (y == 21 || y == 42)) || ((y >= 2 && y <= 61) && (x == 31 || x == 63)))
            oled_data <= 16'h07FF;
        else if (((x >= 4 && x <= 29) || (x >= 34 && x <= 60) || (x >= 65 && x <= 91)) &&
                 (y == 7 || y == 14 || y == 28 || y == 35 || y == 49 || y == 56))
            oled_data <= 16'hFFFF;
        else if (((y >= 2 && y <= 19) || (y >= 23 && y <= 40) || (y >= 44 && y <= 61)) &&
                 (x == 11 || x == 21 || x == 42 || x == 52 || x == 73 || x == 83))
            oled_data <= 16'hFFFF;
        else
            oled_data <= 16'h0000;
        
//        Calculations:
//        x: 3 13 23 34 44 54 65 75 85
//           ---0--- ---1---- ---2----
        
//        For grouping:
//        x = (cellCount % 9) / 3
        
//        For number in grouping:
//        x = ((cellCount % 9) % 3) * 10
        
         
//        y: 2  9 16 23 30 37 44 51 58
//           ---0--- ---1---- ---2----
        
//        For grouping:
//        y = (cellCount / 9) / 3
        
//        For number in grouping
//        y = ((cellCount / 9) % 3) * 7
        
        // Print the current position indicator
        if (winner == 3)
        begin
        if (current_pos == 0) begin if (x >= 3 && x <= 9 && y >= 2 && y <= 5) oled_data <= colourOn; end
        if (current_pos == 1) begin if (x >= 13 && x <= 19 && y >= 2 && y <= 5) oled_data <= colourOn; end
        if (current_pos == 2) begin if (x >= 23 && x <= 29 && y >= 2 && y <= 5) oled_data <= colourOn; end
        if (current_pos == 3) begin if (x >= 34 && x <= 40 && y >= 2 && y <= 5) oled_data <= colourOn; end
        if (current_pos == 4) begin if (x >= 44 && x <= 50 && y >= 2 && y <= 5) oled_data <= colourOn; end
        if (current_pos == 5) begin if (x >= 54 && x <= 60 && y >= 2 && y <= 5) oled_data <= colourOn; end
        if (current_pos == 6) begin if (x >= 65 && x <= 71 && y >= 2 && y <= 5) oled_data <= colourOn; end
        if (current_pos == 7) begin if (x >= 75 && x <= 81 && y >= 2 && y <= 5) oled_data <= colourOn; end
        if (current_pos == 8) begin if (x >= 85 && x <= 91 && y >= 2 && y <= 5) oled_data <= colourOn; end
        if (current_pos == 9) begin if (x >= 3 && x <= 9 && y >= 9 && y <= 12) oled_data <= colourOn; end
        if (current_pos == 10) begin if (x >= 13 && x <= 19 && y >= 9 && y <= 12) oled_data <= colourOn; end
        if (current_pos == 11) begin if (x >= 23 && x <= 29 && y >= 9 && y <= 12) oled_data <= colourOn; end
        if (current_pos == 12) begin if (x >= 34 && x <= 40 && y >= 9 && y <= 12) oled_data <= colourOn; end
        if (current_pos == 13) begin if (x >= 44 && x <= 50 && y >= 9 && y <= 12) oled_data <= colourOn; end
        if (current_pos == 14) begin if (x >= 54 && x <= 60 && y >= 9 && y <= 12) oled_data <= colourOn; end
        if (current_pos == 15) begin if (x >= 65 && x <= 71 && y >= 9 && y <= 12) oled_data <= colourOn; end
        if (current_pos == 16) begin if (x >= 75 && x <= 81 && y >= 9 && y <= 12) oled_data <= colourOn; end
        if (current_pos == 17) begin if (x >= 85 && x <= 91 && y >= 9 && y <= 12) oled_data <= colourOn; end
        if (current_pos == 18) begin if (x >= 3 && x <= 9 && y >= 16 && y <= 19) oled_data <= colourOn; end
        if (current_pos == 19) begin if (x >= 13 && x <= 19 && y >= 16 && y <= 19) oled_data <= colourOn; end
        if (current_pos == 20) begin if (x >= 23 && x <= 29 && y >= 16 && y <= 19) oled_data <= colourOn; end
        if (current_pos == 21) begin if (x >= 34 && x <= 40 && y >= 16 && y <= 19) oled_data <= colourOn; end
        if (current_pos == 22) begin if (x >= 44 && x <= 50 && y >= 16 && y <= 19) oled_data <= colourOn; end
        if (current_pos == 23) begin if (x >= 54 && x <= 60 && y >= 16 && y <= 19) oled_data <= colourOn; end
        if (current_pos == 24) begin if (x >= 65 && x <= 71 && y >= 16 && y <= 19) oled_data <= colourOn; end
        if (current_pos == 25) begin if (x >= 75 && x <= 81 && y >= 16 && y <= 19) oled_data <= colourOn; end
        if (current_pos == 26) begin if (x >= 85 && x <= 91 && y >= 16 && y <= 19) oled_data <= colourOn; end
        if (current_pos == 27) begin if (x >= 3 && x <= 9 && y >= 23 && y <= 26) oled_data <= colourOn; end
        if (current_pos == 28) begin if (x >= 13 && x <= 19 && y >= 23 && y <= 26) oled_data <= colourOn; end
        if (current_pos == 29) begin if (x >= 23 && x <= 29 && y >= 23 && y <= 26) oled_data <= colourOn; end
        if (current_pos == 30) begin if (x >= 34 && x <= 40 && y >= 23 && y <= 26) oled_data <= colourOn; end
        if (current_pos == 31) begin if (x >= 44 && x <= 50 && y >= 23 && y <= 26) oled_data <= colourOn; end
        if (current_pos == 32) begin if (x >= 54 && x <= 60 && y >= 23 && y <= 26) oled_data <= colourOn; end
        if (current_pos == 33) begin if (x >= 65 && x <= 71 && y >= 23 && y <= 26) oled_data <= colourOn; end
        if (current_pos == 34) begin if (x >= 75 && x <= 81 && y >= 23 && y <= 26) oled_data <= colourOn; end
        if (current_pos == 35) begin if (x >= 85 && x <= 91 && y >= 23 && y <= 26) oled_data <= colourOn; end     
        if (current_pos == 36) begin if (x >= 3 && x <= 9 && y >= 30 && y <= 33) oled_data <= colourOn; end
        if (current_pos == 37) begin if (x >= 13 && x <= 19 && y >= 30 && y <= 33) oled_data <= colourOn; end
        if (current_pos == 38) begin if (x >= 23 && x <= 29 && y >= 30 && y <= 33) oled_data <= colourOn; end
        if (current_pos == 39) begin if (x >= 34 && x <= 40 && y >= 30 && y <= 33) oled_data <= colourOn; end
        if (current_pos == 40) begin if (x >= 44 && x <= 50 && y >= 30 && y <= 33) oled_data <= colourOn; end
        if (current_pos == 41) begin if (x >= 54 && x <= 60 && y >= 30 && y <= 33) oled_data <= colourOn; end
        if (current_pos == 42) begin if (x >= 65 && x <= 71 && y >= 30 && y <= 33) oled_data <= colourOn; end
        if (current_pos == 43) begin if (x >= 75 && x <= 81 && y >= 30 && y <= 33) oled_data <= colourOn; end
        if (current_pos == 44) begin if (x >= 85 && x <= 91 && y >= 30 && y <= 33) oled_data <= colourOn; end
        if (current_pos == 45) begin if (x >= 3 && x <= 9 && y >= 37 && y <= 40) oled_data <= colourOn; end
        if (current_pos == 46) begin if (x >= 13 && x <= 19 && y >= 37 && y <= 40) oled_data <= colourOn; end
        if (current_pos == 47) begin if (x >= 23 && x <= 29 && y >= 37 && y <= 40) oled_data <= colourOn; end
        if (current_pos == 48) begin if (x >= 34 && x <= 40 && y >= 37 && y <= 40) oled_data <= colourOn; end
        if (current_pos == 49) begin if (x >= 44 && x <= 50 && y >= 37 && y <= 40) oled_data <= colourOn; end
        if (current_pos == 50) begin if (x >= 54 && x <= 60 && y >= 37 && y <= 40) oled_data <= colourOn; end
        if (current_pos == 51) begin if (x >= 65 && x <= 71 && y >= 37 && y <= 40) oled_data <= colourOn; end
        if (current_pos == 52) begin if (x >= 75 && x <= 81 && y >= 37 && y <= 40) oled_data <= colourOn; end
        if (current_pos == 53) begin if (x >= 85 && x <= 91 && y >= 37 && y <= 40) oled_data <= colourOn; end  
        if (current_pos == 54) begin if (x >= 3 && x <= 9 && y >= 44 && y <= 47) oled_data <= colourOn; end
        if (current_pos == 55) begin if (x >= 13 && x <= 19 && y >= 44 && y <= 47) oled_data <= colourOn; end
        if (current_pos == 56) begin if (x >= 23 && x <= 29 && y >= 44 && y <= 47) oled_data <= colourOn; end
        if (current_pos == 57) begin if (x >= 34 && x <= 40 && y >= 44 && y <= 47) oled_data <= colourOn; end
        if (current_pos == 58) begin if (x >= 44 && x <= 50 && y >= 44 && y <= 47) oled_data <= colourOn; end
        if (current_pos == 59) begin if (x >= 54 && x <= 60 && y >= 44 && y <= 47) oled_data <= colourOn; end
        if (current_pos == 60) begin if (x >= 65 && x <= 71 && y >= 44 && y <= 47) oled_data <= colourOn; end
        if (current_pos == 61) begin if (x >= 75 && x <= 81 && y >= 44 && y <= 47) oled_data <= colourOn; end
        if (current_pos == 62) begin if (x >= 85 && x <= 91 && y >= 44 && y <= 47) oled_data <= colourOn; end
        if (current_pos == 63) begin if (x >= 3 && x <= 9 && y >= 51 && y <= 54) oled_data <= colourOn; end
        if (current_pos == 64) begin if (x >= 13 && x <= 19 && y >= 51 && y <= 54) oled_data <= colourOn; end
        if (current_pos == 65) begin if (x >= 23 && x <= 29 && y >= 51 && y <= 54) oled_data <= colourOn; end
        if (current_pos == 66) begin if (x >= 34 && x <= 40 && y >= 51 && y <= 54) oled_data <= colourOn; end
        if (current_pos == 67) begin if (x >= 44 && x <= 50 && y >= 51 && y <= 54) oled_data <= colourOn; end
        if (current_pos == 68) begin if (x >= 54 && x <= 60 && y >= 51 && y <= 54) oled_data <= colourOn; end
        if (current_pos == 69) begin if (x >= 65 && x <= 71 && y >= 51 && y <= 54) oled_data <= colourOn; end
        if (current_pos == 70) begin if (x >= 75 && x <= 81 && y >= 51 && y <= 54) oled_data <= colourOn; end
        if (current_pos == 71) begin if (x >= 85 && x <= 91 && y >= 51 && y <= 54) oled_data <= colourOn; end 
        if (current_pos == 72) begin if (x >= 3 && x <= 9 && y >= 58 && y <= 61) oled_data <= colourOn; end
        if (current_pos == 73) begin if (x >= 13 && x <= 19 && y >= 58 && y <= 61) oled_data <= colourOn; end
        if (current_pos == 74) begin if (x >= 23 && x <= 29 && y >= 58 && y <= 61) oled_data <= colourOn; end
        if (current_pos == 75) begin if (x >= 34 && x <= 40 && y >= 58 && y <= 61) oled_data <= colourOn; end
        if (current_pos == 76) begin if (x >= 44 && x <= 50 && y >= 58 && y <= 61) oled_data <= colourOn; end
        if (current_pos == 77) begin if (x >= 54 && x <= 60 && y >= 58 && y <= 61) oled_data <= colourOn; end
        if (current_pos == 78) begin if (x >= 65 && x <= 71 && y >= 58 && y <= 61) oled_data <= colourOn; end
        if (current_pos == 79) begin if (x >= 75 && x <= 81 && y >= 58 && y <= 61) oled_data <= colourOn; end
        if (current_pos == 80) begin if (x >= 85 && x <= 91 && y >= 58 && y <= 61) oled_data <= colourOn; end                                           
        end
        
        // Update each individual cell in terms of player 0
        if (board0[0] == 1) begin if (x >= 3 && x <= 9 && y >= 2 && y <= 5) oled_data <= 16'hF800; end
        if (board0[1] == 1) begin if (x >= 13 && x <= 19 && y >= 2 && y <= 5) oled_data <= 16'hF800; end
        if (board0[2] == 1) begin if (x >= 23 && x <= 29 && y >= 2 && y <= 5) oled_data <= 16'hF800; end
        if (board0[3] == 1) begin if (x >= 34 && x <= 40 && y >= 2 && y <= 5) oled_data <= 16'hF800; end
        if (board0[4] == 1) begin if (x >= 44 && x <= 50 && y >= 2 && y <= 5) oled_data <= 16'hF800; end
        if (board0[5] == 1) begin if (x >= 54 && x <= 60 && y >= 2 && y <= 5) oled_data <= 16'hF800; end
        if (board0[6] == 1) begin if (x >= 65 && x <= 71 && y >= 2 && y <= 5) oled_data <= 16'hF800; end
        if (board0[7] == 1) begin if (x >= 75 && x <= 81 && y >= 2 && y <= 5) oled_data <= 16'hF800; end
        if (board0[8] == 1) begin if (x >= 85 && x <= 91 && y >= 2 && y <= 5) oled_data <= 16'hF800; end
        if (board0[9] == 1) begin if (x >= 3 && x <= 9 && y >= 9 && y <= 12) oled_data <= 16'hF800; end
        if (board0[10] == 1) begin if (x >= 13 && x <= 19 && y >= 9 && y <= 12) oled_data <= 16'hF800; end
        if (board0[11] == 1) begin if (x >= 23 && x <= 29 && y >= 9 && y <= 12) oled_data <= 16'hF800; end
        if (board0[12] == 1) begin if (x >= 34 && x <= 40 && y >= 9 && y <= 12) oled_data <= 16'hF800; end
        if (board0[13] == 1) begin if (x >= 44 && x <= 50 && y >= 9 && y <= 12) oled_data <= 16'hF800; end
        if (board0[14] == 1) begin if (x >= 54 && x <= 60 && y >= 9 && y <= 12) oled_data <= 16'hF800; end
        if (board0[15] == 1) begin if (x >= 65 && x <= 71 && y >= 9 && y <= 12) oled_data <= 16'hF800; end
        if (board0[16] == 1) begin if (x >= 75 && x <= 81 && y >= 9 && y <= 12) oled_data <= 16'hF800; end
        if (board0[17] == 1) begin if (x >= 85 && x <= 91 && y >= 9 && y <= 12) oled_data <= 16'hF800; end
        if (board0[18] == 1) begin if (x >= 3 && x <= 9 && y >= 16 && y <= 19) oled_data <= 16'hF800; end
        if (board0[19] == 1) begin if (x >= 13 && x <= 19 && y >= 16 && y <= 19) oled_data <= 16'hF800; end
        if (board0[20] == 1) begin if (x >= 23 && x <= 29 && y >= 16 && y <= 19) oled_data <= 16'hF800; end
        if (board0[21] == 1) begin if (x >= 34 && x <= 40 && y >= 16 && y <= 19) oled_data <= 16'hF800; end
        if (board0[22] == 1) begin if (x >= 44 && x <= 50 && y >= 16 && y <= 19) oled_data <= 16'hF800; end
        if (board0[23] == 1) begin if (x >= 54 && x <= 60 && y >= 16 && y <= 19) oled_data <= 16'hF800; end
        if (board0[24] == 1) begin if (x >= 65 && x <= 71 && y >= 16 && y <= 19) oled_data <= 16'hF800; end
        if (board0[25] == 1) begin if (x >= 75 && x <= 81 && y >= 16 && y <= 19) oled_data <= 16'hF800; end
        if (board0[26] == 1) begin if (x >= 85 && x <= 91 && y >= 16 && y <= 19) oled_data <= 16'hF800; end
        if (board0[27] == 1) begin if (x >= 3 && x <= 9 && y >= 23 && y <= 26) oled_data <= 16'hF800; end
        if (board0[28] == 1) begin if (x >= 13 && x <= 19 && y >= 23 && y <= 26) oled_data <= 16'hF800; end
        if (board0[29] == 1) begin if (x >= 23 && x <= 29 && y >= 23 && y <= 26) oled_data <= 16'hF800; end
        if (board0[30] == 1) begin if (x >= 34 && x <= 40 && y >= 23 && y <= 26) oled_data <= 16'hF800; end
        if (board0[31] == 1) begin if (x >= 44 && x <= 50 && y >= 23 && y <= 26) oled_data <= 16'hF800; end
        if (board0[32] == 1) begin if (x >= 54 && x <= 60 && y >= 23 && y <= 26) oled_data <= 16'hF800; end
        if (board0[33] == 1) begin if (x >= 65 && x <= 71 && y >= 23 && y <= 26) oled_data <= 16'hF800; end
        if (board0[34] == 1) begin if (x >= 75 && x <= 81 && y >= 23 && y <= 26) oled_data <= 16'hF800; end
        if (board0[35] == 1) begin if (x >= 85 && x <= 91 && y >= 23 && y <= 26) oled_data <= 16'hF800; end     
        if (board0[36] == 1) begin if (x >= 3 && x <= 9 && y >= 30 && y <= 33) oled_data <= 16'hF800; end
        if (board0[37] == 1) begin if (x >= 13 && x <= 19 && y >= 30 && y <= 33) oled_data <= 16'hF800; end
        if (board0[38] == 1) begin if (x >= 23 && x <= 29 && y >= 30 && y <= 33) oled_data <= 16'hF800; end
        if (board0[39] == 1) begin if (x >= 34 && x <= 40 && y >= 30 && y <= 33) oled_data <= 16'hF800; end
        if (board0[40] == 1) begin if (x >= 44 && x <= 50 && y >= 30 && y <= 33) oled_data <= 16'hF800; end
        if (board0[41] == 1) begin if (x >= 54 && x <= 60 && y >= 30 && y <= 33) oled_data <= 16'hF800; end
        if (board0[42] == 1) begin if (x >= 65 && x <= 71 && y >= 30 && y <= 33) oled_data <= 16'hF800; end
        if (board0[43] == 1) begin if (x >= 75 && x <= 81 && y >= 30 && y <= 33) oled_data <= 16'hF800; end
        if (board0[44] == 1) begin if (x >= 85 && x <= 91 && y >= 30 && y <= 33) oled_data <= 16'hF800; end
        if (board0[45] == 1) begin if (x >= 3 && x <= 9 && y >= 37 && y <= 40) oled_data <= 16'hF800; end
        if (board0[46] == 1) begin if (x >= 13 && x <= 19 && y >= 37 && y <= 40) oled_data <= 16'hF800; end
        if (board0[47] == 1) begin if (x >= 23 && x <= 29 && y >= 37 && y <= 40) oled_data <= 16'hF800; end
        if (board0[48] == 1) begin if (x >= 34 && x <= 40 && y >= 37 && y <= 40) oled_data <= 16'hF800; end
        if (board0[49] == 1) begin if (x >= 44 && x <= 50 && y >= 37 && y <= 40) oled_data <= 16'hF800; end
        if (board0[50] == 1) begin if (x >= 54 && x <= 60 && y >= 37 && y <= 40) oled_data <= 16'hF800; end
        if (board0[51] == 1) begin if (x >= 65 && x <= 71 && y >= 37 && y <= 40) oled_data <= 16'hF800; end
        if (board0[52] == 1) begin if (x >= 75 && x <= 81 && y >= 37 && y <= 40) oled_data <= 16'hF800; end
        if (board0[53] == 1) begin if (x >= 85 && x <= 91 && y >= 37 && y <= 40) oled_data <= 16'hF800; end  
        if (board0[54] == 1) begin if (x >= 3 && x <= 9 && y >= 44 && y <= 47) oled_data <= 16'hF800; end
        if (board0[55] == 1) begin if (x >= 13 && x <= 19 && y >= 44 && y <= 47) oled_data <= 16'hF800; end
        if (board0[56] == 1) begin if (x >= 23 && x <= 29 && y >= 44 && y <= 47) oled_data <= 16'hF800; end
        if (board0[57] == 1) begin if (x >= 34 && x <= 40 && y >= 44 && y <= 47) oled_data <= 16'hF800; end
        if (board0[58] == 1) begin if (x >= 44 && x <= 50 && y >= 44 && y <= 47) oled_data <= 16'hF800; end
        if (board0[59] == 1) begin if (x >= 54 && x <= 60 && y >= 44 && y <= 47) oled_data <= 16'hF800; end
        if (board0[60] == 1) begin if (x >= 65 && x <= 71 && y >= 44 && y <= 47) oled_data <= 16'hF800; end
        if (board0[61] == 1) begin if (x >= 75 && x <= 81 && y >= 44 && y <= 47) oled_data <= 16'hF800; end
        if (board0[62] == 1) begin if (x >= 85 && x <= 91 && y >= 44 && y <= 47) oled_data <= 16'hF800; end
        if (board0[63] == 1) begin if (x >= 3 && x <= 9 && y >= 51 && y <= 54) oled_data <= 16'hF800; end
        if (board0[64] == 1) begin if (x >= 13 && x <= 19 && y >= 51 && y <= 54) oled_data <= 16'hF800; end
        if (board0[65] == 1) begin if (x >= 23 && x <= 29 && y >= 51 && y <= 54) oled_data <= 16'hF800; end
        if (board0[66] == 1) begin if (x >= 34 && x <= 40 && y >= 51 && y <= 54) oled_data <= 16'hF800; end
        if (board0[67] == 1) begin if (x >= 44 && x <= 50 && y >= 51 && y <= 54) oled_data <= 16'hF800; end
        if (board0[68] == 1) begin if (x >= 54 && x <= 60 && y >= 51 && y <= 54) oled_data <= 16'hF800; end
        if (board0[69] == 1) begin if (x >= 65 && x <= 71 && y >= 51 && y <= 54) oled_data <= 16'hF800; end
        if (board0[70] == 1) begin if (x >= 75 && x <= 81 && y >= 51 && y <= 54) oled_data <= 16'hF800; end
        if (board0[71] == 1) begin if (x >= 85 && x <= 91 && y >= 51 && y <= 54) oled_data <= 16'hF800; end 
        if (board0[72] == 1) begin if (x >= 3 && x <= 9 && y >= 58 && y <= 61) oled_data <= 16'hF800; end
        if (board0[73] == 1) begin if (x >= 13 && x <= 19 && y >= 58 && y <= 61) oled_data <= 16'hF800; end
        if (board0[74] == 1) begin if (x >= 23 && x <= 29 && y >= 58 && y <= 61) oled_data <= 16'hF800; end
        if (board0[75] == 1) begin if (x >= 34 && x <= 40 && y >= 58 && y <= 61) oled_data <= 16'hF800; end
        if (board0[76] == 1) begin if (x >= 44 && x <= 50 && y >= 58 && y <= 61) oled_data <= 16'hF800; end
        if (board0[77] == 1) begin if (x >= 54 && x <= 60 && y >= 58 && y <= 61) oled_data <= 16'hF800; end
        if (board0[78] == 1) begin if (x >= 65 && x <= 71 && y >= 58 && y <= 61) oled_data <= 16'hF800; end
        if (board0[79] == 1) begin if (x >= 75 && x <= 81 && y >= 58 && y <= 61) oled_data <= 16'hF800; end
        if (board0[80] == 1) begin if (x >= 85 && x <= 91 && y >= 58 && y <= 61) oled_data <= 16'hF800; end                                           
        
         // Update each individual cell in terms of player 1
        if (board1[0] == 1) begin if (x >= 3 && x <= 9 && y >= 2 && y <= 5) oled_data <= 16'hFFE0; end
        if (board1[1] == 1) begin if (x >= 13 && x <= 19 && y >= 2 && y <= 5) oled_data <= 16'hFFE0; end
        if (board1[2] == 1) begin if (x >= 23 && x <= 29 && y >= 2 && y <= 5) oled_data <= 16'hFFE0; end
        if (board1[3] == 1) begin if (x >= 34 && x <= 40 && y >= 2 && y <= 5) oled_data <= 16'hFFE0; end
        if (board1[4] == 1) begin if (x >= 44 && x <= 50 && y >= 2 && y <= 5) oled_data <= 16'hFFE0; end
        if (board1[5] == 1) begin if (x >= 54 && x <= 60 && y >= 2 && y <= 5) oled_data <= 16'hFFE0; end
        if (board1[6] == 1) begin if (x >= 65 && x <= 71 && y >= 2 && y <= 5) oled_data <= 16'hFFE0; end
        if (board1[7] == 1) begin if (x >= 75 && x <= 81 && y >= 2 && y <= 5) oled_data <= 16'hFFE0; end
        if (board1[8] == 1) begin if (x >= 85 && x <= 91 && y >= 2 && y <= 5) oled_data <= 16'hFFE0; end
        if (board1[9] == 1) begin if (x >= 3 && x <= 9 && y >= 9 && y <= 12) oled_data <= 16'hFFE0; end
        if (board1[10] == 1) begin if (x >= 13 && x <= 19 && y >= 9 && y <= 12) oled_data <= 16'hFFE0; end
        if (board1[11] == 1) begin if (x >= 23 && x <= 29 && y >= 9 && y <= 12) oled_data <= 16'hFFE0; end
        if (board1[12] == 1) begin if (x >= 34 && x <= 40 && y >= 9 && y <= 12) oled_data <= 16'hFFE0; end
        if (board1[13] == 1) begin if (x >= 44 && x <= 50 && y >= 9 && y <= 12) oled_data <= 16'hFFE0; end
        if (board1[14] == 1) begin if (x >= 54 && x <= 60 && y >= 9 && y <= 12) oled_data <= 16'hFFE0; end
        if (board1[15] == 1) begin if (x >= 65 && x <= 71 && y >= 9 && y <= 12) oled_data <= 16'hFFE0; end
        if (board1[16] == 1) begin if (x >= 75 && x <= 81 && y >= 9 && y <= 12) oled_data <= 16'hFFE0; end
        if (board1[17] == 1) begin if (x >= 85 && x <= 91 && y >= 9 && y <= 12) oled_data <= 16'hFFE0; end
        if (board1[18] == 1) begin if (x >= 3 && x <= 9 && y >= 16 && y <= 19) oled_data <= 16'hFFE0; end
        if (board1[19] == 1) begin if (x >= 13 && x <= 19 && y >= 16 && y <= 19) oled_data <= 16'hFFE0; end
        if (board1[20] == 1) begin if (x >= 23 && x <= 29 && y >= 16 && y <= 19) oled_data <= 16'hFFE0; end
        if (board1[21] == 1) begin if (x >= 34 && x <= 40 && y >= 16 && y <= 19) oled_data <= 16'hFFE0; end
        if (board1[22] == 1) begin if (x >= 44 && x <= 50 && y >= 16 && y <= 19) oled_data <= 16'hFFE0; end
        if (board1[23] == 1) begin if (x >= 54 && x <= 60 && y >= 16 && y <= 19) oled_data <= 16'hFFE0; end
        if (board1[24] == 1) begin if (x >= 65 && x <= 71 && y >= 16 && y <= 19) oled_data <= 16'hFFE0; end
        if (board1[25] == 1) begin if (x >= 75 && x <= 81 && y >= 16 && y <= 19) oled_data <= 16'hFFE0; end
        if (board1[26] == 1) begin if (x >= 85 && x <= 91 && y >= 16 && y <= 19) oled_data <= 16'hFFE0; end
        if (board1[27] == 1) begin if (x >= 3 && x <= 9 && y >= 23 && y <= 26) oled_data <= 16'hFFE0; end
        if (board1[28] == 1) begin if (x >= 13 && x <= 19 && y >= 23 && y <= 26) oled_data <= 16'hFFE0; end
        if (board1[29] == 1) begin if (x >= 23 && x <= 29 && y >= 23 && y <= 26) oled_data <= 16'hFFE0; end
        if (board1[30] == 1) begin if (x >= 34 && x <= 40 && y >= 23 && y <= 26) oled_data <= 16'hFFE0; end
        if (board1[31] == 1) begin if (x >= 44 && x <= 50 && y >= 23 && y <= 26) oled_data <= 16'hFFE0; end
        if (board1[32] == 1) begin if (x >= 54 && x <= 60 && y >= 23 && y <= 26) oled_data <= 16'hFFE0; end
        if (board1[33] == 1) begin if (x >= 65 && x <= 71 && y >= 23 && y <= 26) oled_data <= 16'hFFE0; end
        if (board1[34] == 1) begin if (x >= 75 && x <= 81 && y >= 23 && y <= 26) oled_data <= 16'hFFE0; end
        if (board1[35] == 1) begin if (x >= 85 && x <= 91 && y >= 23 && y <= 26) oled_data <= 16'hFFE0; end     
        if (board1[36] == 1) begin if (x >= 3 && x <= 9 && y >= 30 && y <= 33) oled_data <= 16'hFFE0; end
        if (board1[37] == 1) begin if (x >= 13 && x <= 19 && y >= 30 && y <= 33) oled_data <= 16'hFFE0; end
        if (board1[38] == 1) begin if (x >= 23 && x <= 29 && y >= 30 && y <= 33) oled_data <= 16'hFFE0; end
        if (board1[39] == 1) begin if (x >= 34 && x <= 40 && y >= 30 && y <= 33) oled_data <= 16'hFFE0; end
        if (board1[40] == 1) begin if (x >= 44 && x <= 50 && y >= 30 && y <= 33) oled_data <= 16'hFFE0; end
        if (board1[41] == 1) begin if (x >= 54 && x <= 60 && y >= 30 && y <= 33) oled_data <= 16'hFFE0; end
        if (board1[42] == 1) begin if (x >= 65 && x <= 71 && y >= 30 && y <= 33) oled_data <= 16'hFFE0; end
        if (board1[43] == 1) begin if (x >= 75 && x <= 81 && y >= 30 && y <= 33) oled_data <= 16'hFFE0; end
        if (board1[44] == 1) begin if (x >= 85 && x <= 91 && y >= 30 && y <= 33) oled_data <= 16'hFFE0; end
        if (board1[45] == 1) begin if (x >= 3 && x <= 9 && y >= 37 && y <= 40) oled_data <= 16'hFFE0; end
        if (board1[46] == 1) begin if (x >= 13 && x <= 19 && y >= 37 && y <= 40) oled_data <= 16'hFFE0; end
        if (board1[47] == 1) begin if (x >= 23 && x <= 29 && y >= 37 && y <= 40) oled_data <= 16'hFFE0; end
        if (board1[48] == 1) begin if (x >= 34 && x <= 40 && y >= 37 && y <= 40) oled_data <= 16'hFFE0; end
        if (board1[49] == 1) begin if (x >= 44 && x <= 50 && y >= 37 && y <= 40) oled_data <= 16'hFFE0; end
        if (board1[50] == 1) begin if (x >= 54 && x <= 60 && y >= 37 && y <= 40) oled_data <= 16'hFFE0; end
        if (board1[51] == 1) begin if (x >= 65 && x <= 71 && y >= 37 && y <= 40) oled_data <= 16'hFFE0; end
        if (board1[52] == 1) begin if (x >= 75 && x <= 81 && y >= 37 && y <= 40) oled_data <= 16'hFFE0; end
        if (board1[53] == 1) begin if (x >= 85 && x <= 91 && y >= 37 && y <= 40) oled_data <= 16'hFFE0; end  
        if (board1[54] == 1) begin if (x >= 3 && x <= 9 && y >= 44 && y <= 47) oled_data <= 16'hFFE0; end
        if (board1[55] == 1) begin if (x >= 13 && x <= 19 && y >= 44 && y <= 47) oled_data <= 16'hFFE0; end
        if (board1[56] == 1) begin if (x >= 23 && x <= 29 && y >= 44 && y <= 47) oled_data <= 16'hFFE0; end
        if (board1[57] == 1) begin if (x >= 34 && x <= 40 && y >= 44 && y <= 47) oled_data <= 16'hFFE0; end
        if (board1[58] == 1) begin if (x >= 44 && x <= 50 && y >= 44 && y <= 47) oled_data <= 16'hFFE0; end
        if (board1[59] == 1) begin if (x >= 54 && x <= 60 && y >= 44 && y <= 47) oled_data <= 16'hFFE0; end
        if (board1[60] == 1) begin if (x >= 65 && x <= 71 && y >= 44 && y <= 47) oled_data <= 16'hFFE0; end
        if (board1[61] == 1) begin if (x >= 75 && x <= 81 && y >= 44 && y <= 47) oled_data <= 16'hFFE0; end
        if (board1[62] == 1) begin if (x >= 85 && x <= 91 && y >= 44 && y <= 47) oled_data <= 16'hFFE0; end
        if (board1[63] == 1) begin if (x >= 3 && x <= 9 && y >= 51 && y <= 54) oled_data <= 16'hFFE0; end
        if (board1[64] == 1) begin if (x >= 13 && x <= 19 && y >= 51 && y <= 54) oled_data <= 16'hFFE0; end
        if (board1[65] == 1) begin if (x >= 23 && x <= 29 && y >= 51 && y <= 54) oled_data <= 16'hFFE0; end
        if (board1[66] == 1) begin if (x >= 34 && x <= 40 && y >= 51 && y <= 54) oled_data <= 16'hFFE0; end
        if (board1[67] == 1) begin if (x >= 44 && x <= 50 && y >= 51 && y <= 54) oled_data <= 16'hFFE0; end
        if (board1[68] == 1) begin if (x >= 54 && x <= 60 && y >= 51 && y <= 54) oled_data <= 16'hFFE0; end
        if (board1[69] == 1) begin if (x >= 65 && x <= 71 && y >= 51 && y <= 54) oled_data <= 16'hFFE0; end
        if (board1[70] == 1) begin if (x >= 75 && x <= 81 && y >= 51 && y <= 54) oled_data <= 16'hFFE0; end
        if (board1[71] == 1) begin if (x >= 85 && x <= 91 && y >= 51 && y <= 54) oled_data <= 16'hFFE0; end 
        if (board1[72] == 1) begin if (x >= 3 && x <= 9 && y >= 58 && y <= 61) oled_data <= 16'hFFE0; end
        if (board1[73] == 1) begin if (x >= 13 && x <= 19 && y >= 58 && y <= 61) oled_data <= 16'hFFE0; end
        if (board1[74] == 1) begin if (x >= 23 && x <= 29 && y >= 58 && y <= 61) oled_data <= 16'hFFE0; end
        if (board1[75] == 1) begin if (x >= 34 && x <= 40 && y >= 58 && y <= 61) oled_data <= 16'hFFE0; end
        if (board1[76] == 1) begin if (x >= 44 && x <= 50 && y >= 58 && y <= 61) oled_data <= 16'hFFE0; end
        if (board1[77] == 1) begin if (x >= 54 && x <= 60 && y >= 58 && y <= 61) oled_data <= 16'hFFE0; end
        if (board1[78] == 1) begin if (x >= 65 && x <= 71 && y >= 58 && y <= 61) oled_data <= 16'hFFE0; end
        if (board1[79] == 1) begin if (x >= 75 && x <= 81 && y >= 58 && y <= 61) oled_data <= 16'hFFE0; end
        if (board1[80] == 1) begin if (x >= 85 && x <= 91 && y >= 58 && y <= 61) oled_data <= 16'hFFE0; end  
        
        // Update for small win for player 0
        if (win0[0] == 1) begin
            if (x >= 3 && x <= 29 && y >= 2 && y <= 19)
                oled_data <= 16'hF800;
        end
        if (win0[1] == 1) begin
            if (x >= 34 && x <= 60 && y >= 2 && y <= 19)
                oled_data <= 16'hF800;
        end
        if (win0[2] == 1) begin
            if (x >= 65 && x <= 91 && y >= 2 && y <= 19)
                oled_data <= 16'hF800;
        end
        if (win0[3] == 1) begin
            if (x >= 3 && x <= 29 && y >= 23 && y <= 40)
                oled_data <= 16'hF800;
        end
        if (win0[4] == 1) begin
            if (x >= 34 && x <= 60 && y >= 23 && y <= 40)
                oled_data <= 16'hF800;
        end
        if (win0[5] == 1) begin
            if (x >= 65 && x <= 91 && y >= 23 && y <= 40)
                oled_data <= 16'hF800;
        end
        if (win0[6] == 1) begin
            if (x >= 3 && x <= 29 && y >= 44 && y <= 61)
                oled_data <= 16'hF800;
        end
        if (win0[7] == 1) begin
            if (x >= 34 && x <= 60 && y >= 44 && y <= 61)
                oled_data <= 16'hF800;
        end
        if (win0[8] == 1) begin
            if (x >= 65 && x <= 91 && y >= 44 && y <= 61)
                oled_data <= 16'hF800;
        end                                   
        
        // Update for small win for player 1
        if (win1[0] == 1) begin
            if (x >= 3 && x <= 29 && y >= 2 && y <= 19)
                oled_data <= 16'hFFE0;
        end
        if (win1[1] == 1) begin
            if (x >= 34 && x <= 60 && y >= 2 && y <= 19)
                oled_data <= 16'hFFE0;
        end
        if (win1[2] == 1) begin
            if (x >= 65 && x <= 91 && y >= 2 && y <= 19)
                oled_data <= 16'hFFE0;
        end
        if (win1[3] == 1) begin
            if (x >= 3 && x <= 29 && y >= 23 && y <= 40)
                oled_data <= 16'hFFE0;
        end
        if (win1[4] == 1) begin
            if (x >= 34 && x <= 60 && y >= 23 && y <= 40)
                oled_data <= 16'hFFE0;
        end
        if (win1[5] == 1) begin
            if (x >= 65 && x <= 91 && y >= 23 && y <= 40)
                oled_data <= 16'hFFE0;
        end
        if (win1[6] == 1) begin
            if (x >= 3 && x <= 29 && y >= 44 && y <= 61)
                oled_data <= 16'hFFE0;
        end
        if (win1[7] == 1) begin
            if (x >= 34 && x <= 60 && y >= 44 && y <= 61)
                oled_data <= 16'hFFE0;
        end
        if (win1[8] == 1) begin
            if (x >= 65 && x <= 91 && y >= 44 && y <= 61)
                oled_data <= 16'hFFE0;
        end                                   
                    
    end
     
endmodule
