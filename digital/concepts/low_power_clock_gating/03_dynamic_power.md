# Dynamic Power

## Dynamic power의 의미

Dynamic power는 signal이 switching할 때 load capacitance를 충전하고 방전하면서 발생하는 power이다. Digital logic에서 activity가 많을수록 dynamic power가 증가한다.

대표적인 식은 다음과 같다.

```text
Pdynamic = α C V^2 f
```

여기서 각 항의 의미는 다음과 같다.

- `α`: switching activity factor
- `C`: load capacitance
- `V`: supply voltage
- `f`: clock frequency

## Switching activity

Switching activity는 signal이 얼마나 자주 toggle되는지를 나타낸다. 같은 회로라도 data pattern, enable condition, workload에 따라 dynamic power가 달라진다.

RTL 설계에서 activity를 줄이는 방법은 다음과 같다.

- Idle block의 enable을 끈다.
- 불필요한 counter/free-running logic을 줄인다.
- Wide bus toggle을 줄인다.
- Datapath input을 필요할 때만 바뀌게 한다.
- Clock gating을 적용한다.

## Load capacitance

Load capacitance가 클수록 한 번 switching할 때 더 많은 charge가 필요하다. Fanout이 큰 net, long wire, large gate input, clock tree는 capacitance가 커질 수 있다.

Physical design 관점에서는 placement, buffering, routing, cell sizing이 capacitance와 power에 영향을 준다.

## Voltage 영향

Dynamic power는 voltage의 제곱에 비례한다.

```text
Pdynamic ∝ V^2
```

따라서 supply voltage를 낮추면 dynamic power를 크게 줄일 수 있다. 하지만 voltage를 낮추면 delay가 증가하고 timing closure가 어려워질 수 있다.

## Frequency 영향

Dynamic power는 frequency에 비례한다. Clock frequency를 낮추면 switching 횟수가 줄어 power가 감소한다.

DVFS(dynamic voltage and frequency scaling)는 workload에 따라 voltage와 frequency를 함께 조절하는 대표적인 power management 기법이다.

## Short-circuit power

Short-circuit power는 input transition 동안 PMOS와 NMOS가 순간적으로 동시에 켜져 VDD에서 GND로 current가 흐를 때 발생한다.

Input transition이 느리거나 load condition이 좋지 않으면 short-circuit power가 증가할 수 있다. 실제 power 분석에서는 switching power와 함께 고려된다.

## 핵심 정리

- Dynamic power는 switching할 때 발생한다.
- 기본 식은 `Pdynamic = α C V^2 f`이다.
- Clock gating은 주로 `α`를 줄이는 기법이다.
- Voltage scaling은 `V^2` 항 때문에 power 감소 효과가 크지만 timing에 영향을 준다.
- Short-circuit power는 input transition 중 pull-up/pull-down path가 동시에 열리며 발생한다.
