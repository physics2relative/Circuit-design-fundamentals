# Digital Design

디지털 회로 설계 기본 개념을 RTL 구현, 타이밍, 검증 관점으로 정리합니다. 면접에서는 단순 정의보다 **왜 그런 설계를 선택했는지**, **어떤 trade-off가 있는지**, **어떻게 검증했는지**를 설명하는 것이 중요합니다.

## Topics

1. [Number Systems](./01_number_systems/README.md)
2. [Combinational Logic](./02_combinational_logic/README.md)
3. [Sequential Logic](./03_sequential_logic/README.md)
4. [FSM](./04_fsm/README.md)
5. [Timing and CDC](./05_timing_cdc/README.md)
6. [Verilog/SystemVerilog Basics](./06_verilog_systemverilog/README.md)
7. [RTL Interview Study Guide](./07_rtl_interview_study_guide/README.md)

## 면접 답변 프레임

```text
정의 → 회로/RTL 관점 설명 → trade-off → 검증/디버깅 방법 → 직접 해본 예시
```

예시:

> FIFO의 full/empty는 read/write pointer 관계로 판단합니다. Synchronous FIFO에서는 같은 clock domain이므로 pointer 비교나 counter 방식이 가능하고, asynchronous FIFO에서는 pointer를 gray code로 변환해 CDC synchronizer를 거친 뒤 비교합니다. 검증 시에는 empty read, full write, wrap-around, simultaneous read/write, reset 직후 상태를 확인합니다.

## 우선순위

### 1순위: 반드시 바로 설명/구현 가능해야 하는 주제

- Blocking vs non-blocking assignment
- `always_comb` / `always_ff` 사용 기준
- Latch inference 방지
- FSM 설계와 Moore/Mealy 차이
- Counter, edge detector, sequence detector
- FIFO full/empty 판단
- valid-ready handshake
- setup/hold timing, critical path
- CDC와 2-flop synchronizer

### 2순위: 프로젝트 설명에 연결하기 좋은 주제

- UART/SPI/I2C 같은 간단 protocol
- Arbiter, round-robin arbiter
- Backpressure
- Pipeline stage 삽입
- FPGA vs ASIC 차이
- 간단한 cache/pipeline/computer architecture 기초

## 작성 템플릿

```md
# Topic Name

## Definition
## Why It Matters
## Key Concepts
## RTL/Example
## Common Pitfalls
## Interview Answer
## Related Questions
```
