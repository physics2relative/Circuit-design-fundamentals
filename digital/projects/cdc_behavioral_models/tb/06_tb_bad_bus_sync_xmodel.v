`timescale 1ns/1ps

module tb_06_bad_bus_sync_xmodel;
    reg clk_src;
    reg clk_dst;
    reg rst_src_n;
    reg rst_dst_n;
    reg [3:0] src_bus;
    reg [3:0] src_bus_next;
    wire [3:0] dst_bus;

    bad_bus_sync_xmodel #(
        .WIDTH    (4),
        .SETUP_NS (1.0),
        .HOLD_NS  (1.0)
    ) u_bad_bus_sync_xmodel (
        .clk_dst   (clk_dst),
        .rst_n     (rst_dst_n),
        .async_bus (src_bus),
        .sync_bus  (dst_bus)
    );

    // Destination clock: 10 ns period, posedges at 5, 15, 25, ... ns.
    initial clk_dst = 1'b0;
    always #5 clk_dst = ~clk_dst;

    // Source clock: 12 ns period with an 8 ns initial offset.
    // Posedges occur at 8, 20, 32, 44, 56, ... ns, so some source
    // launches intentionally land close to destination sampling edges.
    initial begin
        clk_src = 1'b0;
        #2;
        forever #6 clk_src = ~clk_src;
    end

    always @(posedge clk_src or negedge rst_src_n) begin
        if (!rst_src_n)
            src_bus <= 4'b0000;
        else
            src_bus <= src_bus_next;
    end

    task launch_on_next_src_edge;
        input [3:0] value;
        begin
            @(negedge clk_src);
            src_bus_next = value;
            @(posedge clk_src);
        end
    endtask

    initial begin
        rst_src_n = 1'b0;
        rst_dst_n = 1'b0;
        src_bus_next = 4'b0000;

        #23;
        rst_src_n = 1'b1;
        rst_dst_n = 1'b1;

        // The bus is now launched by a source-domain FF on clk_src.
        // Destination still receives it as an asynchronous multi-bit bus.
        @(posedge clk_src);              // 32 ns: keep 0000 after reset
        launch_on_next_src_edge(4'b0011); // launch at 44 ns: 1 ns before dst posedge at 45 ns
        launch_on_next_src_edge(4'b1100); // launch at 56 ns: 1 ns after dst posedge at 55 ns

        repeat (3) @(posedge clk_src);    // 68, 80, 92 ns: hold previous bus value
        launch_on_next_src_edge(4'b0111); // launch at 104 ns: 1 ns before dst posedge at 105 ns
        launch_on_next_src_edge(4'b1000); // launch at 116 ns: 1 ns after dst posedge at 115 ns

        #80;
        $display("06 bad_bus_sync_xmodel done. Source-clock-launched multi-bit bus shows bitwise CDC incoherency/X risk.");
        $finish;
    end
endmodule
