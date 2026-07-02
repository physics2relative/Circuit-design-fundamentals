# Verilog RTL Model

## 핵심 관점

Verilog는 hardware description language입니다. 따라서 코드를 볼 때 “문장이 어떤 순서로 실행되는가”보다 **어떤 hardware 구조와 cycle 동작으로 해석되는가**를 먼저 생각해야 합니다.

```text
Verilog RTL → simulation behavior
Verilog RTL → synthesis result
```

두 결과가 항상 같은 의미를 갖도록 코딩하는 것이 중요합니다.

## Simulation vs Synthesis

### Simulation

- Verilog code의 event-driven 동작을 simulator가 계산합니다.
- testbench, delay, display task 등을 사용할 수 있습니다.
- waveform으로 cycle별 동작을 확인합니다.

### Synthesis

- RTL code를 gate, mux, register, memory 등 실제 hardware 구조로 변환합니다.
- 모든 Verilog 문법이 synthesis 가능한 것은 아닙니다.
- simulation에서 동작해도 합성 불가능하거나 의도와 다른 회로가 나올 수 있습니다.

## RTL에서 주로 표현하는 hardware

- Continuous assignment → 조합논리 연결
- `always @(*)` → 조합논리 block
- `always @(posedge clk)` → flip-flop/register
- `case` / `if-else` → mux, priority logic
- array/register file → memory 또는 register bank

## 정리 포인트

Verilog를 작성할 때는 아래 질문을 계속 해야 합니다.

```text
이 signal은 wire인가 register인가?
이 always block은 조합논리인가 순차논리인가?
모든 조건에서 값이 결정되는가?
clock edge에서 update되는 state는 무엇인가?
이 코드는 합성 가능한가?
```

## 면접 질문

### Q. Verilog는 프로그래밍 언어인가?

면접 답변:

> Verilog는 일반 software처럼 순차 실행 프로그램을 작성하는 언어라기보다 hardware를 기술하는 HDL입니다. 특히 RTL에서는 register 사이의 data transfer와 조합논리를 기술하며, 최종적으로 mux, gate, flip-flop 같은 hardware로 합성되는 것을 염두에 두고 작성해야 합니다.

### Q. Simulation과 synthesis의 차이는?

면접 답변:

> Simulation은 Verilog 코드의 동작을 event-driven 방식으로 검증하는 과정이고, synthesis는 synthesizable RTL을 실제 gate-level hardware 구조로 변환하는 과정입니다. Testbench에서 쓰는 delay나 display task는 simulation에는 유용하지만 일반적으로 합성 대상이 아닙니다.
