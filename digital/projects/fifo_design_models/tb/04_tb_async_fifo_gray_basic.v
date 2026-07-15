`timescale 1ns/1ps

module tb_async_fifo_gray_basic;
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
    integer i;

    async_fifo_gray #(.DATA_WIDTH(8), .ADDR_WIDTH(3)) dut (
        .wclk(wclk), .wrst_n(wrst_n), .winc(winc), .wdata(wdata), .wfull(wfull),
        .rclk(rclk), .rrst_n(rrst_n), .rinc(rinc), .rdata(rdata), .rempty(rempty),
        .wbin_dbg(wbin_dbg), .rbin_dbg(rbin_dbg), .wgray_dbg(wgray_dbg), .rgray_dbg(rgray_dbg),
        .wq2_rgray_dbg(wq2_rgray_dbg), .rq2_wgray_dbg(rq2_wgray_dbg)
    );

    initial wclk = 0;
    always #4 wclk = ~wclk;
    initial rclk = 0;
    always #7 rclk = ~rclk;

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

    task write_one;
        input [7:0] data;
        begin
            @(negedge wclk);
            wdata = data;
            winc  = 1'b1;
            @(negedge wclk);
            winc  = 1'b0;
        end
    endtask

    task read_expect;
        input [7:0] data;
        begin
            wait (!rempty);
            @(negedge rclk);
            rinc = 1'b1;
            #1;
            check(rdata == data, "async FIFO read data mismatch");
            @(posedge rclk);
            @(negedge rclk);
            rinc = 1'b0;
        end
    endtask

    initial begin
        errors = 0;
        wrst_n = 0; rrst_n = 0;
        winc = 0; wdata = 0; rinc = 0;
        repeat (4) @(posedge wclk);
        repeat (3) @(posedge rclk);
        wrst_n = 1; rrst_n = 1;

        for (i = 0; i < 6; i = i + 1) begin
            write_one(8'h50 + i[7:0]);
        end
        for (i = 0; i < 6; i = i + 1) begin
            read_expect(8'h50 + i[7:0]);
        end
        repeat (4) @(posedge rclk); #1;
        check(rempty, "async FIFO should be empty after basic transfer");

        if (errors == 0) $display("04 async FIFO gray basic done: PASS");
        else begin
            $display("04 async FIFO gray basic done: FAIL errors=%0d", errors);
            $fatal;
        end
        $finish;
    end
endmodule
