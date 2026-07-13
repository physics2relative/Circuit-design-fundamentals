`timescale 1ns/1ps

module naive_and_clock_gate (
    input  wire clk,
    input  wire en,
    input  wire test_en,
    output wire gated_clk
);
    wire effective_en;

    assign effective_en = en | test_en;
    assign gated_clk    = clk & effective_en;
endmodule
