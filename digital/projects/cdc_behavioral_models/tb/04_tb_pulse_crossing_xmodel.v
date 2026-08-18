`timescale 1ns/1ps

module tb_04_pulse_crossing_xmodel;
    reg clk_src;
    reg clk_dst;
    reg rst_n;
    reg src_pulse;
    wire dst_level;
    reg dst_level_d;
    wire dst_pulse_seen;
    integer sent_count;

    two_flop_sync_xmodel #(
        .SETUP_NS         (1.0),
        .HOLD_NS          (1.0),
        .RESOLVE_DELAY_NS (2.0),
        .RESOLVE_VALUE    (1'b1)
    ) u_sync_xmodel (
        .clk_dst  (clk_dst),
        .rst_n    (rst_n),
        .async_in (src_pulse),
        .sync_out (dst_level)
    );

    initial clk_src = 1'b0;
    always #3 clk_src = ~clk_src;   // source-domain fast clock, period = 6 ns

    initial clk_dst = 1'b0;
    always #10 clk_dst = ~clk_dst;  // destination-domain slow clock, period = 20 ns

    always @(posedge clk_dst or negedge rst_n) begin
        if (!rst_n)
            dst_level_d <= 1'b0;
        else
            dst_level_d <= dst_level;
    end

    assign dst_pulse_seen = dst_level & ~dst_level_d;

    task send_src_pulse;
        begin
            @(posedge clk_src);
            src_pulse <= 1'b1;
            sent_count = sent_count + 1;
            @(posedge clk_src);
            src_pulse <= 1'b0;
        end
    endtask

    initial begin
        rst_n = 1'b0;
        src_pulse = 1'b0;
        sent_count = 0;
        #25 rst_n = 1'b1;

        #7  send_src_pulse();  // clk_src 33-39 ns: one-cycle pulse between clk_dst edges, can be missed
        #1  send_src_pulse();  // clk_src 45-51 ns: falling edge is 1 ns after clk_dst posedge at 50 ns
        #13 send_src_pulse();  // clk_src 69-75 ns: rising edge is 1 ns before clk_dst posedge at 70 ns
        #100;

        $display("04 pulse_crossing_xmodel done. src-domain one-cycle pulses sent=%0d", sent_count);
        $finish;
    end
endmodule
