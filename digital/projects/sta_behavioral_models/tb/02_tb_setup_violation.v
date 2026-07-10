`timescale 1ns/1ps

module tb_02_setup_violation;
    reg clk;
    reg rst_n;
    reg launch_d;
    wire launch_q;
    wire comb_out;
    wire capture_q;

    sta_ff_to_ff_path #(
        .COMB_DELAY_NS (9.5),
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
        repeat (5) @(posedge clk);
        $display("02 setup_violation done. Long combinational delay reaches capture edge too late.");
        $finish;
    end
endmodule
