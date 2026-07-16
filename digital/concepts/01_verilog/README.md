# Verilog

Verilog 문법 입문서가 아니라 RTL 설계 시 반드시 구분해야 하는 의미와 주의점을 정리한 문서이다.

## Scope

이 폴더의 기준은 다음과 같다.

```text
Verilog로 어떻게 표현하는가?
이 코드가 어떤 회로로 해석되는가?
어떤 문법 실수가 simulation/synthesis mismatch를 만드는가?
```

회로 이론 자체는 다른 concept 폴더에서 다룬다.

```text
조합논리 이론       → ../03_combinational_logic/
순차논리 이론       → ../04_sequential_logic/
FSM 설계법          → ../05_fsm/
setup/hold, CDC     → ../06_timing_sta/, ../07_clock_reset_cdc/
FIFO/interface 등   → ../08_memory_fifo_interface/
```

## Contents

1. [Verilog RTL Model](./01_verilog_rtl_model.md)
2. [Signal Types and Widths](./02_signal_types_and_widths.md)
3. [Assignment Semantics](./03_assignment_semantics.md)
4. [Always Block Patterns](./04_always_block_patterns.md)
5. [Reset and Clock Coding](./05_reset_and_clock_coding.md)
6. [Parameterization](./06_parameterization.md)
7. [Simulation and Testbench](./07_simulation_and_testbench.md)
8. [Synthesis Pitfalls](./08_synthesis_pitfalls.md)
9. [Verilog Interview Checklist](./09_verilog_interview_checklist.md)

## 핵심 정리

- Verilog는 software 실행 순서가 아니라 합성될 hardware 구조와 cycle 동작을 기술하는 언어이다.
- `wire`는 연결선이고, `reg`는 procedural assignment 대상이다. `reg`가 항상 flip-flop을 의미하지는 않는다.
- 조합논리는 보통 `assign` 또는 `always @(*)`와 blocking assignment로 표현한다.
- 순차논리는 `always @(posedge clk)`와 non-blocking assignment로 표현한다.
- 좋은 Verilog RTL은 simulation에서만 맞는 코드가 아니라 의도한 회로로 합성되는 코드이다.
