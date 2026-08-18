`timescale 1ns/1ps

module latch_based_icg (
    input  wire clk,
    input  wire en,
    input  wire test_en,
    output wire gated_clk,
    output wire latched_en
);
    reg en_latch;
    wire effective_en;

    assign effective_en = en | test_en;

    // Active-high clock gating for positive-edge triggered flops.
    // The enable latch is transparent only while clk is low. During clk high,
    // en_latch remains stable so gated_clk cannot glitch due to en changes.
    always @(*) begin
        if (!clk)
            en_latch = effective_en;
    end

    assign latched_en = en_latch;
    assign gated_clk  = clk & en_latch;
endmodule
