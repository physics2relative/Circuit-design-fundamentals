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
    localparam DEPTH = (1 << ADDR_WIDTH);

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    reg [ADDR_WIDTH:0] wbin;
    reg [ADDR_WIDTH:0] wgray;
    reg [ADDR_WIDTH:0] wq1_rgray;
    reg [ADDR_WIDTH:0] wq2_rgray;

    reg [ADDR_WIDTH:0] rbin;
    reg [ADDR_WIDTH:0] rgray;
    reg [ADDR_WIDTH:0] rq1_wgray;
    reg [ADDR_WIDTH:0] rq2_wgray;
    reg                wfull_r;
    reg                rempty_r;

    wire                wpush;
    wire                rpop;
    wire [ADDR_WIDTH:0] wbin_next;
    wire [ADDR_WIDTH:0] wgray_next;
    wire [ADDR_WIDTH:0] rbin_next;
    wire [ADDR_WIDTH:0] rgray_next;
    wire                wfull_next;
    wire                rempty_next;

    function [ADDR_WIDTH:0] bin2gray;
        input [ADDR_WIDTH:0] bin;
        begin
            bin2gray = (bin >> 1) ^ bin;
        end
    endfunction

    assign wpush      = winc && !wfull;
    assign rpop       = rinc && !rempty;
    assign wbin_next  = wbin + {{ADDR_WIDTH{1'b0}}, wpush};
    assign wgray_next = bin2gray(wbin_next);
    assign rbin_next  = rbin + {{ADDR_WIDTH{1'b0}}, rpop};
    assign rgray_next = bin2gray(rbin_next);

    assign wfull_next = (wgray_next == {~wq2_rgray[ADDR_WIDTH:ADDR_WIDTH-1],
                                         wq2_rgray[ADDR_WIDTH-2:0]});
    assign rempty_next = (rgray_next == rq2_wgray);
    assign wfull = wfull_r;
    assign rempty = rempty_r;
    assign rdata  = mem[rbin[ADDR_WIDTH-1:0]];

    assign wbin_dbg       = wbin;
    assign rbin_dbg       = rbin;
    assign wgray_dbg      = wgray;
    assign rgray_dbg      = rgray;
    assign wq2_rgray_dbg  = wq2_rgray;
    assign rq2_wgray_dbg  = rq2_wgray;

    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            wbin      <= {ADDR_WIDTH+1{1'b0}};
            wgray     <= {ADDR_WIDTH+1{1'b0}};
            wq1_rgray <= {ADDR_WIDTH+1{1'b0}};
            wq2_rgray <= {ADDR_WIDTH+1{1'b0}};
            wfull_r   <= 1'b0;
        end else begin
            wq1_rgray <= rgray;
            wq2_rgray <= wq1_rgray;
            wbin      <= wbin_next;
            wgray     <= wgray_next;
            wfull_r   <= wfull_next;
            if (wpush) begin
                mem[wbin[ADDR_WIDTH-1:0]] <= wdata;
            end
        end
    end

    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            rbin      <= {ADDR_WIDTH+1{1'b0}};
            rgray     <= {ADDR_WIDTH+1{1'b0}};
            rq1_wgray <= {ADDR_WIDTH+1{1'b0}};
            rq2_wgray <= {ADDR_WIDTH+1{1'b0}};
            rempty_r  <= 1'b1;
        end else begin
            rq1_wgray <= wgray;
            rq2_wgray <= rq1_wgray;
            rbin      <= rbin_next;
            rgray     <= rgray_next;
            rempty_r  <= rempty_next;
        end
    end
endmodule
