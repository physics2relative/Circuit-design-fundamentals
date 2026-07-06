`timescale 1ns/1ps

module tb_01_no_sync_capture_xmodel;
    reg clk_src;
    reg clk_dst;
    reg rst_n;
    reg async_in;
    wire captured_out;

    no_sync_capture_xmodel #(
        .SETUP_NS (1.0),
        .HOLD_NS  (1.0)
    ) u_no_sync_capture_xmodel (
        .clk_dst      (clk_dst),
        .rst_n        (rst_n),
        .async_in     (async_in),
        .captured_out (captured_out)
    );

    initial clk_src = 1'b0;
    always #7 clk_src = ~clk_src;  // reference source-domain clock for waveform context

    initial clk_dst = 1'b0;
    always #5 clk_dst = ~clk_dst;

    initial begin
        rst_n = 1'b0;
        async_in = 1'b0;
        #23 rst_n = 1'b1;

        // async_in represents a signal launched from another clock domain.
        // clk_src is shown as source-domain context, while these transitions are
        // scheduled explicitly to stress clk_dst setup/hold windows.
        #21 async_in = 1'b1;  // 1 ns before clk_dst posedge at 45 ns: setup violation
        #12 async_in = 1'b0;  // 1 ns after clk_dst posedge at 55 ns: hold violation
        #18 async_in = 1'b1;  // 1 ns before clk_dst posedge at 75 ns: setup violation
        #21 async_in = 1'b0;  // same time as clk_dst posedge at 95 ns: edge-aligned stress
        #50;

        $display("01 no_sync_capture_xmodel done. Direct async capture exposes X on setup/hold stress.");
        $finish;
    end
endmodule
