`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2018 15:31:01
// Design Name: 
// Module Name: Seg_Config
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

module Seg_Config(
    input CLK_BTNS_DEBOUNCE,
    
    input [2:0] BTNS_CONFIG,    // [0] -> BTN_L, [1] -> BTN_R, [2] -> BTN_C
    input [1:0] CONFIG_MODE,
    output reg [5:0] SEG_MENU_POINTER = 0,
    output reg SEG_MENU_EXIT = 0,
    
    output reg [5:0] SEG_REFRESH_FREQ = 10,    // default refresh rate.
    output reg [8:0] SEG_BLINK_FREQ = 200,     // default blinking rate.
    output reg SEG_STATE_SEL = 1               // 7-segment display on by default.
    );
    
    parameter CONFIG_MODE_MAIN = 0;
    parameter CONFIG_MODE_SEG = 2;
    
    parameter SEG_MENU_MAIN = 0;
    parameter SEG_MENU_REFRESH = 1;
    parameter SEG_MENU_BLINK = 2;
    parameter SEG_MENU_STATE = 3;
    parameter SEG_MAIN_RETURN = 3;
    
    parameter SEG_REFRESH_FREQ_MIN = 1;
    parameter SEG_REFRESH_FREQ_MAX = 50;
    parameter SEG_BLINK_FREQ_MIN = 50;
    parameter SEG_BLINK_FREQ_MAX = 300;
    
    reg [1:0] seg_pointer = 0;
    reg [1:0] current = 0;
    reg [5:0] seg_menu [7:0];
    
    initial begin
        seg_menu[0] = 9;    // Refresh frequency (SEG menu)
        seg_menu[1] = 10;   // Blinking frequency (SEG menu)
        seg_menu[2] = 11;   // Display state (SEG menu)
        seg_menu[3] = 14;   // Return (SEG menu)
        seg_menu[4] = 33;   // 7-segment refresh freq. menu
        seg_menu[5] = 34;   // 7-segment blinking freq. menu
        seg_menu[6] = 12;   // Off (SEG state menu)
        seg_menu[7] = 13;   // On (SEG state menu)
    end
    
    always @ (posedge CLK_BTNS_DEBOUNCE) begin
        if (CONFIG_MODE == CONFIG_MODE_SEG) begin
            if (BTNS_CONFIG[0]) begin       // BTN_L
                if (current == SEG_MENU_MAIN)
                    seg_pointer <= (seg_pointer - 1);
                else if (current == SEG_MENU_REFRESH)
                    SEG_REFRESH_FREQ <= (SEG_REFRESH_FREQ > SEG_REFRESH_FREQ_MIN)
                        ? (SEG_REFRESH_FREQ - 1) : SEG_REFRESH_FREQ_MIN;
                else if (current == SEG_MENU_BLINK)
                    SEG_BLINK_FREQ <= (SEG_BLINK_FREQ > SEG_BLINK_FREQ_MIN) ? 
                        (SEG_BLINK_FREQ - 10) : SEG_BLINK_FREQ_MIN;
                else if (current == SEG_MENU_STATE)
                    SEG_STATE_SEL <= (SEG_STATE_SEL - 1);
            end
        
            if (BTNS_CONFIG[1]) begin       // BTN_R
                if (current == SEG_MENU_MAIN)
                    seg_pointer <= (seg_pointer + 1);
                else if (current == SEG_MENU_REFRESH)
                    SEG_REFRESH_FREQ <= (SEG_REFRESH_FREQ < SEG_REFRESH_FREQ_MAX) ? 
                        (SEG_REFRESH_FREQ + 1) : SEG_REFRESH_FREQ_MAX;
                else if (current == SEG_MENU_BLINK)
                    SEG_BLINK_FREQ <= (SEG_BLINK_FREQ < SEG_BLINK_FREQ_MAX) ? 
                        (SEG_BLINK_FREQ + 10) : SEG_BLINK_FREQ_MAX;
                else if (current == SEG_MENU_STATE)
                    SEG_STATE_SEL <= (SEG_STATE_SEL + 1);
            end
        
            if (BTNS_CONFIG[2]) begin       // BTN_C
                if (current == SEG_MENU_MAIN)
                    if (seg_pointer == SEG_MAIN_RETURN)
                        SEG_MENU_EXIT <= 1;
                    else
                        current <= (seg_pointer + 1);
                else
                    current <= SEG_MENU_MAIN;
            end
        end
        else begin
            SEG_MENU_EXIT <= 0;
            seg_pointer <= 0;
            current <= 0;
        end
    end
    
    always @ (*) begin
        case (current)
            SEG_MENU_MAIN: SEG_MENU_POINTER <= seg_menu[seg_pointer];
            SEG_MENU_REFRESH: SEG_MENU_POINTER <= seg_menu[4];
            SEG_MENU_BLINK: SEG_MENU_POINTER <= seg_menu[5];
            SEG_MENU_STATE : SEG_MENU_POINTER <= seg_menu[6+SEG_STATE_SEL];
            default: SEG_MENU_POINTER <= seg_menu[seg_pointer];
        endcase
    end
    
endmodule