`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2018 19:06:51
// Design Name: 
// Module Name: Draw_Leds_Menu
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

module Draw_Leds_Menu(
    input CLK_VGA,
    input [31:0] horzCoord,
    input [31:0] vertCoord,
    input [5:0] MENU_POINTER,
    output reg LED_RES = 0
    );
    
    parameter TITLE_X = 25;
    parameter TITLE_Y = 25;
    parameter LINE_X = 50;
    parameter LINE_ONE_Y = 60;
    parameter LINE_TWO_Y = 85;
    parameter LINE_THREE_Y = 110;
    parameter LINE_FOUR_Y = 135;
    parameter LINE_FIVE_Y = 160;
    
    wire [10:0] res;
    
    
    /* LEDs ARRAY MAIN MENU */
    Pixel_On_Text2 #(.displayText("LEDs ARRAY MENU")) led_text_01
       (CLK_VGA, TITLE_X, TITLE_Y, horzCoord, vertCoord, res[0]);
    
    Pixel_On_Text2 #(.displayText("1. Volume Refresh Frequency")) led_text_02
       (CLK_VGA, LINE_X, LINE_ONE_Y, horzCoord, vertCoord, res[1]);
       
    Pixel_On_Text2 #(.displayText("2. Position")) led_text_03
       (CLK_VGA, LINE_X, LINE_TWO_Y, horzCoord, vertCoord, res[2]);
       
    Pixel_On_Text2 #(.displayText("3. Back")) led_text_04
       (CLK_VGA, LINE_X, LINE_THREE_Y, horzCoord, vertCoord, res[3]);
    
    
    /* LED POSITION MENU */                                                                   
    Pixel_On_Text2 #(.displayText("POSITION")) led_text_05                   
       (CLK_VGA, TITLE_X, TITLE_Y, horzCoord, vertCoord, res[4]);
       
    Pixel_On_Text2 #(.displayText("1. Left")) led_text_06                   
       (CLK_VGA, LINE_X, LINE_ONE_Y, horzCoord, vertCoord, res[5]);
              
    Pixel_On_Text2 #(.displayText("2. Right")) led_text_07
       (CLK_VGA, LINE_X, LINE_TWO_Y, horzCoord, vertCoord, res[6]);
    
    Pixel_On_Text2 #(.displayText("3. Center")) led_text_08
       (CLK_VGA, LINE_X, LINE_THREE_Y, horzCoord, vertCoord, res[7]);
       
    Pixel_On_Text2 #(.displayText("4. Off")) led_text_09
       (CLK_VGA, LINE_X, LINE_FOUR_Y, horzCoord, vertCoord, res[8]);
    
    
    /* LED REFRESH FREQ. MENU */
    Pixel_On_Text2 #(.displayText("REFRESH FREQUENCY")) led_text_10
       (CLK_VGA, TITLE_X, TITLE_Y, horzCoord, vertCoord, res[9]);    
       
    Pixel_On_Text2 #(.displayText("Done")) led_text_11
       (CLK_VGA, LINE_X, LINE_ONE_Y, horzCoord, vertCoord, res[10]);
    
    
    always @ (posedge CLK_VGA) begin
       /* LED POSITION MENU */
       if (MENU_POINTER >= 3 && MENU_POINTER <= 6)
           LED_RES <= res[8:4] ? 1 : 0;
       /* LED REFRESH FREQ. MENU */
       else if (MENU_POINTER == 32)
           LED_RES <= res[10:9] ? 1 : 0;
       /* LED MAIN MENU */
       else
           LED_RES <= res[3:0] ? 1 : 0;
    end
   
endmodule