# FIFO Design Models

FIFO 개념을 Verilog behavioral RTL과 xrun/SHM waveform으로 확인하기 위한 실습이다.

## 구성

```text
fifo_design_models/
  rtl/
    sync_fifo.v
    async_fifo_gray.v
  tb/
    01_tb_sync_fifo_basic.v
    02_tb_sync_fifo_full_empty.v
    03_tb_sync_fifo_valid_ready.v
    04_tb_async_fifo_gray_basic.v
    05_tb_async_fifo_clock_ratio.v
  sim/
    run_xrun.sh
    xrun_shm.tcl
```

## 예제 흐름

1. `01_sync_fifo_basic`은 같은 clock domain에서 FIFO ordering을 확인한다.
2. `02_sync_fifo_full_empty`는 depth만큼 채웠을 때 full, 모두 읽었을 때 empty가 정확히 동작하는지 확인한다.
3. `03_sync_fifo_valid_ready`는 consumer stall 상황에서 valid-ready와 backpressure가 어떻게 동작하는지 확인한다.
4. `04_async_fifo_gray_basic`은 write clock과 read clock이 다른 상황에서 Gray pointer 기반 async FIFO가 data 순서를 유지하는지 확인한다.
5. `05_async_fifo_clock_ratio`는 write clock이 read clock보다 빠른 상황에서 full stall이 걸리고, 이후 read 쪽에서 data를 순서대로 drain하는지 확인한다.


## RTL 구조 관점

`rtl/async_fifo_gray.v`는 학습용으로 async FIFO 내부 구조가 명시적으로 보이도록 다음 module로 나누어 둔 형태이다.

- `async_fifo_gray_mem`: shared memory array with `wclk` write and `rclk` synchronous read
- `async_fifo_gray_sync`: Gray pointer 2-stage synchronizer
- `async_fifo_gray_wptr_full`: write pointer, write address, full flag 생성 로직
- `async_fifo_gray_rptr_empty`: read pointer, read address, empty flag 생성 로직

Top module인 `async_fifo_gray`는 이 block들을 연결한다. Memory read는 `rclk`에 맞춰 `rdata` register로 샘플되는 synchronous read 형태이다. Waveform을 볼 때는 `wbin_dbg/wgray_dbg`가 write-side pointer이고, `rbin_dbg/rgray_dbg`가 read-side pointer이다. `wq2_rgray_dbg`는 write domain으로 넘어온 read pointer, `rq2_wgray_dbg`는 read domain으로 넘어온 write pointer이다.

## 실행

```bash
cd /user/choi.jw/PROJECT/Circuit-Design-Fundamentals/digital/projects/fifo_design_models
bash sim/run_xrun.sh
```

SimVision이 같은 SHM을 열고 있으면 스크립트가 중단된다. 의도적으로 덮어쓰려면 다음처럼 실행한다.

```bash
ALLOW_OPEN_SHM_OVERWRITE=1 bash sim/run_xrun.sh
```

## Waveform에서 볼 신호

### Synchronous FIFO

- `in_valid`, `in_ready`, `in_data`
- `out_valid`, `out_ready`, `out_data`
- `full`, `empty`, `count`
- `dut.wptr`, `dut.rptr`, `dut.used`

### Asynchronous FIFO

- `wclk`, `rclk`
- `winc`, `wfull`, `wdata`
- `rinc`, `rempty`, `rdata`
- `wbin_dbg`, `rbin_dbg`
- `wgray_dbg`, `rgray_dbg`
- `wq2_rgray_dbg`, `rq2_wgray_dbg`

## 개념 문서 연결

관련 개념은 `../../concepts/09_memory_fifo_interface/README.md`에서 정리한다.
