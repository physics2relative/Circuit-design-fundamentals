`timescale 1ns/1ps

module no_sync_capture (
    input  wire clk_dst,
    input  wire rst_n,
    input  wire async_in,
    output reg  captured_out
);
    always @(posedge clk_dst or negedge rst_n) begin
        if (!rst_n)
            captured_out <= 1'b0;
        else
            captured_out <= async_in;
    end
endmodule
