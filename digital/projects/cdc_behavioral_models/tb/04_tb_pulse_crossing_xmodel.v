`timescale 1ns/1ps

module tb_04_pulse_crossing_xmodel;
    reg clk_slow;
    reg rst_n;
    reg fast_pulse;
    wire slow_level;
    reg slow_level_d;
    wire slow_pulse_seen;

    two_flop_sync_xmodel #(
        .SETUP_NS (1.0),
        .HOLD_NS  (1.0)
    ) u_sync_xmodel (
        .clk_dst  (clk_slow),
        .rst_n    (rst_n),
        .async_in (fast_pulse),
        .sync_out (slow_level)
    );

    initial clk_slow = 1'b0;
    always #10 clk_slow = ~clk_slow;

    always @(posedge clk_slow or negedge rst_n) begin
        if (!rst_n)
            slow_level_d <= 1'b0;
        else
            slow_level_d <= slow_level;
    end

    assign slow_pulse_seen = slow_level & ~slow_level_d;

    initial begin
        rst_n = 1'b0;
        fast_pulse = 1'b0;
        #25 rst_n = 1'b1;

        #7  fast_pulse = 1'b1;  // 32 ns: short pulse between slow edges, can be missed
        #6  fast_pulse = 1'b0;  // 38 ns
        #11 fast_pulse = 1'b1;  // 49 ns: 1 ns before slow posedge at 50 ns
        #7  fast_pulse = 1'b0;  // 56 ns
        #13 fast_pulse = 1'b1;  // 69 ns: 1 ns before slow posedge at 70 ns
        #2  fast_pulse = 1'b0;  // 71 ns: 1 ns after slow posedge at 70 ns
        #90;

        $display("04 pulse_crossing_xmodel done. Fast pulse can be missed or sampled uncertainly.");
        $finish;
    end
endmodule
