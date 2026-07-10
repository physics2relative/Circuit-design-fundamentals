`timescale 1ns/1ps

module tb_04_skew_effect;
    reg clk_launch;
    reg clk_capture_late;
    reg clk_capture_early;
    reg rst_n;
    reg launch_d;
    wire launch_q_late;
    wire comb_out_late;
    wire capture_q_late;
    wire launch_q_early;
    wire comb_out_early;
    wire capture_q_early;

    // Capture clock is 1 ns later than launch clock: setup-friendly, hold-stress.
    sta_ff_to_ff_path #(
        .COMB_DELAY_NS (0.6),
        .SETUP_NS      (1.0),
        .HOLD_NS       (1.0)
    ) u_late_capture_path (
        .clk_launch  (clk_launch),
        .clk_capture (clk_capture_late),
        .rst_n       (rst_n),
        .launch_d    (launch_d),
        .launch_q    (launch_q_late),
        .comb_out    (comb_out_late),
        .capture_q   (capture_q_late)
    );

    // Capture clock is 1 ns earlier than launch clock: setup-stress, hold-friendly.
    sta_ff_to_ff_path #(
        .COMB_DELAY_NS (8.6),
        .SETUP_NS      (1.0),
        .HOLD_NS       (1.0)
    ) u_early_capture_path (
        .clk_launch  (clk_launch),
        .clk_capture (clk_capture_early),
        .rst_n       (rst_n),
        .launch_d    (launch_d),
        .launch_q    (launch_q_early),
        .comb_out    (comb_out_early),
        .capture_q   (capture_q_early)
    );

    initial clk_launch = 1'b0;
    always #5 clk_launch = ~clk_launch;

    initial begin
        clk_capture_late = 1'b0;
        #1;
        forever #5 clk_capture_late = ~clk_capture_late;
    end

    initial begin
        clk_capture_early = 1'b0;
        #4;
        forever #5 clk_capture_early = ~clk_capture_early;
    end

    initial begin
        rst_n = 1'b0;
        launch_d = 1'b0;
        #14 rst_n = 1'b1;
        @(negedge clk_launch); launch_d = 1'b1;
        repeat (5) @(posedge clk_launch);
        $display("04 skew_effect done. Late capture stresses hold; early capture stresses setup.");
        $finish;
    end
endmodule
