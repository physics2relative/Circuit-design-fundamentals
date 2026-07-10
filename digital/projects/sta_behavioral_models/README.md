# STA Behavioral Models

Static timing analysis의 setup/hold/skew/pipeline 개념을 Verilog behavioral model과 Xcelium `xrun`으로 확인하기 위한 프로젝트이다.

## 목표

상용 STA 툴 없이도 timing path의 핵심 개념을 waveform으로 확인한다.

- launch FF / capture FF timing path
- setup pass와 setup violation
- hold violation
- clock skew가 setup/hold margin에 주는 영향
- pipeline insertion이 critical path를 줄이는 효과

## 구조

```text
rtl/
  sta_check_dff.v
  sta_ff_to_ff_path.v
  sta_pipeline_path.v

tb/
  01_tb_setup_pass.v
  02_tb_setup_violation.v
  03_tb_hold_violation.v
  04_tb_skew_effect.v
  05_tb_pipeline_fix.v

sim/
  run_xrun.sh
  xrun_shm.tcl
```


## 예제 흐름

1. `01_setup_pass`는 combinational delay가 clock period 안에 충분히 들어와 setup을 만족하는 경우이다.
2. `02_setup_violation`은 combinational delay가 길어 capture edge 직전에 data가 도착하는 setup violation 경우이다.
3. `03_hold_violation`은 data path가 너무 짧아 capture edge 직후 data가 바뀌는 hold violation 경우이다.
4. `04_skew_effect`는 launch/capture clock edge 위치 차이가 timing margin을 바꾸는 상황이다. Behavioral FF는 capture edge 주변 data transition을 setup/hold window 위반으로 표시하므로, waveform에서 clock edge와 data arrival의 상대 위치를 함께 봐야 한다.
5. `05_pipeline_fix`는 긴 단일 combinational path와 pipeline으로 나눈 path를 비교한다. 단일 path는 setup을 위반하지만, pipeline path는 각 stage delay가 줄어 timing을 만족한다.

## 실행

```bash
cd digital/projects/sta_behavioral_models
bash sim/run_xrun.sh
```

## 해석 주의

이 프로젝트는 signoff STA가 아니다. 실제 timing signoff에는 liberty, SDC, gate-level netlist, PrimeTime/Tempus/OpenSTA 같은 STA tool이 필요하다. 여기서는 setup/hold 식과 margin 개념을 직관적으로 보기 위해 behavioral delay와 timing-check FF를 사용한다.
