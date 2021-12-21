`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2021 02:42:34 PM
// Design Name: 
// Module Name: CLOCKA
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


module clock_divider(
    input CLOCK,
    input [31:0] my_m_value,
    output reg clk_20khz
    );
    
    reg [31:0] count = 0;
    always @ (posedge CLOCK)
    begin
        count <= (count == my_m_value) ? 0 : (count + 1);
        clk_20khz <= (count == 0) ? ~clk_20khz : clk_20khz; 
    end
    
endmodule

module debounced_pulse(
    input CLOCK, button,
    output pulse
    );
    wire Q0, Q1;

    d_ff d1(CLOCK, button, Q0);
    d_ff d2(CLOCK, Q0, Q1);
        
    and(pulse,Q0,~Q1);
    
endmodule

module d_ff(
    input CLOCK, button,
    output reg Q = 0
    );
    
    always @(posedge CLOCK)
    begin
        Q <= button;
    end
    
endmodule