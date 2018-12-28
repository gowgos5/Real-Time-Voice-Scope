`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2018 13:52:29
// Design Name: 
// Module Name: Waveform_Select
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

module Waveform_Select(
    input SEL,
    input [11:0] MIC_AVG,
    input [9:0] RAMP_WAVE,
    output [9:0] WAVE_SAMPLE
    );
    
    assign WAVE_SAMPLE = (SEL) ? (RAMP_WAVE) : (MIC_AVG >> 2);
    
endmodule