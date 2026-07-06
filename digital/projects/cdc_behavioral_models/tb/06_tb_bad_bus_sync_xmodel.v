`timescale 1ns/1ps

module tb_06_bad_bus_sync_xmodel;
    reg clk_dst;
    reg rst_n;
    reg [3:0] src_bus;
    wire [3:0] dst_bus;

    bad_bus_sync_xmodel #(
        .WIDTH    (4),
        .SETUP_NS (1.0),
        .HOLD_NS  (1.0)
    ) u_bad_bus_sync_xmodel (
        .clk_dst   (clk_dst),
        .rst_n     (rst_n),
        .async_bus (src_bus),
        .sync_bus  (dst_bus)
    );

    initial clk_dst = 1'b0;
    always #5 clk_dst = ~clk_dst;

    initial begin
        rst_n = 1'b0;
        src_bus = 4'b0000;
        #23 rst_n = 1'b1;

        #21 src_bus = 4'b0011; // 1 ns before clk posedge at 45 ns: setup violation on changed bits
        #12 src_bus = 4'b1100; // 1 ns after clk posedge at 55 ns: hold violation on changed bits
        #18 src_bus = 4'b0111; // 1 ns before clk posedge at 75 ns: setup violation
        #21 src_bus = 4'b1000; // same time as clk posedge at 95 ns: edge-aligned multi-bit stress
        #80;

        $display("06 bad_bus_sync_xmodel done. Bitwise sync of multi-bit bus exposes incoherent/X-prone data.");
        $finish;
    end
endmodule
