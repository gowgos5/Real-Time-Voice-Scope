`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2018 15:49:22
// Design Name: 
// Module Name: Disp_Config
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

module Disp_Config(
    input CLK_BTNS_DEBOUNCE,
    
    input [2:0] BTNS_CONFIG,    // [0] -> BTN_L, [1] -> BTN_R, [2] -> BTN_C
    input [1:0] CONFIG_MODE,
    output reg [5:0] DISP_MENU_POINTER = 0,
    output reg DISP_MENU_EXIT = 0,
    
    output reg [9:0] DISP_REFRESH_FREQ = 300,      // default update freq.
    output reg [2:0] DISP_THEME_SEL = 4,            // black
    output reg [1:0] DISP_GRID_SEL = 2,             // grid off
    output reg [1:0] DISP_WAVEFORM_SEL = 2,         // circle waveform
    output reg DISP_VOL_HISTORY_SEL = 1             // show volume history
    );
    
    parameter CONFIG_MODE_MAIN = 0;
    parameter CONFIG_MODE_DISP = 3;
    
    parameter DISP_MENU_MAIN = 0;
    parameter DISP_MENU_THEME = 1;
    parameter DISP_MENU_GRID = 2;
    parameter DISP_MENU_WAVEFORM = 3;
    parameter DISP_MENU_REFRESH = 4;
    parameter DISP_MENU_HISTORY = 5;
    parameter DISP_MAIN_RETURN = 5;
    
    parameter DISP_MENU_MAX = 5;
    parameter THEME_MENU_MAX = 4;
    parameter GRID_MENU_MAX = 2;
    parameter WAVEFORM_MENU_MAX = 3;
    parameter HISTORY_MENU_MAX = 1;
    parameter DISP_REFRESH_FREQ_MIN = 100;
    parameter DISP_REFRESH_FREQ_MAX = 1000;
    
    reg [2:0] disp_pointer = 0;
    reg [2:0] current = 0;
    reg [5:0] disp_menu [20:0];
        
    initial begin
        disp_menu[0] = 16;      // Theme (DISP menu)
        disp_menu[1] = 22;      // Grid (DISP menu)
        disp_menu[2] = 26;      // Waveform type (DISP menu)
        disp_menu[3] = 36;      // Refresh frequency (DISP menu)
        disp_menu[4] = 37;      // Volume history waveform (DISP menu)
        disp_menu[5] = 40;      // Return (DISP menu)
        disp_menu[6] = 17;      // Theme 1 (DISP theme menu)
        disp_menu[7] = 18;      // Theme 2 (DISP theme menu)
        disp_menu[8] = 19;      // Theme 3 (DISP theme menu)
        disp_menu[9] = 20;      // Theme 4 (DISP theme menu)
        disp_menu[10] = 21;     // Theme 5 (DISP theme menu)
        disp_menu[11] = 23;     // Dots (DISP grid menu)
        disp_menu[12] = 24;     // Line (DISP grid menu)
        disp_menu[13] = 25;     // Off (DISP grid menu)
        disp_menu[14] = 27;     // Raw (DISP waveform type menu)
        disp_menu[15] = 28;     // Bar (DISP waveform type menu)
        disp_menu[16] = 29;     // Circle (DISP waveform type menu)
        disp_menu[17] = 30;     // Off (DISP waveform type menu)
        disp_menu[18] = 35;     // DISP refresh freq. menu
        disp_menu[19] = 38;     // Off (DISP volume history menu)
        disp_menu[20] = 39;     // On (DISP volume history menu)
    end
    
    always @ (posedge CLK_BTNS_DEBOUNCE) begin
        if (CONFIG_MODE == CONFIG_MODE_DISP) begin
            if (BTNS_CONFIG[0]) begin   // BTN_L
                if (current == DISP_MENU_MAIN)
                    disp_pointer <= (disp_pointer == 0) ? DISP_MENU_MAX : 
                        (disp_pointer - 1);
                else if (current == DISP_MENU_THEME)
                    DISP_THEME_SEL <= (DISP_THEME_SEL == 0) ? 
                        THEME_MENU_MAX : (DISP_THEME_SEL - 1);
                else if (current == DISP_MENU_GRID)
                    DISP_GRID_SEL <= (DISP_GRID_SEL == 0) ? 
                        GRID_MENU_MAX : (DISP_GRID_SEL - 1);
                else if (current == DISP_MENU_WAVEFORM)
                   DISP_WAVEFORM_SEL <= (DISP_WAVEFORM_SEL == 0) ?
                        WAVEFORM_MENU_MAX : (DISP_WAVEFORM_SEL - 1);
                else if (current == DISP_MENU_REFRESH)
                    DISP_REFRESH_FREQ <= (DISP_REFRESH_FREQ > DISP_REFRESH_FREQ_MIN) ?
                        (DISP_REFRESH_FREQ - 20) : DISP_REFRESH_FREQ_MIN;
                else if (current == DISP_MENU_HISTORY)
                    DISP_VOL_HISTORY_SEL <= (DISP_VOL_HISTORY_SEL == 0) ?
                        HISTORY_MENU_MAX : (DISP_VOL_HISTORY_SEL - 1);
            end
            
            if (BTNS_CONFIG[1]) begin   // BTN_R
                if (current == DISP_MENU_MAIN)
                    disp_pointer <= (disp_pointer == DISP_MENU_MAX) ? 
                        0 : (disp_pointer + 1);
                else if (current == DISP_MENU_THEME)
                    DISP_THEME_SEL <= (DISP_THEME_SEL == THEME_MENU_MAX) ? 
                        0 : (DISP_THEME_SEL + 1);
                else if (current == DISP_MENU_GRID)
                    DISP_GRID_SEL <= (DISP_GRID_SEL == GRID_MENU_MAX) ?
                        0 : (DISP_GRID_SEL + 1);
                else if (current == DISP_MENU_WAVEFORM)
                    DISP_WAVEFORM_SEL <= (DISP_WAVEFORM_SEL == WAVEFORM_MENU_MAX) ?
                        0 : (DISP_WAVEFORM_SEL + 1);
                else if (current == DISP_MENU_REFRESH)
                    DISP_REFRESH_FREQ <= (DISP_REFRESH_FREQ < DISP_REFRESH_FREQ_MAX) ?
                        (DISP_REFRESH_FREQ + 20) : DISP_REFRESH_FREQ_MAX;
                else if (current == DISP_MENU_HISTORY)
                    DISP_VOL_HISTORY_SEL <= (DISP_VOL_HISTORY_SEL == HISTORY_MENU_MAX) ?
                        0 : (DISP_VOL_HISTORY_SEL + 1);
            end
                        
            if (BTNS_CONFIG[2]) begin   // BTN_C
                if (current == DISP_MENU_MAIN)
                    if (disp_pointer == DISP_MAIN_RETURN)
                        DISP_MENU_EXIT <= 1;
                    else
                        current <= disp_pointer + 1;
                else
                    current <= DISP_MENU_MAIN;
            end
        end
        else begin
            DISP_MENU_EXIT <= 0;
            disp_pointer <= 0;
            current <= 0;
        end
    end
    
    always @ (*) begin
        case (current)
            DISP_MENU_MAIN : DISP_MENU_POINTER <= disp_menu[disp_pointer];
            DISP_MENU_THEME: DISP_MENU_POINTER <= disp_menu[6+DISP_THEME_SEL];
            DISP_MENU_GRID: DISP_MENU_POINTER <= disp_menu[11+DISP_GRID_SEL];
            DISP_MENU_WAVEFORM: DISP_MENU_POINTER <= disp_menu[14+DISP_WAVEFORM_SEL];
            DISP_MENU_REFRESH: DISP_MENU_POINTER <= disp_menu[18];
            DISP_MENU_HISTORY: DISP_MENU_POINTER <= disp_menu[19+DISP_VOL_HISTORY_SEL];
            default: DISP_MENU_POINTER <= disp_menu[disp_pointer];
        endcase
    end
    
endmodule