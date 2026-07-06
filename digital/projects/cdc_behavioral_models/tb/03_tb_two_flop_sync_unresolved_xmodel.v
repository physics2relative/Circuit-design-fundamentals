`timescale 1ns/1ps

module tb_03_two_flop_sync_unresolved_xmodel;
    reg clk_dst;
    reg rst_n;
    reg async_in;
    wire sync_out;

    two_flop_sync_xmodel #(
        .SETUP_NS         (1.0),
        .HOLD_NS          (1.0),
        .RESOLVE_DELAY_NS (12.0),
        .RESOLVE_VALUE    (1'b1)
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

        #21 async_in = 1'b1;  // 1 ns before clk_dst posedge at 45 ns
        #80;

        $display("03 two_flop_sync_unresolved_xmodel done. First stage stays X across next sampling edge.");
        $finish;
    end
endmodule
