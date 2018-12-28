`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2018 18:03:47
// Design Name: 
// Module Name: Draw_Vol_History
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

module Draw_Vol_History(
    input CLK_VGA,
    input CLK_VOL_UPDATE,
    
    input [8:0] VOL_UPDATE_FREQ,
    input [4:0] MIC_VOL,
    
    input [11:0] VGA_HORZ_COORD,
    input [11:0] VGA_VERT_COORD,
    
    input DISP_VOL_HISTORY_SEL,
    output reg [3:0] VOL_HISTORY_RES = 0
    );
    
    parameter ON = 1;
    parameter OFF = 0;
    
    parameter WAVE_WINDOW_LEN = 350;
    parameter WAVE_WINDOW_WIDTH = 210;
    parameter WAVE_WINDOW_LEFT = 905;
    parameter WAVE_WINDOW_TOP = 789;
    parameter WAVE_WINDOW_RIGHT = WAVE_WINDOW_LEFT + WAVE_WINDOW_LEN;
    parameter WAVE_WINDOW_BOTTOM = WAVE_WINDOW_TOP + WAVE_WINDOW_WIDTH;
    parameter WAVEFORM_HEIGHT = 8;
    parameter BORDER_WIDTH = 1;
          
    parameter TEXT_SPACING = 15;
    parameter TEXT_LEFT = WAVE_WINDOW_LEFT + 32;
    parameter TEXT_TOP = WAVE_WINDOW_TOP + TEXT_SPACING;

    parameter VOL_HISTORY_UPDATE_FREQ = 10;   // in Hz
    parameter VOL_ARRAY_MAX = WAVE_WINDOW_LEN - 1;
    
    
    /* VOLUME GENERATION */
    reg [4:0] num_vol_samples = 0;
    wire [4:0] max_vol_samples = VOL_UPDATE_FREQ / VOL_HISTORY_UPDATE_FREQ;
    reg [11:0] vol_sum = 0;
    
    reg [8:0] i;
    reg [4:0] history_vol [VOL_ARRAY_MAX:0];
    reg [9:0] vol_index = 0;
    
    // Allow the waveform to shift to the left as time goes by.
    reg overflow = 0;
    reg [8:0] overflow_index = 0;
    
    always @ (posedge CLK_VOL_UPDATE) begin
        vol_sum = vol_sum + MIC_VOL;
        num_vol_samples = num_vol_samples + 1;
        
        if (num_vol_samples >= max_vol_samples) begin
            if (i == VOL_ARRAY_MAX)
                overflow = 1;
            
            if (overflow)
                overflow_index = (overflow_index == VOL_ARRAY_MAX) ? 
                    0 : overflow_index + 1;
        
            i = (i == VOL_ARRAY_MAX) ? 0 : i + 1;
            history_vol[i] = vol_sum / num_vol_samples;
            vol_sum = 0;
            num_vol_samples = 0;
        end
    end
    
    wire text_res, waveform_res, background_res, border_res;
    
    /* GRAPHICS GENERATION */
    /* VOLUME HISTORY TEXT */
    Pixel_On_Text2 #(.displayText("AVERAGE VOLUME OVER PAST 35 SECONDS")) text_01                   
        (CLK_VGA, TEXT_LEFT, TEXT_TOP, VGA_HORZ_COORD, VGA_VERT_COORD, text_res);
    
     /* VOLUME HISTORY WAVEFORM */
    assign waveform_res = (VGA_HORZ_COORD >= WAVE_WINDOW_LEFT) && 
       (VGA_HORZ_COORD <= WAVE_WINDOW_RIGHT) && (VGA_VERT_COORD >=
       (WAVE_WINDOW_BOTTOM - (history_vol[vol_index] * WAVEFORM_HEIGHT))) && 
       (VGA_VERT_COORD <= WAVE_WINDOW_BOTTOM);
    
    /* VOLUME HISTORY WINDOW BACKGROUND */
    assign background_res = ((VGA_HORZ_COORD >= WAVE_WINDOW_LEFT) &&
       (VGA_HORZ_COORD <= WAVE_WINDOW_RIGHT) && (VGA_VERT_COORD >= WAVE_WINDOW_TOP) &&
       (VGA_VERT_COORD <= WAVE_WINDOW_BOTTOM));
           
    wire border_left = (VGA_HORZ_COORD >= WAVE_WINDOW_LEFT) && 
       (VGA_HORZ_COORD <= (WAVE_WINDOW_LEFT + BORDER_WIDTH));
    wire border_right = (VGA_HORZ_COORD >= (WAVE_WINDOW_RIGHT - BORDER_WIDTH))
       && (VGA_HORZ_COORD <= WAVE_WINDOW_RIGHT);
    wire border_top = (VGA_VERT_COORD >= WAVE_WINDOW_TOP) && 
       (VGA_VERT_COORD <= (WAVE_WINDOW_TOP + BORDER_WIDTH));
    wire border_bottom = (VGA_VERT_COORD >= (WAVE_WINDOW_BOTTOM - BORDER_WIDTH))
       && (VGA_VERT_COORD <= WAVE_WINDOW_BOTTOM);
       
    /* VOLUME HISTORY WINDOW BORDER */
    assign border_res = background_res && (border_left || border_right || border_top || border_bottom);
    
    // Update volume history waveform
    always @ (posedge CLK_VGA) begin
        if ((VGA_HORZ_COORD >= WAVE_WINDOW_LEFT) && (VGA_HORZ_COORD <= 
            WAVE_WINDOW_RIGHT)) begin
            vol_index = (VGA_HORZ_COORD - WAVE_WINDOW_LEFT) + overflow_index;
            
            vol_index = (vol_index >= VOL_ARRAY_MAX) ? 
                (vol_index - VOL_ARRAY_MAX) : vol_index;
        end
    end
    
    always @ (*) begin
        case (DISP_VOL_HISTORY_SEL)
            ON: VOL_HISTORY_RES = {background_res, border_res, waveform_res, text_res};
            OFF: VOL_HISTORY_RES = 0;
        endcase
    end
    
endmodule