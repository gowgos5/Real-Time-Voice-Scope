`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2018 16:24:43
// Design Name: 
// Module Name: Seg_Display
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

module Seg_Display(
    input CLK_SEG_REFRESH,
    input CLK_SEG_BLINK,
    
    input SW_CONFIG,
    input SEG_STATE_SEL,
    
    // Display dataset.
    input [5:0] LEDS_REFRESH_FREQ,
    input [5:0] SEG_REFRESH_FREQ,
    input [8:0] SEG_BLINK_FREQ,
    input [9:0] DISP_REFRESH_FREQ,
    input [4:0] MIC_VOL,
      
    input [5:0] MENU_POINTER,
    
    output reg [3:0] ANODE = 0,
    output [7:0] CATHODE
    );
    
    reg [1:0] blink = 0;
    
    Seg_Mux mux(.CLK_SEG_REFRESH(CLK_SEG_REFRESH), .SEL(MENU_POINTER), 
        .BLINK(blink), .SEG_REFRESH_FREQ(SEG_REFRESH_FREQ),
        .SEG_BLINK_FREQ(SEG_BLINK_FREQ), .LEDS_REFRESH_FREQ(LEDS_REFRESH_FREQ),
        .DISP_REFRESH_FREQ(DISP_REFRESH_FREQ), .MIC_VOL(MIC_VOL), .CODE(CATHODE));
    
    // Refresh 7-segment display.
    always @ (posedge CLK_SEG_BLINK) begin
        if ((SW_CONFIG == 0) && (SEG_STATE_SEL == 0)) begin
            ANODE = 4'b1111;
        end
        else begin
           blink = blink + 1;
           
           case (blink)
               2'b00: ANODE = 4'b0111;
               2'b01: ANODE = 4'b1011;
               2'b10: ANODE = 4'b1101;
               2'b11: ANODE = 4'b1110;
           endcase
        end
    end
    
endmodule