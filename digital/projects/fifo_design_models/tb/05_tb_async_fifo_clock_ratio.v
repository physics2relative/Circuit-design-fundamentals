`timescale 1ns/1ps

module tb_async_fifo_clock_ratio;
    reg wclk;
    reg rclk;
    reg wrst_n;
    reg rrst_n;
    reg winc;
    reg [7:0] wdata;
    wire wfull;
    reg rinc;
    wire [7:0] rdata;
    wire rempty;
    wire [3:0] wbin_dbg, rbin_dbg, wgray_dbg, rgray_dbg, wq2_rgray_dbg, rq2_wgray_dbg;
    integer errors;
    integer produced;
    integer consumed;
    integer cycle;
    reg push_now;
    reg pop_now;

    async_fifo_gray #(.DATA_WIDTH(8), .ADDR_WIDTH(3)) dut (
        .wclk(wclk), .wrst_n(wrst_n), .winc(winc), .wdata(wdata), .wfull(wfull),
        .rclk(rclk), .rrst_n(rrst_n), .rinc(rinc), .rdata(rdata), .rempty(rempty),
        .wbin_dbg(wbin_dbg), .rbin_dbg(rbin_dbg), .wgray_dbg(wgray_dbg), .rgray_dbg(rgray_dbg),
        .wq2_rgray_dbg(wq2_rgray_dbg), .rq2_wgray_dbg(rq2_wgray_dbg)
    );

    initial wclk = 0;
    always #3 wclk = ~wclk;
    initial rclk = 0;
    always #11 rclk = ~rclk;

    task check;
        input cond;
        input [255:0] msg;
        begin
            if (!cond) begin
                $display("ERROR: %0s at %0t", msg, $time);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        errors = 0;
        produced = 0;
        winc = 0;
        wdata = 0;
        wrst_n = 0;
        repeat (5) @(posedge wclk);
        wrst_n = 1;

        for (cycle = 0; cycle < 120; cycle = cycle + 1) begin
            @(negedge wclk);
            if (produced < 20) begin
                winc = 1'b1;
                wdata = 8'h80 + produced[7:0];
            end else begin
                winc = 1'b0;
            end
            #1;
            push_now = winc && !wfull;
            @(posedge wclk); #1;
            if (push_now) produced = produced + 1;
        end
        @(negedge wclk);
        winc = 0;
    end

    initial begin
        consumed = 0;
        rinc = 0;
        rrst_n = 0;
        repeat (4) @(posedge rclk);
        rrst_n = 1;

        for (cycle = 0; cycle < 180; cycle = cycle + 1) begin
            @(negedge rclk);
            rinc = (consumed < 20);
            #1;
            pop_now = rinc && !rempty;
            if (pop_now) begin
                check(rdata == (8'h80 + consumed[7:0]), "async FIFO clock-ratio data mismatch");
            end
            @(posedge rclk); #1;
            if (pop_now) consumed = consumed + 1;
        end
        rinc = 0;
        check(produced == 20, "producer should eventually write 20 items despite full stalls");
        check(consumed == 20, "consumer should eventually read 20 items");
        check(rempty, "async FIFO should end empty in clock ratio test");

        if (errors == 0) $display("05 async FIFO clock-ratio done: PASS produced=%0d consumed=%0d", produced, consumed);
        else begin
            $display("05 async FIFO clock-ratio done: FAIL errors=%0d", errors);
            $fatal;
        end
        $finish;
    end
endmodule
