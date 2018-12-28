`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2018 19:06:51
// Design Name: 
// Module Name: Draw_Seg_Menu
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

module Draw_Seg_Menu(
    input CLK_VGA,
    input [31:0] horzCoord,
    input [31:0] vertCoord,
    input [5:0] MENU_POINTER,
    output reg SEG_RES = 0
    );
    
    parameter TITLE_X = 25;
    parameter TITLE_Y = 25;
    parameter LINE_X = 50;
    parameter LINE_ONE_Y = 60;
    parameter LINE_TWO_Y = 85;
    parameter LINE_THREE_Y = 110;
    parameter LINE_FOUR_Y = 135;
    parameter LINE_FIVE_Y = 160;
    
    wire [11:0] res;
    
    
    /* 7-SEGMENT DISPLAY MAIN MENU */
    Pixel_On_Text2 #(.displayText("7-SEGMENT DISPLAY MENU")) seg_text_01
        (CLK_VGA, TITLE_X, TITLE_Y, horzCoord, vertCoord, res[0]);
    
    Pixel_On_Text2 #(.displayText("1. Volume Refresh Frequency")) seg_text_02
        (CLK_VGA, LINE_X, LINE_ONE_Y, horzCoord, vertCoord, res[1]);
        
    Pixel_On_Text2 #(.displayText("2. 7-Segment Blinking Frequency")) seg_text_03
        (CLK_VGA, LINE_X, LINE_TWO_Y, horzCoord, vertCoord, res[2]);
        
    Pixel_On_Text2 #(.displayText("3. Display State")) seg_text_04
        (CLK_VGA, LINE_X, LINE_THREE_Y, horzCoord, vertCoord, res[3]);
        
    Pixel_On_Text2 #(.displayText("4. Back")) seg_text_05
        (CLK_VGA, LINE_X, LINE_FOUR_Y, horzCoord, vertCoord, res[4]);
    
    
    /* 7-SEGMENT DISPLAY REFRESH FREQUENCY MENU */
    Pixel_On_Text2 #(.displayText("REFRESH FREQUENCY")) seg_text_06
        (CLK_VGA, TITLE_X, TITLE_Y, horzCoord, vertCoord, res[5]);    
        
    Pixel_On_Text2 #(.displayText("Done")) seg_text_07
        (CLK_VGA, LINE_X, LINE_ONE_Y, horzCoord, vertCoord, res[6]);
    
    
    /* 7-SEGMENT DISPLAY BLINKING FREQUENCY MENU */               
    Pixel_On_Text2 #(.displayText("BLINKING FREQUENCY")) seg_text_08
        (CLK_VGA, TITLE_X, TITLE_Y, horzCoord, vertCoord, res[7]);    
        
    Pixel_On_Text2 #(.displayText("Done")) seg_text_09
        (CLK_VGA, LINE_X, LINE_ONE_Y, horzCoord, vertCoord, res[8]);
        
        
    /* 7-SEGMENT DISPLAY STATE MENU */
    Pixel_On_Text2 #(.displayText("DISPLAY STATE")) seg_text_10
        (CLK_VGA, TITLE_X, TITLE_Y, horzCoord, vertCoord, res[9]);
                   
    Pixel_On_Text2 #(.displayText("1. Off")) seg_text_11
        (CLK_VGA, LINE_X, LINE_ONE_Y, horzCoord, vertCoord, res[10]);    
        
    Pixel_On_Text2 #(.displayText("2. On")) seg_text_12
        (CLK_VGA, LINE_X, LINE_TWO_Y, horzCoord, vertCoord, res[11]);
    
    
    always @ (posedge CLK_VGA) begin
        /* 7-SEGMENT DISPLAY REFRESH FREQ. MENU */
        if (MENU_POINTER == 33)
            SEG_RES <= res[6:5] ? 1 : 0;
        /* 7-SEGMENT DISPLAY BLINKING FREQ. MENU */
        else if (MENU_POINTER == 34)
            SEG_RES <= res[8:7] ? 1 : 0;
        /* 7-SEGMENT DISPLAY STATE MENU */
        else if ((MENU_POINTER >= 12) && (MENU_POINTER <= 13))
            SEG_RES <= res[11:9] ? 1 : 0;
        /* 7-SEGMENT DISPLAY MAIN MENU */
        else
            SEG_RES <= res[4:0] ? 1 : 0;
    end

endmodule