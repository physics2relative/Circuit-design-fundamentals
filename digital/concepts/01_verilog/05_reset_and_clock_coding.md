# Reset and Clock Coding

## 핵심 관점

Clock과 reset은 RTL 전체의 state update 기준입니다. Verilog에서는 sensitivity list와 조건문 순서가 reset 방식과 우선순위를 표현합니다.

## Synchronous reset

```verilog
always @(posedge clk) begin
    if (rst)
        q <= 1'b0;
    else
        q <= d;
end
```

특징:

- reset도 clock edge에서 반영됩니다.
- timing 분석이 상대적으로 단순합니다.
- clock이 동작해야 reset이 적용됩니다.

## Asynchronous reset

```verilog
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        q <= 1'b0;
    else
        q <= d;
end
```

특징:

- clock과 무관하게 reset assertion이 가능합니다.
- reset deassertion timing에는 주의가 필요합니다.
- active-low reset은 `negedge rst_n` 형태로 자주 표현합니다.

## Reset priority

```verilog
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        q <= 1'b0;
    else if (en)
        q <= d;
end
```

위 구조에서는 reset이 enable보다 우선합니다. 조건문 순서는 hardware priority를 나타낼 수 있으므로 명확히 작성해야 합니다.

## Clock enable

Clock 자체를 조합논리로 gating하기보다, 가능하면 clock enable 구조를 사용합니다.

```verilog
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        q <= 1'b0;
    else if (en)
        q <= d;
end
```

## Reset을 무조건 많이 넣는 것이 좋은가?

항상 그렇지는 않습니다.

- control register, valid bit, FSM state는 reset이 필요한 경우가 많습니다.
- 큰 datapath register는 reset tree 부담을 줄이기 위해 reset하지 않고 valid bit로 관리할 수 있습니다.
- reset 정책은 design style, target, verification strategy에 따라 결정합니다.

깊은 reset timing, recovery/removal, CDC reset release 문제는 `../05_timing_cdc/`에서 다룹니다.

## 면접 질문

### Q. Synchronous reset과 asynchronous reset의 차이는?

면접 답변:

> Synchronous reset은 clock edge에서 reset이 반영되고, asynchronous reset은 clock과 무관하게 reset assertion이 가능합니다. Async reset은 빠른 초기화에 유리하지만 deassertion timing을 주의해야 하고, sync reset은 timing 분석과 coding style이 상대적으로 단순합니다.

### Q. Gated clock보다 clock enable을 선호하는 이유는?

면접 답변:

> 조합논리로 clock을 직접 gating하면 glitch나 skew 문제가 생길 수 있습니다. 일반 RTL 수준에서는 clock enable을 사용해 register update 여부를 제어하는 방식이 더 안전하고 timing 분석도 명확합니다.
