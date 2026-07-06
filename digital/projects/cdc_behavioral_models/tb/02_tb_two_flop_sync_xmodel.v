`timescale 1ns/1ps

module tb_02_two_flop_sync_xmodel;
    reg clk_dst;
    reg rst_n;
    reg async_in;
    wire sync_out;

    two_flop_sync_xmodel #(
        .SETUP_NS (1.0),
        .HOLD_NS  (1.0)
    ) u_two_flop_sync_xmodel (
        .clk_dst  (clk_dst),
        .rst_n    (rst_n),
        .async_in (async_in),
        .sync_out (sync_out)
    );

    initial clk_dst = 1'b0;
    always #5 clk_dst = ~clk_dst;

    initial begin
        rst_n = 1'b0;
        async_in = 1'b0;
        #23 rst_n = 1'b1;

        #21 async_in = 1'b1;  // 1 ns before clk posedge at 45 ns: setup violation on first stage
        #12 async_in = 1'b0;  // 1 ns after clk posedge at 55 ns: hold violation on first stage
        #18 async_in = 1'b1;  // 1 ns before clk posedge at 75 ns: setup violation on first stage
        #21 async_in = 1'b0;  // same time as clk posedge at 95 ns: edge-aligned stress
        #70;

        $display("02 two_flop_sync_xmodel done. First-stage X is observed through synchronizer latency.");
        $finish;
    end
endmodule
