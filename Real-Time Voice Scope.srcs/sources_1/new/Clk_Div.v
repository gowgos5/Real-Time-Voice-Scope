`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2018 11:50:57
// Design Name: 
// Module Name: Clk_Div
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

module Clk_Div #(
    parameter FREQ_WIDTH = 0,
    parameter DIV_WIDTH = 0
    )
    (
    input CLK_100M,
    input [FREQ_WIDTH:0] FREQ,
    output reg SLOW_CLK = 0
    );
    
    wire [DIV_WIDTH:0] clk_divider;
    reg [DIV_WIDTH:0] counter = 0;
    
    Freq_To_Clk_Divider #(FREQ_WIDTH, DIV_WIDTH)
        freq_to_div(.FREQ(FREQ), .CLK_DIVIDER(clk_divider));
    
    always @ (posedge CLK_100M) begin
        counter <= (counter >= clk_divider) ? 0 : (counter + 1);
        SLOW_CLK <= (counter == 0) ? ~SLOW_CLK : SLOW_CLK;
    end
    
endmodule