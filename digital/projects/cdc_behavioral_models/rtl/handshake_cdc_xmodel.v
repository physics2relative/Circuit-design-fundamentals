`timescale 1ns/1ps

module handshake_cdc_xmodel #(
    parameter real SETUP_NS = 1.0,
    parameter real HOLD_NS  = 1.0,
    parameter real RESOLVE_DELAY_NS = 2.0,
    parameter      RESOLVE_VALUE = 1'b1
)(
    input  wire clk_src,
    input  wire rst_src_n,
    input  wire src_event,
    output wire src_busy,
    output reg  src_accept_pulse,

    input  wire clk_dst,
    input  wire rst_dst_n,
    output reg  dst_pulse
);
    reg src_req;

    wire dst_req_sync_1;
    reg  dst_req_sync_2;
    reg  dst_req_sync_3;
    reg  dst_ack;

    wire src_ack_sync_1;
    reg  src_ack_sync_2;

    assign src_busy = src_req;

    always @(posedge clk_src or negedge rst_src_n) begin
        if (!rst_src_n) begin
            src_req <= 1'b0;
            src_accept_pulse <= 1'b0;
        end else begin
            src_accept_pulse <= 1'b0;

            if (src_ack_sync_2)
                src_req <= 1'b0;
            else if (src_event && !src_req) begin
                src_req <= 1'b1;
                src_accept_pulse <= 1'b1;
            end
        end
    end

    x_inject_dff #(
        .SETUP_NS         (SETUP_NS),
        .HOLD_NS          (HOLD_NS),
        .RESOLVE_DELAY_NS (RESOLVE_DELAY_NS),
        .RESOLVE_VALUE    (RESOLVE_VALUE)
    ) u_req_first_stage_ff (
        .clk   (clk_dst),
        .rst_n (rst_dst_n),
        .d     (src_req),
        .q     (dst_req_sync_1)
    );

    always @(posedge clk_dst or negedge rst_dst_n) begin
        if (!rst_dst_n) begin
            dst_req_sync_2 <= 1'b0;
            dst_req_sync_3 <= 1'b0;
            dst_ack <= 1'b0;
            dst_pulse <= 1'b0;
        end else begin
            dst_req_sync_2 <= dst_req_sync_1;
            dst_req_sync_3 <= dst_req_sync_2;
            dst_pulse <= dst_req_sync_2 & ~dst_req_sync_3;
            dst_ack <= dst_req_sync_2;
        end
    end

    x_inject_dff #(
        .SETUP_NS         (SETUP_NS),
        .HOLD_NS          (HOLD_NS),
        .RESOLVE_DELAY_NS (RESOLVE_DELAY_NS),
        .RESOLVE_VALUE    (RESOLVE_VALUE)
    ) u_ack_first_stage_ff (
        .clk   (clk_src),
        .rst_n (rst_src_n),
        .d     (dst_ack),
        .q     (src_ack_sync_1)
    );

    always @(posedge clk_src or negedge rst_src_n) begin
        if (!rst_src_n)
            src_ack_sync_2 <= 1'b0;
        else
            src_ack_sync_2 <= src_ack_sync_1;
    end
endmodule
