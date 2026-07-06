`timescale 1ns/1ps

module no_sync_capture_xmodel #(
    parameter real SETUP_NS = 1.0,
    parameter real HOLD_NS  = 1.0
)(
    input  wire clk_dst,
    input  wire rst_n,
    input  wire async_in,
    output wire captured_out
);
    x_inject_dff #(
        .SETUP_NS (SETUP_NS),
        .HOLD_NS  (HOLD_NS)
    ) u_capture_ff (
        .clk   (clk_dst),
        .rst_n (rst_n),
        .d     (async_in),
        .q     (captured_out)
    );
endmodule
