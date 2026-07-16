module async_fifo_gray #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 3
) (
    input  wire                  wclk,
    input  wire                  wrst_n,
    input  wire                  winc,
    input  wire [DATA_WIDTH-1:0] wdata,
    output wire                  wfull,

    input  wire                  rclk,
    input  wire                  rrst_n,
    input  wire                  rinc,
    output wire [DATA_WIDTH-1:0] rdata,
    output wire                  rempty,

    output wire [ADDR_WIDTH:0]   wbin_dbg,
    output wire [ADDR_WIDTH:0]   rbin_dbg,
    output wire [ADDR_WIDTH:0]   wgray_dbg,
    output wire [ADDR_WIDTH:0]   rgray_dbg,
    output wire [ADDR_WIDTH:0]   wq2_rgray_dbg,
    output wire [ADDR_WIDTH:0]   rq2_wgray_dbg
);
    wire                  wpush;
    wire                  rpop;
    wire [ADDR_WIDTH-1:0] waddr;
    wire [ADDR_WIDTH-1:0] raddr;
    wire [ADDR_WIDTH:0]   wbin;
    wire [ADDR_WIDTH:0]   rbin;
    wire [ADDR_WIDTH:0]   wgray;
    wire [ADDR_WIDTH:0]   rgray;
    wire [ADDR_WIDTH:0]   wq2_rgray;
    wire [ADDR_WIDTH:0]   rq2_wgray;

    assign wpush = winc && !wfull;
    assign rpop  = rinc && !rempty;

    async_fifo_gray_mem #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) u_mem (
        .wclk  (wclk),
        .wpush (wpush),
        .waddr (waddr),
        .wdata (wdata),
        .raddr (raddr),
        .rdata (rdata)
    );

    async_fifo_gray_sync #(
        .WIDTH(ADDR_WIDTH + 1)
    ) u_sync_rptr_to_wclk (
        .clk       (wclk),
        .rst_n     (wrst_n),
        .async_in  (rgray),
        .sync_out  (wq2_rgray)
    );

    async_fifo_gray_sync #(
        .WIDTH(ADDR_WIDTH + 1)
    ) u_sync_wptr_to_rclk (
        .clk       (rclk),
        .rst_n     (rrst_n),
        .async_in  (wgray),
        .sync_out  (rq2_wgray)
    );

    async_fifo_gray_wptr_full #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) u_wptr_full (
        .wclk        (wclk),
        .wrst_n      (wrst_n),
        .wpush       (wpush),
        .wq2_rgray   (wq2_rgray),
        .waddr       (waddr),
        .wbin        (wbin),
        .wgray       (wgray),
        .wfull       (wfull)
    );

    async_fifo_gray_rptr_empty #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) u_rptr_empty (
        .rclk        (rclk),
        .rrst_n      (rrst_n),
        .rpop        (rpop),
        .rq2_wgray   (rq2_wgray),
        .raddr       (raddr),
        .rbin        (rbin),
        .rgray       (rgray),
        .rempty      (rempty)
    );

    assign wbin_dbg      = wbin;
    assign rbin_dbg      = rbin;
    assign wgray_dbg     = wgray;
    assign rgray_dbg     = rgray;
    assign wq2_rgray_dbg = wq2_rgray;
    assign rq2_wgray_dbg = rq2_wgray;
endmodule

module async_fifo_gray_mem #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 3
) (
    input  wire                  wclk,
    input  wire                  wpush,
    input  wire [ADDR_WIDTH-1:0] waddr,
    input  wire [DATA_WIDTH-1:0] wdata,
    input  wire [ADDR_WIDTH-1:0] raddr,
    output wire [DATA_WIDTH-1:0] rdata
);
    localparam DEPTH = (1 << ADDR_WIDTH);

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge wclk) begin
        if (wpush) begin
            mem[waddr] <= wdata;
        end
    end

    assign rdata = mem[raddr];
endmodule

