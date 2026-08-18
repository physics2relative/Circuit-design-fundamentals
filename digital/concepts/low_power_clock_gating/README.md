# Low Power and Clock Gating

Dynamic/static power의 원인과 clock gating의 위치를 정리하고, latch-based ICG가 glitch-free clock을 만드는 구조적 이유를 연결한다.

## Contents

1. [Power Dissipation Sources](./01_power_dissipation_sources.md)
2. [Static Power](./02_static_power.md)
3. [Dynamic Power](./03_dynamic_power.md)
4. [Power Management Techniques](./04_power_management_techniques.md)
5. [Clock Gating](./05_clock_gating.md)
6. [Integrated Clock Gating Cell](./06_integrated_clock_gating_cell.md)

Clock gating은 idle sequential logic의 clock switching을 줄여 dynamic power를 낮춘다. Enable을 clock low phase에 저장하는 latch는 high phase 동안 gating 조건을 고정하여 mid-cycle edge와 잘린 pulse를 방지한다.

## Lab

[Clock Gating ICG Experiment](../../projects/clock_gating_icg_experiment/README.md)에서 latch-based, raw AND, FF-based 구조를 같은 stimulus로 비교한다.
