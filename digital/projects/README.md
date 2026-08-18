# Digital Projects

모든 프로젝트는 Verilog RTL, testbench, Xcelium 실행 스크립트를 같은 구조로 제공한다.

```text
<project>/
  rtl/       # design 또는 교육용 behavioral model
  tb/        # 번호가 붙은 simulation scenario
  sim/       # run_xrun.sh, SHM setup
  README.md  # 목적, 실행법, 관찰 포인트, 검증 상태
```

## Projects

1. [CDC Behavioral Models](./cdc_behavioral_models/README.md) — 9 scenarios, waveform observation
2. [Clock Gating ICG Experiment](./clock_gating_icg_experiment/README.md) — 4 scenarios, waveform observation
3. [FIFO Design Models](./fifo_design_models/README.md) — 5 scenarios, self-checking

## Run

각 프로젝트 디렉터리에서 동일하게 실행한다.

```bash
bash sim/run_xrun.sh
```

`xrun`이 PATH에 없으면 설치 경로를 환경변수로 전달할 수 있다.

```bash
XRUN=/path/to/xrun bash sim/run_xrun.sh
```
