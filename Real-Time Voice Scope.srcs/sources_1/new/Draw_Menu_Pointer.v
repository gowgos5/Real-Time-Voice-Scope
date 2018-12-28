`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2018 19:06:51
// Design Name: 
// Module Name: Draw_Menu_Pointer
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

module Draw_Menu_Pointer(
    input CLK_VGA,
    input [31:0] horzCoord,
    input [31:0] vertCoord,
    
    input SW_CONFIG,
    input [1:0] CONFIG_MODE,
    input [5:0] MENU_POINTER,
    
    output POINTER_RES
    );
    
    parameter POINTER_X = 25;   
    parameter LINE_ONE_Y = 60;
    parameter LINE_TWO_Y = 85;
    parameter LINE_THREE_Y = 110;
    parameter LINE_FOUR_Y = 135;
    parameter LINE_FIVE_Y = 160;
    parameter LINE_SIX_Y = 185;
    
    wire res;
    reg [7:0] pointer_y = 0;
    
    wire line_one = (MENU_POINTER == 0) ||       // LEDS (MAIN MENU)
                    (MENU_POINTER == 1) ||       // LEDS REFRESH FREQ. (LEDS MENU)
                    (MENU_POINTER == 3) ||       // LEFT (LEDS POS. MENU)
                    (MENU_POINTER == 32) ||      // LEDS REFRESH FREQ. MENU
                    (MENU_POINTER == 9) ||       // 7-SEG REFRESH FREQ. (SEG MENU)
                    (MENU_POINTER == 33) ||      // 7-SEG REFRESH FREQ. MENU
                    (MENU_POINTER == 34) ||      // 7-SEG BLINKING FREQ. MENU
                    (MENU_POINTER == 12) ||      // OFF (SEG STATE MENU)
                    (MENU_POINTER == 16) ||      // VGA THEME (VGA MENU)
                    (MENU_POINTER == 17) ||      // THEME 1 (VGA THEME MENU)
                    (MENU_POINTER == 23) ||      // DOTS (VGA GRID MENU)
                    (MENU_POINTER == 27) ||      // NORMAL (VGA WAVEFORM MENU)
                    (MENU_POINTER == 35) ||      // VGA REFRESH FREQ. MENU
                    (MENU_POINTER == 38);        // ON (VGA PERIOD MENU)
    
    wire line_two = (MENU_POINTER == 8) ||       // 7-SEG (MAIN MENU)
                    (MENU_POINTER == 2) ||       // LEDS POSITION (LEDS MENU)
                    (MENU_POINTER == 4) ||       // RIGHT (LEDS POS. MENU)
                    (MENU_POINTER == 10) ||      // 7-SEG BLINKING FREQ. (SEG MENU)
                    (MENU_POINTER == 13) ||      // ON (SEG STATE MENU)
                    (MENU_POINTER == 22) ||      // VGA GRID TYPE (VGA MENU)
                    (MENU_POINTER == 18) ||      // THEME 2 (VGA THEME MENU)
                    (MENU_POINTER == 24) ||      // LINES (VGA GRID MENU)
                    (MENU_POINTER == 28) ||      // BAR (VGA WAVEFORM MENU)
                    (MENU_POINTER == 39);        // OFF (VGA PERIOD MENU)
    
    wire line_three = (MENU_POINTER == 15) ||    // VGA DISPLAY (MAIN MENU)
                      (MENU_POINTER == 7) ||     // RETURN (LEDS MENU)
                      (MENU_POINTER == 5) ||     // CENTER (LEDS POS. MENU)
                      (MENU_POINTER == 11) ||    // 7-SEG DISPLAY STATE (SEG MENU)
                      (MENU_POINTER == 26) ||    // VGA WAVEFORM TYPE (VGA MENU) 
                      (MENU_POINTER == 19) ||    // THEME 3 (VGA THEME MENU)
                      (MENU_POINTER == 25) ||    // OFF (VGA GRID MENU)
                      (MENU_POINTER == 29);      // CIRCLE (VGA WAVEFORM MENU)
    
    
    wire line_four = (MENU_POINTER == 6) ||      // OFF (LEDS POS. MENU)
                     (MENU_POINTER == 14) ||     // RETURN (SEG MENU)
                     (MENU_POINTER == 36) ||     // VGA REFRESH FREQ. (VGA MENU)
                     (MENU_POINTER == 20) ||     // THEME 4 (VGA THEME MENU)
                     (MENU_POINTER == 30);       // OFF (VGA WAVEFORM MENU)
                    
    
    
    wire line_five = (MENU_POINTER == 37) ||     // VGA PERIOD WAVEFORM (VGA MENU)
                     (MENU_POINTER == 21);       // THEME 5 (VGA THEME MENU)
    
    wire line_six = (MENU_POINTER == 40);        // RETURN (VGA MENU)
    
    
    Pixel_On_Text2 #(.displayText("->")) pointer_01
       (CLK_VGA, POINTER_X, pointer_y, horzCoord, vertCoord, res);
    
    always @ (*) begin
        if (line_one)
            pointer_y = LINE_ONE_Y;
        else if (line_two)
            pointer_y = LINE_TWO_Y;
        else if (line_three)
            pointer_y = LINE_THREE_Y;
        else if (line_four)
            pointer_y = LINE_FOUR_Y;
        else if (line_five)
            pointer_y = LINE_FIVE_Y;
        else if (line_six)
            pointer_y = LINE_SIX_Y;
        else
            pointer_y = 0;
    end
    
    assign POINTER_RES = (SW_CONFIG) ? res : 0;
    
endmodule