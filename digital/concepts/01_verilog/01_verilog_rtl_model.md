# Verilog RTL Model

## 핵심 관점

Verilog는 hardware description language이다. 코드를 볼 때 문장이 어떤 순서로 실행되는가보다 **어떤 hardware 구조와 cycle 동작으로 해석되는가**를 먼저 생각해야 한다.

```text
Verilog RTL → simulation behavior
Verilog RTL → synthesis result
```

두 결과가 같은 의도를 갖도록 작성하는 것이 중요하다.

## Simulation

- Verilog code의 event-driven 동작을 simulator가 계산하는 과정이다.
- testbench, delay, display task 등을 사용할 수 있다.
- waveform으로 cycle별 동작을 확인한다.
- 기능 검증과 debug를 위한 단계이다.

## Synthesis

- RTL code를 gate, mux, register, memory 등 실제 hardware 구조로 변환하는 과정이다.
- 모든 Verilog 문법이 synthesis 가능한 것은 아니다.
- simulation에서 동작해도 합성 불가능하거나 의도와 다른 회로가 나올 수 있다.
- target technology와 synthesis tool의 해석을 고려해야 한다.

## RTL에서 주로 표현하는 hardware

- Continuous assignment → 조합논리 연결
- `always @(*)` → 조합논리 block
- `always @(posedge clk)` → flip-flop/register
- `case` / `if-else` → mux 또는 priority logic
- array/register file → memory 또는 register bank

## 작성 시 확인할 것

```text
이 signal은 wire인가 register인가?
이 always block은 조합논리인가 순차논리인가?
모든 조건에서 값이 결정되는가?
clock edge에서 update되는 state는 무엇인가?
이 코드는 합성 가능한가?
```

## 정리

Verilog RTL은 software처럼 실행 절차를 쓰는 것이 아니라 hardware 구조와 cycle 동작을 기술하는 방식이다. 따라서 문법을 외우는 것보다 코드가 어떤 회로로 해석되는지 판단하는 것이 중요하다.
