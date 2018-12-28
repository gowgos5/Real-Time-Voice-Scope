`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2018 16:22:17
// Design Name: 
// Module Name: Seg_Lut
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

module Seg_Lut(
    input [7:0] INDEX,
    output reg [7:0] CODE
    );
    
    always @ (*) begin
        case (INDEX)
            0 : CODE =  8'b11000000;
            1 : CODE =  8'b11111001;
            2 : CODE =  8'b10100100;
            3 : CODE =  8'b10110000;
            4 : CODE =  8'b10011001;
            5 : CODE =  8'b10010010;
            6 : CODE =  8'b10000010;
            7 : CODE =  8'b11111000;
            8 : CODE =  8'b10000000;
            9 : CODE =  8'b10010000;
            "A" : CODE =  8'b10001000;
            "B" : CODE =  8'b10000011;
            "b" : CODE =  8'b10000011;
            "C" : CODE =  8'b11000110;
            "c" : CODE =  8'b10100111;
            "D" : CODE =  8'b11000000;
            "d" : CODE =  8'b10100001;
            "E" : CODE =  8'b10000110;
            "e" : CODE =  8'b10000100;
            "F" : CODE =  8'b10001110;
            "f" : CODE =  8'b10001110;
            "G" : CODE =  8'b11000010;
            "g" : CODE =  8'b10010000;
            "H" : CODE =  8'b10001001;
            "h" : CODE =  8'b10001011;
            "I" : CODE =  8'b11111001;
            "i" : CODE =  8'b11111011;
            "J" : CODE =  8'b11100001;
            "j" : CODE =  8'b11100001;
            "L" : CODE =  8'b11000111;
            "l" : CODE =  8'b11001111;
            "n" : CODE =  8'b10101011;
            "O" : CODE =  8'b11000000;
            "o" : CODE =  8'b10100011;
            "P" : CODE =  8'b10001100;
            "p" : CODE =  8'b10001100;
            "Q" : CODE =  8'b01000000;
            "q" : CODE =  8'b10011000;
            "r" : CODE =  8'b10101111;
            "S" : CODE =  8'b10010010;
            "s" : CODE =  8'b10010010;
            "t" : CODE =  8'b10000111;
            "U" : CODE =  8'b11000001;
            "u" : CODE =  8'b11100011;
            "V" : CODE =  8'b11000001;
            "v" : CODE =  8'b11100011;
            "Y" : CODE =  8'b10010001;
            "y" : CODE =  8'b10010001;
            "." : CODE =  8'b01111111;
            " " : CODE =  8'b11111111;
            default : CODE = 8'b11111111;
        endcase
    end
    
endmodule