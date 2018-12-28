`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2018 15:00:43
// Design Name: 
// Module Name: Buttons_Debounce
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

module Buttons_Debounce(
    input CLK,
    input [2:0] BTNS,
    output [2:0] BTNS_DEBOUNCED
    );
    
    Debounce_Circuit debounce_01(.CLK(CLK), .BTN(BTNS[0]), .OUTPUT(BTNS_DEBOUNCED[0]));
    Debounce_Circuit debounce_02(.CLK(CLK), .BTN(BTNS[1]), .OUTPUT(BTNS_DEBOUNCED[1]));
    Debounce_Circuit debounce_03(.CLK(CLK), .BTN(BTNS[2]), .OUTPUT(BTNS_DEBOUNCED[2]));
    
endmodule