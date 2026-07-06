`timescale 1ns/1ps

module tb_01_no_sync_capture_xmodel;
    reg clk_src;
    reg clk_dst;
    reg rst_n;
    reg async_in;
    wire captured_out;
    integer src_cycle_count;

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
    always #6 clk_src = ~clk_src;  // source-domain clock, period = 12 ns

    initial clk_dst = 1'b0;
    always #5 clk_dst = ~clk_dst;  // destination-domain clock, period = 10 ns

    always @(posedge clk_src or negedge rst_n) begin
        if (!rst_n) begin
            async_in <= 1'b0;
            src_cycle_count <= 0;
        end else begin
            src_cycle_count <= src_cycle_count + 1;

            // async_in is launched by clk_src. Since clk_src and clk_dst are
            // unrelated, some src launches naturally fall inside the clk_dst
            // setup/hold stress window.
            async_in <= ~async_in;
        end
    end

    initial begin
        rst_n = 1'b0;
        async_in = 1'b0;
        src_cycle_count = 0;
        #23 rst_n = 1'b1;

        #120;

        $display("01 no_sync_capture_xmodel done. clk_src-launched async_in is captured directly by clk_dst.");
        $finish;
    end
endmodule
