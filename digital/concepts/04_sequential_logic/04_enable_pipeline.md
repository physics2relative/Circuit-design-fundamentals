# Enable and Pipeline Register

## Enable

Enable은 clock은 계속 공급하되 register update 여부를 제어하는 signal이다.

```verilog
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        q <= 1'b0;
    else if (en)
        q <= d;
end
```

`en`이 0이면 register는 이전 값을 유지한다. Clock gating과 달리 clock 자체를 직접 가공하지 않는다.

## Pipeline register

Pipeline register는 긴 combinational path를 여러 stage로 나누기 위해 삽입하는 register이다.

```text
logic A → reg → logic B → reg → logic C
```

Pipeline은 clock frequency를 높일 수 있지만 latency가 증가한다.

## Alignment

Pipeline에서는 data와 control signal의 cycle alignment가 중요하다. valid, tag, control bit가 data와 같은 stage를 따라 이동해야 한다.
