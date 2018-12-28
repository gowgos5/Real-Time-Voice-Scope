`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//-------------------------------------------------------------------------  
//                  DRAWING GRID LINES AND TICKS ON SCREEN
// Description:
// Grid lines are drawn at pixel # 320 along the x-axis, and
// pixel #768 along the y-axis

// Note the VGA controller is configured to produce a 1024 x 1280 pixel resolution
//-------------------------------------------------------------------------

//-------------------------------------------------------------------------
// TOOD:    Draw grid lines at every 80-th pixel along the horizontal axis, and every 64th pixel
//          along the vertical axis. This gives us a 16x16 grid on screen. 
//          
//          Further draw ticks on the central x and y grid lines spaced 16 and 8 pixels apart in the 
//          horizontal and vertical directions respectively. This gives us 5 sub-divisions per division 
//          in the horizontal and 8 sub-divisions per divsion in the vertical direction   
//-------------------------------------------------------------------------  
  
//////////////////////////////////////////////////////////////////////////////////

module Draw_Background(
    input CLK_VGA,
    
    input [11:0] VGA_HORZ_COORD,
    input [11:0] VGA_VERT_COORD,
    output reg [3:0] VGA_Red_Grid = 0,
    output reg [3:0] VGA_Green_Grid = 0,
    output reg [3:0] VGA_Blue_Grid = 0,
    
    input [2:0] DISP_THEME_SEL,
    input [1:0] DISP_GRID_SEL,
    
    input WAVEFORM_RES,
    input [3:0] MENU_RES,
    input [3:0] VOL_HISTORY_RES
    );
    
    wire grid_res;
    wire [23:0] background;
    wire [23:0] grid;
    
    Background_Mux mux_01(.DISP_THEME_SEL(DISP_THEME_SEL), .BACKGROUND(background), .GRID(grid));
        
    Grid_Mux mux_02(.CLK_VGA(CLK_VGA), .VGA_HORZ_COORD(VGA_HORZ_COORD), .VGA_VERT_COORD(VGA_VERT_COORD),
        .DISP_GRID_SEL(DISP_GRID_SEL), .GRID_RES(grid_res));


    /* DISPLAY PRIORITY (IN DECREASING ORDER) */
    // 1. Configuration menu
    // 2. Volume history waveform
    // 3. Main Waveform
    // 4. Grid
    // 5. Background
    always @ (posedge CLK_VGA) begin
        if (MENU_RES[0]) begin      // Menu text
            VGA_Red_Grid = 4'hF;
            VGA_Green_Grid = 4'hF;
            VGA_Blue_Grid = 4'hF;
        end
        else if (MENU_RES[1]) begin // Menu pointer
            VGA_Red_Grid = 4'h0;
            VGA_Green_Grid = 4'hE;
            VGA_Blue_Grid = 4'hE;
        end
        else if (MENU_RES[2]) begin // Menu border
            VGA_Red_Grid = 4'hF;
            VGA_Green_Grid = 4'hF;
            VGA_Blue_Grid = 4'hF;
        end
        else if (MENU_RES[3]) begin // Menu background
            VGA_Red_Grid = 4'h0;
            VGA_Green_Grid = 4'h0;
            VGA_Blue_Grid = 4'h0;            
        end
        else if (VOL_HISTORY_RES[0]) begin   // Volume history window text
            VGA_Red_Grid = 4'hF;
            VGA_Green_Grid = 4'hF;
            VGA_Blue_Grid = 4'hF; 
        end
        else if (VOL_HISTORY_RES[1]) begin   // Volume history waveform
            VGA_Red_Grid = 4'hF;
            VGA_Green_Grid = 4'hF;
            VGA_Blue_Grid = 4'hF;
        end
        else if (VOL_HISTORY_RES[2]) begin   // Volume history window border
            VGA_Red_Grid = 4'hF;
            VGA_Green_Grid = 4'hF;
            VGA_Blue_Grid = 4'hF;
        end
        else if (VOL_HISTORY_RES[3]) begin   // Volume history window background
            VGA_Red_Grid = 4'h0;
            VGA_Green_Grid = 4'h0;
            VGA_Blue_Grid = 4'h0;
        end
        else if (WAVEFORM_RES) begin    // Main waveform
            VGA_Red_Grid = 4'h0;
            VGA_Green_Grid = 4'h0;
            VGA_Blue_Grid = 4'h0;
        end
        else if (grid_res) begin        // Main grid
            VGA_Red_Grid = grid[23:16];
            VGA_Green_Grid = grid[15:8];
            VGA_Blue_Grid = grid[7:0];
        end
        else begin                     // Main background
            VGA_Red_Grid = background[23:16];
            VGA_Green_Grid = background[15:8];
            VGA_Blue_Grid = background[7:0];
        end
    end
    
endmodule