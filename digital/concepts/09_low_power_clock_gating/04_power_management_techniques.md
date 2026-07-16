# Power Management Techniques

## Power management의 목적

Power management는 회로의 성능, 면적, 검증 복잡도와 trade-off하면서 power를 낮추는 설계 기법들의 집합이다. 어떤 기법을 쓸지는 줄이고 싶은 power 성분과 system 요구사항에 따라 달라진다.

## Multi-Vt design

Multi-Vt design은 threshold voltage가 다른 standard cell을 함께 사용하는 방식이다.

```text
Low-Vt  : 빠름, leakage 큼
High-Vt : 느림, leakage 작음
```

Timing critical path에는 빠른 cell을 쓰고, timing 여유가 있는 path에는 leakage가 작은 cell을 쓰는 방식으로 static power를 줄인다.

## Bus encoding

Bus encoding은 bus switching activity를 줄이기 위해 data encoding을 바꾸는 기법이다. Wide bus나 off-chip bus처럼 toggle power가 큰 경로에서 고려할 수 있다.

대표 개념은 다음과 같다.

- Redundant encoding: 추가 bit를 사용해 switching을 줄인다.
- Non-redundant encoding: bit 수를 늘리지 않고 mapping을 바꾼다.

Bus encoding은 encoder/decoder overhead가 있으므로 activity 감소 효과가 overhead보다 커야 의미가 있다.

## Hardware/software trade-off

Power는 hardware만의 문제가 아니다. Software가 workload, sleep mode 진입, clock frequency, voltage level, peripheral enable을 제어하는 경우가 많다.

예를 들어 software가 idle 상태를 빠르게 감지해 low power mode로 전환하면 system power를 줄일 수 있다. 반대로 너무 자주 sleep/wake-up을 반복하면 wake-up overhead 때문에 이득이 줄어들 수 있다.

## Multi-Vdd design

Multi-Vdd design은 block마다 다른 supply voltage를 사용하는 기법이다. Timing critical block은 높은 voltage를 쓰고, 성능 요구가 낮은 block은 낮은 voltage를 써서 power를 줄인다.

Multi-Vdd에서는 서로 다른 voltage domain 사이에 level shifter가 필요할 수 있다.

## SVS와 DVFS

SVS(static voltage scaling)는 operating mode별로 고정된 voltage level을 사용하는 방식이다.

DVFS(dynamic voltage and frequency scaling)는 runtime workload에 따라 voltage와 frequency를 함께 조절하는 방식이다.

```text
High performance mode: 높은 V, 높은 f
Low power mode       : 낮은 V, 낮은 f
```

DVFS는 power를 크게 줄일 수 있지만, voltage/frequency transition sequence와 timing 검증이 중요하다.

## Clock gating

Clock gating은 idle block의 clock을 차단해 dynamic power를 줄이는 기법이다. Clock tree와 flip-flop clock pin switching을 줄일 수 있어 효과가 크다.

## Power gating

Power gating은 idle power domain의 supply를 차단해 static leakage를 줄이는 기법이다. Isolation, retention, power switch, wake-up sequence가 함께 필요하다.

## 핵심 정리

- Multi-Vt는 leakage와 speed의 trade-off이다.
- Bus encoding은 switching activity를 줄이기 위한 기법이다.
- Multi-Vdd, SVS, DVFS는 voltage를 조절해 power를 줄인다.
- Clock gating은 dynamic power를 줄인다.
- Power gating은 static power를 줄인다.
- Power management는 hardware, software, physical implementation이 함께 맞아야 한다.
