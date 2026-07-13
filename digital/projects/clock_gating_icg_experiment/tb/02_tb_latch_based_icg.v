`timescale 1ns/1ps

module tb_latch_based_icg;
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

        // Same stimulus as the naive case. en rises while clk is high, but
        // latched_en cannot update until clk goes low. Therefore gated_clk has
        // no mid-cycle edge at 17ns; the request is applied on the next normal
        // clock pulse after the low phase samples en.
        #14 en = 1'b1;  // t=17, clk high
        #15 en = 1'b0;  // t=32, clk low

        #25;
        $display("02 latch_based_icg done: count=%0d", count);
        $finish;
    end
endmodule
