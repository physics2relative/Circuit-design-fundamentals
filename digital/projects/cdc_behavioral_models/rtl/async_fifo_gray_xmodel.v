`timescale 1ns/1ps

module async_fifo_gray_xmodel #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 2,
    parameter real SETUP_NS = 1.0,
    parameter real HOLD_NS  = 1.0,
    parameter real RESOLVE_DELAY_NS = 2.0,
    parameter      RESOLVE_VALUE = 1'b1
)(
    input  wire                  wclk,
    input  wire                  wrst_n,
    input  wire                  w_en,
    input  wire [DATA_WIDTH-1:0] wdata,
    output wire                  full,
    output wire [ADDR_WIDTH:0]   wptr_bin_dbg,
    output wire [ADDR_WIDTH:0]   wptr_gray_dbg,
    output wire [ADDR_WIDTH:0]   rptr_gray_wsync_dbg,

    input  wire                  rclk,
    input  wire                  rrst_n,
    input  wire                  r_en,
    output reg  [DATA_WIDTH-1:0] rdata,
    output wire                  empty,
    output wire [ADDR_WIDTH:0]   rptr_bin_dbg,
    output wire [ADDR_WIDTH:0]   rptr_gray_dbg,
    output wire [ADDR_WIDTH:0]   wptr_gray_rsync_dbg
);
    localparam DEPTH = (1 << ADDR_WIDTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    reg  [PTR_WIDTH-1:0] wptr_bin;
    reg  [PTR_WIDTH-1:0] wptr_gray;
    reg  [PTR_WIDTH-1:0] rptr_bin;
    reg  [PTR_WIDTH-1:0] rptr_gray;

    wire [PTR_WIDTH-1:0] wptr_bin_next;
    wire [PTR_WIDTH-1:0] wptr_gray_next;
    wire [PTR_WIDTH-1:0] rptr_bin_next;
    wire [PTR_WIDTH-1:0] rptr_gray_next;

    reg  [PTR_WIDTH-1:0] wptr_gray_rsync_1;
    reg  [PTR_WIDTH-1:0] wptr_gray_rsync_2;
    reg  [PTR_WIDTH-1:0] rptr_gray_wsync_1;
    reg  [PTR_WIDTH-1:0] rptr_gray_wsync_2;

    wire w_do_write;
    wire r_do_read;

    function [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        begin
            bin2gray = (bin >> 1) ^ bin;
        end
    endfunction

    assign w_do_write = w_en && !full;
    assign r_do_read  = r_en && !empty;

    assign wptr_bin_next  = wptr_bin + {{(PTR_WIDTH-1){1'b0}}, w_do_write};
    assign wptr_gray_next = bin2gray(wptr_bin_next);
    assign rptr_bin_next  = rptr_bin + {{(PTR_WIDTH-1){1'b0}}, r_do_read};
    assign rptr_gray_next = bin2gray(rptr_bin_next);

    // Use current-pointer full/empty flags in this educational model to keep
    // the control path free of combinational loops. Production FIFOs often use
    // next-pointer lookahead, but the CDC concept is the same.
    assign full = (wptr_gray == {~rptr_gray_wsync_2[PTR_WIDTH-1:PTR_WIDTH-2],
                                 rptr_gray_wsync_2[PTR_WIDTH-3:0]});
    assign empty = (rptr_gray == wptr_gray_rsync_2);

    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            wptr_bin <= {PTR_WIDTH{1'b0}};
            wptr_gray <= {PTR_WIDTH{1'b0}};
        end else begin
            if (w_do_write)
                mem[wptr_bin[ADDR_WIDTH-1:0]] <= wdata;
            wptr_bin <= wptr_bin_next;
            wptr_gray <= wptr_gray_next;
        end
    end

    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            rptr_bin <= {PTR_WIDTH{1'b0}};
            rptr_gray <= {PTR_WIDTH{1'b0}};
            rdata <= {DATA_WIDTH{1'b0}};
        end else begin
            if (r_do_read)
                rdata <= mem[rptr_bin[ADDR_WIDTH-1:0]];
            rptr_bin <= rptr_bin_next;
            rptr_gray <= rptr_gray_next;
        end
    end

    // For the FIFO case, keep pointer synchronizers as ordinary 2-FF chains.
    // The CDC lesson here is the architecture: data stays in dual-clock memory,
    // and only Gray-coded pointers cross domains. Injecting X directly into the
    // full/empty control path can make the educational simulation unusable.
    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            wptr_gray_rsync_1 <= {PTR_WIDTH{1'b0}};
            wptr_gray_rsync_2 <= {PTR_WIDTH{1'b0}};
        end else begin
            wptr_gray_rsync_1 <= wptr_gray;
            wptr_gray_rsync_2 <= wptr_gray_rsync_1;
        end
    end

    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            rptr_gray_wsync_1 <= {PTR_WIDTH{1'b0}};
            rptr_gray_wsync_2 <= {PTR_WIDTH{1'b0}};
        end else begin
            rptr_gray_wsync_1 <= rptr_gray;
            rptr_gray_wsync_2 <= rptr_gray_wsync_1;
        end
    end

    assign wptr_bin_dbg = wptr_bin;
    assign wptr_gray_dbg = wptr_gray;
    assign rptr_gray_wsync_dbg = rptr_gray_wsync_2;
    assign rptr_bin_dbg = rptr_bin;
    assign rptr_gray_dbg = rptr_gray;
    assign wptr_gray_rsync_dbg = wptr_gray_rsync_2;
endmodule
