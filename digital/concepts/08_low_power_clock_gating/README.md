# Low Power Design

Low power design은 회로의 성능과 기능을 유지하면서 불필요한 power dissipation을 줄이는 설계 관점이다. Clock gating은 중요한 기법이지만, 전체 low power 설계 중 dynamic power를 줄이는 한 방법으로 보는 것이 적절하다.

## 목차

1. [Power Dissipation Sources](./01_power_dissipation_sources.md)
2. [Static Power](./02_static_power.md)
3. [Dynamic Power](./03_dynamic_power.md)
4. [Power Management Techniques](./04_power_management_techniques.md)
5. [Clock Gating](./05_clock_gating.md)
6. [Power Gating](./06_power_gating.md)
7. [Multi-Voltage and Power Domain](./07_multi_voltage_power_domain.md)
8. [Isolation, Level Shifter, and Retention](./08_isolation_level_shifter_retention.md)
9. [UPF Basics](./09_upf_basics.md)
10. [Low Power Interview Checklist](./10_low_power_interview_checklist.md)

## 핵심 관점

- 전체 power는 크게 dynamic power와 static power로 나눌 수 있다.
- Dynamic power는 switching activity, capacitance, voltage, frequency에 의해 결정된다.
- Static power는 회로가 switching하지 않아도 발생하는 leakage 성분이다.
- Clock gating은 idle logic의 clock switching을 줄여 dynamic power를 낮춘다.
- Power gating은 idle power domain의 supply를 차단해 static power를 낮춘다.
- Multi-voltage design에서는 voltage domain crossing을 위해 level shifter가 필요하다.
- Power-gated domain에서는 off domain output을 안전한 값으로 묶기 위해 isolation cell이 필요하다.
- State 보존이 필요한 block은 retention cell을 사용한다.
- UPF는 power intent를 RTL과 별도로 표현하는 형식이다.

## 학습 방향

이 대단원은 power의 원인 → power 절감 기법 → multi-power domain special cell → UPF 기초 순서로 정리한다. RTL 설계자 관점에서는 dynamic power와 clock gating을 먼저 이해하고, 이후 SoC integration 관점에서 power gating, isolation, retention, UPF로 확장하는 것이 좋다.
