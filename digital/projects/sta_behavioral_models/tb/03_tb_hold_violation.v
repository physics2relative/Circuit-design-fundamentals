`timescale 1ns/1ps

module tb_03_hold_violation;
    reg clk;
    reg rst_n;
    reg launch_d;
    wire launch_q;
    wire comb_out;
    wire capture_q;

    sta_ff_to_ff_path #(
        .COMB_DELAY_NS (0.2),
        .SETUP_NS      (1.0),
        .HOLD_NS       (1.0)
    ) u_path (
        .clk_launch  (clk),
        .clk_capture (clk),
        .rst_n       (rst_n),
        .launch_d    (launch_d),
        .launch_q    (launch_q),
        .comb_out    (comb_out),
        .capture_q   (capture_q)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        rst_n = 1'b0;
        launch_d = 1'b0;
        #12 rst_n = 1'b1;
        @(negedge clk); launch_d = 1'b1;
        repeat (4) @(posedge clk);
        $display("03 hold_violation done. Very short data path changes too soon after capture edge.");
        $finish;
    end
endmodule
