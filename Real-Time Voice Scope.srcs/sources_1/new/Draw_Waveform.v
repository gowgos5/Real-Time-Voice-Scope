`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// You may study and modify the code inside this module to imporve the display feature or introduce other features
//////////////////////////////////////////////////////////////////////////////////

module Draw_Waveform(
    input CLK_VGA,
    input clk_sample,
    input CLK_VOL_UPDATE,
    input CLK_DISP_REFRESH,
        
    input [11:0] VGA_HORZ_COORD,
    input [11:0] VGA_VERT_COORD,
        
    input [9:0] wave_sample,
    input [4:0] MIC_VOL,
    
    input [1:0] DISP_WAVEFORM_SEL,
    input [2:0] DISP_THEME_SEL,
    input [3:0] MENU_RES,
    
    output reg [3:0] VGA_Red_waveform = 0,
    output reg [3:0] VGA_Green_waveform = 0,
    output reg [3:0] VGA_Blue_waveform = 0,
    
    output reg WAVEFORM_RES
    );
    
    parameter NORMAL = 0;
    parameter BAR = 1;
    parameter CIRCLE = 2;
    parameter OFF = 3;
    
    wire [11:0] normal_waveform;
    wire [11:0] bar_waveform;
    wire [11:0] circle_waveform;
    reg [11:0] waveform;
    
    wire normal_res, bar_res, circle_res;
    
    Normal_Waveform normal(.CLK_SAMPLE(clk_sample), .VGA_HORZ_COORD(VGA_HORZ_COORD),
        .VGA_VERT_COORD(VGA_VERT_COORD), .WAVE_SAMPLE(wave_sample), .DISP_THEME_SEL(DISP_THEME_SEL),
        .WAVEFORM(normal_waveform), .WAVEFORM_RES(normal_res));
        
    Bar_Waveform bar(.CLK_VGA(CLK_VGA), .CLK_DISP_REFRESH(CLK_DISP_REFRESH), .CLK_VOL_UPDATE(CLK_VOL_UPDATE), 
        .VGA_HORZ_COORD(VGA_HORZ_COORD), .VGA_VERT_COORD(VGA_VERT_COORD), .DISP_THEME_SEL(DISP_THEME_SEL),
        .MIC_VOL(MIC_VOL), .WAVEFORM(bar_waveform), .WAVEFORM_RES(bar_res));
        
    Circle_Waveform circle(.CLK_VGA(CLK_VGA), .CLK_DISP_REFRESH(CLK_DISP_REFRESH),
        .CLK_VOL_UPDATE(CLK_VOL_UPDATE), .VGA_HORZ_COORD(VGA_HORZ_COORD), .VGA_VERT_COORD(VGA_VERT_COORD),
        .DISP_THEME_SEL(DISP_THEME_SEL), .MIC_VOL(MIC_VOL), .WAVEFORM(circle_waveform), 
        .WAVEFORM_RES(circle_res));
        
        
    always @ (*) begin
        if (MENU_RES) begin
            waveform = 0;
            WAVEFORM_RES = 0;
        end
        else begin
            case (DISP_WAVEFORM_SEL)
                NORMAL: begin
                    waveform = normal_waveform;
                    WAVEFORM_RES = normal_res;
                end
                BAR: begin
                    waveform = bar_waveform;
                    WAVEFORM_RES = bar_res;
                end
                CIRCLE: begin
                    waveform = circle_waveform;
                    WAVEFORM_RES = circle_res;
                end
                OFF: begin
                    waveform = 0;
                    WAVEFORM_RES = 0;
                end
            endcase
        end
        
        VGA_Red_waveform <= waveform[11:8];
        VGA_Green_waveform <= waveform[7:4];
        VGA_Blue_waveform <= waveform[3:0];
    end
        
endmodule