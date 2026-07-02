# FSM RTL Structure

## 핵심 관점

일반적인 FSM RTL은 next-state logic과 state register를 분리한다.

## Next-state logic

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
                next_state = DONE;
        end
        DONE: begin
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end
```

## State register

```verilog
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        state <= IDLE;
    else
        state <= next_state;
end
```

## 기본 원칙

- state register는 clocked always block에 둔다.
- next-state logic은 조합논리로 작성한다.
- next_state에는 default assignment를 둔다.
- default branch에서 safe state로 복구한다.
