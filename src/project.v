/*
 * Copyright (c) 2024 sazzach
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

wire [9:0] row;
wire [9:0] col;
wire vsync;
wire hsync;
wire vga_active;
wire [5:0] color; // RRGGBB

// TinyVGA PMOD
assign uo_out = {hsync, color[0], color[2], color[4], vsync, color[1], color[3], color[5]};

// All output pins must be assigned. If not used, assign to 0.
assign uio_out = 0;
assign uio_oe  = 0;

// List all unused inputs to prevent warnings
wire _unused = &{ena, ui_in, uio_in, 1'b0};

vga_timing vga_timing_inst (
    .clk(clk),
    .rst_n(rst_n),
    .row(row),
    .col(col),
    .vsync(vsync),
    .hsync(hsync),
    .vga_active(vga_active)
);

assign color = vga_active ? {row[6], 1'b0, col[6], 1'b0, 2'b0} : 0;
//assign color = vga_active ? 6'b111100 : 0;

endmodule
