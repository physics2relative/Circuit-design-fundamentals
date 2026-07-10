`timescale 1ns/1ps

module sta_pipeline_path #(
    parameter real LONG_DELAY_NS = 9.5,
    parameter real STAGE1_DELAY_NS = 4.5,
    parameter real STAGE2_DELAY_NS = 4.5,
    parameter real SETUP_NS = 1.0,
    parameter real HOLD_NS  = 1.0
)(
    input  wire clk,
    input  wire rst_n,
    input  wire in_d,
    output reg  launch_q,
    output wire long_comb_out,
    output wire long_capture_q,
    output wire pipe_mid_d,
    output wire pipe_mid_q,
    output wire pipe_out_d,
    output wire pipe_capture_q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            launch_q <= 1'b0;
        else
            launch_q <= in_d;
    end

    assign #(LONG_DELAY_NS) long_comb_out = launch_q;

    sta_check_dff #(
        .SETUP_NS (SETUP_NS),
        .HOLD_NS  (HOLD_NS),
        .RESOLVE_DELAY_NS (2.0),
        .RESET_VALUE (1'b0),
        .RESOLVE_VALUE (1'bx)
    ) u_long_capture_ff (
        .clk   (clk),
        .rst_n (rst_n),
        .d     (long_comb_out),
        .q     (long_capture_q)
    );

    assign #(STAGE1_DELAY_NS) pipe_mid_d = launch_q;

    sta_check_dff #(
        .SETUP_NS (SETUP_NS),
        .HOLD_NS  (HOLD_NS),
        .RESOLVE_DELAY_NS (2.0),
        .RESET_VALUE (1'b0),
        .RESOLVE_VALUE (1'bx)
    ) u_pipe_mid_ff (
        .clk   (clk),
        .rst_n (rst_n),
        .d     (pipe_mid_d),
        .q     (pipe_mid_q)
    );

    assign #(STAGE2_DELAY_NS) pipe_out_d = pipe_mid_q;

    sta_check_dff #(
        .SETUP_NS (SETUP_NS),
        .HOLD_NS  (HOLD_NS),
        .RESOLVE_DELAY_NS (2.0),
        .RESET_VALUE (1'b0),
        .RESOLVE_VALUE (1'bx)
    ) u_pipe_capture_ff (
        .clk   (clk),
        .rst_n (rst_n),
        .d     (pipe_out_d),
        .q     (pipe_capture_q)
    );
endmodule
