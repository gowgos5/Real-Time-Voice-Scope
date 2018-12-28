`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2018 14:56:10
// Design Name: 
// Module Name: D_Flip_Flop
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

module D_Flip_Flop(
    input CLK,
    input D,
    output reg Q = 0
    );
    
    always @ (posedge CLK)
    begin
        Q <= D;
    end
    
endmodule