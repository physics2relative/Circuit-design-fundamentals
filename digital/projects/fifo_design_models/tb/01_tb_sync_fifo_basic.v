`timescale 1ns/1ps

module tb_sync_fifo_basic;
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

    task push_byte;
        input [7:0] data;
        begin
            @(negedge clk);
            in_data  = data;
            in_valid = 1'b1;
            @(negedge clk);
            check(in_ready, "push expected ready");
            in_valid = 1'b0;
        end
    endtask

    task pop_expect;
        input [7:0] data;
        begin
            @(negedge clk);
            out_ready = 1'b1;
            #1;
            check(out_valid, "pop expected valid");
            check(out_data == data, "pop data mismatch");
            @(posedge clk);
            @(negedge clk);
            out_ready = 1'b0;
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
        @(posedge clk); #1;
        check(empty, "reset should make FIFO empty");
        check(!out_valid, "empty FIFO should not assert out_valid");

        push_byte(8'h11);
        push_byte(8'h22);
        push_byte(8'h33);
        @(posedge clk); #1;
        check(count == 3, "count should be 3 after three pushes");

        pop_expect(8'h11);
        pop_expect(8'h22);
        pop_expect(8'h33);
        @(posedge clk); #1;
        check(empty, "FIFO should become empty after all pops");

        if (errors == 0) $display("01 sync FIFO basic done: PASS");
        else begin
            $display("01 sync FIFO basic done: FAIL errors=%0d", errors);
            $fatal;
        end
        $finish;
    end
endmodule
