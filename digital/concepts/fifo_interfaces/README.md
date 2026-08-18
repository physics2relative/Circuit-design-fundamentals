# FIFO and Interfaces

FIFO의 저장 구조, full/empty 제어, valid-ready backpressure와 asynchronous FIFO의 Gray pointer crossing을 정리한다.

## Contents

1. [Memory Basics](./01_memory_basics.md)
2. [Synchronous FIFO](./02_synchronous_fifo.md)
3. [FIFO Full / Empty Flags](./03_fifo_full_empty_flags.md)
4. [FIFO Interface and Valid-Ready](./04_fifo_interface_valid_ready.md)
5. [FIFO Depth, Burst Size, and Rate Matching](./05_fifo_depth_burst_rate.md)
6. [Asynchronous FIFO Overview](./06_asynchronous_fifo_overview.md)
7. [Gray Pointer FIFO](./07_gray_pointer_fifo.md)
8. [FIFO Verification Checklist](./08_fifo_verification_checklist.md)

## Study Flow

Synchronous FIFO의 pointer와 flags를 먼저 확인하고, valid-ready 및 depth 산정으로 확장한다. Asynchronous FIFO에서는 data memory를 직접 synchronize하지 않고 binary pointer를 Gray code로 바꿔 상대 domain에 전달한다.

## Labs

- [FIFO Design Models](../../projects/fifo_design_models/README.md)
- [CDC Behavioral Models](../../projects/cdc_behavioral_models/README.md)
