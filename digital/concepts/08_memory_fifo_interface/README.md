# 08. Memory, FIFO, and Interfaces

Memory, FIFO, interface는 data를 저장하고 block 사이의 흐름을 조절하는 구조이다. RTL 설계 관점에서는 `어디에 저장하는가`, `언제 쓰고 읽는가`, `가득 참/비어 있음은 어떻게 판단하는가`, `상대 block이 받을 수 없을 때 어떻게 멈추는가`를 명확히 하는 것이 핵심이다.

## 목차

1. [Memory Basics](./01_memory_basics.md)
2. [Synchronous FIFO](./02_synchronous_fifo.md)
3. [FIFO Full / Empty Flags](./03_fifo_full_empty_flags.md)
4. [FIFO Interface and Valid-Ready](./04_fifo_interface_valid_ready.md)
5. [FIFO Depth, Burst Size, and Rate Matching](./05_fifo_depth_burst_rate.md)
6. [Asynchronous FIFO Overview](./06_asynchronous_fifo_overview.md)
7. [Gray Pointer FIFO](./07_gray_pointer_fifo.md)
8. [FIFO Verification Checklist](./08_fifo_verification_checklist.md)
9. [FIFO Interview Checklist](./09_fifo_interview_checklist.md)

## 학습 방향

- 먼저 synchronous FIFO로 pointer, wrap-around, full/empty 판단을 정리한다.
- 그 다음 valid-ready, backpressure, FIFO depth 산정 관점을 연결해서 FIFO가 system-level dataflow에서 어떤 역할을 하는지 본다.
- asynchronous FIFO는 CDC의 응용 예시로 다룬다. 핵심은 data memory는 공유하고, pointer 정보만 Gray code로 바꿔 다른 clock domain에 넘기는 것이다.
- Async FIFO의 metastability 자체는 `../07_clock_reset_cdc/README.md`의 synchronizer 개념과 연결해서 본다.
