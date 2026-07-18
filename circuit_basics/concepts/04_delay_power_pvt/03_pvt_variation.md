# 4-3. PVT Variation

PVT는 process, voltage, temperature를 의미한다. 회로의 delay, leakage, noise margin은 PVT 조건에 따라 변한다.

## Process

Process variation은 제조 편차로 transistor 특성이 달라지는 것을 의미한다.

```text
fast corner : transistor가 빠름, leakage가 클 수 있음
slow corner : transistor가 느림, timing이 나빠질 수 있음
```

## Voltage

VDD가 낮아지면 drive current가 감소하고 delay가 증가한다. 동시에 dynamic power는 VDD 제곱에 비례해 줄어든다.

```text
VDD 감소 -> power 감소, delay 증가
VDD 증가 -> speed 증가, power 증가
```

## Temperature

온도가 올라가면 일반적으로 mobility가 감소해 delay가 증가할 수 있고, leakage는 증가한다. 단, 세부 동작은 공정과 전압 영역에 따라 달라질 수 있다.

## Timing corner

STA에서는 worst-case setup, worst-case hold 조건을 다른 corner에서 본다.

- setup은 느린 cell, 낮은 voltage, 높은 temperature 같은 slow 조건이 중요하다.
- hold는 너무 빠른 data path가 문제가 되므로 fast 조건이 중요하다.

## 설계 관점

PVT는 “typical simulation에서 잘 됐다”가 충분하지 않은 이유이다. 실제 chip은 corner 전체에서 동작해야 한다.
