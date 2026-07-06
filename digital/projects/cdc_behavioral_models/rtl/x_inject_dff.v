`timescale 1ns/1ps

module x_inject_dff #(
    parameter real SETUP_NS = 1.0,
    parameter real HOLD_NS  = 1.0
)(
    input  wire clk,
    input  wire rst_n,
    input  wire d,
    output reg  q
);
    realtime last_d_change;
    realtime last_clk_edge;
    reg      seen_clk_edge;

    initial begin
        q = 1'b0;
        last_d_change = -1.0e9;
        last_clk_edge = -1.0e9;
        seen_clk_edge = 1'b0;
    end

    always @(d) begin
        last_d_change = $realtime;

        if (rst_n && seen_clk_edge && (($realtime - last_clk_edge) <= HOLD_NS)) begin
            q <= 1'bx;
            $display("%0t %m HOLD violation: d changed %0.3f ns after clk edge", $time, $realtime - last_clk_edge);
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q <= 1'b0;
            seen_clk_edge <= 1'b0;
        end else begin
            last_clk_edge = $realtime;
            seen_clk_edge <= 1'b1;

            if (($realtime - last_d_change) <= SETUP_NS) begin
                q <= 1'bx;
                $display("%0t %m SETUP violation: d changed %0.3f ns before clk edge", $time, $realtime - last_d_change);
            end else begin
                q <= d;
            end
        end
    end
endmodule
