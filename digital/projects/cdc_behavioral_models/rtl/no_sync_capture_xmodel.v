`timescale 1ns/1ps

module no_sync_capture_xmodel #(
    parameter real SETUP_NS = 1.0,
    parameter real HOLD_NS  = 1.0,
    parameter real RESOLVE_DELAY_NS = 2.0,
    parameter      RESOLVE_VALUE = 1'b1
)(
    input  wire clk_dst,
    input  wire rst_n,
    input  wire async_in,
    output wire captured_out
);
    x_inject_dff #(
        .SETUP_NS         (SETUP_NS),
        .HOLD_NS          (HOLD_NS),
        .RESOLVE_DELAY_NS (RESOLVE_DELAY_NS),
        .RESOLVE_VALUE    (RESOLVE_VALUE)
    ) u_capture_ff (
        .clk   (clk_dst),
        .rst_n (rst_n),
        .d     (async_in),
        .q     (captured_out)
    );
endmodule
