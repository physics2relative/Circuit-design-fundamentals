`timescale 1ns/1ps

module sta_ff_to_ff_path #(
    parameter real COMB_DELAY_NS = 4.0,
    parameter real SETUP_NS = 1.0,
    parameter real HOLD_NS  = 1.0
)(
    input  wire clk_launch,
    input  wire clk_capture,
    input  wire rst_n,
    input  wire launch_d,
    output reg  launch_q,
    output wire comb_out,
    output wire capture_q
);
    always @(posedge clk_launch or negedge rst_n) begin
        if (!rst_n)
            launch_q <= 1'b0;
        else
            launch_q <= launch_d;
    end

    assign #(COMB_DELAY_NS) comb_out = launch_q;

    sta_check_dff #(
        .SETUP_NS (SETUP_NS),
        .HOLD_NS  (HOLD_NS),
        .RESOLVE_DELAY_NS (2.0),
        .RESET_VALUE (1'b0),
        .RESOLVE_VALUE (1'bx)
    ) u_capture_ff (
        .clk   (clk_capture),
        .rst_n (rst_n),
        .d     (comb_out),
        .q     (capture_q)
    );
endmodule
