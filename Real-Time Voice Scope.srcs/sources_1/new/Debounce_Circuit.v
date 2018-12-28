`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2018 14:54:20
// Design Name: 
// Module Name: Debounce_Circuit
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

module Debounce_Circuit(
    input CLK,
    input BTN,
    output OUTPUT
    );
    
    wire q_one, q_two, q_tmp;
    
    D_Flip_Flop dff_01(.CLK(CLK), .D(BTN), .Q(q_one));
    D_Flip_Flop dff_02(.CLK(CLK), .D(q_one), .Q(q_tmp));
    
    assign q_two = ~q_tmp;
    assign OUTPUT = q_one & q_two;
    
endmodule