# Always Block Patterns

## 핵심 관점

`always` block은 Verilog RTL의 의도를 가장 직접적으로 드러낸다. 중요한 것은 block을 **조합논리용**과 **순차논리용**으로 명확히 나누는 것이다.

## Combinational pattern

```verilog
always @(*) begin
    y = 1'b0;

    case (sel)
        2'b00: y = a;
        2'b01: y = b;
        2'b10: y = c;
        2'b11: y = d;
        default: y = 1'b0;
    endcase
end
```

핵심은 다음과 같다.

- `always @(*)` 사용
- blocking assignment 사용
- block 시작에서 default assignment
- 모든 branch에서 output 결정

## Sequential pattern

```verilog
always @(posedge clk) begin
    q <= d;
end
```

핵심은 다음과 같다.

- clock edge 기준 update
- non-blocking assignment 사용
- state/register update를 한 cycle 단위로 이해

## Async reset pattern

```verilog
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        q <= 1'b0;
    else
        q <= d;
end
```

## Next-state / state-register split

FSM이나 복잡한 control logic은 보통 next-state 조합논리와 state register를 분리한다.

```verilog
always @(*) begin
    next_state = state;

    case (state)
        IDLE: begin
            if (start)
                next_state = RUN;
        end
        RUN: begin
            if (done)
                next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        state <= IDLE;
    else
        state <= next_state;
end
```

FSM 자체의 설계법은 `../05_fsm/`에서 다루고, 여기서는 Verilog 표현 패턴만 정리한다.

## 정리

`always @(*)` block은 값이 유지되지 않도록 모든 path를 assign해야 한다. `always @(posedge clk)` block은 clock edge에서 state가 update되는 구조로 해석해야 한다. 두 block의 역할을 섞지 않는 것이 기본이다.
