`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.11.2018 20:09:40
// Design Name: 
// Module Name: Grid_Mux
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

module Grid_Mux(
    input CLK_VGA,                            
    input [11:0] VGA_HORZ_COORD,
    input [11:0] VGA_VERT_COORD,
    input [1:0] DISP_GRID_SEL,
    output reg GRID_RES = 0
    );
    
    parameter DOTS = 0;
    parameter LINE = 1;
    parameter OFF = 2;
    
    wire axes = (VGA_HORZ_COORD == 640) || (VGA_VERT_COORD == 512);
    wire dots = ((VGA_VERT_COORD % 16 == 0) && (VGA_HORZ_COORD % 80 == 0)) || 
        ((VGA_VERT_COORD % 64 == 0) && (VGA_HORZ_COORD % 20 == 0));
    wire ticks = (VGA_VERT_COORD > 502 &&  VGA_VERT_COORD < 522 && (VGA_HORZ_COORD % 20 == 0)) || 
        (VGA_HORZ_COORD > 634 && VGA_HORZ_COORD < 646 && (VGA_VERT_COORD % 16 == 0));
    wire lines = ((VGA_HORZ_COORD % 80 == 0) && (VGA_HORZ_COORD > 0)) || 
        ((VGA_VERT_COORD % 64 == 0) && (VGA_VERT_COORD > 0));
    
    wire dots_res = axes || dots || ticks;
    
    always @ (posedge CLK_VGA) begin
        case (DISP_GRID_SEL)
            DOTS: GRID_RES = dots_res;
            LINE: GRID_RES = lines;
            OFF: GRID_RES = 0;
        endcase
    end
    
endmodule