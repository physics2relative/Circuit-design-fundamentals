# Clock Gating ICG Experiment

## Objective

단순 AND gating, latch-based ICG, FF-based gating을 같은 enable stimulus로 비교하여 glitch-free clock gating에 latch가 필요한 이유를 확인한다.

## What This Project Demonstrates

- clock high phase에서 enable이 변할 때 raw AND gate가 만드는 잘린 pulse와 mid-cycle edge
- low phase에 enable을 저장하는 latch-based ICG의 동작
- posedge FF 기반 gating에서 enable 반영이 늦어지는 이유
- functional enable과 별도로 test enable을 두는 목적

## Project Structure

```text
rtl/   # three gating structures and target counter
tb/    # 01~04 numbered scenarios
sim/   # xrun launcher and SHM setup
```

## Scenarios

| No. | Scenario | Main observation |
| ---: | --- | --- |
| 01 | latch-based ICG | source clock의 정상 edge와 pulse width만 통과함 |
| 02 | naive AND | enable 변화 시 mid-cycle edge와 truncated pulse가 생김 |
| 03 | FF-based gating | posedge sampling 때문에 기준 ICG보다 enable 반영이 늦음 |
| 04 | test enable | functional enable이 0이어도 test clock을 전달함 |

1~3번은 `clk=high`인 17 ns에 enable을 올리고 57 ns에 내리는 동일 stimulus를 사용한다.

## Run

```bash
cd digital/projects/clock_gating_icg_experiment
bash sim/run_xrun.sh
```

결과는 `sim/xrun_work/<numbered_test>/xrun.log`와 `waves.shm`에 생성된다.

## Observation Points

- `clk`, `en`, `latched_en`, `gated_clk`의 edge 정렬
- gated clock의 high pulse width
- target counter가 증가하는 edge
- latch-based 구조와 FF-based 구조의 첫 통과 edge
- `test_en=1`일 때의 clock 전달

## Verification Record

- Tool: Xcelium 22.03-s002
- Last full run: 2026-08-18
- Result: 4개 test가 compile, elaborate, simulate 완료
- Evidence level: waveform 관찰형 behavioral RTL

## Model Limit

실제 ASIC 구현에서는 library ICG cell과 clock-gating timing check, CTS, DFT flow를 사용한다. 이 프로젝트는 standard-cell timing arc나 physical implementation을 signoff하지 않는다.

## Related Concepts

- [Low Power and Clock Gating](../../concepts/low_power_clock_gating/README.md)
