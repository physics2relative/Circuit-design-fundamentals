# FSM Interview Checklist

## FSM의 정의

FSM은 control logic을 state, input, transition, output으로 구조화하는 방법이다. 복잡한 control sequence를 명확히 표현할 때 사용한다.

```text
current state + input -> next state
current state/input -> output
```

## Moore와 Mealy

Moore FSM은 output이 current state에만 의존한다. Output이 안정적이고 timing 분석이 쉽지만, input 변화에 반응하려면 state transition을 기다려야 해서 latency가 생길 수 있다.

Mealy FSM은 output이 current state와 input에 의존한다. 빠르게 반응할 수 있고 state 수를 줄일 수 있지만, input glitch와 combinational timing에 민감하다.

## Registered output FSM

Registered output FSM은 output을 combinational로 바로 내보내지 않고 clock edge에서 register에 저장한 뒤 내보낸다.

장점은 다음과 같다.

- output glitch가 줄어든다.
- downstream datapath 입장에서 register output에서 시작하는 path가 된다.
- output timing이 명확해진다.

단점은 output latency가 1 cycle 증가할 수 있다는 점이다.

## State encoding

대표 encoding은 다음과 같다.

- Binary encoding: state bit 수가 적다.
- One-hot encoding: flop 수는 많지만 next-state logic이 단순할 수 있다.
- Gray encoding: 인접 state 전이에서 bit change를 줄일 수 있다.

FPGA에서는 one-hot이 유리할 수 있고, ASIC에서는 state 수와 timing, area에 따라 선택한다.

## FSM RTL 구조

일반적인 FSM RTL 구조는 다음과 같다.

```text
1. state register
2. next-state combinational logic
3. output logic
```

면접에서는 2-block 또는 3-block style을 설명할 수 있으면 좋다. 중요한 것은 state update, next-state 계산, output 계산이 명확히 분리되는 것이다.

## Output logic

FSM output은 Moore, Mealy, registered output 중 어떤 방식인지 명확히 해야 한다. Output이 datapath enable, write enable, valid 같은 민감한 control이면 glitch와 timing을 특히 조심해야 한다.

## Illegal state recovery

FSM이 reset 또는 soft error 등으로 정의되지 않은 state에 들어갈 수 있다. Safety가 중요한 FSM은 default branch에서 safe state로 복구하는 방식을 고려한다.

다만 synthesis optimization이 illegal state를 don't-care로 처리하지 않도록 coding style과 constraint를 확인해야 한다.

## 검증 포인트

- reset 후 initial state
- 모든 state transition
- invalid input 조합
- back-to-back transaction
- output pulse width
- enable/valid timing
- illegal state recovery

## 핵심 답변 문장

- FSM은 control sequence를 state와 transition으로 구조화한 회로이다.
- Moore는 output이 state에만 의존하고, Mealy는 state와 input에 의존한다.
- Registered output FSM은 glitch와 downstream timing에 유리하지만 latency가 증가할 수 있다.
- State encoding은 area, timing, target technology에 따라 선택한다.
- 좋은 FSM은 state, transition, output timing, recovery 정책이 명확하다.
