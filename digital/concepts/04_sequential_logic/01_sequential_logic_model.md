# Sequential Logic Model

## 핵심 관점

Sequential logic은 현재 입력뿐 아니라 저장된 state에 의해 출력이나 다음 state가 결정되는 logic이다.

```text
next_state = f(current_state, current_inputs)
output     = g(current_state, current_inputs)
```

state는 clock edge를 기준으로 update된다.

## Synchronous design

일반적인 digital RTL은 flip-flop 기반 synchronous design을 사용한다. 모든 state update를 clock edge 기준으로 맞추면 timing 분석과 검증이 명확해진다.

## State

State는 회로가 과거 입력의 영향을 저장한 값이다. register, counter, FSM state, valid bit 등이 state에 해당한다.
