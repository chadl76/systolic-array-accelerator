`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2026 08:32:28 PM
// Design Name: 
// Module Name: array_2x2
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


module array_2x2 (
    input  wire               clk, rst, clear,
    input  wire signed [7:0]  a_0, a_1, b_0, b_1,
    output wire signed [31:0] c_00, c_01, c_10, c_11
);

    // internal wires between PEs (the short wires in Logisim)
    wire signed [7:0] a00_to_01;   // PE00 -> PE01 (pass right)
    wire signed [7:0] a10_to_11;   // PE10 -> PE11 (pass right)
    wire signed [7:0] b00_to_10;   // PE00 -> PE10 (pass down)
    wire signed [7:0] b01_to_11;   // PE01 -> PE11 (pass down)

    // top-left: fed by both array inputs
    pe u_pe00 (
        .clk(clk), .rst(rst), .clear(clear),
        .a_in(a_0),        .b_in(b_0),
        .a_out(a00_to_01), .b_out(b00_to_10),
        .acc(c_00)
    );

    // top-right: a from PE00, b from array input
    pe u_pe01 (
        .clk(clk), .rst(rst), .clear(clear),
        .a_in(a00_to_01),  .b_in(b_1),
        .a_out(),          .b_out(b01_to_11),   // a falls off the right edge
        .acc(c_01)
    );

    // bottom-left: a from array input, b from PE00
    pe u_pe10 (
        .clk(clk), .rst(rst), .clear(clear),
        .a_in(a_1),        .b_in(b00_to_10),
        .a_out(a10_to_11), .b_out(),            // b falls off the bottom edge
        .acc(c_10)
    );

    // bottom-right: a from PE10, b from PE01
    pe u_pe11 (
        .clk(clk), .rst(rst), .clear(clear),
        .a_in(a10_to_11),  .b_in(b01_to_11),
        .a_out(),          .b_out(),            // both fall off
        .acc(c_11)
    );

endmodule