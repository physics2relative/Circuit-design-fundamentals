# Clock, Reset, and CDC

서로 다른 clock/reset domain 사이에서 신호를 전달할 때 생기는 sampling uncertainty와 구조별 해결 방법을 정리한다.

## Contents

1. [Metastability and Synchronizer](./01_metastability_and_synchronizer.md)
2. [Pulse and Toggle Synchronizer](./02_pulse_and_toggle_synchronizer.md)
3. [Multi-bit CDC](./03_multibit_cdc.md)
4. [Handshake CDC](./04_handshake_cdc.md)
5. [Async FIFO CDC View](./05_async_fifo_cdc_view.md)
6. [Reset Synchronizer and RDC](./06_reset_synchronizer_rdc.md)
7. [CDC Design Checklist](./07_cdc_design_checklist.md)

## Structure Selection

| Crossing | Typical structure | Required assumption |
| --- | --- | --- |
| single-bit slow level | 2-FF synchronizer | cycle latency uncertainty 허용 |
| short pulse/event | toggle synchronizer or handshake | event 간 최소 간격 또는 acknowledge |
| multi-bit control | Gray code | 한 transition에 한 bit만 변경 |
| multi-bit data stream | asynchronous FIFO | data는 memory, pointer만 CDC |
| reset release | reset synchronizer | async assert, sync deassert |

## Lab

[CDC Behavioral Models](../../projects/cdc_behavioral_models/README.md)에서 각 구조를 번호별 waveform으로 비교한다.
