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
