//------------------------------------------------------------------------------
// Title         : VGA Driver
//------------------------------------------------------------------------------
// File          : VGA.sv
// Author        : David Ramón Alamán
// Created       : 02.08.2024
//------------------------------------------------------------------------------
// Description: VGA driver. Specific for a 640x480 @ 60 Hz screen.
//------------------------------------------------------------------------------

// VGA Signal 640x480 @ 60 Hz
// Data from http://www.tinyvga.com/vga-timing/640x480@60Hz
//
// Horizontal timing:
//  + (VA) Visible area: 640 pixels
//  + (FP) Front porch:   16 pixels
//  + (SP) Sync pulse:    96 pixels
//  + (BP) Back porch:    48 pixels
//  ---------------------------------
//         Whole line:   800 pixels
//
// Vertical timing:
//  + (VA) Visible area: 480 lines
//  + (FP) Front porch:   10 lines
//  + (SP) Sync pulse:     2 lines
//  + (BP) Back porch:    33 lines
//  ---------------------------------
//         Whole line:   525 lines

// 50 MHz input clk due to the Dev-Board Terasic DE10-Lite

module VGA(
    input logic clk_50MHz, arst_n, en,
    output logic hsync, vsync, clk_25MHz,
    output logic[9:0] v_count, h_count
);

parameter V_LENGTH     = 525;
parameter H_LENGTH     = 800;
parameter V_SYNC_START = 489; // VA + FP - 1 (480 + 10 - 1)
parameter V_SYNC_STOP  = 491; // VA + FP + SP - 1 (480 + 10 + 2- 1)
parameter H_SYNC_START = 655; // VA + FP - 1 (640 + 16 - 1)
parameter H_SYNC_STOP  = 751; // VA + FP + SP - 1 (640 + 16 + 96 - 1)

// Frequency divider 50 MHz -> 25 MHz
logic clk_count;
always_ff @ (posedge clk_50MHz or negedge arst_n) begin
    if (!arst_n) begin
        clk_count <= 0;
    end
    else if(en) begin
        clk_count <= clk_count + 1;
    end
end
assign clk_25MHz = (clk_count == 0) ? 1'b1 : 1'b0;

// Horizontal pixel counter
logic v_en; // Vertical counter enable
H_Count #(.COUNT(H_LENGTH -1)) Horz_counter(
    .clk(clk_25MHz), 
    .arst_n(arst_n),
    .en(en),
    .v_en(v_en), 
    .h_count(h_count)
);

// Vertical line counter
V_Count #(.COUNT(V_LENGTH -1)) Vert_counter(
    .clk(clk_25MHz), 
    .v_en(v_en), 
    .arst_n(arst_n),
    .en(en),
    .v_count(v_count)
);

// Generate vertical and horizontal sync pulses
assign vsync = (v_count > V_SYNC_START && v_count <= V_SYNC_STOP) ? 1'b1 : 1'b0;
assign hsync = (h_count > H_SYNC_START && h_count <= H_SYNC_STOP) ? 1'b1 : 1'b0;
   
endmodule