# Circuit Design Fundamentals

회로 설계 개념을 RTL 및 회로 시뮬레이션으로 확인하는 실습 중심 저장소이다. 공개 트리에는 재현 가능한 실습과 이를 이해하는 데 필요한 최소한의 개념 문서만 둔다.

## Featured Labs

| Project | What it demonstrates | Verification |
| --- | --- | --- |
| [CDC Behavioral Models](./digital/projects/cdc_behavioral_models/README.md) | metastability xmodel, 2-FF, pulse/toggle, handshake, Gray FIFO, reset crossing | Xcelium `xrun`, 9 scenarios |
| [Clock Gating ICG Experiment](./digital/projects/clock_gating_icg_experiment/README.md) | naive AND, latch-based ICG, FF-based latency, test enable | Xcelium `xrun`, 4 scenarios |
| [FIFO Design Models](./digital/projects/fifo_design_models/README.md) | synchronous FIFO, valid-ready, Gray-pointer asynchronous FIFO | Xcelium `xrun`, 5 self-checking scenarios |

세 프로젝트는 2026-08-18에 Xcelium 22.03-s002로 전체 실행하여 compile, elaboration, simulation 종료를 확인했다. CDC와 ICG는 waveform 관찰형 실습이고, FIFO testbench는 PASS/FAIL을 자체 검사한다.

## Quick Start

필요 환경은 Bash와 Cadence Xcelium의 `xrun`이다. 저장소 루트에서 다음과 같이 실행한다.

```bash
cd digital/projects/cdc_behavioral_models
bash sim/run_xrun.sh

cd ../clock_gating_icg_experiment
bash sim/run_xrun.sh

cd ../fifo_design_models
bash sim/run_xrun.sh
```

각 실행은 `sim/xrun_work/<test_name>/` 아래에 `xrun.log`와 `waves.shm`을 생성한다. 생성물은 Git에서 제외된다.

## Project Map

```text
digital/
  projects/
    cdc_behavioral_models/
    clock_gating_icg_experiment/
    fifo_design_models/
  concepts/                    # 위 실습과 직접 연결되는 보조 설명

analog/
  README.md
  ROADMAP.md                    # Virtuoso/Spectre 실습 계획

```

## Supporting Notes

- [Digital Design](./digital/README.md): 현재 실행 가능한 프로젝트와 관련 개념을 연결한다.
- [Analog Simulation Roadmap](./analog/ROADMAP.md): 회로별 DC/AC/transient 검증 순서를 정의한다.
- [Resources](./resources.md) · [Glossary](./glossary.md)

## Repository Policy

- 공개 프로젝트는 목적, 구조, 실행 방법, 관찰 포인트, 결과 상태를 README에 명시한다.
- PDK, model, license, proprietary netlist와 EDA raw result는 commit하지 않는다.
- 재현되지 않은 항목은 완료된 프로젝트처럼 표시하지 않고 roadmap으로 구분한다.
