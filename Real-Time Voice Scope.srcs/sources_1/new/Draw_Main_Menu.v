`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2018 19:06:51
// Design Name: 
// Module Name: Draw_Main_Menu
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

module Draw_Main_Menu(
    input CLK_VGA,
    input [31:0] horzCoord,
    input [31:0] vertCoord,
    output MAIN_RES
    );
    
    parameter TITLE_X = 25;
    parameter TITLE_Y = 25;
    parameter LINE_X = 50;
    parameter LINE_ONE_Y = 60;
    parameter LINE_TWO_Y = 85;
    parameter LINE_THREE_Y = 110;
    parameter LINE_FOUR_Y = 135;
    parameter LINE_FIVE_Y = 160;
    
    wire [3:0] res;
    
    
    /* CONFIGURATION MAIN MENU */
    Pixel_On_Text2 #(.displayText("CONFIGURATION MENU")) main_text_01
        (CLK_VGA, TITLE_X, TITLE_Y, horzCoord, vertCoord, res[0]);
    
    Pixel_On_Text2 #(.displayText("1. LEDs Array")) main_text_02
        (CLK_VGA, LINE_X, LINE_ONE_Y, horzCoord, vertCoord, res[1]);
       
    Pixel_On_Text2 #(.displayText("2. 7-Segment Display")) main_text_03
        (CLK_VGA, LINE_X, LINE_TWO_Y, horzCoord, vertCoord, res[2]);
        
    Pixel_On_Text2 #(.displayText("3. VGA Display")) main_text_04
        (CLK_VGA, LINE_X, LINE_THREE_Y, horzCoord, vertCoord, res[3]);
    
    assign MAIN_RES = (res) ? 1 : 0;
    
endmodule