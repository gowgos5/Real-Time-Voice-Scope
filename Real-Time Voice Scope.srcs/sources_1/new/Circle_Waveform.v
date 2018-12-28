`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2018 17:37:57
// Design Name: 
// Module Name: Circle_Waveform
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

module Circle_Waveform(
    input CLK_VGA,
    input CLK_DISP_REFRESH,
    input CLK_VOL_UPDATE,
    
    input [11:0] VGA_HORZ_COORD,
    input [11:0] VGA_VERT_COORD,
    input [2:0] DISP_THEME_SEL,
    
    input [4:0] MIC_VOL,
    output reg [11:0] WAVEFORM = 0,
    output WAVEFORM_RES
    );
    
    parameter BASE_INNER_RADIUS = 140;
    parameter BASE_OUTER_RADIUS = 150;
    parameter BASE_CENTER_X = 639;
    parameter BASE_CENTER_Y = 511;
    parameter MAX_NUM_CIRCLES = 20;
    parameter CIRCLES_INTERVAL = 10;
    parameter NUM_SECTORS = 8;
    parameter VOL_ARRAY_MAX = NUM_SECTORS - 1;
    
    parameter THEME_ONE = 0;
    parameter THEME_TWO = 1;
    parameter THEME_THREE = 2;
    parameter THEME_FOUR = 3;
    parameter THEME_FIVE = 4;
    
    reg [11:0] WAVEFORM_COLOURS[4:0][7:0];
    
    initial begin
        WAVEFORM_COLOURS[THEME_ONE][0] = 12'h09F;
        WAVEFORM_COLOURS[THEME_ONE][1] = 12'hD0F;
        WAVEFORM_COLOURS[THEME_ONE][2] = 12'hFF0;
        WAVEFORM_COLOURS[THEME_ONE][3] = 12'h0F0;
        WAVEFORM_COLOURS[THEME_ONE][4] = 12'h0EF;
        WAVEFORM_COLOURS[THEME_ONE][5] = 12'hE75;
        WAVEFORM_COLOURS[THEME_ONE][6] = 12'hF90;
        WAVEFORM_COLOURS[THEME_ONE][7] = 12'h0A0;
        
        WAVEFORM_COLOURS[THEME_TWO][0] = 12'h405;
        WAVEFORM_COLOURS[THEME_TWO][1] = 12'h804;
        WAVEFORM_COLOURS[THEME_TWO][2] = 12'hFF0;
        WAVEFORM_COLOURS[THEME_TWO][3] = 12'hF86;
        WAVEFORM_COLOURS[THEME_TWO][4] = 12'hC0F;
        WAVEFORM_COLOURS[THEME_TWO][5] = 12'hC48;
        WAVEFORM_COLOURS[THEME_TWO][6] = 12'hF90;
        WAVEFORM_COLOURS[THEME_TWO][7] = 12'hB31;
        
        WAVEFORM_COLOURS[THEME_THREE][0] = 12'h00F;
        WAVEFORM_COLOURS[THEME_THREE][1] = 12'h007;
        WAVEFORM_COLOURS[THEME_THREE][2] = 12'h425;
        WAVEFORM_COLOURS[THEME_THREE][3] = 12'hF87;
        WAVEFORM_COLOURS[THEME_THREE][4] = 12'hF00;
        WAVEFORM_COLOURS[THEME_THREE][5] = 12'hF0B;
        WAVEFORM_COLOURS[THEME_THREE][6] = 12'hC50;
        WAVEFORM_COLOURS[THEME_THREE][7] = 12'hFF0;
        
        WAVEFORM_COLOURS[THEME_FOUR][0] = 12'h8C0;
        WAVEFORM_COLOURS[THEME_FOUR][1] = 12'hFF0;
        WAVEFORM_COLOURS[THEME_FOUR][2] = 12'hF60;
        WAVEFORM_COLOURS[THEME_FOUR][3] = 12'hF00;
        WAVEFORM_COLOURS[THEME_FOUR][4] = 12'h00F;
        WAVEFORM_COLOURS[THEME_FOUR][5] = 12'h0F9;
        WAVEFORM_COLOURS[THEME_FOUR][6] = 12'hF05;
        WAVEFORM_COLOURS[THEME_FOUR][7] = 12'hFAA;
        
        WAVEFORM_COLOURS[THEME_FIVE][0] = 12'hE20;
        WAVEFORM_COLOURS[THEME_FIVE][1] = 12'hD80;
        WAVEFORM_COLOURS[THEME_FIVE][2] = 12'hDD0;
        WAVEFORM_COLOURS[THEME_FIVE][3] = 12'h4D0;
        WAVEFORM_COLOURS[THEME_FIVE][4] = 12'h00F;
        WAVEFORM_COLOURS[THEME_FIVE][5] = 12'h407;
        WAVEFORM_COLOURS[THEME_FIVE][6] = 12'h80C;
        WAVEFORM_COLOURS[THEME_FIVE][7] = 12'hFFF;
    end
    
    
    /* VOLUME CALCULATION */
    reg [2:0] i;
    reg [4:0] vol [VOL_ARRAY_MAX:0];
    
    reg [2:0] j;
    reg [4:0] current_vol [VOL_ARRAY_MAX:0];
            
    // Update volume levels.
    always @ (posedge CLK_VOL_UPDATE) begin
        i = (i == VOL_ARRAY_MAX) ? 0 : (i + 1);
        vol[i] <= MIC_VOL;  // range from 0 to 20.
    end
    
    // Allow for a smooth transition between volume levels of the
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
    wire vertical_spacing = ((VGA_VERT_COORD <= 504) || (VGA_VERT_COORD >= 518));
    wire horizontal_spacing = ((VGA_HORZ_COORD <= 632) || (VGA_HORZ_COORD >= 646));
    wire diagonal_spacing_one = (((VGA_HORZ_COORD + VGA_VERT_COORD) <= 1143) ||
        ((VGA_HORZ_COORD + VGA_VERT_COORD) >= 1157));
    wire diagonal_spacing_two = (((VGA_HORZ_COORD - VGA_VERT_COORD) <= 122) ||
        ((VGA_HORZ_COORD - VGA_VERT_COORD) >= 136));
        
    wire sector_one = ((VGA_HORZ_COORD + VGA_VERT_COORD) > 1150) && (VGA_VERT_COORD < 511);
    wire sector_two = ((VGA_HORZ_COORD + VGA_VERT_COORD) < 1150) && (VGA_HORZ_COORD > 639);
    wire sector_three = (VGA_HORZ_COORD > (128 + VGA_VERT_COORD)) && (VGA_HORZ_COORD < 639);
    wire sector_four = (VGA_HORZ_COORD < (128 + VGA_VERT_COORD)) && (VGA_VERT_COORD < 511);
    wire sector_five = ((VGA_HORZ_COORD + VGA_VERT_COORD) < 1150) && (VGA_VERT_COORD > 511);
    wire sector_six = ((VGA_HORZ_COORD + VGA_VERT_COORD) > 1150) && (VGA_HORZ_COORD < 639) ;
    wire sector_seven = (VGA_HORZ_COORD < (128 + VGA_VERT_COORD)) && (VGA_HORZ_COORD > 639);
    wire sector_eight = (VGA_HORZ_COORD > (128 + VGA_VERT_COORD)) && (VGA_VERT_COORD > 511);
        
    reg [3:0] sector_index = 0;
    wire [20:0] inner_radius = (current_vol[sector_index]*CIRCLES_INTERVAL) + BASE_INNER_RADIUS;
    wire [20:0] outer_radius = (current_vol[sector_index]*CIRCLES_INTERVAL) + BASE_OUTER_RADIUS;
        
    // x^2 + y^2 = r^2
    wire circle = (((VGA_HORZ_COORD - BASE_CENTER_X) * (VGA_HORZ_COORD - BASE_CENTER_X) + 
        (VGA_VERT_COORD - BASE_CENTER_Y) * (VGA_VERT_COORD - BASE_CENTER_Y)) >= (inner_radius * inner_radius))
        && (((VGA_HORZ_COORD - BASE_CENTER_X) * (VGA_HORZ_COORD - BASE_CENTER_X) + 
        (VGA_VERT_COORD - BASE_CENTER_Y) * (VGA_VERT_COORD - BASE_CENTER_Y)) <= (outer_radius * outer_radius));
    
    assign WAVEFORM_RES = circle && vertical_spacing && horizontal_spacing && 
                diagonal_spacing_one && diagonal_spacing_two;
    
    // Colours
    always @ (posedge CLK_VGA) begin
        if (WAVEFORM_RES) begin
            if (sector_one) begin
                WAVEFORM = WAVEFORM_COLOURS[DISP_THEME_SEL][0];
            end
            else if (sector_two) begin
                WAVEFORM = WAVEFORM_COLOURS[DISP_THEME_SEL][1];
            end
            else if (sector_three) begin
                WAVEFORM = WAVEFORM_COLOURS[DISP_THEME_SEL][2];
            end
            else if (sector_four) begin
                WAVEFORM = WAVEFORM_COLOURS[DISP_THEME_SEL][3];
            end
            else if (sector_five) begin
                WAVEFORM = WAVEFORM_COLOURS[DISP_THEME_SEL][4];
            end
            else if (sector_six) begin
                WAVEFORM = WAVEFORM_COLOURS[DISP_THEME_SEL][5];
            end
            else if (sector_seven)  begin
                WAVEFORM = WAVEFORM_COLOURS[DISP_THEME_SEL][6];
            end
            else if (sector_eight) begin
                WAVEFORM = WAVEFORM_COLOURS[DISP_THEME_SEL][7];
            end
        end
        else begin
            WAVEFORM <= 0;
        end
    end
    
    // Volume levels
    always @ (posedge CLK_VGA) begin
        if (sector_one) begin
            sector_index = 0;
        end
        else if (sector_two) begin
            sector_index <= 1;
        end
        else if (sector_three) begin
            sector_index <= 2;
        end
        else if (sector_four) begin
            sector_index <= 3;
        end
        else if (sector_five) begin
            sector_index <= 4;
        end
        else if (sector_six) begin
            sector_index <= 5;
        end
        else if (sector_seven)  begin
            sector_index <= 6;
        end
        else if (sector_eight) begin
            sector_index <= 7;
        end
    end
        
endmodule