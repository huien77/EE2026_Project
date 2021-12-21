`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//
//  LAB SESSION DAY (Delete where applicable): MONDAY P.M
//
//  STUDENT A NAME: Tan Jun Heng Daren Justin
//  STUDENT A MATRICULATION NUMBER: A0219673W
//
//  STUDENT B NAME: Tan Hui En
//  STUDENT B MATRICULATION NUMBER: A0221841N
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
    input  CLOCK,
    input  SW0,SW1,SW2,SW3,SW4,SW5,SW6,SW7,SW8,SW9,SW10,SW11,SW12,SW13,SW14,SW15,
    input  BUTTON, U_button, L_button, R_button, D_button,
    input  J_MIC3_Pin3,   // Connect from this signal to Audio_Capture.v
    output J_MIC3_Pin1,   // Connect to this signal from Audio_Capture.v
    output J_MIC3_Pin4,   // Connect to this signal from Audio_Capture.v
    output [15:0] led,
    output [7:0] JX,
    output [3:0] an,
    output [6:0] seg
    );

    // Clock Instantiation
    wire clk_20khz, clk_6p25mhz, clk_10hz, clk_48hz;
    clock_divider unit_clk20khz(CLOCK, 2499, clk_20khz);
    clock_divider unit_clk6p25mhz(CLOCK, 7, clk_6p25mhz);
    clock_divider unit_clk10hz(CLOCK, 4999999, clk_10hz);
    clock_divider unit_clk48hz(CLOCK, 1041666, clk_48hz);
    
    // OLED variables
    wire reset, up, left, right, down;
    wire frame_begin, sending_pixels, sample_pixel;
    wire [12:0] pixel_index;  //current pixel being updated
    wire [4:0] teststate;
    wire [15:0] oled_data;    //16bit colour, 5bit (red), 6bit(green), 5bit(blue)
   
    // DFF Instantiation
    debounced_pulse d1(clk_48hz, BUTTON, reset);
    debounced_pulse d2(clk_48hz, L_button, left);
    debounced_pulse d3(clk_48hz, R_button, right);
    debounced_pulse d4(clk_48hz, U_button, up);
    debounced_pulse d5(clk_48hz, D_button, down);
    
    // Task ID variable
    wire [3:0] task_id;
        
    // Main Menu (Task 0)
    wire [15:0] oled_data_menu;
    main_menu(CLOCK, left, right, reset, SW1, pixel_index, oled_data_menu, task_id);
       
    // Instantiate the Audio_Capture.v module (Task 1A)
    wire [11:0] mic_in;
    Audio_Capture(CLOCK, clk_20khz, J_MIC3_Pin3, J_MIC3_Pin1, J_MIC3_Pin4, mic_in);

    // Instantiate the Oled_Display.v module (Task 1B)
    Oled_Display(clk_6p25mhz, reset, frame_begin, sending_pixels, sample_pixel, 
                 pixel_index, oled_data, JX[0], JX[1], JX[3], JX[4], JX[5], JX[6], JX[7], teststate);
    
    // For Task 2A
    wire [11:0] peak;
    wire [3:0] volume;
    wire [3:0] an_2a;
    wire [6:0] seg_2a;
    peak_algorithm(mic_in, CLOCK, peak);
    light_up(CLOCK, mic_in, peak, SW0, led);
    seven_seg(peak, SW2, CLOCK, an_2a, seg_2a, volume);
    
    // For Task 2B
    wire [5:0] y_coor;
    wire [6:0] x_coor;
    wire [15:0] oled_data_2b;
    index_coordinate(pixel_index, y_coor, x_coor);
    print_oled(SW15, SW14, SW13, SW12, SW11, SW1, CLOCK, left, right, volume, x_coor, y_coor, oled_data_2b);
    
    // Overworked Game (Task 3A)
    wire [3:0] an_3a;
    wire [6:0] seg_3a;
    wire [15:0] oled_data_3a;
    overworked(CLOCK, up, down, left, right, U_button, D_button, L_button, R_button,reset, SW1,
               pixel_index, task_id, oled_data_3a, an_3a, seg_3a);
    
    // Simon Says / Pattern Recogntion Game (Task 4B)
    wire [15:0] oled_data_4b;
    simon_says(CLOCK, up, down, left, right, x_coor, y_coor, task_id, oled_data_4b);
    
    // Ultimate Tic-Tac-Toe (Task 5)
    wire [3:0] an_5;
    wire [6:0] seg_5;
    wire [15:0] oled_data_5;
    ultimate_TTT(CLOCK, up, down, left, right, reset, SW1, task_id, pixel_index, oled_data_5, an_5, seg_5); 
    
    // Assignment to 7-Segment and OLED Display
    assign an = (task_id == 2) ? an_2a : (task_id == 3) ? an_3a : (task_id == 5) ? an_5 : 4'b1111;
    assign seg = (task_id == 2) ? seg_2a : (task_id == 3) ? seg_3a : (task_id == 5)? seg_5 : 7'b1111111;
    assign oled_data = (task_id == 0) ? oled_data_menu : (task_id == 2) ? oled_data_2b : 
                       (task_id == 3) ? oled_data_3a : (task_id == 4) ? oled_data_4b : oled_data_5;
    
endmodule