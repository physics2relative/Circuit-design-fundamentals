`timescale 1ns/1ps

module tb_sync_fifo_valid_ready;
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
    integer cycle;
    integer produced;
    integer consumed;
    reg push_now;
    reg pop_now;

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
        produced = 0;
        consumed = 0;
        rst_n = 0;
        in_valid = 0;
        in_data = 0;
        out_ready = 0;
        repeat (3) @(posedge clk);
        rst_n = 1;

        for (cycle = 0; cycle < 30; cycle = cycle + 1) begin
            @(negedge clk);
            in_valid  = (produced < 12);
            in_data   = 8'h30 + produced[7:0];
            out_ready = !((cycle >= 3) && (cycle <= 8));
            #1;

            push_now = in_valid && in_ready;
            pop_now  = out_valid && out_ready;
            if (pop_now) begin
                check(out_data == (8'h30 + consumed[7:0]), "valid-ready output order mismatch");
            end
            if ((cycle >= 3) && (cycle <= 8)) begin
                check(!out_ready, "consumer stall scenario should hold out_ready low");
            end
            check(count <= 8, "count must not exceed FIFO depth");

            @(posedge clk); #1;
            if (push_now) produced = produced + 1;
            if (pop_now) consumed = consumed + 1;
        end

        @(negedge clk);
        in_valid = 0;
        out_ready = 1;
        while (consumed < produced) begin
            #1;
            pop_now = out_valid && out_ready;
            if (pop_now) begin
                check(out_data == (8'h30 + consumed[7:0]), "drain output order mismatch");
            end
            @(posedge clk); #1;
            if (pop_now) consumed = consumed + 1;
            @(negedge clk);
        end
        @(posedge clk); #1;
        check(produced == 12, "all planned input transfers should occur");
        check(consumed == 12, "all planned output transfers should occur");
        check(empty, "FIFO should end empty after drain");

        if (errors == 0) $display("03 sync FIFO valid-ready done: PASS produced=%0d consumed=%0d", produced, consumed);
        else begin
            $display("03 sync FIFO valid-ready done: FAIL errors=%0d", errors);
            $fatal;
        end
        $finish;
    end
endmodule
