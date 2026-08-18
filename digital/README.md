# Digital Design

Digital 영역은 실행 가능한 RTL simulation project를 중심으로 구성한다. 개념 문서는 프로젝트의 구조와 waveform을 해석하는 데 필요한 범위만 남긴다.

## Projects

| Project | Focus | Result style |
| --- | --- | --- |
| [CDC Behavioral Models](./projects/cdc_behavioral_models/README.md) | clock/reset domain crossing 구조 비교 | waveform observation |
| [Clock Gating ICG Experiment](./projects/clock_gating_icg_experiment/README.md) | glitch-free clock gating 구조 비교 | waveform observation |
| [FIFO Design Models](./projects/fifo_design_models/README.md) | sync/async FIFO와 backpressure | self-checking testbench |

프로젝트 전체 목록과 공통 실행 조건은 [Digital Projects](./projects/README.md)에서 확인한다.

## Concepts Connected to Labs

1. [Clock, Reset, and CDC](./concepts/clock_reset_cdc/README.md) → CDC behavioral models
2. [FIFO and Interfaces](./concepts/fifo_interfaces/README.md) → FIFO design models
3. [Low Power and Clock Gating](./concepts/low_power_clock_gating/README.md) → ICG experiment

## Artifact Boundary

RTL, testbench, 실행 스크립트와 설명 문서는 commit한다. `xrun_work`, SHM database, log와 기타 생성물은 commit하지 않는다.
