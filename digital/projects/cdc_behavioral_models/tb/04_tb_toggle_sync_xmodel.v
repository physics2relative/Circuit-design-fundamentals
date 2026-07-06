`timescale 1ns/1ps

module tb_04_toggle_sync_xmodel;
    reg clk_fast;
    reg clk_slow;
    reg rst_fast_n;
    reg rst_slow_n;
    reg fast_pulse;
    wire slow_pulse;
    integer sent_count;
    integer seen_count;

    toggle_sync_xmodel #(
        .SETUP_NS (1.0),
        .HOLD_NS  (1.0)
    ) u_toggle_sync_xmodel (
        .clk_src   (clk_fast),
        .rst_src_n (rst_fast_n),
        .src_pulse (fast_pulse),
        .clk_dst   (clk_slow),
        .rst_dst_n (rst_slow_n),
        .dst_pulse (slow_pulse)
    );

    initial clk_fast = 1'b0;
    always #3 clk_fast = ~clk_fast;

    initial clk_slow = 1'b0;
    always #10 clk_slow = ~clk_slow;

    always @(posedge clk_slow) begin
        if (slow_pulse === 1'b1)
            seen_count <= seen_count + 1;
    end

    initial begin
        rst_fast_n = 1'b0;
        rst_slow_n = 1'b0;
        fast_pulse = 1'b0;
        sent_count = 0;
        seen_count = 0;
        #25;
        rst_fast_n = 1'b1;
        rst_slow_n = 1'b1;

        #24 fast_pulse = 1'b1; sent_count = sent_count + 1; // src_toggle changes at fast posedge 51 ns, 1 ns after slow edge
        #4  fast_pulse = 1'b0;
        #14 fast_pulse = 1'b1; sent_count = sent_count + 1; // src_toggle changes at fast posedge 69 ns, 1 ns before slow edge
        #4  fast_pulse = 1'b0;
        #80 fast_pulse = 1'b1; sent_count = sent_count + 1; // src_toggle changes at fast posedge 153 ns, away from slow edge
        #4  fast_pulse = 1'b0;
        #180;

        $display("04 toggle_sync_xmodel done. sent=%0d seen=%0d", sent_count, seen_count);
        $finish;
    end
endmodule
