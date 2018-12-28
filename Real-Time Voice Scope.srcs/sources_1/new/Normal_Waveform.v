`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2018 17:37:04
// Design Name: 
// Module Name: Normal_Waveform
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

module Normal_Waveform(
    input CLK_SAMPLE,
    
    input [11:0] VGA_HORZ_COORD,
    input [11:0] VGA_VERT_COORD,
    
    input [9:0] WAVE_SAMPLE,
    input [2:0] DISP_THEME_SEL,
    
    output [11:0] WAVEFORM,
    output WAVEFORM_RES
    );
    
    parameter THEME_ONE = 0;
    parameter THEME_TWO = 1;
    parameter THEME_THREE = 2;
    parameter THEME_FOUR = 3;
    parameter THEME_FIVE = 4;
    
    reg [11:0] WAVEFORM_COLOURS[4:0];
    
    initial begin
        WAVEFORM_COLOURS[THEME_ONE] = 12'h298;
        WAVEFORM_COLOURS[THEME_TWO] = 12'hB31;
        WAVEFORM_COLOURS[THEME_THREE] = 12'hF87;
        WAVEFORM_COLOURS[THEME_FOUR] = 12'h804;
        WAVEFORM_COLOURS[THEME_FIVE] = 12'hD80;
    end
    
    // The Sample_Memory represents the memory array used to store the mic samples.
    // There are 1280 points and each point can range from 0 to 1023. 
    reg [9:0] Sample_Memory [1279:0];
    reg [10:0] i;
    
    // Each WAVE_SAMPLE is displayed on the screen from left to right.
    always @ (posedge CLK_SAMPLE) begin
        i = (i == 1279) ? 0 : (i + 1);
        Sample_Memory[i] <= WAVE_SAMPLE;
    end
    
    assign WAVEFORM_RES = (VGA_HORZ_COORD < 1280) && (VGA_VERT_COORD == (1024 - 
        Sample_Memory[VGA_HORZ_COORD]));
    
    assign WAVEFORM = (WAVEFORM_RES) ? WAVEFORM_COLOURS[DISP_THEME_SEL] : 0;

endmodule