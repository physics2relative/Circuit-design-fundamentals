`timescale 1ns/1ps

module tb_ff_based_latency;
    reg clk;
    reg rst_n;
    reg en;
    reg test_en;

    wire gated_clk_ff;
    wire sampled_en_ff;
    wire [3:0] count_ff;

    wire gated_clk_latch;
    wire latched_en;
    wire [3:0] count_latch;

    ff_based_clock_gate u_ff_gate (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .test_en(test_en),
        .gated_clk(gated_clk_ff),
        .sampled_en(sampled_en_ff)
    );

    latch_based_icg u_latch_gate (
        .clk(clk),
        .en(en),
        .test_en(test_en),
        .gated_clk(gated_clk_latch),
        .latched_en(latched_en)
    );

    clock_gating_target_counter u_counter_ff (
        .gated_clk(gated_clk_ff),
        .rst_n(rst_n),
        .count(count_ff)
    );

    clock_gating_target_counter u_counter_latch (
        .gated_clk(gated_clk_latch),
        .rst_n(rst_n),
        .count(count_latch)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        rst_n   = 1'b0;
        en      = 1'b0;
        test_en = 1'b0;

        #3 rst_n = 1'b1;

        // en becomes active during clk low before the t=15 rising edge.
        // Latch-based ICG samples en in that low phase and passes the t=15
        // clock edge. FF-based gating samples en at t=15, after the edge has
        // already arrived, so its useful gated clock starts later.
        #9  en = 1'b1;  // t=12, clk low
        #23 en = 1'b0;  // t=35, right after a rising edge

        #35;
        $display("03 ff_based_latency done: count_ff=%0d count_latch=%0d", count_ff, count_latch);
        $finish;
    end
endmodule
