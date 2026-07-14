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

        // Common enable scenario used by TB 01~03.
        // clk is high from 15ns to 20ns. en rises at 17ns, which would be
        // dangerous for a raw AND gate. The latch-based ICG does not update
        // latched_en until clk goes low at 20ns, then passes normal clock
        // edges at 25ns, 35ns, 45ns, and 55ns while en remains high.
        #14 en = 1'b1;  // t=17, clk high
        #40 en = 1'b0;  // t=57, clk high, ICG closes after next low phase

        #23;
        $display("01 latch_based_icg done: count=%0d", count);
        $finish;
    end
endmodule
