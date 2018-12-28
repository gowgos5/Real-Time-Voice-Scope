`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2018 11:40:36
// Design Name: 
// Module Name: Freq_To_Clk_Divider
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

module Freq_To_Clk_Divider #(
    parameter FREQ_WIDTH = 0,
    parameter DIV_WIDTH = 0
    )
    (
    input [FREQ_WIDTH:0] FREQ,
    output [DIV_WIDTH:0] CLK_DIVIDER
    );
    
    assign CLK_DIVIDER = ((100000000 / FREQ) / 2) - 1;
    
endmodule