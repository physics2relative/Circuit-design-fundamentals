`timescale 1ns/1ps

module tb_pulse_crossing;
    reg clk_fast;
    reg clk_slow;
    reg rst_n;
    reg fast_pulse;
    wire slow_level;
    reg slow_level_d;
    wire slow_pulse_seen;

    two_flop_sync u_sync (
        .clk_dst  (clk_slow),
        .rst_n    (rst_n),
        .async_in (fast_pulse),
        .sync_out (slow_level)
    );

    initial clk_fast = 1'b0;
    always #3 clk_fast = ~clk_fast;

    initial clk_slow = 1'b0;
    always #10 clk_slow = ~clk_slow;

    always @(posedge clk_slow or negedge rst_n) begin
        if (!rst_n)
            slow_level_d <= 1'b0;
        else
            slow_level_d <= slow_level;
    end

    assign slow_pulse_seen = slow_level & ~slow_level_d;

    task send_fast_pulse;
        begin
            @(posedge clk_fast);
            fast_pulse <= 1'b1;
            @(posedge clk_fast);
            fast_pulse <= 1'b0;
        end
    endtask

    initial begin
        $dumpfile("sim/pulse_crossing.vcd");
        $dumpvars(0, tb_pulse_crossing);

        rst_n = 1'b0;
        fast_pulse = 1'b0;
        #25 rst_n = 1'b1;

        #7  send_fast_pulse();
        #19 send_fast_pulse();
        #23 send_fast_pulse();
        #41 send_fast_pulse();
        #80;

        $display("TB pulse_crossing done. Some fast pulses may be missed by slow domain.");
        $finish;
    end
endmodule
