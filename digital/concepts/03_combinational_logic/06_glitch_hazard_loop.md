# Glitch, Hazard, and Combinational Loop

## Glitch / Hazard

조합논리에서는 input이 동시에 바뀌더라도 각 path의 delay가 다르기 때문에 output에 짧은 pulse가 생길 수 있다. 이를 glitch 또는 hazard라고 한다.

특히 다음 신호에서 위험하다.

- clock
- reset
- clock enable
- asynchronous control signal
- CDC input

일반 datapath signal의 glitch는 register sampling 시점에 안정되면 문제가 되지 않을 수 있다. 하지만 clock/reset 같은 민감한 신호에 조합논리 glitch가 들어가면 심각한 문제가 된다.

## Combinational loop

Combinational loop는 조합논리 출력이 다시 자기 입력으로 돌아가는 구조이다.

```text
a → logic → b → logic → a
```

의도하지 않은 oscillation, simulation 불안정, timing 분석 실패를 만들 수 있다. 대부분 RTL bug로 간주한다.

## 정리

조합논리는 function correctness뿐 아니라 delay, glitch, loop 여부까지 확인해야 한다.
