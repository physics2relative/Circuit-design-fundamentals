`timescale 1ns/1ps

module tb_two_flop_sync;
    reg clk_dst;
    reg rst_n;
    reg async_in;
    wire sync_out;

    two_flop_sync u_sync (
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
        #23;
        rst_n = 1'b1;

        #17 async_in = 1'b1;
        #37 async_in = 1'b0;
        #13 async_in = 1'b1;
        #50 async_in = 1'b0;
        #40;

        $display("TB two_flop_sync done");
        $finish;
    end
endmodule
