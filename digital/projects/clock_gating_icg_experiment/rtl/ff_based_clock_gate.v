`timescale 1ns/1ps

module ff_based_clock_gate (
    input  wire clk,
    input  wire rst_n,
    input  wire en,
    input  wire test_en,
    output wire gated_clk,
    output wire sampled_en
);
    reg en_ff;
    wire effective_en;

    assign effective_en = en | test_en;

    // This is intentionally not the usual ICG structure. It samples enable at
    // the same posedge used by the downstream flops, then ANDs that registered
    // enable with clk. The result is glitch-free in this simple model, but the
    // gated clock opens only after the clock edge that sampled en has already
    // passed, so it can add an extra-cycle latency and can also create a short
    // gated-clock high pulse depending on clock-to-Q delay.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            en_ff <= 1'b0;
        else
            en_ff <= effective_en;
    end

    assign sampled_en = en_ff;
    assign gated_clk  = clk & en_ff;
endmodule
