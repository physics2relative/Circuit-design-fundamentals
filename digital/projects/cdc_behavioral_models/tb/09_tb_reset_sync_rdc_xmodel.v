`timescale 1ns/1ps

module tb_09_reset_sync_rdc_xmodel;
    reg clk_src;
    reg clk_dst;
    reg global_rst_n;
    wire rst_src_n;
    wire rst_dst_n;
    wire bad_src_state;
    wire bad_dst_state;
    wire good_src_state;
    wire good_dst_state;

    reset_sync_rdc_xmodel #(
        .RECOVERY_NS (1.0),
        .REMOVAL_NS  (1.0),
        .RESOLVE_DELAY_NS (2.0),
        .RESOLVE_VALUE (1'b1)
    ) u_reset_sync_rdc_xmodel (
        .clk_src        (clk_src),
        .clk_dst        (clk_dst),
        .global_rst_n   (global_rst_n),
        .rst_src_n      (rst_src_n),
        .rst_dst_n      (rst_dst_n),
        .bad_src_state  (bad_src_state),
        .bad_dst_state  (bad_dst_state),
        .good_src_state (good_src_state),
        .good_dst_state (good_dst_state)
    );

    initial clk_src = 1'b0;
    always #6 clk_src = ~clk_src;

    initial begin
        clk_dst = 1'b0;
        #2;
        forever #5 clk_dst = ~clk_dst;
    end

    initial begin
        global_rst_n = 1'b0;

        // Deassert 1 ns before a dst edge at 27 ns and 1 ns after a src edge at 24 ns.
        // Directly released FFs can violate recovery/removal assumptions, while
        // reset synchronizers release rst_src_n/rst_dst_n only on local clock edges.
        #26 global_rst_n = 1'b1;
        #70 global_rst_n = 1'b0;
        #15 global_rst_n = 1'b1;
        #100;

        $display("09 reset_sync_rdc_xmodel done. bad states can X on direct release; synced resets release per domain.");
        $finish;
    end
endmodule
