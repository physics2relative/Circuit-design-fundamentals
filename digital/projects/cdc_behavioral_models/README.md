# CDC Behavioral Models

## Objective

실제 metastability의 analog 전압을 RTL로 재현하는 대신, setup/hold window 위반 시 `X`를 주입하는 교육용 model로 CDC 구조의 차이를 waveform에서 확인한다.

## What This Project Demonstrates

- synchronizer 없는 capture와 2-FF synchronizer의 차이
- destination clock에 잡히지 않는 짧은 source pulse
- toggle synchronizer와 request/ack handshake
- bit별 bus synchronizer의 coherency 문제
- Gray-pointer asynchronous FIFO
- asynchronous assert, synchronous deassert reset

## Project Structure

```text
rtl/   # CDC 구조와 setup/hold violation xmodel
tb/    # 01~09 numbered scenarios
sim/   # xrun launcher and SHM setup
```

## Scenarios

| No. | Scenario | Main observation |
| ---: | --- | --- |
| 01 | no synchronizer | receiver output에 일시적인 `X`가 직접 보임 |
| 02 | 2-FF, resolved | first stage가 다음 sampling 전에 resolve됨 |
| 03 | 2-FF, unresolved | first stage의 `X`가 다음 edge까지 남는 rare-failure model |
| 04 | direct pulse crossing | source 1-cycle pulse가 miss될 수 있음 |
| 05 | toggle synchronizer | event를 level transition으로 전달한 뒤 pulse로 복원함 |
| 06 | bit-wise bus synchronization | 서로 다른 cycle의 bit가 섞여 coherent하지 않은 word가 생김 |
| 07 | request/ack handshake | acknowledge까지 request와 data를 유지함 |
| 08 | Gray asynchronous FIFO | data는 memory에 두고 pointer만 synchronize함 |
| 09 | reset crossing | domain별 synchronized reset release를 비교함 |

## Run

저장소 루트 기준으로 실행한다.

```bash
cd digital/projects/cdc_behavioral_models
bash sim/run_xrun.sh
```

결과는 `sim/xrun_work/<numbered_test>/xrun.log`와 `waves.shm`에 생성된다. SimVision이 같은 SHM을 열고 있으면 안전을 위해 스크립트가 중단된다.

## Observation Points

- `clk_src`와 `clk_dst`의 edge 관계
- first synchronizer stage의 `X` 발생 및 resolve 시점
- destination event pulse의 누락 여부와 latency
- multi-bit bus의 source word와 destination word
- asynchronous FIFO의 binary/Gray pointer와 synchronized pointer
- raw reset과 synchronized reset의 deassert edge

## Verification Record

- Tool: Xcelium 22.03-s002
- Last full run: 2026-08-18
- Result: 9개 test가 compile, elaborate, simulate 완료
- Evidence level: waveform 관찰형이며 실제 MTBF를 계산하는 model은 아님

## Model Limit

`x_inject_dff`의 `X`는 실제 중간 전압이 아니라 destination이 0/1을 확정할 수 없다는 표시이다. `RESOLVE_DELAY_NS`와 `RESOLVE_VALUE`는 상황을 반복 가능하게 만드는 deterministic parameter이며 실제 resolution-time distribution을 예측하지 않는다.

## Related Concepts

- [Clock, Reset, and CDC](../../concepts/clock_reset_cdc/README.md)
- [FIFO and Interfaces](../../concepts/fifo_interfaces/README.md)
