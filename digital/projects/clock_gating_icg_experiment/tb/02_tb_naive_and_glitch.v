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

        // Same enable scenario as TB 01 and TB 03.
        // Because this gate uses raw en directly, en rising at 17ns while clk
        // is already high creates a mid-cycle rising edge on gated_clk. en
        // falling at 57ns while clk is high also cuts the high pulse short.
        #14 en = 1'b1;  // t=17, clk high -> mid-cycle gated_clk edge
        #40 en = 1'b0;  // t=57, clk high -> shortened high pulse

        #23;
        $display("02 naive_and_glitch done: count=%0d", count);
        $finish;
    end
endmodule
