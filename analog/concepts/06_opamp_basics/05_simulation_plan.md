# 6-5. Simulation Plan

Op-amp는 여러 simulation을 조합해서 검증한다.

## DC operating point

확인:

```text
모든 transistor saturation 여부
bias current
input/output common-mode
headroom
power
```

## Open-loop AC

확인:

```text
DC gain
unity-gain bandwidth
phase margin
pole/zero
```

## Closed-loop transient

확인:

```text
step response
overshoot/ringing
settling time
small-signal/large-signal 응답
```

## Slew rate

큰 step input을 넣고 output slope를 측정한다.

```text
SR+ / SR-
```

## Noise / offset / corner

가능하면 다음을 수행한다.

```text
noise simulation -> input-referred noise
Monte Carlo -> offset distribution
PVT corner -> gain/UGB/PM/SR 변화
load sweep -> capacitive load 안정성
```
