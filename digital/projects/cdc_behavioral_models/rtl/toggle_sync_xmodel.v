`timescale 1ns/1ps

module toggle_sync_xmodel #(
    parameter real SETUP_NS = 1.0,
    parameter real HOLD_NS  = 1.0,
    parameter real RESOLVE_DELAY_NS = 2.0,
    parameter      RESOLVE_VALUE = 1'b1
)(
    input  wire clk_src,
    input  wire rst_src_n,
    input  wire src_pulse,

    input  wire clk_dst,
    input  wire rst_dst_n,
    output wire dst_pulse
);
    reg  src_toggle;
    wire src_toggle_hold;
    wire src_toggle_flip;
    wire src_toggle_next;
    wire dst_sync_1;
    reg  dst_sync_2;
    reg  dst_sync_3;

    // Explicit 2:1 mux form for the source-domain toggle register.
    // Functionally this is equivalent to: src_toggle_next = src_toggle ^ src_pulse.
    // Keeping the mux expression here makes the toggle hardware easier to inspect
    // in RTL schematic viewers.
    assign src_toggle_hold = src_toggle;
    assign src_toggle_flip = ~src_toggle;
    assign src_toggle_next = src_pulse ? src_toggle_flip : src_toggle_hold;

    always @(posedge clk_src or negedge rst_src_n) begin
        if (!rst_src_n)
            src_toggle <= 1'b0;
        else
            src_toggle <= src_toggle_next;
    end

    x_inject_dff #(
        .SETUP_NS         (SETUP_NS),
        .HOLD_NS          (HOLD_NS),
        .RESOLVE_DELAY_NS (RESOLVE_DELAY_NS),
        .RESOLVE_VALUE    (RESOLVE_VALUE)
    ) u_dst_first_stage_ff (
        .clk   (clk_dst),
        .rst_n (rst_dst_n),
        .d     (src_toggle),
        .q     (dst_sync_1)
    );

    always @(posedge clk_dst or negedge rst_dst_n) begin
        if (!rst_dst_n) begin
            dst_sync_2 <= 1'b0;
            dst_sync_3 <= 1'b0;
        end else begin
            dst_sync_2 <= dst_sync_1;
            dst_sync_3 <= dst_sync_2;
        end
    end

    assign dst_pulse = dst_sync_2 ^ dst_sync_3;
endmodule
