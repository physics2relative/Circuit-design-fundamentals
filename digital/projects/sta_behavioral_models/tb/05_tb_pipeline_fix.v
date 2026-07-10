`timescale 1ns/1ps

module tb_05_pipeline_fix;
    reg clk;
    reg rst_n;
    reg in_d;
    wire launch_q;
    wire long_comb_out;
    wire long_capture_q;
    wire pipe_mid_d;
    wire pipe_mid_q;
    wire pipe_out_d;
    wire pipe_capture_q;

    sta_pipeline_path #(
        .LONG_DELAY_NS   (9.5),
        .STAGE1_DELAY_NS (4.5),
        .STAGE2_DELAY_NS (4.5),
        .SETUP_NS        (1.0),
        .HOLD_NS         (1.0)
    ) u_pipeline_path (
        .clk            (clk),
        .rst_n          (rst_n),
        .in_d           (in_d),
        .launch_q       (launch_q),
        .long_comb_out  (long_comb_out),
        .long_capture_q (long_capture_q),
        .pipe_mid_d     (pipe_mid_d),
        .pipe_mid_q     (pipe_mid_q),
        .pipe_out_d     (pipe_out_d),
        .pipe_capture_q (pipe_capture_q)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        rst_n = 1'b0;
        in_d = 1'b0;
        #12 rst_n = 1'b1;
        @(negedge clk); in_d = 1'b1;
        repeat (7) @(posedge clk);
        $display("05 pipeline_fix done. Long single-stage path violates setup; split pipeline stages pass.");
        $finish;
    end
endmodule
