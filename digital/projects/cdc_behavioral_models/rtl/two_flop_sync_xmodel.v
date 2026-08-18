`timescale 1ns/1ps

module two_flop_sync_xmodel #(
    parameter real SETUP_NS = 1.0,
    parameter real HOLD_NS  = 1.0,
    parameter real RESOLVE_DELAY_NS = 2.0,
    parameter      RESOLVE_VALUE = 1'b1
)(
    input  wire clk_dst,
    input  wire rst_n,
    input  wire async_in,
    output wire sync_out
);
    wire sync_1;
    reg  sync_2;

    x_inject_dff #(
        .SETUP_NS         (SETUP_NS),
        .HOLD_NS          (HOLD_NS),
        .RESOLVE_DELAY_NS (RESOLVE_DELAY_NS),
        .RESOLVE_VALUE    (RESOLVE_VALUE)
    ) u_first_stage_ff (
        .clk   (clk_dst),
        .rst_n (rst_n),
        .d     (async_in),
        .q     (sync_1)
    );

    always @(posedge clk_dst or negedge rst_n) begin
        if (!rst_n)
            sync_2 <= 1'b0;
        else
            sync_2 <= sync_1;
    end

    assign sync_out = sync_2;
endmodule
