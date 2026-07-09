`timescale 1ns/1ps

module toggle_sync (
    input  wire clk_src,
    input  wire rst_src_n,
    input  wire src_pulse,

    input  wire clk_dst,
    input  wire rst_dst_n,
    output wire dst_pulse
);
    reg src_toggle;
    reg dst_sync_1;
    reg dst_sync_2;
    reg dst_sync_3;

    always @(posedge clk_src or negedge rst_src_n) begin
        if (!rst_src_n)
            src_toggle <= 1'b0;
        else if (src_pulse)
            src_toggle <= ~src_toggle;
    end

    always @(posedge clk_dst or negedge rst_dst_n) begin
        if (!rst_dst_n) begin
            dst_sync_1 <= 1'b0;
            dst_sync_2 <= 1'b0;
            dst_sync_3 <= 1'b0;
        end else begin
            dst_sync_1 <= src_toggle;
            dst_sync_2 <= dst_sync_1;
            dst_sync_3 <= dst_sync_2;
        end
    end

    assign dst_pulse = dst_sync_2 ^ dst_sync_3;
endmodule
