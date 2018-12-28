`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2018 12:11:57
// Design Name: 
// Module Name: Slow_Clocks
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

module Slow_Clocks(
    input CLK_100M,
    
    input [8:0] VOL_UPDATE_FREQ,
    input [5:0] LEDS_REFRESH_FREQ,
    input [5:0] SEG_REFRESH_FREQ,
    input [8:0] SEG_BLINK_FREQ,
    input [9:0] DISP_REFRESH_FREQ,
    
    output CLK_20K,
    output CLK_VOL_UPDATE,
    output CLK_LEDS_REFRESH,
    output CLK_SEG_REFRESH,
    output CLK_SEG_BLINK,
    output CLK_DISP_REFRESH,
    output CLK_BTNS_DEBOUNCE
    );
    
    // Clock signal for sampling raw audio signal (20 kHz).
    Clk_Div #(14, 11) clk_div_01(.CLK_100M(CLK_100M), .FREQ(20000),
        .SLOW_CLK(CLK_20K));
    // Clock signal for updating audio volume levels (VOL_UPDATE_FREQ).
    Clk_Div #(8, 25) clk_div_02(.CLK_100M(CLK_100M), .FREQ(VOL_UPDATE_FREQ),
        .SLOW_CLK(CLK_VOL_UPDATE));
    // Clock signal for updating LEDs volume indicator (LEDS_REFRESH_FREQ).
    // Default: 15 Hz. Min: 1 Hz. Max: 50 Hz.
    Clk_Div #(5, 25) clk_div_03(.CLK_100M(CLK_100M), .FREQ(LEDS_REFRESH_FREQ), 
        .SLOW_CLK(CLK_LEDS_REFRESH));
    // Clock signal for updating 7-seg display volume indicator (SEG_REFRESH_FREQ).
    // Default: 10 Hz. Min: 1 Hz. Max: 50 Hz.
    Clk_Div #(5, 25) clk_div_04(.CLK_100M(CLK_100M), .FREQ(SEG_REFRESH_FREQ), 
        .SLOW_CLK(CLK_SEG_REFRESH));
    // Clock signal for blinking 7-seg display (SEG_BLINK_FREQ).
    // Default: 200 Hz. Min: 50 Hz. Max: 300 Hz.
    Clk_Div #(8, 19) clk_div_05(.CLK_100M(CLK_100M), .FREQ(SEG_BLINK_FREQ),
        .SLOW_CLK(CLK_SEG_BLINK));
    // Clock signal for updating VGA display volume indicator (DISP_REFRESH_FREQ).
    // Default: 300 Hz. Min: 100 Hz. Max: 1000 Hz.
    Clk_Div #(9, 18) clk_div_06(.CLK_100M(CLK_100M), .FREQ(DISP_REFRESH_FREQ), 
        .SLOW_CLK(CLK_DISP_REFRESH));
    // Clock signal for debouncing button presses (20 Hz).
    Clk_Div #(4, 21) clk_div_07(.CLK_100M(CLK_100M), .FREQ(20),
        .SLOW_CLK(CLK_BTNS_DEBOUNCE));
    
endmodule