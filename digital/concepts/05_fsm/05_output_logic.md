# Output Logic

## Moore style output

Moore style output은 state에 따라 결정된다.

```verilog
always @(*) begin
    busy = 1'b0;
    done_pulse = 1'b0;

    case (state)
        RUN:  busy = 1'b1;
        DONE: done_pulse = 1'b1;
        default: begin
            busy = 1'b0;
            done_pulse = 1'b0;
        end
    endcase
end
```

## Mealy style output

Mealy style output은 state와 input에 함께 의존한다.

```verilog
always @(*) begin
    accept = 1'b0;

    if (state == IDLE && valid)
        accept = 1'b1;
end
```

## Output timing

FSM output이 같은 cycle에 반응해야 하는지, register를 거쳐 다음 cycle에 나가도 되는지 명확히 해야 한다. output timing은 interface protocol과 연결된다.


## Registered output

FSM output을 조합논리로 바로 내보내지 않고 clock edge에서 register에 저장해 출력하는 방식도 있다. 이 방식은 output glitch를 줄이고 downstream timing을 단순하게 만들 수 있지만, output latency가 1 cycle 증가할 수 있다. 자세한 내용은 [Registered Output FSM](./06_registered_output_fsm.md)에서 다룬다.
