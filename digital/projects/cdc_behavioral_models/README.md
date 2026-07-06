# CDC Behavioral Models

CDC(clock domain crossing) 개념을 Verilog behavioral model로 확인하기 위한 Xcelium `xrun` 기반 simulation project이다.

## 목표

RTL simulation은 실제 metastability의 analog behavior를 정확히 재현하지 못한다. 대신 다음을 확인한다.

- synchronizer 없이 asynchronous signal을 직접 capture하는 구조의 위험성
- 1-bit level signal crossing에서 2-flop synchronizer의 역할
- fast-to-slow pulse crossing에서 pulse가 miss될 수 있는 문제
- toggle synchronizer를 이용한 pulse event 전달
- multi-bit bus를 bit별 synchronizer로 넘길 때 coherent하지 않은 값이 보일 수 있는 문제

## 구조

```text
rtl/
  x_inject_dff.v
  no_sync_capture.v
  no_sync_capture_xmodel.v
  two_flop_sync.v
  two_flop_sync_xmodel.v
  toggle_sync.v
  bad_bus_sync.v

tb/
  tb_no_sync_capture.v
  tb_no_sync_capture_xmodel.v
  tb_two_flop_sync.v
  tb_two_flop_sync_xmodel.v
  tb_pulse_crossing.v
  tb_toggle_sync.v
  tb_bad_bus_sync.v

sim/
  run_xrun.sh
  xrun_shm.tcl
```

## 실습 흐름

1. `no_sync_capture`는 asynchronous input을 destination flip-flop 하나로 바로 capture하는 unsafe baseline이다. RTL simulation에서는 값이 정상적으로 잡히는 것처럼 보일 수 있지만, 실제 회로에서는 clock edge 근처 입력 변화가 metastability로 이어질 수 있다.
2. `no_sync_capture_xmodel`은 임의의 setup/hold window 안에서 asynchronous input이 변하면 destination FF 출력에 `X`를 주입한다. synchronizer가 없는 직접 capture 구조의 위험을 waveform에서 의도적으로 드러내는 모델이다.
3. `two_flop_sync`는 1-bit level signal을 2단 synchronizer로 받아 metastability가 뒤 logic으로 전파될 확률을 낮추는 기본 구조이다.
4. `two_flop_sync_xmodel`은 첫 번째 stage에만 setup/hold X-injection FF를 사용하여 first-stage uncertainty와 synchronizer latency를 함께 관찰한다.
5. `pulse_crossing`은 fast-to-slow pulse가 2-flop synchronizer만으로는 miss될 수 있음을 보인다.
6. `toggle_sync`는 pulse event를 toggle state change로 바꾸어 slow domain에서 event를 복원하는 구조이다.
7. `bad_bus_sync`는 multi-bit bus를 bit별 synchronizer로 넘기는 구조가 data coherency 측면에서 unsafe함을 보인다.

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

- compile/run log: `sim/xrun_work/<tb_name>/xrun.log`
- waveform database: `sim/xrun_work/<tb_name>/waves.shm`

## 중요한 한계

RTL simulation에서 flip-flop의 setup/hold violation과 metastability resolution time은 실제 analog 현상처럼 모델링되지 않는다. 따라서 기본 RTL 예제는 metastability 자체가 아니라 CDC 구조의 기능적 문제와 synchronizer의 사용 의도를 확인하기 위한 모델이다. `x_inject_dff`는 교육용으로 setup/hold window 위반 시 `X`를 주입하는 보수적 behavioral model이며, 실제 metastability resolution time이나 MTBF를 예측하는 모델은 아니다.
