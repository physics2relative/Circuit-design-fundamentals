`timescale 1ns/1ps

module bad_bus_sync_xmodel #(
    parameter WIDTH = 4,
    parameter real SETUP_NS = 1.0,
    parameter real HOLD_NS  = 1.0,
    parameter real RESOLVE_DELAY_NS = 2.0,
    parameter      RESOLVE_VALUE = 1'b1
)(
    input  wire             clk_dst,
    input  wire             rst_n,
    input  wire [WIDTH-1:0] async_bus,
    output wire [WIDTH-1:0] sync_bus
);
    wire [WIDTH-1:0] sync_1;
    reg  [WIDTH-1:0] sync_2;

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : g_bit_sync
            x_inject_dff #(
                .SETUP_NS         (SETUP_NS),
                .HOLD_NS          (HOLD_NS),
                .RESOLVE_DELAY_NS (RESOLVE_DELAY_NS),
                .RESOLVE_VALUE    (RESOLVE_VALUE)
            ) u_first_stage_ff (
                .clk   (clk_dst),
                .rst_n (rst_n),
                .d     (async_bus[i]),
                .q     (sync_1[i])
            );
        end
    endgenerate

    always @(posedge clk_dst or negedge rst_n) begin
        if (!rst_n)
            sync_2 <= {WIDTH{1'b0}};
        else
            sync_2 <= sync_1;
    end

    assign sync_bus = sync_2;
endmodule
