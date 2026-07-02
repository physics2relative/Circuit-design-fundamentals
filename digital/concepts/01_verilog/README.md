# Verilog

이 폴더는 Verilog 문법을 입문서처럼 설명하기보다, RTL 설계자가 코드를 작성할 때 반드시 구분해야 하는 핵심 의미와 실수를 정리합니다.

## Scope

여기서는 다음 질문에 집중합니다.

```text
Verilog로 어떻게 표현하는가?
이 코드가 어떤 회로로 해석되는가?
어떤 문법 실수가 simulation/synthesis mismatch를 만드는가?
```

반대로 회로 이론 자체는 다른 concept 폴더에서 다룹니다.

```text
조합논리 이론       → ../02_combinational_logic/
순차논리 이론       → ../03_sequential_logic/
FSM 설계법          → ../04_fsm/
setup/hold, CDC     → ../05_timing_cdc/
FIFO/arbiter 등     → ../07_rtl_interview_study_guide/
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

## 면접 대비 핵심 문장

- Verilog는 software 실행 순서를 쓰는 언어라기보다, 합성될 hardware 구조와 cycle 동작을 기술하는 언어입니다.
- `wire`는 연결선, `reg`는 procedural assignment 대상입니다. `reg`가 항상 flip-flop을 의미하지는 않습니다.
- 조합논리는 보통 `assign` 또는 `always @(*)`와 blocking assignment로, 순차논리는 `always @(posedge clk)`와 non-blocking assignment로 표현합니다.
- 좋은 Verilog RTL은 simulation에서만 맞는 코드가 아니라, 의도한 회로로 합성되는 코드입니다.
