`timescale 1ns/1ps

module reset_sync_rdc_xmodel #(
    parameter real RECOVERY_NS = 1.0,
    parameter real REMOVAL_NS  = 1.0,
    parameter real RESOLVE_DELAY_NS = 2.0,
    parameter      RESOLVE_VALUE = 1'b1
)(
    input  wire clk_src,
    input  wire clk_dst,
    input  wire global_rst_n,
    output wire rst_src_n,
    output wire rst_dst_n,
    output wire bad_src_state,
    output wire bad_dst_state,
    output reg  good_src_state,
    output reg  good_dst_state
);
    reset_synchronizer u_src_reset_sync (
        .clk         (clk_src),
        .async_rst_n (global_rst_n),
        .sync_rst_n  (rst_src_n)
    );

    reset_synchronizer u_dst_reset_sync (
        .clk         (clk_dst),
        .async_rst_n (global_rst_n),
        .sync_rst_n  (rst_dst_n)
    );

    // Bad examples: global reset deassertion directly releases FFs in each domain.
    x_reset_dff #(
        .RECOVERY_NS      (RECOVERY_NS),
        .REMOVAL_NS       (REMOVAL_NS),
        .RESOLVE_DELAY_NS (RESOLVE_DELAY_NS),
        .RESOLVE_VALUE    (RESOLVE_VALUE)
    ) u_bad_src_ff (
        .clk   (clk_src),
        .rst_n (global_rst_n),
        .d     (1'b1),
        .q     (bad_src_state)
    );

    x_reset_dff #(
        .RECOVERY_NS      (RECOVERY_NS),
        .REMOVAL_NS       (REMOVAL_NS),
        .RESOLVE_DELAY_NS (RESOLVE_DELAY_NS),
        .RESOLVE_VALUE    (RESOLVE_VALUE)
    ) u_bad_dst_ff (
        .clk   (clk_dst),
        .rst_n (global_rst_n),
        .d     (1'b1),
        .q     (bad_dst_state)
    );

    // Good examples: reset assertion is asynchronous, but release is synchronized
    // per clock domain before the local state FFs are released.
    always @(posedge clk_src or negedge rst_src_n) begin
        if (!rst_src_n)
            good_src_state <= 1'b0;
        else
            good_src_state <= 1'b1;
    end

    always @(posedge clk_dst or negedge rst_dst_n) begin
        if (!rst_dst_n)
            good_dst_state <= 1'b0;
        else
            good_dst_state <= 1'b1;
    end
endmodule
