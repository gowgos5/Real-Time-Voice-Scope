`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2018 14:24:25
// Design Name: 
// Module Name: Menu_Config
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

module Menu_Config(
    input CLK_BTNS_DEBOUNCE,
    
    input SW_CONFIG,
    input [2:0] BTNS_CONFIG,    // [0] -> BTN_L, [1] -> BTN_R, [2] -> BTN_C
    output reg [1:0] CONFIG_MODE = 0,   // Main menu
    output reg [5:0] MENU_POINTER = 31, // Volume program
    
    /* SETTINGS TO BE CONFIGURED */
    // LEDs Array
    output [5:0] LEDS_REFRESH_FREQ,
    output [1:0] LEDS_POSITION,
    
    // 7-Segment Display
    output [5:0] SEG_REFRESH_FREQ,
    output [8:0] SEG_BLINK_FREQ,
    output SEG_STATE_SEL,
    
    // VGA Display
    output [9:0] DISP_REFRESH_FREQ,
    output [2:0] DISP_THEME_SEL,
    output [1:0] DISP_GRID_SEL,
    output [1:0] DISP_WAVEFORM_SEL,
    output DISP_VOL_HISTORY_SEL
    );
    
    parameter CONFIG_MODE_MAIN = 0;
    parameter CONFIG_MODE_LEDS = 1;
    parameter CONFIG_MODE_SEG = 2;
    parameter CONFIG_MODE_DISP = 3;
    parameter VOLUME = 31;
    
    wire [2:0] deb_btns;
    
    wire [5:0] leds_menu_pointer;
    wire [5:0] seg_menu_pointer;
    wire [5:0] disp_menu_pointer;
    
    wire leds_menu_exit, seg_menu_exit, disp_menu_exit;
    
    /* DEBOUNCE BUTTONS */
    Buttons_Debounce btns_deb(.CLK(CLK_BTNS_DEBOUNCE), .BTNS(BTNS_CONFIG), 
        .BTNS_DEBOUNCED(deb_btns));

    /* LEDS CONFIGURATION MENU */
    Leds_Config config_01(.CLK_BTNS_DEBOUNCE(CLK_BTNS_DEBOUNCE), .BTNS_CONFIG(deb_btns), 
        .CONFIG_MODE(CONFIG_MODE), .LEDS_MENU_POINTER(leds_menu_pointer), .LEDS_MENU_EXIT(leds_menu_exit),
        .LEDS_POSITION(LEDS_POSITION), .LEDS_REFRESH_FREQ(LEDS_REFRESH_FREQ));
     
    /* 7-SEGMENT DISPLAY CONFIGURATION MENU */
    Seg_Config config_02(.CLK_BTNS_DEBOUNCE(CLK_BTNS_DEBOUNCE), .BTNS_CONFIG(deb_btns), 
        .CONFIG_MODE(CONFIG_MODE), .SEG_MENU_POINTER(seg_menu_pointer), .SEG_MENU_EXIT(seg_menu_exit),
        .SEG_REFRESH_FREQ(SEG_REFRESH_FREQ), .SEG_BLINK_FREQ(SEG_BLINK_FREQ), .SEG_STATE_SEL(SEG_STATE_SEL));

    /* VGA DISPLAY CONFIGURATION MENU */
    Disp_Config config_03(.CLK_BTNS_DEBOUNCE(CLK_BTNS_DEBOUNCE), .BTNS_CONFIG(deb_btns), 
        .CONFIG_MODE(CONFIG_MODE), .DISP_MENU_POINTER(disp_menu_pointer), .DISP_MENU_EXIT(disp_menu_exit),
        .DISP_REFRESH_FREQ(DISP_REFRESH_FREQ), .DISP_THEME_SEL(DISP_THEME_SEL), .DISP_GRID_SEL(DISP_GRID_SEL), 
        .DISP_WAVEFORM_SEL(DISP_WAVEFORM_SEL), .DISP_VOL_HISTORY_SEL(DISP_VOL_HISTORY_SEL));
        
        
    reg [5:0] main_menu [2:0];
    reg [1:0] main_pointer = 0;
    
    initial begin
        main_menu[0] = 0;   // LEDs menu
        main_menu[1] = 8;   // SEG menu
        main_menu[2] = 15;  // DISP menu
    end
    
    always @ (posedge CLK_BTNS_DEBOUNCE) begin
        if (SW_CONFIG) begin                                // Access configuration mode.
            if (CONFIG_MODE == CONFIG_MODE_MAIN) begin      // Main menu.
                if (deb_btns[0])                            // BTN_L
                    main_pointer <= (main_pointer == 0) ? 2 : (main_pointer - 1);
                
                if (deb_btns[1])                            // BTN_R
                    main_pointer <= (main_pointer == 2) ? 0 : (main_pointer + 1);
                                
                if (deb_btns[2])                            // BTN_C
                    CONFIG_MODE <= (main_pointer + 1);
            end
            else if (leds_menu_exit || seg_menu_exit || disp_menu_exit)
                CONFIG_MODE <= CONFIG_MODE_MAIN;
        end
        else begin                                          // Exit configuration mode.
            CONFIG_MODE <= CONFIG_MODE_MAIN;
            main_pointer <= 0;
        end
    end
    
    always @ (*) begin
        if (SW_CONFIG) begin    // Configuration mode.
            case (CONFIG_MODE)
                CONFIG_MODE_MAIN: MENU_POINTER <= main_menu[main_pointer];
                CONFIG_MODE_LEDS: MENU_POINTER <= leds_menu_pointer;
                CONFIG_MODE_SEG: MENU_POINTER <= seg_menu_pointer;
                CONFIG_MODE_DISP: MENU_POINTER <= disp_menu_pointer;
                default: MENU_POINTER <= main_menu[main_pointer];
            endcase
        end
        else    // Volume indicator program.
            MENU_POINTER <= VOLUME;
    end
    
endmodule