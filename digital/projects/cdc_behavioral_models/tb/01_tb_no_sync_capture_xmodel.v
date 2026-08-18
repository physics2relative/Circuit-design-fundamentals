`timescale 1ns/1ps

module tb_01_no_sync_capture_xmodel;
    reg clk_src;
    reg clk_dst;
    reg rst_n;
    reg async_in;
    wire captured_out;
    integer src_cycle_count;

    no_sync_capture_xmodel #(
        .SETUP_NS         (1.0),
        .HOLD_NS          (1.0),
        .RESOLVE_DELAY_NS (2.0),
        .RESOLVE_VALUE    (1'b1)
    ) u_no_sync_capture_xmodel (
        .clk_dst      (clk_dst),
        .rst_n        (rst_n),
        .async_in     (async_in),
        .captured_out (captured_out)
    );

    initial clk_src = 1'b0;
    always #6 clk_src = ~clk_src;

    initial clk_dst = 1'b0;
    always #5 clk_dst = ~clk_dst;

    always @(posedge clk_src or negedge rst_n) begin
        if (!rst_n) begin
            async_in <= 1'b0;
            src_cycle_count <= 0;
        end else begin
            src_cycle_count <= src_cycle_count + 1;
            async_in <= ~async_in;
        end
    end

    initial begin
        rst_n = 1'b0;
        async_in = 1'b0;
        src_cycle_count = 0;
        #23 rst_n = 1'b1;
        #120;

        $display("01 no_sync_capture_xmodel done. Direct receiver FF shows temporary X then deterministic resolve.");
        $finish;
    end
endmodule
