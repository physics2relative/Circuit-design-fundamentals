`timescale 1ns/1ps

module tb_naive_and_glitch;
    reg clk;
    reg rst_n;
    reg en;
    reg test_en;
    wire gated_clk;
    wire [3:0] count;

    naive_and_clock_gate u_gate (
        .clk(clk),
        .en(en),
        .test_en(test_en),
        .gated_clk(gated_clk)
    );

    clock_gating_target_counter u_counter (
        .gated_clk(gated_clk),
        .rst_n(rst_n),
        .count(count)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        rst_n   = 1'b0;
        en      = 1'b0;
        test_en = 1'b0;

        #3  rst_n = 1'b1;

        // clk is high from 15ns to 20ns. Raising en at 17ns creates a
        // mid-cycle rising edge on gated_clk in the naive AND gate.
        #14 en = 1'b1;  // t=17
        #1  en = 1'b0;  // t=18, pulse is cut while clk is still high

        // Normal enable before a clock edge for comparison.
        #4  en = 1'b1;  // t=22, clk low
        #12 en = 1'b0;  // t=34, clk low before next rising edge

        #20;
        $display("02 naive_and_glitch done: count=%0d", count);
        $finish;
    end
endmodule
