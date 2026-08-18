`timescale 1ns/1ps

module tb_sync_fifo_full_empty;
    reg clk;
    reg rst_n;
    reg in_valid;
    wire in_ready;
    reg [7:0] in_data;
    wire out_valid;
    reg out_ready;
    wire [7:0] out_data;
    wire full;
    wire empty;
    wire [3:0] count;
    integer errors;
    integer i;

    sync_fifo #(.DATA_WIDTH(8), .ADDR_WIDTH(3)) dut (
        .clk(clk), .rst_n(rst_n),
        .in_valid(in_valid), .in_ready(in_ready), .in_data(in_data),
        .out_valid(out_valid), .out_ready(out_ready), .out_data(out_data),
        .full(full), .empty(empty), .count(count)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

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
        rst_n = 0;
        in_valid = 0;
        in_data = 0;
        out_ready = 0;
        repeat (3) @(posedge clk);
        rst_n = 1;

        for (i = 0; i < 8; i = i + 1) begin
            @(negedge clk);
            in_valid = 1'b1;
            in_data  = 8'hA0 + i[7:0];
            #1;
            check(in_ready, "FIFO should accept until depth entries are written");
            @(posedge clk);
        end
        @(negedge clk);
        in_valid = 1'b0;
        @(posedge clk); #1;
        check(full, "FIFO should be full after depth pushes");
        check(count == 8, "count should equal depth");
        check(!in_ready, "full FIFO should deassert in_ready");

        @(negedge clk);
        in_valid = 1'b1;
        in_data  = 8'hFF;
        #1;
        check(!in_ready, "overflow attempt should be blocked by in_ready");
        @(posedge clk); #1;
        check(count == 8, "blocked overflow should not change count");
        @(negedge clk);
        in_valid = 1'b0;

        for (i = 0; i < 8; i = i + 1) begin
            @(negedge clk);
            out_ready = 1'b1;
            #1;
            check(out_valid, "FIFO should have valid data while draining");
            check(out_data == (8'hA0 + i[7:0]), "FIFO order should be preserved");
            @(posedge clk);
        end
        @(negedge clk);
        out_ready = 1'b0;
        @(posedge clk); #1;
        check(empty, "FIFO should be empty after all entries are read");
        check(!out_valid, "empty FIFO should deassert out_valid");

        if (errors == 0) $display("02 sync FIFO full/empty done: PASS");
        else begin
            $display("02 sync FIFO full/empty done: FAIL errors=%0d", errors);
            $fatal;
        end
        $finish;
    end
endmodule
