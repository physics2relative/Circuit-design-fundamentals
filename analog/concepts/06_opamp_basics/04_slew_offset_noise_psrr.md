# 6-4. Slew Rate, Offset, Noise, PSRR

## Slew rate

Slew rate는 output이 시간당 얼마나 빠르게 변할 수 있는지이다.

```text
SR = max(dVout/dt)
```

Two-stage op-amp에서는 compensation capacitor를 충전/방전하는 current가 slew rate를 제한한다.

```text
SR ≈ Ibias / Cc
```

## Offset

Input offset은 output을 0으로 만들기 위해 필요한 differential input voltage이다. Input pair mismatch와 load mismatch가 주요 원인이다.

## Noise

Input-referred noise는 op-amp가 작은 신호를 얼마나 깨끗하게 증폭할 수 있는지 나타낸다. Thermal noise와 flicker noise가 중요하다.

## PSRR

PSRR은 supply 변동이 output에 얼마나 나타나는지 나타낸다.

```text
PSRR = supply gain에 대한 signal gain의 비
```

Bias 회로와 current mirror, gain stage 구조가 PSRR에 영향을 준다.
