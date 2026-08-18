`timescale 1ns/1ps

module tb_test_enable_bypass;
    reg clk;
    reg rst_n;
    reg en;
    reg test_en;
    wire gated_clk;
    wire latched_en;
    wire [3:0] count;

    latch_based_icg u_icg (
        .clk(clk),
        .en(en),
        .test_en(test_en),
        .gated_clk(gated_clk),
        .latched_en(latched_en)
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

        // Functional enable stays low. test_en opens the ICG so clock pulses
        // can pass in test/scan mode.
        #9  test_en = 1'b1; // t=12, clk low, sampled before t=15 edge
        #28 test_en = 1'b0; // t=40, clk low

        #20;
        $display("04 test_enable_bypass done: count=%0d", count);
        $finish;
    end
endmodule
