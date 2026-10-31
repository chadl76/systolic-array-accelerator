`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2026 06:05:06 PM
// Design Name: 
// Module Name: tb_pe
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


module tb_pe;
    
    reg signed [7:0]       a_in, b_in;
    reg                    clk, rst, clear;
    wire signed [7:0]      a_out, b_out;
    wire signed [31:0]     acc;
        
       // Set up the board the testbench hooks up to the circuit pins 
       pe dut(
        .a_in(a_in),
        .b_in(b_in),
        .clk(clk),
        .rst(rst),
        .clear(clear),
        .a_out(a_out),
        .b_out(b_out),
        .acc(acc)
          
       );
       
       // The function generator
       initial   clk = 0;
       always #5 clk = ~clk;
       
       initial begin
       rst = 1;
       a_in = 0;
       b_in = 0;
       clear = 0;
       @(posedge clk); #1; 
       rst = 0;
       @(posedge clk); #1;
       // Step one
       a_in = 1;
       b_in = 5;
       @(posedge clk); #1;
       if (acc == 5)
            $display("Passed: acc = %0d", acc);
            else
                $display("Fail");
        a_in = 2;
        b_in = 6;
        @(posedge clk); #1;
        if (acc == 17)
            $display("Passed: acc = %0d", acc);
            else
                $display("Fail");
                
       a_in = 3;
       b_in = 7;
       @(posedge clk); #1;
       
       if (acc == 38)
            $display("Passed: acc = %0d", acc);
            else
                $display("Fail");
                
                
       a_in = 4;
       b_in = 8;
       @(posedge clk); #1;
       
       if (acc == 70)
            $display("Passed: acc = %0d", acc);
            else
                $display("Fail");
                
       clear = 1;
       a_in = 9;
        @(posedge clk); #1;
       
       if (acc ==0 && a_out == 9)
            $display("Reset Passed: acc = %0d, a_out = %0d", acc, a_out);
            else
                $display("Failed to reset"); 
             
       
         
       
       
       $finish;
       
       
       end
       
       
       
       
       
endmodule
