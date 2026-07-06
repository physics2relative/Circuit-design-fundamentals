# CDC Behavioral Models

CDC(clock domain crossing) 개념을 Verilog behavioral model로 확인하기 위한 Xcelium `xrun` 기반 simulation project이다. 메인 실습은 setup/hold window 위반 시 `X`를 주입하는 xmodel 흐름으로 진행한다.

## 목표

RTL simulation은 실제 metastability의 analog behavior를 정확히 재현하지 못한다. 이 프로젝트에서는 교육용 `x_inject_dff`를 사용해 다음을 waveform으로 확인한다.

- synchronizer 없이 asynchronous signal을 직접 capture하는 구조의 위험성
- 1-bit level signal crossing에서 2-flop synchronizer의 역할
- fast-to-slow pulse crossing에서 pulse가 miss되거나 불확정하게 sampling될 수 있는 문제
- toggle synchronizer를 이용한 pulse event 전달
- multi-bit bus를 bit별 synchronizer로 넘길 때 coherent하지 않은 값이 보일 수 있는 문제

## 구조

```text
rtl/
  x_inject_dff.v
  no_sync_capture_xmodel.v
  two_flop_sync_xmodel.v
  toggle_sync_xmodel.v
  bad_bus_sync_xmodel.v

  # 비교/참고용 ideal RTL
  no_sync_capture.v
  two_flop_sync.v
  toggle_sync.v
  bad_bus_sync.v

tb/
  01_tb_no_sync_capture_xmodel.v
  02_tb_two_flop_sync_resolved_xmodel.v
  03_tb_two_flop_sync_unresolved_xmodel.v
  04_tb_pulse_crossing_xmodel.v
  05_tb_toggle_sync_xmodel.v
  06_tb_bad_bus_sync_xmodel.v

sim/
  run_xrun.sh
  xrun_shm.tcl
```

## 실습 흐름

1. `no_sync_capture_xmodel`은 `clk_src` domain에서 launch된 `async_in`을 destination flip-flop 하나로 바로 capture한다. `clk_src`와 `clk_dst`의 관계가 보장되지 않기 때문에 일부 source launch edge가 destination setup/hold window 근처에 걸리고, 이때 output이 잠깐 `X`가 된 뒤 deterministic value로 resolve된다.
2. `two_flop_sync_resolved_xmodel`은 첫 번째 stage가 setup/hold violation으로 잠깐 `X`가 되지만 다음 destination clock edge 전에 resolve되는 경우이다. second stage는 resolved value를 sampling하므로 2-FF synchronizer가 효과적으로 동작한다.
3. `two_flop_sync_unresolved_xmodel`은 첫 번째 stage의 resolve delay를 destination clock period보다 길게 둔 rare failure case이다. second stage가 아직 `X`인 first-stage output을 sampling할 수 있음을 보인다.
4. `pulse_crossing_xmodel`은 `clk_src` domain에서 생성된 1-cycle event pulse를 `clk_dst` domain으로 그대로 넘기려는 상황이다. pulse가 destination clock edge 사이에서 끝나면 miss될 수 있고, edge 근처에 걸리면 first stage가 불확정해질 수 있음을 보인다.
5. `toggle_sync_xmodel`은 pulse event를 source domain의 toggle state change로 바꾸어 destination domain에서 event를 복원하는 구조이다.
6. `bad_bus_sync_xmodel`은 multi-bit bus를 bit별 synchronizer로 넘기는 구조가 data coherency 측면에서 unsafe함을 보인다.

## 실행

EDA 서버 기준:

```bash
cd /user/choi.jw/PROJECT/Circuit-Design-Fundamentals/digital/projects/cdc_behavioral_models
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

`x_inject_dff`는 교육용으로 setup/hold window 위반 시 `X`를 주입한 뒤 `RESOLVE_DELAY_NS` 후 deterministic `RESOLVE_VALUE`로 resolve시키는 behavioral model이다. 실제 flip-flop의 metastability resolution time distribution, failure probability, MTBF를 예측하는 모델은 아니다. 여기서의 `X`는 실제 중간 전압 자체가 아니라, 해당 timing에서 destination domain이 0/1 값을 확정할 수 없다는 표시로 해석해야 한다.
