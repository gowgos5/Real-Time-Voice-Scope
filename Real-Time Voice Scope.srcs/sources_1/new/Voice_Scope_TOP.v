`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2018 11:32:00
// Design Name: 
// Module Name: Voice_Scope_TOP
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

module Voice_Scope_TOP(
    input CLK_100M,
    
    input  J_MIC3_Pin3,     // PmodMIC3 audio input data (serial)
    output J_MIC3_Pin1,     // PmodMIC3 chip select, 20kHz sampling clock
    output J_MIC3_Pin4,     // PmodMIC3 serial clock (generated by module VOICE_CAPTURER.v)
    
    output [3:0] VGA_RED,   // RGB outputs to VGA connector (4 bits per channel gives 4096 possible colors)
    output [3:0] VGA_GREEN,
    output [3:0] VGA_BLUE,
    
    output VGA_VS,          // horizontal & vertical sync outputs to VGA connector
    output VGA_HS,
    
    input SW_WAVEFORM_SEL,
    input SW_CONFIG,
    output LED_CONFIG,
    input [2:0] BTNS_CONFIG, // [0] -> BTN_L, [1] -> BTN_R, [2] -> BTN_C
    
    output [9:0] LEDS_ARRAY,
    output [3:0] ANODE,
    output [7:0] CATHODE
    );


    /* INSTANTIATE ALL SLOW CLOCKS. */
    wire clk_20k;
    wire clk_vol_update;
    wire clk_leds_refresh;
    wire clk_seg_refresh;
    wire clk_seg_blink;
    wire clk_disp_refresh;
    wire clk_btns_debounce;
    wire clk_vga;
    
    wire [8:0] vol_update_freq = 200;
    wire [5:0] leds_refresh_freq;
    wire [5:0] seg_refresh_freq;
    wire [8:0] seg_blink_freq;
    wire [9:0] disp_refresh_freq;

    Slow_Clocks slow_clks(.CLK_100M(CLK_100M), .VOL_UPDATE_FREQ(vol_update_freq),
        .LEDS_REFRESH_FREQ(leds_refresh_freq), .SEG_REFRESH_FREQ(seg_refresh_freq), 
        .SEG_BLINK_FREQ(seg_blink_freq), .DISP_REFRESH_FREQ(disp_refresh_freq),
        .CLK_20K(clk_20k), .CLK_VOL_UPDATE(clk_vol_update),
        .CLK_LEDS_REFRESH(clk_leds_refresh), .CLK_SEG_REFRESH(clk_seg_refresh),
        .CLK_SEG_BLINK(clk_seg_blink), .CLK_DISP_REFRESH(clk_disp_refresh),
        .CLK_BTNS_DEBOUNCE(clk_btns_debounce));


    /* INSTANTIATE VOICE CAPTURER MODULE */
    wire [11:0] mic_in;
    
    VOICE_CAPTURER voice_capturer(.CLK(CLK_100M), .cs(clk_20k), .MISO(J_MIC3_Pin3),
        .clk_samp(J_MIC3_Pin1), .sclk(J_MIC3_Pin4), .sample(mic_in));


    /* INSTANTIATE MIC DATA TO VOLUME CONVERTER MODULE */
    wire [11:0] mic_avg;    // waveform
    wire [4:0] mic_vol;     // volume level
    
    Volume_Converter vol_converter(.CLK_SAMPLE(clk_20k), .VOL_UPDATE_FREQ(vol_update_freq),
        .MIC_IN(mic_in), .MIC_AVG(mic_avg), .MIC_VOL(mic_vol));


    /* INSTANTIATE TEST (RAMP) WAVE GENERATOR MODULE */
    wire [9:0] ramp_wave;
    
    TestWave_Gen ramp_gen(.CLK_20K(clk_20k), .RAMP_WAVE(ramp_wave));


    /* INSTANTIATE WAVEFORM MULTIPLEXER MODULE */
    wire [9:0] wave_sample;
    
    Waveform_Select waveform_mux(.SEL(SW_WAVEFORM_SEL), .MIC_AVG(mic_avg), .RAMP_WAVE(ramp_wave),
        .WAVE_SAMPLE(wave_sample));


    /* INSTANTIATE CONFIGURATION MENU MODULE */
    wire [1:0] config_mode;
    wire [5:0] menu_pointer;
    
    wire [1:0] leds_pos;
    wire seg_state_sel;
    wire [2:0] disp_theme_sel;
    wire [1:0] disp_grid_sel;
    wire [1:0] disp_waveform_sel;
    wire disp_vol_history_sel;
    
    Menu_Config menu(.CLK_BTNS_DEBOUNCE(clk_btns_debounce), .SW_CONFIG(SW_CONFIG), .BTNS_CONFIG(BTNS_CONFIG),
        .CONFIG_MODE(config_mode), .MENU_POINTER(menu_pointer), .LEDS_REFRESH_FREQ(leds_refresh_freq),
        .LEDS_POSITION(leds_pos), .SEG_REFRESH_FREQ(seg_refresh_freq), .SEG_BLINK_FREQ(seg_blink_freq),
        .SEG_STATE_SEL(seg_state_sel), .DISP_REFRESH_FREQ(disp_refresh_freq), .DISP_THEME_SEL(disp_theme_sel), 
        .DISP_GRID_SEL(disp_grid_sel), .DISP_WAVEFORM_SEL(disp_waveform_sel), .DISP_VOL_HISTORY_SEL(disp_vol_history_sel));
    
    assign LED_CONFIG = SW_CONFIG;


    /* INSTANTIATE VGA DISPLAY MODULE */
    wire [3:0] R_wave;
    wire [3:0] G_wave;
    wire [3:0] B_wave;
    
    wire [3:0] R_grid;
    wire [3:0] G_grid;
    wire [3:0] B_grid;
    
    wire [11:0] VGA_HORZ_COORD;
    wire [11:0] VGA_VERT_COORD;
    
    VGA_DISPLAY vga_display(.CLK(CLK_100M), .VGA_RED_WAVEFORM(R_wave), 
        .VGA_GREEN_WAVEFORM(G_wave), .VGA_BLUE_WAVEFORM(B_wave), .VGA_RED_GRID(R_grid),
        .VGA_GREEN_GRID(G_grid), .VGA_BLUE_GRID(B_grid), .VGA_HORZ_COORD(VGA_HORZ_COORD), 
        .VGA_VERT_COORD(VGA_VERT_COORD), .VGA_RED(VGA_RED), .VGA_GREEN(VGA_GREEN), 
        .VGA_BLUE(VGA_BLUE), .VGA_VS(VGA_VS), .VGA_HS(VGA_HS), .CLK_VGA(clk_vga));


    /* INSTANTIATE MENU DRAWING MODUEL */
    wire [3:0] menu_res;

    Draw_Menu draw_menu(.CLK_VGA(clk_vga), .VGA_HORZ_COORD(VGA_HORZ_COORD),
        .VGA_VERT_COORD(VGA_VERT_COORD), .SW_CONFIG(SW_CONFIG), .CONFIG_MODE(config_mode),
        .MENU_POINTER(menu_pointer), .MENU_RES(menu_res));


    /* INSTANTIATE VOLUME HISTORY WAVEFORM DRAWING MOUDLE */
    wire [3:0] vol_history_res;

    Draw_Vol_History draw_vol_history(.CLK_VGA(clk_vga), .CLK_VOL_UPDATE(clk_vol_update), 
        .VOL_UPDATE_FREQ(vol_update_freq), .MIC_VOL(mic_vol), .VGA_HORZ_COORD(VGA_HORZ_COORD), 
        .VGA_VERT_COORD(VGA_VERT_COORD), .DISP_VOL_HISTORY_SEL(disp_vol_history_sel), 
        .VOL_HISTORY_RES(vol_history_res));
    

    /* INSTANTIATE WAVEFORM DRAWING MODULE */
    wire waveform_res;
    
    Draw_Waveform draw_waveform(.CLK_VGA(clk_vga), .clk_sample(clk_20k), .CLK_VOL_UPDATE(clk_vol_update),
        .CLK_DISP_REFRESH(clk_disp_refresh), .VGA_HORZ_COORD(VGA_HORZ_COORD), .VGA_VERT_COORD(VGA_VERT_COORD),
        .wave_sample(wave_sample), .MIC_VOL(mic_vol), .DISP_WAVEFORM_SEL(disp_waveform_sel),
        .DISP_THEME_SEL(disp_theme_sel), .MENU_RES(menu_res), .VGA_Red_waveform(R_wave), 
        .VGA_Green_waveform(G_wave), .VGA_Blue_waveform(B_wave), .WAVEFORM_RES(waveform_res));


    /* INSTANTIATE BACKGROUND DRAWING MODULE */
    Draw_Background draw_background(.CLK_VGA(clk_vga), .VGA_HORZ_COORD(VGA_HORZ_COORD), 
        .VGA_VERT_COORD(VGA_VERT_COORD), .VGA_Red_Grid(R_grid), .VGA_Green_Grid(G_grid), 
        .VGA_Blue_Grid(B_grid), .DISP_THEME_SEL(disp_theme_sel), .DISP_GRID_SEL(disp_grid_sel), 
        .WAVEFORM_RES(waveform_res), .MENU_RES(menu_res), .VOL_HISTORY_RES(vol_history_res));
    

    /* INSTANTIATE LEDS ARRAY MODULE */
    Leds_Array leds(.CLK_LEDS_REFRESH(clk_leds_refresh), .SW_CONFIG(SW_CONFIG),        
        .CONFIG_MODE(config_mode), .MIC_VOL(mic_vol), .LEDS_POS(leds_pos),
        .LEDS_ARRAY(LEDS_ARRAY));


    /* INSTANTIATE 7-SEGMENT DISPLAY MODULE */
    Seg_Display seg(.CLK_SEG_REFRESH(clk_seg_refresh), .CLK_SEG_BLINK(clk_seg_blink), 
        .SW_CONFIG(SW_CONFIG), .SEG_STATE_SEL(seg_state_sel), .LEDS_REFRESH_FREQ(leds_refresh_freq),
        .SEG_REFRESH_FREQ(seg_refresh_freq), .SEG_BLINK_FREQ(seg_blink_freq),
        .DISP_REFRESH_FREQ(disp_refresh_freq), .MIC_VOL(mic_vol), .MENU_POINTER(menu_pointer),
        .ANODE(ANODE), .CATHODE(CATHODE));

endmodule