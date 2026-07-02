# Reset and Clock Coding

## 핵심 관점

Clock과 reset은 RTL 전체의 state update 기준이다. Verilog에서는 sensitivity list와 조건문 순서가 reset 방식과 우선순위를 표현한다.

## Synchronous reset

```verilog
always @(posedge clk) begin
    if (rst)
        q <= 1'b0;
    else
        q <= d;
end
```

특징은 다음과 같다.

- reset도 clock edge에서 반영된다.
- timing 분석이 상대적으로 단순하다.
- clock이 동작해야 reset이 적용된다.

## Asynchronous reset

```verilog
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        q <= 1'b0;
    else
        q <= d;
end
```

특징은 다음과 같다.

- clock과 무관하게 reset assertion이 가능하다.
- reset deassertion timing에는 주의가 필요하다.
- active-low reset은 `negedge rst_n` 형태로 자주 표현한다.

## Reset priority

```verilog
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        q <= 1'b0;
    else if (en)
        q <= d;
end
```

위 구조에서는 reset이 enable보다 우선한다. 조건문 순서는 hardware priority를 나타낼 수 있으므로 명확히 작성해야 한다.

## Clock enable

Clock 자체를 조합논리로 gating하기보다, 가능하면 clock enable 구조를 사용한다.

```verilog
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        q <= 1'b0;
    else if (en)
        q <= d;
end
```

## Reset 대상 선택

모든 register를 무조건 reset하는 것이 항상 좋은 것은 아니다.

- control register, valid bit, FSM state는 reset이 필요한 경우가 많다.
- 큰 datapath register는 reset tree 부담을 줄이기 위해 reset하지 않고 valid bit로 관리할 수 있다.
- reset 정책은 design style, target, verification strategy에 따라 결정한다.

깊은 reset timing, recovery/removal, CDC reset release 문제는 `../05_timing_cdc/`에서 다룬다.

## 정리

Reset과 enable은 조건문 순서로 priority가 표현된다. Clock은 RTL의 기준 신호이므로 조합논리로 함부로 가공하지 않고, 일반적인 RTL에서는 clock enable을 사용하는 방식이 안전하다.