module async_fifo_gray_sync #(
    parameter WIDTH = 4
) (
    input  wire             clk,
    input  wire             rst_n,
    input  wire [WIDTH-1:0] async_in,
    output wire [WIDTH-1:0] sync_out
);
    reg [WIDTH-1:0] sync_q1;
    reg [WIDTH-1:0] sync_q2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_q1 <= {WIDTH{1'b0}};
            sync_q2 <= {WIDTH{1'b0}};
        end else begin
            sync_q1 <= async_in;
            sync_q2 <= sync_q1;
        end
    end

    assign sync_out = sync_q2;
endmodule

module async_fifo_gray_wptr_full #(
    parameter ADDR_WIDTH = 3
) (
    input  wire                  wclk,
    input  wire                  wrst_n,
    input  wire                  wpush,
    input  wire [ADDR_WIDTH:0]   wq2_rgray,
    output wire [ADDR_WIDTH-1:0] waddr,
    output wire [ADDR_WIDTH:0]   wbin,
    output wire [ADDR_WIDTH:0]   wgray,
    output wire                  wfull
);
    reg [ADDR_WIDTH:0] wbin_r;
    reg [ADDR_WIDTH:0] wgray_r;
    reg                wfull_r;

    wire [ADDR_WIDTH:0] wbin_next;
    wire [ADDR_WIDTH:0] wgray_next;
    wire                wfull_next;

    function [ADDR_WIDTH:0] bin2gray;
        input [ADDR_WIDTH:0] bin;
        begin
            bin2gray = (bin >> 1) ^ bin;
        end
    endfunction

    assign wbin_next  = wbin_r + {{ADDR_WIDTH{1'b0}}, wpush};
    assign wgray_next = bin2gray(wbin_next);

    assign wfull_next = (wgray_next == {~wq2_rgray[ADDR_WIDTH:ADDR_WIDTH-1],
                                         wq2_rgray[ADDR_WIDTH-2:0]});

    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            wbin_r  <= {ADDR_WIDTH+1{1'b0}};
            wgray_r <= {ADDR_WIDTH+1{1'b0}};
            wfull_r <= 1'b0;
        end else begin
            wbin_r  <= wbin_next;
            wgray_r <= wgray_next;
            wfull_r <= wfull_next;
        end
    end

    assign waddr = wbin_r[ADDR_WIDTH-1:0];
    assign wbin  = wbin_r;
    assign wgray = wgray_r;
    assign wfull = wfull_r;
endmodule

module async_fifo_gray_rptr_empty #(
    parameter ADDR_WIDTH = 3
) (
    input  wire                  rclk,
    input  wire                  rrst_n,
    input  wire                  rpop,
    input  wire [ADDR_WIDTH:0]   rq2_wgray,
    output wire [ADDR_WIDTH-1:0] raddr,
    output wire [ADDR_WIDTH:0]   rbin,
    output wire [ADDR_WIDTH:0]   rgray,
    output wire                  rempty
);
    reg [ADDR_WIDTH:0] rbin_r;
    reg [ADDR_WIDTH:0] rgray_r;
    reg                rempty_r;

    wire [ADDR_WIDTH:0] rbin_next;
    wire [ADDR_WIDTH:0] rgray_next;
    wire                rempty_next;

    function [ADDR_WIDTH:0] bin2gray;
        input [ADDR_WIDTH:0] bin;
        begin
            bin2gray = (bin >> 1) ^ bin;
        end
    endfunction

    assign rbin_next   = rbin_r + {{ADDR_WIDTH{1'b0}}, rpop};
    assign rgray_next  = bin2gray(rbin_next);
    assign rempty_next = (rgray_next == rq2_wgray);

    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            rbin_r   <= {ADDR_WIDTH+1{1'b0}};
            rgray_r  <= {ADDR_WIDTH+1{1'b0}};
            rempty_r <= 1'b1;
        end else begin
            rbin_r   <= rbin_next;
            rgray_r  <= rgray_next;
            rempty_r <= rempty_next;
        end
    end

    assign raddr  = rbin_r[ADDR_WIDTH-1:0];
    assign rbin   = rbin_r;
    assign rgray  = rgray_r;
    assign rempty = rempty_r;
endmodule
