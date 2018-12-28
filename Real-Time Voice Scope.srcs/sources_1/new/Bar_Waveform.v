`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2018 17:37:04
// Design Name: 
// Module Name: Bar_Waveform
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

module Bar_Waveform(
    input CLK_VGA,
    input CLK_DISP_REFRESH,
    input CLK_VOL_UPDATE,
    
    input [11:0] VGA_HORZ_COORD,
    input [11:0] VGA_VERT_COORD,
    input [2:0] DISP_THEME_SEL,
    
    input [4:0] MIC_VOL,
    
    output reg [11:0] WAVEFORM,
    output WAVEFORM_RES
    );
    
    // Expressed in terms of the number of pixels.
    parameter BAR_WIDTH = 128;
    parameter BAR_SPACING = 4;
    parameter BLOCK_HEIGHT = 20;
    parameter BLOCK_SPACING = 1;
    parameter MAX_NUM_BLOCKS = 20;
    parameter WAVEFORM_WINDOW_LEFT = 0;
    parameter WAVEFORM_WINDOW_RIGHT = 1279;
    parameter ZERO_LEVEL = 512;
    parameter AREA_ONE_LEVEL = ZERO_LEVEL - (6 * BLOCK_HEIGHT);
    parameter AREA_TWO_LEVEL = ZERO_LEVEL - (11 * BLOCK_HEIGHT);
    parameter AREA_THREE_LEVEL = ZERO_LEVEL - (15 * BLOCK_HEIGHT);
    parameter AREA_FOUR_LEVEL = ZERO_LEVEL - (18 * BLOCK_HEIGHT);
    parameter AREA_FIVE_LEVEL = ZERO_LEVEL - (MAX_NUM_BLOCKS * BLOCK_HEIGHT);
    parameter VOL_ARRAY_MAX = (1280 / BAR_WIDTH) - 1;
    
    parameter THEME_ONE = 0;
    parameter THEME_TWO = 1;
    parameter THEME_THREE = 2;
    parameter THEME_FOUR = 3;
    parameter THEME_FIVE = 4;
    
    reg [11:0] WAVEFORM_COLOURS[4:0][4:0];
    
    initial begin
        WAVEFORM_COLOURS[THEME_ONE][0] = 12'hFE8;
        WAVEFORM_COLOURS[THEME_ONE][1] = 12'hE9B;
        WAVEFORM_COLOURS[THEME_ONE][2] = 12'hBEB;
        WAVEFORM_COLOURS[THEME_ONE][3] = 12'h298;
        WAVEFORM_COLOURS[THEME_ONE][4] = 12'h166;
        
        WAVEFORM_COLOURS[THEME_TWO][0] = 12'h405;
        WAVEFORM_COLOURS[THEME_TWO][1] = 12'h804;
        WAVEFORM_COLOURS[THEME_TWO][2] = 12'hB31;
        WAVEFORM_COLOURS[THEME_TWO][3] = 12'hF90;
        WAVEFORM_COLOURS[THEME_TWO][4] = 12'hFF0;
        
        WAVEFORM_COLOURS[THEME_THREE][0] = 12'h00F;
        WAVEFORM_COLOURS[THEME_THREE][1] = 12'h007;
        WAVEFORM_COLOURS[THEME_THREE][2] = 12'h425;
        WAVEFORM_COLOURS[THEME_THREE][3] = 12'hF87;
        WAVEFORM_COLOURS[THEME_THREE][4] = 12'hF00;
        
        WAVEFORM_COLOURS[THEME_FOUR][0] = 12'h8C0;
        WAVEFORM_COLOURS[THEME_FOUR][1] = 12'hFF0;
        WAVEFORM_COLOURS[THEME_FOUR][2] = 12'hFB0;
        WAVEFORM_COLOURS[THEME_FOUR][3] = 12'hF70;
        WAVEFORM_COLOURS[THEME_FOUR][4] = 12'hF00;
        
        WAVEFORM_COLOURS[THEME_FIVE][0] = 12'h4D0;
        WAVEFORM_COLOURS[THEME_FIVE][1] = 12'hAD0;
        WAVEFORM_COLOURS[THEME_FIVE][2] = 12'hDD0;
        WAVEFORM_COLOURS[THEME_FIVE][3] = 12'hD80;
        WAVEFORM_COLOURS[THEME_FIVE][4] = 12'hE20;
    end
    
    /* VOLUME CALCULATION */
    reg [10:0] i;
    reg [4:0] vol [VOL_ARRAY_MAX:0];
    
    reg [10:0] j;
    reg [4:0] current_vol [VOL_ARRAY_MAX:0];
    
    wire [10:0] vol_index = VGA_HORZ_COORD / BAR_WIDTH;
            
    // Update volume levels.
    always @ (posedge CLK_VOL_UPDATE) begin
        i = (i == VOL_ARRAY_MAX) ? 0 : (i + 1);
        vol[i] <= MIC_VOL;  // range from 0 to 20.
    end
    
    // Allows for a smooth transition between volume levels of the
    // VGA display volume indicator.
    always @ (posedge CLK_DISP_REFRESH) begin
        j = (j == VOL_ARRAY_MAX) ? 0 : (j + 1);
        
        if (current_vol[j] < vol[j]) begin
            current_vol[j] <= current_vol[j] + 1;
        end
        else if (current_vol[j] > vol[j]) begin
            current_vol[j] <= current_vol[j] - 1;
        end
    end
    
    
    /* WAVEFORM GENERATION */
    wire waveform_window = (VGA_HORZ_COORD >= WAVEFORM_WINDOW_LEFT) && (VGA_HORZ_COORD <= WAVEFORM_WINDOW_RIGHT)
        && (VGA_VERT_COORD <= ZERO_LEVEL);
    wire bar_spacing = (VGA_HORZ_COORD % BAR_WIDTH) >= BAR_SPACING;
    wire block_spacing = (waveform_window) ? (((ZERO_LEVEL - VGA_VERT_COORD) % BLOCK_HEIGHT) >= BLOCK_SPACING) : 0;
    wire base = (VGA_VERT_COORD == ZERO_LEVEL);
    wire bar = VGA_VERT_COORD >= (ZERO_LEVEL - (current_vol[vol_index] * BLOCK_HEIGHT));
    
    wire area_one = (VGA_VERT_COORD <= ZERO_LEVEL) && (VGA_VERT_COORD >= AREA_ONE_LEVEL);
    wire area_two = (VGA_VERT_COORD <= AREA_ONE_LEVEL) && 
        (VGA_VERT_COORD >= AREA_TWO_LEVEL);
    wire area_three = (VGA_VERT_COORD <= AREA_TWO_LEVEL) && 
        (VGA_VERT_COORD >= AREA_THREE_LEVEL);
    wire area_four = (VGA_VERT_COORD <= AREA_THREE_LEVEL) && 
        (VGA_VERT_COORD >= AREA_FOUR_LEVEL);
    wire area_five = (VGA_VERT_COORD <= AREA_FOUR_LEVEL) && 
        (VGA_VERT_COORD >= AREA_FIVE_LEVEL);
    
    assign WAVEFORM_RES = (bar && bar_spacing && block_spacing && waveform_window) || base;
    
    always @ (posedge CLK_VGA) begin
        if (WAVEFORM_RES) begin 
            if (area_one)
                WAVEFORM = WAVEFORM_COLOURS[DISP_THEME_SEL][0];
            else if (area_two)
                WAVEFORM = WAVEFORM_COLOURS[DISP_THEME_SEL][1];
            else if (area_three)
                WAVEFORM = WAVEFORM_COLOURS[DISP_THEME_SEL][2];
            else if (area_four)
                WAVEFORM = WAVEFORM_COLOURS[DISP_THEME_SEL][3];
            else if (area_five)
                WAVEFORM = WAVEFORM_COLOURS[DISP_THEME_SEL][4];
            else
                WAVEFORM = 0;
        end
        else
            WAVEFORM = 0;
    end
    
endmodule