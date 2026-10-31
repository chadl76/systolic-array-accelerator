`timescale 1ns / 1ps
// tb_array_4x4: feeds the NumPy golden-model files into the 4x4 array
// and checks all 16 answers.
// Make new test data in Docker:  python3 golden_4x4.py   (then rerun this sim)

module tb_array_4x4;

    // 1. bench wires
    reg          clk, rst, clear;
    reg  [31:0]  A_in, B_in;
    wire [511:0] acc_all;

    // 2. memories for the golden-model files
    reg [31:0] a_mem [0:9];     // A_in for each of the 10 ticks
    reg [31:0] b_mem [0:9];     // B_in for each of the 10 ticks
    reg [31:0] c_exp [0:15];    // expected acc #0 .. #15

    integer t, n, errors;

    // 3. socket
    array_4x4 dut (
        .clk(clk),
        .rst(rst),
        .clear(clear),
        .A_in(A_in),
        .B_in(B_in),
        .acc_all(acc_all)
    );

    // 4. function generator: 10 ns period = 100 MHz
    initial clk = 0;
    always #5 clk = ~clk;

    // 5. procedure (runs once)
    initial begin
        // read the files made by golden_4x4.py
        $readmemh("C:/Users/chadl/eda/designs/a_in.mem",       a_mem);
        $readmemh("C:/Users/chadl/eda/designs/b_in.mem",       b_mem);
        $readmemh("C:/Users/chadl/eda/designs/c_expected.mem", c_exp);

        // reset
        rst = 1; clear = 0; A_in = 0; B_in = 0;
        @(posedge clk); #1;
        rst = 0;

        // feed the conveyor belts: one line of each file per tick
        for (t = 0; t < 10; t = t + 1) begin
            A_in = a_mem[t];
            B_in = b_mem[t];
            @(posedge clk); #1;
        end

        // check all 16 answers against NumPy
        errors = 0;
        for (n = 0; n < 16; n = n + 1) begin
            if (acc_all[n*32 +: 32] === c_exp[n])
                $display("PASS  acc #%0d (row %0d, col %0d) = %0d",
                         n, n/4, n%4, acc_all[n*32 +: 32]);
            else begin
                $display("FAIL  acc #%0d (row %0d, col %0d) = %0d, expected %0d",
                         n, n/4, n%4, acc_all[n*32 +: 32], c_exp[n]);
                errors = errors + 1;
            end
        end

        if (errors == 0) $display("=== ALL 16 PASSED: array matches NumPy ===");
        else             $display("=== %0d FAILED ===", errors);

        repeat (3) @(posedge clk);
        $finish;
    end

endmodule
