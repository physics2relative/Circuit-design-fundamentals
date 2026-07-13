# Clock Gating ICG Experiment

Clock gating과 integrated clock gating(ICG) cell의 구조적 이유를 Verilog behavioral model로 확인하기 위한 Xcelium `xrun` 기반 simulation project이다. 구조와 실행 방식은 `cdc_behavioral_models` 프로젝트와 동일하게 `rtl/`, `tb/`, `sim/`으로 나눈다.

## 목표

이 프로젝트에서는 waveform으로 다음을 확인한다.

- 단순 AND clock gating에서 enable이 clock high 구간에 변하면 gated clock에 mid-cycle edge가 생길 수 있음
- latch-based ICG가 enable을 clock low phase에서만 sampling해 glitch-free gated clock을 만드는 방식
- test enable이 functional enable과 별도로 gated clock을 열어 scan/test clock 전달을 가능하게 하는 이유

## 구조

```text
rtl/
  naive_and_clock_gate.v
  latch_based_icg.v
  clock_gating_target_counter.v

tb/
  01_tb_naive_and_glitch.v
  02_tb_latch_based_icg.v
  03_tb_test_enable_bypass.v

sim/
  run_xrun.sh
  xrun_shm.tcl
```

## 실습 흐름

1. `naive_and_clock_gate`는 `gated_clk = clk & (en | test_en)` 구조이다. `clk=1`인 동안 `en`이 올라가면 gated clock에 정상 source clock edge가 아닌 mid-cycle rising edge가 생기고, target counter가 그 edge를 clock처럼 sampling할 수 있음을 보인다.
2. `latch_based_icg`는 `clk=0`일 때만 effective enable을 latch한다. 같은 enable stimulus를 넣어도 `clk=1` 구간에서는 `latched_en`이 고정되어 gated clock에 mid-cycle edge가 생기지 않는다.
3. `test_enable_bypass`는 functional enable이 0이어도 `test_en`이 1이면 ICG가 열려 test/scan mode에서 clock이 target flop까지 전달될 수 있음을 보인다.

## 실행

EDA 서버 기준:

```bash
cd /user/choi.jw/PROJECT/Circuit-Design-Fundamentals/digital/projects/clock_gating_icg_experiment
bash sim/run_xrun.sh
```

`xrun`이 PATH에 없으면 Xcelium binary 경로를 `XRUN` 환경변수로 지정한다.

```bash
XRUN=/tools/cadence/Xcelium2203.002/bin/xrun bash sim/run_xrun.sh
```

## 출력물

- compile/run log: `sim/xrun_work/<numbered_tb_name>/xrun.log`
- waveform database: `sim/xrun_work/<numbered_tb_name>/waves.shm`

## SimVision 사용 시 주의

`run_xrun.sh`는 기존 `sim/xrun_work/<numbered_tb_name>/waves.shm`을 매번 덮어쓴다. 같은 SHM을 SimVision에서 열어둔 상태로 다시 run하면 diagnostics가 뜨거나 reload가 꼬일 수 있으므로, 재실행 전에는 해당 SimVision 창을 닫는 것이 안전하다. 스크립트는 이 프로젝트의 SHM을 보고 있는 SimVision이 감지되면 기본적으로 중단한다.

## 중요한 한계

이 프로젝트는 ICG의 구조적 이유를 설명하기 위한 behavioral model이다. 실제 ASIC ICG cell의 library timing arc, clock gating setup/hold check, pulse width check, scan insertion, CTS 동작을 signoff하는 모델은 아니다. 실제 구현에서는 foundry/library에서 제공하는 ICG cell과 STA/DFT flow를 사용해야 한다.
