# Combinational Logic Interview Checklist

## 조합논리의 정의

Combinational logic은 현재 입력만으로 출력이 결정되는 logic이다. 내부에 state를 저장하지 않으며, clock edge를 기다리지 않는다.

면접 답변은 다음처럼 정리할 수 있다.

```text
조합논리는 memory element가 없고, propagation delay 이후 output이 input function으로 결정된다.
```

## 기본 gate와 boolean logic

AND, OR, NOT, NAND, NOR, XOR 같은 gate로 boolean function을 구성한다. NAND와 NOR는 universal gate이므로 모든 boolean function을 구현할 수 있다.

## MUX

MUX는 select 값에 따라 여러 input 중 하나를 output으로 선택하는 block이다. 단순 선택기뿐 아니라 truth table 기반 logic 구현에도 사용할 수 있다.

예를 들어 2:1 MUX로 XOR를 구현할 수 있다.

```text
Y = A ? ~B : B
```

## Decoder와 encoder

Decoder는 encoded input을 one-hot output으로 변환한다. Encoder는 여러 input 중 active된 위치를 encoded output으로 변환한다.

Priority encoder는 여러 input이 동시에 active될 수 있을 때 우선순위가 높은 input을 선택한다. 이 경우 priority structure 때문에 timing path가 길어질 수 있다.

## Comparator와 arithmetic logic

Comparator는 equality 또는 magnitude를 판단한다. Width가 커지면 XOR tree, subtractor, carry chain 등 구현 구조에 따라 delay가 달라진다.

Arithmetic combinational logic은 adder, subtractor, shifter, multiplier 등을 포함한다. 복잡한 arithmetic block은 critical path가 되기 쉽기 때문에 pipeline 여부를 고려해야 한다.

## Priority logic

Priority logic은 조건 순서가 의미를 가지는 조합논리이다. RTL에서는 `if/else if` chain이나 priority encoder 형태로 나타난다.

주의할 점은 다음과 같다.

- 우선순위가 정말 필요한지 확인한다.
- 단순 case와 priority case를 구분한다.
- 우선순위 chain이 길면 timing이 나빠질 수 있다.

## Glitch와 hazard

Glitch는 input들이 서로 다른 delay path를 거쳐 output에 도달할 때 생기는 짧은 pulse이다. 일반 data path에서는 register가 sampling하지 않으면 큰 문제가 아닐 수 있지만, clock/reset/enable/CDC 신호에 glitch가 들어가면 위험하다.

완화 방법은 다음과 같다.

- 중요한 control signal은 register로 받는다.
- clock gating 대신 enable 구조를 우선 고려한다.
- async/CDC 신호는 synchronizer 구조를 사용한다.
- combinational loop를 만들지 않는다.

## Combinational loop

Combinational loop는 register 없이 output이 다시 input으로 되먹임되는 구조이다. 안정된 값으로 수렴하지 않거나 timing 분석이 불가능해질 수 있으므로 일반 RTL에서는 피해야 한다.

## RTL coding checklist

조합논리 RTL에서는 다음을 확인한다.

- `always @(*)`를 사용한다.
- blocking assignment를 사용한다.
- 모든 output에 default assignment를 준다.
- 모든 branch에서 output이 결정된다.
- 의도하지 않은 latch가 생기지 않는다.

## 핵심 답변 문장

- 조합논리는 현재 입력만으로 출력이 결정되고 state를 저장하지 않는다.
- MUX, decoder, encoder, comparator는 기본적인 combinational building block이다.
- Glitch는 path delay 차이 때문에 발생하며 clock/reset/enable/CDC 경로에서는 특히 위험하다.
- 조합논리 RTL의 핵심은 incomplete assignment와 combinational loop를 피하는 것이다.
