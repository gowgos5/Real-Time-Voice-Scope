`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2018 16:12:23
// Design Name: 
// Module Name: Leds_Array
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

module Leds_Array(
    input CLK_LEDS_REFRESH,
    input SW_CONFIG,
    input [1:0] CONFIG_MODE,
    input [4:0] MIC_VOL,
    input [1:0] LEDS_POS,
    output reg [9:0] LEDS_ARRAY = 0
    );
    
    parameter ALL_LEDS_OFF = 10'b0000000000;
    parameter ALL_LEDS_ON = 10'b1111111111;
    parameter HALF_LEDS_ON = 5'b11111;
    
    parameter RIGHT = 0;
    parameter LEFT = 1;
    parameter CENTER = 2;
    parameter OFF = 3;
    
    reg [4:0] center_r = 0;
    reg [4:0] center_l = 0;

    reg config_dir = 0;
    reg [9:0] config_leds = 0;
    
    reg [3:0] tmp_vol = 0;
    reg [3:0] current_vol = 0;
    
    always @ (posedge CLK_LEDS_REFRESH) begin
        if (SW_CONFIG == 0) begin   // Volume indicator program.
            case (LEDS_POS)
                RIGHT: LEDS_ARRAY <= (ALL_LEDS_ON >> (10 - current_vol));
                LEFT: LEDS_ARRAY <= ((ALL_LEDS_ON >> current_vol) ^ ALL_LEDS_ON);
                CENTER: begin
                    center_r <= (HALF_LEDS_ON >> (5 - (current_vol >> 1)));
                    center_l <= ((HALF_LEDS_ON >> (current_vol >> 1)) ^ HALF_LEDS_ON);
                    LEDS_ARRAY <= {center_r, center_l};
                end
                OFF: LEDS_ARRAY = ALL_LEDS_OFF;
            endcase
        end
        else begin  // Configuration mode.
            if (CONFIG_MODE == 2'b01) begin     // LEDs config menu.
                case (config_dir)
                    0: config_leds <= ((config_leds << 1) + 1);
                    1: config_leds <= (config_leds >> 1);
                endcase
                
                config_dir <= (config_leds == ALL_LEDS_ON) ? 1 :
                              (config_leds == ALL_LEDS_OFF) ? 0 :
                              (config_dir);
                
                case (LEDS_POS)
                    RIGHT: LEDS_ARRAY <= config_leds;
                    LEFT: LEDS_ARRAY <= (config_leds ^ ALL_LEDS_ON);
                    CENTER: begin
                        center_l <= {config_leds[1], config_leds[3], config_leds[5], 
                            config_leds[7], config_leds[9]};
                        center_r <= {config_leds[9], config_leds[7],
                           config_leds[5], config_leds[3], config_leds[1]};
                        LEDS_ARRAY <= {center_r, center_l};
                    end
                    OFF: LEDS_ARRAY <= ALL_LEDS_OFF;
                endcase
            end
            else begin  // Any other configuration menu.
                LEDS_ARRAY <= 0;
            end
        end
    end
    
    // Allows for a smooth transition between volume levels of the
    // LEDs volume indicator.
    always @ (posedge CLK_LEDS_REFRESH) begin
        tmp_vol <= (MIC_VOL >> 1);    // limit volume range (0 to 10)
    
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