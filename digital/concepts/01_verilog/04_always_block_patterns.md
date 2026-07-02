# Always Block Patterns

## 핵심 관점

`always` block은 Verilog RTL의 의도를 가장 직접적으로 드러냅니다. 중요한 것은 block을 **조합논리용**과 **순차논리용**으로 명확히 나누는 것입니다.

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

핵심:

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

핵심:

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

FSM이나 복잡한 control logic은 보통 next-state 조합논리와 state register를 분리합니다.

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

FSM 자체의 설계법은 `../04_fsm/`에서 다루고, 여기서는 Verilog 표현 패턴만 정리합니다.

## 면접 질문

### Q. `always @(*)`를 쓰는 이유는?

면접 답변:

> 조합논리 block의 sensitivity list를 자동으로 구성하기 위해 사용합니다. 직접 sensitivity list를 작성하다가 입력 신호를 빠뜨리면 simulation behavior와 의도한 조합논리가 달라질 수 있습니다.

### Q. 조합 always block에서 default assignment를 넣는 이유는?

면접 답변:

> 모든 path에서 output이 결정되도록 하기 위해서입니다. 일부 조건에서 값이 assign되지 않으면 이전 값을 유지해야 하는 것으로 해석되어 unintended latch가 생길 수 있습니다.
