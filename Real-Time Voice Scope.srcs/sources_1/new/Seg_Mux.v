`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2018 16:23:24
// Design Name: 
// Module Name: Seg_Mux
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

//////////////////////////////////////////////////////////////////////////////////
// MUX (MENU POINTER)
// 0. LEDS (MAIN MENU)
// 1. REFRESH FREQUENCY (LEDS MENU)
// 2. POSITION (LEDS MENU)
// 3. LEFT (LEDS POSITION MENU)
// 4. RIGHT (LEDS POSITION MENU)
// 5. CEMTER (LEDS POSITION MENU)
// 6. OFF (LEDS POSITION MENU)
// 7. RETURN (LEDS MENU)
// 8. 7-SEG (MAIN MENU)
// 9. REFRESH FREQUENCY (7-SEG MENU)
// 10. BLINKING FREQUENCY (7-SEG MENU)
// 11. 7-SEG DISPLAY STATE (7-SEG MENU)
// 12. OFF (7-SEG STATE MENU)
// 13. ON (7-SEG STATE MENU)
// 14. RETURN (7-SEG MENU)
// 15. VGA DISPLAY (MAIN MENU)
// 16. THEME (VGA MENU)
// 17. THEME 1 (VGA THEME MENU)
// 18. THEME 2 (VGA THEME MENU)
// 19. THEME 3 (VGA THEME MENU)
// 20. THEME 4 (VGA THEME MENU)
// 21. THEME 5 (VGA THEME MENU)
// 22. GRID (VGA MENU)
// 23. DOTS (VGA GRID MENU)
// 24. LINES (VGA GRID MENU)
// 25. OFF (VGA GRID MENU)
// 26. WAVEFORM TYPE (VGA MENU)
// 27. NORMAL (VGA WAVEFORM MENU)
// 28. BAR (VGA WAVEFORM MENU)
// 29. CIRCLE (VGA WAVEFORM MENU)
// 30. OFF (VGA WAVEFORM MENU)
// 31. VOLUME PROGRAM
// 32. CONFIGURE LEDS REFRESH FREQ.
// 33. CONFIGURE 7-SEG REFRESH FREQ.
// 34. CONFIGURE 7-SEG BLINKING FREQ.
// 35. CONFIGURE VGA REFRESH FREQ.
// 36. REFRESH FREQUENCY (VGA MENU)
// 37. VOLUME HISTORY (VGA MENU)
// 38. OFF (VGA VOLUME HISTORY MENU)
// 39. ON (VGA VOLUME HISTORY MENU)
// 40. RETURN (VGA MENU)
/////////////////////////////////////////////////////////////////////////////////

module Seg_Mux(
    input CLK_SEG_REFRESH,
    
    input [5:0] SEL,
    input [1:0] BLINK,
    
    /* DATA TO BE DISPLAYED */
    input [5:0] SEG_REFRESH_FREQ,
    input [8:0] SEG_BLINK_FREQ,
    input [5:0] LEDS_REFRESH_FREQ,
    input [9:0] DISP_REFRESH_FREQ,
    input [4:0] MIC_VOL,
    
    output [7:0] CODE
    );
    
    task get_digit;
        input [14:0] number;
        input [1:0] sel;
        output [3:0] digit;
    
        begin
            case (sel)
            0: digit = (number / 1000) % 10;    // thosuands
            1: digit = (number / 100) % 10;     // hundreds
            2: digit = (number / 10) % 10;      // tens
            3: digit = number % 10;             // ones
            endcase
        end
    endtask
    
    parameter VOLUME = 31;
    parameter LEDS_REFRESH = 32;
    parameter SEG_REFRESH = 33;
    parameter SEG_BLINK = 34;
    parameter DISP_REFRESH = 35;
    
    reg [7:0] seg_words [40:0][3:0];
    reg [7:0] index = 0;
        
    reg [3:0] tmp_vol = 0;
    reg [3:0] current_vol = 0;
    
    reg [14:0] data;
    reg [3:0] tmp;
        
    Seg_Lut lut(.INDEX(index), .CODE(CODE));
    
    initial begin
        /* LEDS (MAIN MENU) */
        seg_words[0][0] = "L";
        seg_words[0][1] = "E";
        seg_words[0][2] = "D"; 
        seg_words[0][3] = "S";    
        
        /* REFRESH FREQUENCY (LEDS MENU) */
        seg_words[1][0] = "r";    
        seg_words[1][1] = "e";    
        seg_words[1][2] = "f";    
        seg_words[1][3] = "r";    
        
        /* POSITION (LEDS MENU) */
        seg_words[2][0] = " ";    
        seg_words[2][1] = "P";    
        seg_words[2][2] = "O";    
        seg_words[2][3] = "S";
        
        /* LEFT (LEDS POSITION MENU) */
        seg_words[3][0] = "L";    
        seg_words[3][1] = "E";    
        seg_words[3][2] = "F";    
        seg_words[3][3] = "t";
        
        /* RIGHT (LEDS POSITION MENU) */                          
        seg_words[4][0] = "r";    
        seg_words[4][1] = "I";    
        seg_words[4][2] = "t";    
        seg_words[4][3] = "e";
        
        /* CENTER (LEDS POSITION MENU) */
        seg_words[5][0] = "C";    
        seg_words[5][1] = "t";    
        seg_words[5][2] = "n";    
        seg_words[5][3] = "r";
        
        /* OFF (LEDS POSITION MENU) */
        seg_words[6][0] = " ";
        seg_words[6][1] = "O";
        seg_words[6][2] = "F";
        seg_words[6][3] = "F";
        
        /* RETURN (LEDS MENU) */
        seg_words[7][0] = " ";
        seg_words[7][1] = "r";
        seg_words[7][2] = "t";
        seg_words[7][3] = "n";
        
        /* 7-SEG (MAIN MENU) */
        seg_words[8][0] = 7;
        seg_words[8][1] = "S";
        seg_words[8][2] = "E";
        seg_words[8][3] = "G";
        
        /* REFRESH FREQUENCY (7-SEG MENU) */
        seg_words[9][0] = "r";
        seg_words[9][1] = "e";
        seg_words[9][2] = "f";
        seg_words[9][3] = "r";
        
        /* BLINKING FREQUENCY (7-SEG MENU) */
        seg_words[10][0] = "F";
        seg_words[10][1] = "L";
        seg_words[10][2] = "S";
        seg_words[10][3] = "H";
        
        /* 7-SEG DISPLAY STATE (7-SEG MENU) */
        seg_words[11][0] = "S";
        seg_words[11][1] = "t";
        seg_words[11][2] = "A";
        seg_words[11][3] = "t";
        
        /* OFF (7-SEG STATE MENU) */
        seg_words[12][0] = " ";
        seg_words[12][1] = "O";
        seg_words[12][2] = "F";
        seg_words[12][3] = "F";
        
        /* ON (7-SEG STATE MENU) */
        seg_words[13][0] = " ";
        seg_words[13][1] = " ";
        seg_words[13][2] = "O";
        seg_words[13][3] = "n";
        
        /* RETURN (7-SEG MENU) */
        seg_words[14][0] = " ";
        seg_words[14][1] = "r";
        seg_words[14][2] = "t";
        seg_words[14][3] = "n";
        
        /* VGA DISPLAY (MAIN MENU) */
        seg_words[15][0] = "D";
        seg_words[15][1] = "I";
        seg_words[15][2] = "S";
        seg_words[15][3] = "P";
        
        /* THEME (VGA MENU) */
        seg_words[16][0] = "S";
        seg_words[16][1] = "c";
        seg_words[16][2] = "r";
        seg_words[16][3] = "n";
        
        /* THEME 1 (VGA THEME MENU) */
        seg_words[17][0] = "s";
        seg_words[17][1] = "c";
        seg_words[17][2] = "n";
        seg_words[17][3] = 1;
        
        /* THEME 2 (VGA THEME MENU) */
        seg_words[18][0] = "s";
        seg_words[18][1] = "c";
        seg_words[18][2] = "n";
        seg_words[18][3] = 2;
        
        /* THEME 3 (VGA THEME MENU) */
        seg_words[19][0] = "s";
        seg_words[19][1] = "c";
        seg_words[19][2] = "n";
        seg_words[19][3] = 3;
        
        /* THEME 4 (VGA THEME MENU) */
        seg_words[20][0] = "s";
        seg_words[20][1] = "c";
        seg_words[20][2] = "n";
        seg_words[20][3] = 4;
        
        /* THEME 5 (VGA THEME MENU) */
        seg_words[21][0] = "s";
        seg_words[21][1] = "c";
        seg_words[21][2] = "n";
        seg_words[21][3] = 5;
        
        /* GRID (VGA MENU) */
        seg_words[22][0] = "g";
        seg_words[22][1] = "r";
        seg_words[22][2] = "I";
        seg_words[22][3] = "d";
        
        /* DOTS (VGA GRID MENU) */
        seg_words[23][0] = "d";
        seg_words[23][1] = "O";
        seg_words[23][2] = "t";
        seg_words[23][3] = "S";
        
        /* LINES (VGA GRID MENU) */
        seg_words[24][0] = "L";
        seg_words[24][1] = "I";
        seg_words[24][2] = "n";
        seg_words[24][3] = "e";
        
        /* OFF (VGA GRID MENU) */
        seg_words[25][0] = " ";
        seg_words[25][1] = "O";
        seg_words[25][2] = "F";
        seg_words[25][3] = "F";
        
        /* WAVEFORM TYPE (VGA MENU) */
        seg_words[26][0] = "t";
        seg_words[26][1] = "Y";
        seg_words[26][2] = "P";
        seg_words[26][3] = "E";
        
        /* NORMAL (VGA WAVEFORM TYPE MENU) */
        seg_words[27][0] = " ";
        seg_words[27][1] = "n";
        seg_words[27][2] = "o";
        seg_words[27][3] = "r";
        
        /* BAR (VGA WAVEFORM TYPE MENU) */
        seg_words[28][0] = " ";
        seg_words[28][1] = "b";
        seg_words[28][2] = "A";
        seg_words[28][3] = "r";
        
        /* CIRCLE (VGA WAVEFORM TYPE MENU) */
        seg_words[29][0] = "c";
        seg_words[29][1] = "i";
        seg_words[29][2] = "r";
        seg_words[29][3] = "c";
        
        /* OFF (VGA WAVEFORM TYPE MENU) */
        seg_words[30][0] = " ";
        seg_words[30][1] = "O";
        seg_words[30][2] = "F";
        seg_words[30][3] = "F";
        
        /* VOLUME PROGRAM */
        seg_words[31][0] = 0;
        seg_words[31][1] = 0;
        seg_words[31][2] = 0;
        seg_words[31][3] = 0;
        
        /* CONFIGURE LEDS REFRESH FREQ. */
        seg_words[32][0] = 0;
        seg_words[32][1] = 0;
        seg_words[32][2] = 0;
        seg_words[32][3] = 0;
        
        /* CONFIGURE 7-SEG REFRESH FREQ. */
        seg_words[33][0] = 0;
        seg_words[33][1] = 0;
        seg_words[33][2] = 0;
        seg_words[33][3] = 0;
        
        /* CONFIGURE 7-SEG BLINKING FREQ. */
        seg_words[34][0] = 0;
        seg_words[34][1] = 0;
        seg_words[34][2] = 0;
        seg_words[34][3] = 0;
        
        /* CONFIGURE VGA REFRESH FREQ. */
        seg_words[35][0] = 0;
        seg_words[35][1] = 0;
        seg_words[35][2] = 0;
        seg_words[35][3] = 0;

        /* REFRESH FREQUENCY (VGA MENU) */
        seg_words[36][0] = "r";
        seg_words[36][1] = "e";
        seg_words[36][2] = "f";
        seg_words[36][3] = "r";
        
        /* VOLUME HISTORY WAVEFORM (VGA MENU) */
        seg_words[37][0] = "H";
        seg_words[37][1] = "I";
        seg_words[37][2] = "S";
        seg_words[37][3] = "t";
        
        /* OFF (VGA VOLUME HISTORY MENU) */
        seg_words[38][0] = " ";
        seg_words[38][1] = "O";
        seg_words[38][2] = "F";
        seg_words[38][3] = "F";
        
        /* ON (VGA VOLUME HISTORY MENU) */
        seg_words[39][0] = " ";
        seg_words[39][1] = " ";
        seg_words[39][2] = "O";
        seg_words[39][3] = "n";
        
        /* RETURN (VGA MENU) */
        seg_words[40][0] = " ";
        seg_words[40][1] = "r";
        seg_words[40][2] = "t";
        seg_words[40][3] = "n";
    end
   
    always @ (*) begin
        case (SEL)
            VOLUME: data = current_vol;
            LEDS_REFRESH: data = LEDS_REFRESH_FREQ;
            SEG_REFRESH: data = SEG_REFRESH_FREQ;
            SEG_BLINK: data = SEG_BLINK_FREQ;
            DISP_REFRESH: data = DISP_REFRESH_FREQ;
            default: data = 0;
        endcase
        
        get_digit(data, BLINK, tmp);
        
        index = ((SEL == VOLUME) || (SEL == LEDS_REFRESH) || (SEL == SEG_REFRESH) || 
            (SEL == SEG_BLINK) || (SEL == DISP_REFRESH)) ? tmp : seg_words[SEL][BLINK];
    end
    
    // Allows for a smooth transition between volume levels of the
    // 7-segment display volume indicator.
    always @ (posedge CLK_SEG_REFRESH) begin
        tmp_vol <= (MIC_VOL >> 1);    // limit vol. range (0 to 10)

        if (current_vol < tmp_vol) begin
            if ((tmp_vol - current_vol) > 3)
                current_vol <= current_vol + 3;
            else if ((tmp_vol - current_vol) > 5)
                current_vol <= current_vol + 5;
            else
                current_vol <= current_vol + 1;
        end
        else if (current_vol > tmp_vol) begin
            current_vol <= current_vol - 1;
        end
    end
    
endmodule