`timescale 1ns/1ps

module clock_gating_target_counter #(
    parameter WIDTH = 4
) (
    input  wire             gated_clk,
    input  wire             rst_n,
    output reg  [WIDTH-1:0] count
);
    always @(posedge gated_clk or negedge rst_n) begin
        if (!rst_n)
            count <= {WIDTH{1'b0}};
        else
            count <= count + {{(WIDTH-1){1'b0}}, 1'b1};
    end
endmodule
