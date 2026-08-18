`timescale 1ns/1ps

module bad_bus_sync #(
    parameter WIDTH = 4
)(
    input  wire             clk_dst,
    input  wire             rst_n,
    input  wire [WIDTH-1:0] async_bus,
    output wire [WIDTH-1:0] sync_bus
);
    reg [WIDTH-1:0] sync_1;
    reg [WIDTH-1:0] sync_2;

    always @(posedge clk_dst or negedge rst_n) begin
        if (!rst_n) begin
            sync_1 <= {WIDTH{1'b0}};
            sync_2 <= {WIDTH{1'b0}};
        end else begin
            sync_1 <= async_bus;
            sync_2 <= sync_1;
        end
    end

    assign sync_bus = sync_2;
endmodule
