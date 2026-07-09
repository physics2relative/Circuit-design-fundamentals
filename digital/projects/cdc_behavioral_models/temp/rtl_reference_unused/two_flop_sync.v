`timescale 1ns/1ps

module two_flop_sync (
    input  wire clk_dst,
    input  wire rst_n,
    input  wire async_in,
    output wire sync_out
);
    reg sync_1;
    reg sync_2;

    always @(posedge clk_dst or negedge rst_n) begin
        if (!rst_n) begin
            sync_1 <= 1'b0;
            sync_2 <= 1'b0;
        end else begin
            sync_1 <= async_in;
            sync_2 <= sync_1;
        end
    end

    assign sync_out = sync_2;
endmodule
