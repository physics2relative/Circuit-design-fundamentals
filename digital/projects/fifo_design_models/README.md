# FIFO Design Models

## Objective

Synchronous FIFO의 pointer와 full/empty 제어부터 Gray-pointer asynchronous FIFO까지 구현하고, ordering, backpressure, 서로 다른 clock ratio를 self-checking testbench로 검증한다.

## What This Project Demonstrates

- write/read pointer, wrap-around, full/empty 판단
- valid-ready interface와 consumer backpressure
- write/read clock이 다른 asynchronous FIFO
- binary-to-Gray pointer 변환과 2-stage pointer synchronizer
- memory, pointer synchronization, full logic, empty logic의 명시적 분리

## Project Structure

```text
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

## Scenarios

| No. | Scenario | Check |
| ---: | --- | --- |
| 01 | synchronous FIFO basic | ordering |
| 02 | full/empty boundary | depth, wrap, flags |
| 03 | valid-ready | stall 중 data stability와 produced/consumed count |
| 04 | asynchronous FIFO basic | dual-clock ordering |
| 05 | write-fast/read-slow | full stall 이후 순서대로 drain |

## Async FIFO Blocks

- `async_fifo_gray_mem`: `wclk` write와 `rclk` synchronous read를 갖는 memory
- `async_fifo_gray_sync`: Gray pointer 2-stage synchronizer
- `async_fifo_gray_wptr_full`: write binary/Gray pointer와 full flag
- `async_fifo_gray_rptr_empty`: read binary/Gray pointer와 empty flag

## Run

```bash
cd digital/projects/fifo_design_models
bash sim/run_xrun.sh
```

결과는 `sim/xrun_work/<numbered_test>/xrun.log`와 `waves.shm`에 생성된다.

## Observation Points

- synchronous FIFO: `in_valid`, `in_ready`, `out_valid`, `out_ready`, `full`, `empty`, `count`
- asynchronous FIFO: `wclk`, `rclk`, `wfull`, `rempty`, `wgray_dbg`, `rgray_dbg`
- synchronized pointer: `wq2_rgray_dbg`, `rq2_wgray_dbg`
- write-fast/read-slow test의 full assertion과 drain 순서

## Verification Record

- Tool: Xcelium 22.03-s002
- Last full run: 2026-08-18
- Result: 5개 self-checking test 모두 PASS

## Related Concepts

- [FIFO and Interfaces](../../concepts/fifo_interfaces/README.md)
- [Clock, Reset, and CDC](../../concepts/clock_reset_cdc/README.md)
