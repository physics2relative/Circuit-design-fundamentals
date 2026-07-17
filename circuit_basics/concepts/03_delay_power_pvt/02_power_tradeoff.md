# 3-2. Power Trade-off

Power 최적화는 dynamic power, short-circuit power, leakage power를 구분해서 봐야 한다.

## Dynamic power

```text
Pdynamic ≈ alpha * CL * VDD^2 * f
```

Dynamic power를 줄이는 방법은 다음과 같다.

- switching activity 감소
- clock gating
- operand isolation
- capacitance 감소
- voltage/frequency 감소

## Leakage power

Leakage power는 회로가 idle 상태일 때도 발생한다.

```text
Pstatic ≈ VDD * Ileakage
```

Leakage를 줄이는 방법은 다음과 같다.

- high-VTH cell 사용
- power gating
- body bias
- sleep mode 설계

## Short-circuit power

Short-circuit power는 input transition 중 pull-up과 pull-down이 동시에 켜질 때 발생한다. Input slew가 나쁘거나 output load와 drive balance가 맞지 않으면 증가할 수 있다.

## Trade-off

```text
speed 개선  -> low VTH, 큰 cell, 높은 VDD -> power 증가 가능
power 절감  -> high VTH, 낮은 VDD, gating -> speed/area/복잡도 비용 가능
area 절감   -> 작은 cell, shared logic -> delay 증가 가능
```

PPA는 performance, power, area의 균형 문제이다.
