# FSM Model

## 핵심 관점

FSM은 복잡한 control logic을 state와 state transition으로 표현하는 방법이다. 가능한 상태와 전이 조건을 명확히 정의해 동작을 구조화한다.

## 기본 구성

FSM은 다음 요소로 구성된다.

- state
- input
- output
- next-state logic
- state register
- output logic

일반적인 구조는 다음과 같다.

```text
current_state + inputs → next_state
current_state + inputs → outputs
clock edge → current_state update
```

## 사용 예

- sequence detector
- traffic light controller
- UART controller
- bus protocol controller
- memory controller
