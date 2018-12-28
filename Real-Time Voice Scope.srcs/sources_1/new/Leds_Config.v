`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2018 15:07:16
// Design Name: 
// Module Name: Leds_Config
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

module Leds_Config(
    input CLK_BTNS_DEBOUNCE,
    
    input [2:0] BTNS_CONFIG,    // [0] -> BTN_L, [1] -> BTN_R, [2] -> BTN_C
    input [1:0] CONFIG_MODE,
    output reg [5:0] LEDS_MENU_POINTER = 0,
    output reg LEDS_MENU_EXIT = 0,
    
    output reg [1:0] LEDS_POSITION = 0,     // default position: right
    output reg [5:0] LEDS_REFRESH_FREQ = 15 // default refresh rate: 15 Hz
    );
    
    parameter CONFIG_MODE_MAIN = 0;
    parameter CONFIG_MODE_LEDS = 1;
    parameter LEDS_MENU_MAIN = 0;
    parameter LEDS_MENU_FREQ = 1;
    parameter LEDS_MENU_POS = 2;
    parameter LEDS_MAIN_RETURN = 2;
    
    parameter LEDS_MENU_MAX = 2;
    parameter LEDS_REFRESH_FREQ_MIN = 1;
    parameter LEDS_REFRESH_FREQ_MAX = 50;
    
    reg [1:0] leds_pointer = 0;
    reg [1:0] current = 0;
    reg [5:0] leds_menu [7:0];
    
    initial begin
        leds_menu[0] = 1;   // Refresh frequency (LEDs main menu)
        leds_menu[1] = 2;   // Position (LEDs main menu)
        leds_menu[2] = 7;   // Return (LEDs main menu)
        leds_menu[3] = 32;  // LEDs refresh frequency menu
        leds_menu[4] = 3;   // Left (LEDs position menu)
        leds_menu[5] = 4;   // Right (LEDs position menu)
        leds_menu[6] = 5;   // Center (LEDs position menu)
        leds_menu[7] = 6;   // Off (LEDs position menu)
    end
    
    always @ (posedge CLK_BTNS_DEBOUNCE) begin
        if (CONFIG_MODE == CONFIG_MODE_LEDS) begin      // LEDs main menu
            if (BTNS_CONFIG[0]) begin                   // BTN_L
                if (current == LEDS_MENU_MAIN)          // LEDs main menu
                    leds_pointer <= (leds_pointer == 0) ? LEDS_MENU_MAX
                        : (leds_pointer - 1);
                else if (current == LEDS_MENU_FREQ)     // LEDs refresh freq. menu
                    LEDS_REFRESH_FREQ <= (LEDS_REFRESH_FREQ > LEDS_REFRESH_FREQ_MIN) ? 
                        (LEDS_REFRESH_FREQ - 1) : LEDS_REFRESH_FREQ_MIN;
                else if (current == LEDS_MENU_POS)      // LEDs position menu
                    LEDS_POSITION <= (LEDS_POSITION - 1);
            end
            
            if (BTNS_CONFIG[1]) begin                    // BTN_R
                if (current == LEDS_MENU_MAIN)           // LEDs main menu
                    leds_pointer <= (leds_pointer == LEDS_MENU_MAX) ? 0 
                        : (leds_pointer + 1);
                else if (current == LEDS_MENU_FREQ)      // LEDs refresh freq. menu
                    LEDS_REFRESH_FREQ <= (LEDS_REFRESH_FREQ < LEDS_REFRESH_FREQ_MAX) ? 
                        (LEDS_REFRESH_FREQ + 1) : LEDS_REFRESH_FREQ_MAX;
                else if (current == LEDS_MENU_POS)       // LEDs position menu
                    LEDS_POSITION <= (LEDS_POSITION + 1);
            end
            
            if (BTNS_CONFIG[2]) begin                       // BTN_C
                if (current == LEDS_MENU_MAIN)              // LEDs main menu
                    if (leds_pointer == LEDS_MAIN_RETURN)   // Return option selected.
                        LEDS_MENU_EXIT = 1;
                    else
                        current <= (leds_pointer + 1);
                else
                    current <= LEDS_MENU_MAIN;
            end
        end
        else begin
            LEDS_MENU_EXIT <= 0;
            leds_pointer <= 0;
            current <= 0;
        end
    end
    
    always @ (*) begin
        case (current)
            LEDS_MENU_MAIN: LEDS_MENU_POINTER <= leds_menu[leds_pointer];
            LEDS_MENU_FREQ: LEDS_MENU_POINTER <= leds_menu[3];
            LEDS_MENU_POS: LEDS_MENU_POINTER <= leds_menu[4+LEDS_POSITION];
            default: LEDS_MENU_POINTER <= leds_menu[leds_pointer];
        endcase
    end
    
endmodule