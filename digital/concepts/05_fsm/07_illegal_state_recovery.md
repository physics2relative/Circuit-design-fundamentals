# Illegal State Recovery

## 핵심 관점

FSM이 정의되지 않은 state에 들어갈 가능성을 고려해야 한다. reset, soft error, X propagation, coding mistake 등으로 illegal state가 발생할 수 있다.

## Safe recovery

일반적으로 `default` branch에서 safe state로 복구한다.

```verilog
default: begin
    next_state = IDLE;
end
```

## 주의점

- default branch가 없는 FSM은 illegal state에서 빠져나오지 못할 수 있다.
- output logic도 illegal state에서 safe value를 내도록 작성한다.
- recovery state가 protocol violation을 만들지 않는지 확인한다.
