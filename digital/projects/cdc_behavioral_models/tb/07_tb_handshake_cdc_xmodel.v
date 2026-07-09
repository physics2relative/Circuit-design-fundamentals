`timescale 1ns/1ps

module tb_07_handshake_cdc_xmodel;
    reg clk_src;
    reg clk_dst;
    reg rst_src_n;
    reg rst_dst_n;
    reg src_event;
    wire src_busy;
    wire src_accept_pulse;
    wire dst_pulse;

    integer requested_count;
    integer accepted_count;
    integer seen_count;

    handshake_cdc_xmodel #(
        .SETUP_NS (1.0),
        .HOLD_NS  (1.0),
        .RESOLVE_DELAY_NS (2.0),
        .RESOLVE_VALUE (1'b1)
    ) u_handshake_cdc_xmodel (
        .clk_src          (clk_src),
        .rst_src_n        (rst_src_n),
        .src_event        (src_event),
        .src_busy         (src_busy),
        .src_accept_pulse (src_accept_pulse),
        .clk_dst          (clk_dst),
        .rst_dst_n        (rst_dst_n),
        .dst_pulse        (dst_pulse)
    );

    initial clk_dst = 1'b0;
    always #5 clk_dst = ~clk_dst;

    initial begin
        clk_src = 1'b0;
        #2;
        forever #6 clk_src = ~clk_src;
    end

    task issue_src_event;
        begin
            @(negedge clk_src);
            src_event = 1'b1;
            @(negedge clk_src);
            src_event = 1'b0;
            requested_count = requested_count + 1;
        end
    endtask

    always @(posedge clk_src or negedge rst_src_n) begin
        if (!rst_src_n)
            accepted_count <= 0;
        else if (src_accept_pulse)
            accepted_count <= accepted_count + 1;
    end

    always @(posedge clk_dst or negedge rst_dst_n) begin
        if (!rst_dst_n)
            seen_count <= 0;
        else if (dst_pulse)
            seen_count <= seen_count + 1;
    end

    initial begin
        rst_src_n = 1'b0;
        rst_dst_n = 1'b0;
        src_event = 1'b0;
        requested_count = 0;
        #23;
        rst_src_n = 1'b1;
        rst_dst_n = 1'b1;

        // Three requests are intentionally issued faster than a full req/ack
        // round trip. The handshake accepts one, keeps req asserted while busy,
        // and rejects the others instead of silently creating extra dst pulses.
        issue_src_event();
        issue_src_event();
        issue_src_event();

        repeat (8) @(posedge clk_src);
        issue_src_event();

        #120;
        $display("07 handshake_cdc_xmodel done. requested=%0d accepted=%0d seen=%0d", requested_count, accepted_count, seen_count);
        $finish;
    end
endmodule
