`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2018 19:06:51
// Design Name: 
// Module Name: Draw_Menu_Background
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

module Draw_Menu_Background(
    input [11:0] VGA_HORZ_COORD,
    input [11:0] VGA_VERT_COORD,
    
    output BACKGROUND_RES,
    output BORDER_RES
    );
    
    parameter MENU_WINDOW_LEN = 320;
    parameter MENU_WINDOW_WIDTH = 230;
    
    parameter MENU_BACKGROUND_LEFT = 0;
    parameter MENU_BACKGROUND_RIGHT = MENU_BACKGROUND_LEFT + MENU_WINDOW_LEN;
    parameter MENU_BACKGROUND_TOP = 0;
    parameter MENU_BACKGROUND_BOTTOM = MENU_BACKGROUND_TOP + MENU_WINDOW_WIDTH;
    
    parameter MENU_BORDER_WIDTH = 2;
    
    // Menu background
    assign BACKGROUND_RES = (VGA_HORZ_COORD >= MENU_BACKGROUND_LEFT) && (VGA_HORZ_COORD <= MENU_BACKGROUND_RIGHT)
        && (VGA_VERT_COORD >= MENU_BACKGROUND_TOP) && (VGA_VERT_COORD <= MENU_BACKGROUND_BOTTOM);
    
    wire border_left = (VGA_HORZ_COORD >= MENU_BACKGROUND_LEFT) && 
        (VGA_HORZ_COORD <= (MENU_BACKGROUND_LEFT + MENU_BORDER_WIDTH));
    wire border_right = (VGA_HORZ_COORD >= (MENU_BACKGROUND_RIGHT - MENU_BORDER_WIDTH))
        && (VGA_HORZ_COORD <= MENU_BACKGROUND_RIGHT);
    wire border_top = (VGA_VERT_COORD >= MENU_BACKGROUND_TOP) && 
        (VGA_VERT_COORD <= (MENU_BACKGROUND_TOP + MENU_BORDER_WIDTH));
    wire border_bottom = (VGA_VERT_COORD >= (MENU_BACKGROUND_BOTTOM - MENU_BORDER_WIDTH))
        && (VGA_VERT_COORD <= MENU_BACKGROUND_BOTTOM);
        
    // Menu border
    assign BORDER_RES = BACKGROUND_RES && (border_left || border_right || border_top || border_bottom);
    
endmodule