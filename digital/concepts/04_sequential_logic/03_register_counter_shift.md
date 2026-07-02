# Register, Counter, and Shift Register

## Register

Register는 하나 이상의 flip-flop으로 구성된 storage이다. datapath value, valid bit, FSM state 등을 저장한다.

```verilog
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        data_q <= 8'b0;
    else
        data_q <= data_d;
end
```

## Counter

Counter는 현재 값에 1을 더하거나 빼는 sequential circuit이다.

```verilog
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        count <= 8'b0;
    else if (en)
        count <= count + 1'b1;
end
```

Counter 설계 시 width, overflow, wrap-around, enable, reset behavior를 명확히 해야 한다.

## Shift register

Shift register는 매 clock마다 data를 한 방향으로 이동시키는 sequential circuit이다.

```verilog
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        shift <= 4'b0;
    else
        shift <= {shift[2:0], din};
end
```

Serial-to-parallel, delay line, simple filter, synchronizer 등에 사용된다.
