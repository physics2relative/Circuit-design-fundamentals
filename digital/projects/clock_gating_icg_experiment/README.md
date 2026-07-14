# Clock Gating ICG Experiment

Clock gating과 integrated clock gating(ICG) cell의 구조적 이유를 Verilog behavioral model로 확인하기 위한 Xcelium `xrun` 기반 simulation project이다. 구조와 실행 방식은 `cdc_behavioral_models` 프로젝트와 동일하게 `rtl/`, `tb/`, `sim/`으로 나눈다.

## 목표

이 프로젝트는 **latch-based ICG를 기준 구조**로 두고, 다른 clock gating 형태를 비교한다.

확인할 내용은 다음과 같다.

- latch-based ICG가 enable을 clock low phase에서 미리 sampling해 glitch-free gated clock을 만드는 방식
- 단순 AND clock gating에서 enable latch가 없을 때 생기는 mid-cycle gated clock edge
- flip-flop으로 enable을 sampling하는 gating 구조가 왜 ICG 구조로 적합하지 않은지
- test enable이 functional enable과 별도로 gated clock을 열어 scan/test clock 전달을 가능하게 하는 이유

## 구조

```text
rtl/
  latch_based_icg.v
  naive_and_clock_gate.v
  ff_based_clock_gate.v
  clock_gating_target_counter.v

tb/
  01_tb_latch_based_icg.v
  02_tb_naive_and_glitch.v
  03_tb_ff_based_latency.v
  04_tb_test_enable_bypass.v

sim/
  run_xrun.sh
  xrun_shm.tcl
```

## 공통 enable 시나리오

1~3번 testbench는 같은 enable stimulus를 사용한다.

```text
clk period = 10ns
clk high   = 15~20ns, 25~30ns, 35~40ns, ...
en rises   = 17ns  # clk가 이미 high인 중간
en falls   = 57ns  # clk가 high인 중간
```

이 시나리오는 raw AND gate에는 의도하지 않은 mid-cycle edge와 잘린 high pulse를 만들고, latch-based ICG에는 정상 clock edge만 통과되는 것을 비교하기 위한 것이다.

## 실습 흐름

1. `latch_based_icg`는 기준 ICG 구조이다. `clk=0`일 때만 effective enable을 latch하고, `clk=1` 동안 `latched_en`을 고정한다. `en`은 17ns에 올라가지만 ICG는 20ns low phase에서 이를 반영하고, 25ns/35ns/45ns/55ns의 정상 clock edge를 통과시킨다.
2. `naive_and_clock_gate`는 `gated_clk = clk & (en | test_en)` 구조이다. 같은 stimulus에서 `en`이 17ns에 올라가면 gated clock에 정상 source clock edge가 아닌 mid-cycle rising edge가 생기고, 57ns에 내려가면 high pulse가 중간에 잘린다.
3. `ff_based_latency`는 같은 stimulus를 latch-based ICG와 FF-based gating으로 동시에 비교한다. FF-based gating은 enable을 posedge에서 sampling한 뒤 clock-to-Q 이후에 반영하므로, 기준 ICG처럼 다음 정상 edge 전에 enable을 준비하는 구조가 아님을 보인다.
4. `test_enable_bypass`는 functional enable이 0이어도 `test_en`이 1이면 ICG가 열려 test/scan mode에서 clock이 target flop까지 전달될 수 있음을 보인다.

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
