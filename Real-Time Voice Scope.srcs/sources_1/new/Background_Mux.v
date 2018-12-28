`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.11.2018 20:58:52
// Design Name: 
// Module Name: Background_Mux
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

module Background_Mux(
    input [2:0] DISP_THEME_SEL,    
    output [23:0] BACKGROUND,
    output [23:0] GRID
    );
    
    reg [23:0] GRID_COLOURS [4:0];
    reg [23:0] BACKGROUND_COLOURS [4:0];
    
    initial begin
       BACKGROUND_COLOURS[0] = 24'h661111;      // Dark Red
       BACKGROUND_COLOURS[1] = 24'h339999;      // Dark Cyan Blue
       BACKGROUND_COLOURS[2] = 24'h709811;      // Green
       BACKGROUND_COLOURS[3] = 24'hDBB76B;      // Pink-purple
       BACKGROUND_COLOURS[4] = 24'h000000;      // Black
       
       GRID_COLOURS[0] = 24'hFFCC66;            // Yellow
       GRID_COLOURS[1] = 24'h000F8F;            // Light Cyan Blue
       GRID_COLOURS[2] = 24'h000007;            // Purple
       GRID_COLOURS[3] = 24'h6611AA;            // Blue
       GRID_COLOURS[4] = 24'hFFFFFF;            // White
    end
    
    assign BACKGROUND = BACKGROUND_COLOURS[DISP_THEME_SEL];
    assign GRID = GRID_COLOURS[DISP_THEME_SEL];

endmodule