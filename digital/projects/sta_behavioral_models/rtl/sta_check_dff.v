`timescale 1ns/1ps

module sta_check_dff #(
    parameter real SETUP_NS = 1.0,
    parameter real HOLD_NS  = 1.0,
    parameter real RESOLVE_DELAY_NS = 2.0,
    parameter      RESET_VALUE = 1'b0,
    parameter      RESOLVE_VALUE = 1'bx
)(
    input  wire clk,
    input  wire rst_n,
    input  wire d,
    output reg  q
);
    realtime last_d_change;
    realtime last_clk_edge;
    reg      seen_clk_edge;
    reg      violation_active;
    integer  resolve_token;

    initial begin
        q = RESET_VALUE;
        last_d_change = -1.0e9;
        last_clk_edge = -1.0e9;
        seen_clk_edge = 1'b0;
        violation_active = 1'b0;
        resolve_token = 0;
    end

    task inject_violation;
        input [8*16-1:0] violation_type;
        input real       margin_ns;
        integer          my_token;
        begin
            resolve_token = resolve_token + 1;
            my_token = resolve_token;
            violation_active = 1'b1;
            q <= 1'bx;
            $display("%0t %m %0s violation: margin=%0.3f ns, q=X",
                     $time, violation_type, margin_ns);

            fork
                begin
                    #(RESOLVE_DELAY_NS);
                    if (rst_n && (my_token == resolve_token)) begin
                        violation_active = 1'b0;
                        q <= RESOLVE_VALUE;
                        $display("%0t %m resolved to %0b", $time, RESOLVE_VALUE);
                    end
                end
            join_none
        end
    endtask

    always @(d) begin
        last_d_change = $realtime;
        if (rst_n && seen_clk_edge && (($realtime - last_clk_edge) < HOLD_NS)) begin
            inject_violation("HOLD", $realtime - last_clk_edge);
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            resolve_token = resolve_token + 1;
            violation_active = 1'b0;
            seen_clk_edge <= 1'b0;
            q <= RESET_VALUE;
        end else begin
            last_clk_edge = $realtime;
            seen_clk_edge <= 1'b1;

            if (($realtime - last_d_change) < SETUP_NS) begin
                inject_violation("SETUP", $realtime - last_d_change);
            end else if (violation_active) begin
                q <= 1'bx;
            end else begin
                resolve_token = resolve_token + 1;
                q <= d;
            end
        end
    end
endmodule
