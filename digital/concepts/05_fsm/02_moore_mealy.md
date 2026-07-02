# Moore and Mealy

## Moore machine

Moore machine은 output이 current state에만 의존하는 FSM이다.

```text
output = f(state)
```

장점은 output이 state register를 기준으로 안정적이라는 점이다. timing 분석과 glitch 관리가 상대적으로 쉽다. 단점은 input 변화에 대한 반응이 한 cycle 늦어질 수 있고, state 수가 증가할 수 있다는 점이다.

## Mealy machine

Mealy machine은 output이 current state와 input에 함께 의존하는 FSM이다.

```text
output = f(state, input)
```

장점은 input 변화에 빠르게 반응할 수 있고 state 수를 줄일 수 있다는 점이다. 단점은 input glitch나 timing path에 더 민감할 수 있다는 점이다.

## 선택 기준

- output 안정성이 중요하면 Moore가 단순하다.
- 빠른 반응이나 state 수 감소가 중요하면 Mealy가 유리할 수 있다.
- Mealy output은 input timing과 glitch에 주의해야 한다.
