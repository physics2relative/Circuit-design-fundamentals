# Multi-Voltage and Power Domain

## Multi-voltage design

Multi-voltage design은 block마다 다른 supply voltage를 사용하는 설계 방식이다. 성능이 중요한 block은 높은 voltage를 사용하고, 성능 요구가 낮은 block은 낮은 voltage를 사용해 dynamic power를 줄일 수 있다.

```text
High-performance domain: high VDD
Low-power domain       : low VDD
```

Dynamic power는 `V^2`에 비례하므로 voltage를 낮추면 power 절감 효과가 크다.

## Voltage domain

Voltage domain은 같은 voltage level을 사용하는 logic 묶음이다. 서로 다른 voltage domain 사이에서 signal이 이동하면 voltage level 차이 때문에 receiver가 정상적으로 값을 인식하지 못할 수 있다.

이때 level shifter가 필요하다.

## Power domain

Power domain은 power on/off control이 같은 logic 묶음이다. Voltage domain과 power domain은 관련이 있지만 완전히 같은 개념은 아니다.

예를 들어 같은 voltage를 쓰더라도 한 block은 항상 켜져 있고 다른 block은 power gated일 수 있다.

## SVS

SVS(static voltage scaling)는 mode별로 정해진 voltage level을 사용하는 방식이다. 예를 들어 low-power mode에서는 낮은 voltage를 사용하고 performance mode에서는 높은 voltage를 사용할 수 있다.

## DVFS

DVFS(dynamic voltage and frequency scaling)는 runtime workload에 따라 voltage와 frequency를 동적으로 조절하는 방식이다.

```text
낮은 workload -> 낮은 V, 낮은 f
높은 workload -> 높은 V, 높은 f
```

Voltage를 낮추면 delay가 증가하므로 frequency도 함께 낮추는 경우가 많다. DVFS에서는 voltage/frequency transition sequence와 timing sign-off가 중요하다.

## Voltage domain crossing

Voltage domain crossing에서는 다음을 확인해야 한다.

- Low-to-high crossing에서 signal high level이 충분한가
- High-to-low crossing에서 receiver가 over-stress되지 않는가
- Level shifter 위치가 적절한가
- Power state에 따라 source/destination domain이 on인지 off인지

## Power state table

Multi-power domain 설계에서는 각 domain이 어떤 power state를 가질 수 있는지 정의해야 한다.

예시는 다음과 같다.

```text
Performance mode: CPU on, SRAM on, PERI on
Sleep mode      : CPU off, SRAM retention, PERI off
Always-on mode  : AON on
```

UPF에서는 power state table(PST)로 이런 조합을 표현할 수 있다.

## 핵심 정리

- Multi-voltage design은 voltage를 낮춰 dynamic power를 줄이는 기법이다.
- Voltage domain crossing에는 level shifter가 필요할 수 있다.
- Power domain은 on/off control 기준이고, voltage domain은 voltage level 기준이다.
- DVFS는 workload에 따라 voltage와 frequency를 함께 조절한다.
- Multi-domain 설계에서는 power state 조합을 명확히 정의해야 한다.
