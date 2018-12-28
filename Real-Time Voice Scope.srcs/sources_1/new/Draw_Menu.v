`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2018 19:06:51
// Design Name: 
// Module Name: Draw_Menu
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

module Draw_Menu(
    input CLK_VGA,
    input [11:0] VGA_HORZ_COORD,
    input [11:0] VGA_VERT_COORD,
    
    input SW_CONFIG,
    input [1:0] CONFIG_MODE,
    input [5:0] MENU_POINTER,
    
    output reg [3:0] MENU_RES = 0
    );
    
    wire menu_background_res, menu_border_res, menu_pointer_res;
    wire main_res, led_res, seg_res, vga_res;
    
    wire [31:0] horzCoord = VGA_HORZ_COORD;
    wire [31:0] vertCoord = VGA_VERT_COORD;
    
    
    Draw_Menu_Background menu_background(.VGA_HORZ_COORD(VGA_HORZ_COORD),
        .VGA_VERT_COORD(VGA_VERT_COORD), .BACKGROUND_RES(menu_background_res),
        .BORDER_RES(menu_border_res));
    
    Draw_Menu_Pointer menu_pointer(.CLK_VGA(CLK_VGA), .horzCoord(horzCoord),
        .vertCoord(vertCoord), .MENU_POINTER(MENU_POINTER),
        .POINTER_RES(menu_pointer_res), .SW_CONFIG(SW_CONFIG), .CONFIG_MODE(CONFIG_MODE));
    
    Draw_Main_Menu menu_01(.CLK_VGA(CLK_VGA), .horzCoord(horzCoord),
        .vertCoord(vertCoord), .MAIN_RES(main_res));
         
    Draw_Leds_Menu menu_02(.CLK_VGA(CLK_VGA), .horzCoord(horzCoord),
        .vertCoord(vertCoord), .LED_RES(led_res), .MENU_POINTER(MENU_POINTER));
    
    Draw_Seg_Menu menu_03(.CLK_VGA(CLK_VGA), .horzCoord(horzCoord),
        .vertCoord(vertCoord), .SEG_RES(seg_res), .MENU_POINTER(MENU_POINTER));
        
    Draw_Vga_Menu menu_04(.CLK_VGA(CLK_VGA), .horzCoord(horzCoord),
        .vertCoord(vertCoord), .VGA_RES(vga_res), .MENU_POINTER(MENU_POINTER));
    
    
    always @ (posedge CLK_VGA) begin
        if (SW_CONFIG) begin
            case (CONFIG_MODE)
                2'b00: MENU_RES[0] = main_res;
                2'b01: MENU_RES[0] = led_res;
                2'b10: MENU_RES[0] = seg_res;
                2'b11: MENU_RES[0] = vga_res;
            endcase
            
            MENU_RES[1] = menu_pointer_res;
            MENU_RES[2] = menu_border_res;
            MENU_RES[3] = menu_background_res;
       end
       else
            MENU_RES = 0;
    end
    
endmodule