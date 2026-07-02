`timescale 1ns/1ps

module tb_bad_bus_sync;
    reg clk_src;
    reg clk_dst;
    reg rst_n;
    reg [3:0] src_bus;
    wire [3:0] dst_bus;

    bad_bus_sync #(.WIDTH(4)) u_bad_bus_sync (
        .clk_dst   (clk_dst),
        .rst_n     (rst_n),
        .async_bus (src_bus),
        .sync_bus  (dst_bus)
    );

    initial clk_src = 1'b0;
    always #7 clk_src = ~clk_src;

    initial clk_dst = 1'b0;
    always #5 clk_dst = ~clk_dst;

    always @(posedge clk_src or negedge rst_n) begin
        if (!rst_n)
            src_bus <= 4'd0;
        else
            src_bus <= src_bus + 4'd3;
    end

    initial begin

        rst_n = 1'b0;
        #22 rst_n = 1'b1;
        #220;
        $display("TB bad_bus_sync done. Bitwise sync of multi-bit bus is structurally unsafe for coherent data.");
        $finish;
    end
endmodule
