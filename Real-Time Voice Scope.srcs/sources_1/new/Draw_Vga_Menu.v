`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2018 19:08:39
// Design Name: 
// Module Name: Draw_Vga_Menu
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

module Draw_Vga_Menu(
    input CLK_VGA,
    input [31:0] horzCoord,
    input [31:0] vertCoord,
    input [5:0] MENU_POINTER,
    output reg VGA_RES = 0
    );
    
    parameter TITLE_X = 25;
    parameter TITLE_Y = 25;
    parameter LINE_X = 50;
    parameter LINE_ONE_Y = 60;
    parameter LINE_TWO_Y = 85;
    parameter LINE_THREE_Y = 110;
    parameter LINE_FOUR_Y = 135;
    parameter LINE_FIVE_Y = 160;
    parameter LINE_SIX_Y = 185;
    
    wire [26:0] res;


    /* VGA DISPLAY MAIN MENU */
    Pixel_On_Text2 #(.displayText("VGA DISPLAY MENU")) vga_text_01
        (CLK_VGA, TITLE_X, TITLE_Y, horzCoord, vertCoord, res[0]);
    
    Pixel_On_Text2 #(.displayText("1. Theme")) vga_text_02
        (CLK_VGA, LINE_X, LINE_ONE_Y, horzCoord, vertCoord, res[1]);
        
    Pixel_On_Text2 #(.displayText("2. Grid Type")) vga_text_03
        (CLK_VGA, LINE_X, LINE_TWO_Y, horzCoord, vertCoord, res[2]);
        
    Pixel_On_Text2 #(.displayText("3. Main Waveform Type")) vga_text_04
        (CLK_VGA, LINE_X, LINE_THREE_Y, horzCoord, vertCoord, res[3]);
        
    Pixel_On_Text2 #(.displayText("4. Volume Refresh Frequency")) vga_text_05
        (CLK_VGA, LINE_X, LINE_FOUR_Y, horzCoord, vertCoord, res[4]);
    
    Pixel_On_Text2 #(.displayText("5. Volume History Waveform")) vga_text_06
        (CLK_VGA, LINE_X, LINE_FIVE_Y, horzCoord, vertCoord, res[5]);
        
    Pixel_On_Text2 #(.displayText("6. Back")) vga_text_07
        (CLK_VGA, LINE_X, LINE_SIX_Y, horzCoord, vertCoord, res[6]);
    
    
    /* VGA DISPLAY THEME MENU */
    Pixel_On_Text2 #(.displayText("THEME")) vga_text_08
        (CLK_VGA, TITLE_X, TITLE_Y, horzCoord, vertCoord, res[7]);
    
    Pixel_On_Text2 #(.displayText("1. Theme 1")) vga_text_09
        (CLK_VGA, LINE_X, LINE_ONE_Y, horzCoord, vertCoord, res[8]);
        
    Pixel_On_Text2 #(.displayText("2. Theme 2")) vga_text_10
        (CLK_VGA, LINE_X, LINE_TWO_Y, horzCoord, vertCoord, res[9]);
        
    Pixel_On_Text2 #(.displayText("3. Theme 3")) vga_text_11
        (CLK_VGA, LINE_X, LINE_THREE_Y, horzCoord, vertCoord, res[10]);
        
    Pixel_On_Text2 #(.displayText("4. Theme 4")) vga_text_12
        (CLK_VGA, LINE_X, LINE_FOUR_Y, horzCoord, vertCoord, res[11]);
        
    Pixel_On_Text2 #(.displayText("5. Theme 5")) vga_text_13
        (CLK_VGA, LINE_X, LINE_FIVE_Y, horzCoord, vertCoord, res[12]);
        
        
    /* VGA DISPLAY GRID TYPE MENU */
    Pixel_On_Text2 #(.displayText("GRID TYPE")) vga_text_14
        (CLK_VGA, TITLE_X, TITLE_Y, horzCoord, vertCoord, res[13]);
    
    Pixel_On_Text2 #(.displayText("1. Dots")) vga_text_15
        (CLK_VGA, LINE_X, LINE_ONE_Y, horzCoord, vertCoord, res[14]);
        
    Pixel_On_Text2 #(.displayText("2. Lines")) vga_text_16
        (CLK_VGA, LINE_X, LINE_TWO_Y, horzCoord, vertCoord, res[15]);
        
    Pixel_On_Text2 #(.displayText("3. Off")) vga_text_17
        (CLK_VGA, LINE_X, LINE_THREE_Y, horzCoord, vertCoord, res[16]);
    
    
    /* VGA DISPLAY WAVEFORM TYPE MENU */
    Pixel_On_Text2 #(.displayText("MAIN WAVEFORM TYPE")) vga_text_18
        (CLK_VGA, TITLE_X, TITLE_Y, horzCoord, vertCoord, res[17]);
    
    Pixel_On_Text2 #(.displayText("1. Normal")) vga_text_19
        (CLK_VGA, LINE_X, LINE_ONE_Y, horzCoord, vertCoord, res[18]);
        
    Pixel_On_Text2 #(.displayText("2. Bar")) vga_text_20
        (CLK_VGA, LINE_X, LINE_TWO_Y, horzCoord, vertCoord, res[19]);
        
    Pixel_On_Text2 #(.displayText("3. Circle")) vga_text_21
        (CLK_VGA, LINE_X, LINE_THREE_Y, horzCoord, vertCoord, res[20]);

    Pixel_On_Text2 #(.displayText("4. Off")) vga_text_22
        (CLK_VGA, LINE_X, LINE_FOUR_Y, horzCoord, vertCoord, res[21]);


    /* VGA DISPLAY REFRESH FREQUENCY MENU */
    Pixel_On_Text2 #(.displayText("REFRESH FREQUENCY")) vga_text_23
        (CLK_VGA, TITLE_X, TITLE_Y, horzCoord, vertCoord, res[22]);
        
    Pixel_On_Text2 #(.displayText("Done")) vga_text_24
        (CLK_VGA, LINE_X, LINE_ONE_Y, horzCoord, vertCoord, res[23]);
    
    
     /* VGA DISPLAY PERIOD WAVEFORM MENU */
    Pixel_On_Text2 #(.displayText("VOLUME HISTORY")) vga_text_25
        (CLK_VGA, TITLE_X, TITLE_Y, horzCoord, vertCoord, res[24]);
    
    Pixel_On_Text2 #(.displayText("1. Hide")) vga_text_26
        (CLK_VGA, LINE_X, LINE_ONE_Y, horzCoord, vertCoord, res[25]);
        
    Pixel_On_Text2 #(.displayText("2. Show")) vga_text_27
        (CLK_VGA, LINE_X, LINE_TWO_Y, horzCoord, vertCoord, res[26]);  


    always @ (posedge CLK_VGA) begin
        /* VGA DISPLAY THEME MENU */
        if ((MENU_POINTER >= 17) && (MENU_POINTER <= 21))
            VGA_RES <= res[12:7] ? 1 : 0;
        /* VGA DISPLAY GRID TYPE MENU */
        else if ((MENU_POINTER >= 23) && (MENU_POINTER <= 25))
            VGA_RES <= res[16:13] ? 1 : 0;
        /* VGA DISPLAY WAVEFORM TYPE MENU */
        else if ((MENU_POINTER >= 27) && (MENU_POINTER <= 30))
            VGA_RES <= res[21:17] ? 1 : 0;
         /* VGA DISPLAY REFRESH FREQUENCY MENU */
        else if (MENU_POINTER == 35)
            VGA_RES <= res[23:22] ? 1 : 0;
         /* VGA DISPLAY PERIOD WAVEFORM MENU */
        else if ((MENU_POINTER >= 38) && (MENU_POINTER <= 39))
            VGA_RES <= res[26:24] ? 1 : 0;
        /* VGA DISPLAY MAIN MENU */
        else
            VGA_RES <= res[6:0] ? 1 : 0;
    end
    
endmodule