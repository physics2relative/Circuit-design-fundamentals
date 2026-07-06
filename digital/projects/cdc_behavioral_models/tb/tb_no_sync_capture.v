`timescale 1ns/1ps

module tb_no_sync_capture;
    reg clk_dst;
    reg rst_n;
    reg async_in;
    wire captured_out;

    no_sync_capture u_no_sync_capture (
        .clk_dst      (clk_dst),
        .rst_n        (rst_n),
        .async_in     (async_in),
        .captured_out (captured_out)
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

        $display("TB no_sync_capture done. Direct async capture is structurally unsafe.");
        $finish;
    end
endmodule
