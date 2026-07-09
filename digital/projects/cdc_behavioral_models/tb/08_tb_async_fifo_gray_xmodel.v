`timescale 1ns/1ps

module tb_08_async_fifo_gray_xmodel;
    reg wclk;
    reg rclk;
    reg wrst_n;
    reg rrst_n;
    reg w_en;
    reg [7:0] wdata;
    reg r_en;
    wire [7:0] rdata;
    wire full;
    wire empty;
    wire [2:0] wptr_bin_dbg;
    wire [2:0] wptr_gray_dbg;
    wire [2:0] rptr_gray_wsync_dbg;
    wire [2:0] rptr_bin_dbg;
    wire [2:0] rptr_gray_dbg;
    wire [2:0] wptr_gray_rsync_dbg;

    integer write_index;
    integer read_index;
    integer writes_seen;
    integer reads_seen;

    async_fifo_gray_xmodel #(
        .DATA_WIDTH (8),
        .ADDR_WIDTH (2),
        .SETUP_NS   (1.0),
        .HOLD_NS    (1.0),
        .RESOLVE_DELAY_NS (2.0),
        .RESOLVE_VALUE (1'b1)
    ) u_async_fifo_gray_xmodel (
        .wclk                 (wclk),
        .wrst_n               (wrst_n),
        .w_en                 (w_en),
        .wdata                (wdata),
        .full                 (full),
        .wptr_bin_dbg         (wptr_bin_dbg),
        .wptr_gray_dbg        (wptr_gray_dbg),
        .rptr_gray_wsync_dbg  (rptr_gray_wsync_dbg),
        .rclk                 (rclk),
        .rrst_n               (rrst_n),
        .r_en                 (r_en),
        .rdata                (rdata),
        .empty                (empty),
        .rptr_bin_dbg         (rptr_bin_dbg),
        .rptr_gray_dbg        (rptr_gray_dbg),
        .wptr_gray_rsync_dbg  (wptr_gray_rsync_dbg)
    );

    initial wclk = 1'b0;
    always #4 wclk = ~wclk;

    initial begin
        rclk = 1'b0;
        #1;
        forever #7 rclk = ~rclk;
    end

    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n)
            writes_seen <= 0;
        else if (w_en && !full)
            writes_seen <= writes_seen + 1;
    end

    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n)
            reads_seen <= 0;
        else if (r_en && !empty)
            reads_seen <= reads_seen + 1;
    end

    initial begin
        wrst_n = 1'b0;
        rrst_n = 1'b0;
        w_en = 1'b0;
        r_en = 1'b0;
        wdata = 8'h00;
        write_index = 0;
        read_index = 0;
        #23;
        wrst_n = 1'b1;
        rrst_n = 1'b1;
    end

    initial begin
        wait (wrst_n);
        repeat (2) @(posedge wclk);
        for (write_index = 0; write_index < 6; write_index = write_index + 1) begin
            @(negedge wclk);
            wdata = 8'hA0 + write_index[7:0];
            w_en = 1'b1;
            @(negedge wclk);
            w_en = 1'b0;
        end
    end

    initial begin
        wait (rrst_n);
        repeat (8) @(posedge rclk);
        for (read_index = 0; read_index < 6; read_index = read_index + 1) begin
            @(negedge rclk);
            r_en = 1'b1;
            @(negedge rclk);
            r_en = 1'b0;
        end
    end

    initial begin
        #500;
        $display("08 async_fifo_gray_xmodel done. writes_seen=%0d reads_seen=%0d", writes_seen, reads_seen);
        $finish;
    end
endmodule
