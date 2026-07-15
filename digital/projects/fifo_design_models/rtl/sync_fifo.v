module sync_fifo #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 3
) (
    input  wire                  clk,
    input  wire                  rst_n,

    input  wire                  in_valid,
    output wire                  in_ready,
    input  wire [DATA_WIDTH-1:0] in_data,

    output wire                  out_valid,
    input  wire                  out_ready,
    output wire [DATA_WIDTH-1:0] out_data,

    output wire                  full,
    output wire                  empty,
    output wire [ADDR_WIDTH:0]   count
);
    localparam DEPTH = (1 << ADDR_WIDTH);

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    reg [ADDR_WIDTH:0]   wptr;
    reg [ADDR_WIDTH:0]   rptr;
    reg [ADDR_WIDTH:0]   used;

    wire push;
    wire pop;

    assign full      = (used == DEPTH[ADDR_WIDTH:0]);
    assign empty     = (used == {ADDR_WIDTH+1{1'b0}});
    assign in_ready  = !full;
    assign out_valid = !empty;
    assign push      = in_valid && in_ready;
    assign pop       = out_valid && out_ready;
    assign out_data  = mem[rptr[ADDR_WIDTH-1:0]];
    assign count     = used;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wptr <= {ADDR_WIDTH+1{1'b0}};
            rptr <= {ADDR_WIDTH+1{1'b0}};
            used <= {ADDR_WIDTH+1{1'b0}};
        end else begin
            if (push) begin
                mem[wptr[ADDR_WIDTH-1:0]] <= in_data;
                wptr <= wptr + {{ADDR_WIDTH{1'b0}}, 1'b1};
            end

            if (pop) begin
                rptr <= rptr + {{ADDR_WIDTH{1'b0}}, 1'b1};
            end

            case ({push, pop})
                2'b10: used <= used + {{ADDR_WIDTH{1'b0}}, 1'b1};
                2'b01: used <= used - {{ADDR_WIDTH{1'b0}}, 1'b1};
                default: used <= used;
            endcase
        end
    end
endmodule
