`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2026 05:39:22 PM
// Design Name: 
// Module Name: pe
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


module pe(
        
        input  wire signed [7:0]     a_in, b_in,
        input  wire                  clk, rst, clear,
        output reg signed [7:0]      a_out, b_out,
        output reg signed [31:0]     acc    
    ); 
      // At the clk it checks if rst or clear if not acc = acc + AxB
    always @(posedge clk) begin 
        if (rst) begin
            acc   <= 0;
            a_out <= 0;
            b_out <= 0;
        end
        else if (clear) begin
            acc   <= 0;
            a_out <= a_in;
            b_out <= b_in;
         end   
         else begin 
            acc   <= a_in * b_in + acc;
            a_out <= a_in;
            b_out <= b_in;
         end
    end         
endmodule
