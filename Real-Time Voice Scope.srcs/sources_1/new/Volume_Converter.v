`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2018 13:43:37
// Design Name: 
// Module Name: Volume_Converter
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

module Volume_Converter(
    input CLK_SAMPLE,
    input [8:0] VOL_UPDATE_FREQ,
    input [11:0] MIC_IN,
    output reg [11:0] MIC_AVG = 0,
    output reg [4:0] MIC_VOL = 0
    );
    
    parameter MIC_SAMPLE_FREQ = 20000;
    parameter BIAS = 2050;
    parameter VOL_INTERVAL = 100;
    
    reg [3:0] num_samples = 0;
    wire [3:0] max_samples = 4;
    reg [8:0] num_peak_samples = 0;
    wire [8:0] max_peak_samples = (MIC_SAMPLE_FREQ / max_samples) / VOL_UPDATE_FREQ;
    
    reg [11:0] mic_tmp = 0;
    reg [11:0] mic_peak = 0;
    reg [31:0] mic_peak_sum = 0;
    
    always @ (posedge CLK_SAMPLE) begin
        /* AVERAGE OF PEAKS CALCULATION */     
        mic_tmp = (MIC_IN < BIAS) ? (BIAS + (BIAS - MIC_IN)) : MIC_IN;
        
        if (mic_peak < mic_tmp)
            mic_peak = mic_tmp;
        
        num_samples = num_samples + 1;
        
        // Add in peak value obtained.
        if (num_samples >= max_samples) begin
            mic_peak_sum = mic_peak_sum + mic_peak;
            num_peak_samples = num_peak_samples + 1;
            mic_peak = 0;
            num_samples = 0;
        end
        
        // Average sum of peak values to obtain volume.
        if (num_peak_samples >= max_peak_samples) begin
            MIC_AVG = mic_peak_sum / num_peak_samples;
            MIC_VOL = (MIC_AVG - BIAS) / VOL_INTERVAL;
            mic_peak_sum = 0;
            num_peak_samples = 0;
        end
    end
    
endmodule