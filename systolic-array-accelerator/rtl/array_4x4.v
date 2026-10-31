`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2026 10:05:01 AM
// Design Name: 
// Module Name: array_4x4
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

module array_4x4 (
    input  wire         clk, rst, clear,
    input  wire [31:0]  A_in, B_in,
    output wire [511:0] acc_all
);

    // ---------------------------------------------------------
    // 1. ALL THE ARROWS in the picture, numbered as "slots"
    //    a[r][c] lives in slot r*5 + c   (4 rows x 5 = 20 slots)
    //    b[r][c] lives in slot r*4 + c   (5 rows x 4 = 20 slots)
    // ---------------------------------------------------------
    wire [159:0] a_bus;
    wire [159:0] b_bus;

    genvar i, r, c;

    // ---------------------------------------------------------
    // 2. THE SPLITTERS (teal boxes): byte i of A_in / B_in
    //    goes onto the edge of the grid
    // ---------------------------------------------------------
    generate
        for (i = 0; i < 4; i = i + 1) begin : split
            assign a_bus[(i*5)*8 +: 8] = A_in[i*8 +: 8];   // a[i][0]: left edge, row i
            assign b_bus[(i)*8   +: 8] = B_in[i*8 +: 8];   // b[0][i]: top edge, column i
        end
    endgenerate

    // ---------------------------------------------------------
    // 3. THE 16 PEs (purple boxes)
    //    PE(r,c) reads a[r][c], b[r][c]
    //           writes a[r][c+1] (right), b[r+1][c] (down)
    // ---------------------------------------------------------
    generate
        for (r = 0; r < 4; r = r + 1) begin : row
            for (c = 0; c < 4; c = c + 1) begin : col

                // bit positions of this PE's 5 wires (just labels for the math)
                localparam A_IN  = (r*5 + c)       * 8;   // a[r][c]
                localparam A_OUT = (r*5 + c + 1)   * 8;   // a[r][c+1]
                localparam B_IN  = (r*4 + c)       * 8;   // b[r][c]
                localparam B_OUT = ((r+1)*4 + c)   * 8;   // b[r+1][c]
                localparam ACC   = (r*4 + c)       * 32;  // acc #(r*4 + c)

                pe u_pe (
                    .clk(clk), .rst(rst), .clear(clear),
                    .a_in (a_bus[A_IN  +: 8]),
                    .b_in (b_bus[B_IN  +: 8]),
                    .a_out(a_bus[A_OUT +: 8]),
                    .b_out(b_bus[B_OUT +: 8]),
                    .acc  (acc_all[ACC +: 32])
                );

            end
        end
    endgenerate

endmodule