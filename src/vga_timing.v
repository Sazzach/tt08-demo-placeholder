/*
 * Copyright (c) 2024 sazzach
 * SPDX-License-Identifier: Apache-2.0
 */

module vga_timing (
    input wire clk,
    input wire rst_n,

    output wire [9:0] row,
    output wire [9:0] col,
    output wire vsync,
    output wire hsync,
    output wire vga_active
);

localparam RESOLUTION_H = 640;
localparam RESOLUTION_V = 480;

// VGA Timing
// From: http://www.tinyvga.com/vga-timing/640x480@60Hz
localparam FRONT_PORCH_H = 16;
localparam BACK_PORCH_H = 48;
localparam SYNC_PULSE_H = 96;
localparam SIZE_H = FRONT_PORCH_H + RESOLUTION_H + BACK_PORCH_H + SYNC_PULSE_H;
localparam HSYNC_START = FRONT_PORCH_H + RESOLUTION_H;
localparam HSYNC_END = HSYNC_START + SYNC_PULSE_H;

localparam FRONT_PORCH_V = 10;
localparam BACK_PORCH_V = 33;
localparam SYNC_PULSE_V = 2;
localparam SIZE_V = FRONT_PORCH_V + RESOLUTION_V + BACK_PORCH_V + SYNC_PULSE_V;
localparam VSYNC_START = FRONT_PORCH_V + RESOLUTION_V;
localparam VSYNC_END = VSYNC_START + SYNC_PULSE_V;

reg [9:0] row_count;
reg [9:0] col_count;

assign row = row_count;
assign col = col_count;
assign vsync = VSYNC_START <= row_count && row_count < VSYNC_END;
assign hsync = HSYNC_START <= col_count && col_count < HSYNC_END;
assign vga_active = col_count < RESOLUTION_H && row_count < RESOLUTION_V;

always @(posedge clk) begin
    if(~rst_n) begin
        row_count <= 0;
        col_count <= 0;
    end
    else begin
        col_count <= col_count+1;

        if(col_count+1 >= SIZE_H) begin
            col_count <= 0;
            row_count <= row_count+1;
        end

        if(row_count+1 >= SIZE_V) begin
            row_count <= 0;
        end
    end
end

endmodule
