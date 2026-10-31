`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2026 08:41:07 AM
// Design Name: 
// Module Name: tb_array2x2
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


module tb_array2x2;
    reg signed [7:0]       a_0, a_1, b_0, b_1;
    reg                    clk, rst, clear;
    //wire signed [7:0]      a_out, b_out;
    wire signed [31:0]     c_00, c_01, c_10, c_11;
        
       // Set up the board the testbench hooks up to the circuit pins 
       array_2x2 dut(
        .a_0(a_0),
        .a_1(a_1),
        .b_0(b_0),
        .b_1(b_1),
        .clk(clk),
        .rst(rst),
        .clear(clear),
        .c_00(c_00),
        .c_01(c_01),
        .c_10(c_10),
        .c_11(c_11)
       );

       // The function generator
       initial   clk = 0;
       always #5 clk = ~clk;
       
       initial begin
        rst = 1;
        a_0 = 0;
        a_1 = 0;
        b_0 = 0;
        b_1 = 0;
        clear = 0;
        @(posedge clk); #1; 
            rst = 0;
        @(posedge clk); #1;
       // Step 1
            a_0 = 1;
            a_1 = 0;
            b_0 = 5;
            b_1 = 0;
        @(posedge clk); #1;
            if (c_00 == 5)
                $display("Passed: c_00 = %0d", c_00);
            else
                $display("Fail");
         // Step 2    
    
            a_0 = 2;
            a_1 = 3;
            b_0 = 7;
            b_1 = 6;
        @(posedge clk); #1;
            if (c_00 == 19)
                $display("Passed: c_00 = %0d", c_00);
            else
                $display("Fail c_00 = %0d", c_00);
                
         // Step 3  
         
            a_0 = 0;
            a_1 = 4;
            b_0 = 0;
            b_1 = 8;
        @(posedge clk); #1;
            if (c_01 == 22 && c_10 ==43)
                $display("Passed: c_01 = %0d and c_10 = %0d", c_01, c_10);
            else
                $display("Fail c_00 = %0d", c_01);
                
          // Step 4    
        
            a_0 = 0;
            a_1 = 0;
            b_0 = 0;
            b_1 = 0;
        @(posedge clk); #1;
            if (c_11 == 50)
                $display("Passed: c_11 = %0d", c_11);
            else
                $display("Fail c_11 = %0d", c_11);       
         
         repeat (3) @(posedge clk);
        $finish;      
       end
endmodule
