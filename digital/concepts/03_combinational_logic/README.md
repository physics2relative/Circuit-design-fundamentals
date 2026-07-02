# Combinational Logic

## 핵심 관점

Combinational logic은 현재 입력만으로 출력이 결정되는 logic이다. 내부에 state를 저장하지 않으며 clock edge를 기다리지 않는다. RTL에서는 `assign` 또는 `always @(*)`로 표현되는 경우가 많다.

## 기본 성질

```text
output = f(current inputs)
```

조합논리에는 memory가 없어야 한다. 어떤 입력 조합에서도 출력이 완전히 결정되어야 하며, 일부 조건에서 값이 유지되어야 한다면 latch가 inference될 수 있다.

## Basic gates

기본 gate는 digital logic의 최소 구성 요소이다.

- AND
- OR
- NOT
- NAND
- NOR
- XOR
- XNOR

NAND와 NOR는 universal gate이다. 즉 NAND 또는 NOR만으로 모든 boolean function을 구현할 수 있다.

## MUX

MUX는 select signal에 따라 여러 input 중 하나를 output으로 전달하는 조합논리이다.

```text
2:1 MUX
sel = 0 → y = d0
sel = 1 → y = d1
```

Verilog 표현 예시는 다음과 같다.

```verilog
assign y = sel ? d1 : d0;
```

MUX는 datapath selection, control path selection, bus selection에 자주 사용된다.

## Decoder / Encoder

Decoder는 encoded input을 one-hot output으로 변환한다.

```text
2-bit input → 4-bit one-hot output
00 → 0001
01 → 0010
10 → 0100
11 → 1000
```

Encoder는 one-hot 또는 priority input을 encoded output으로 변환한다. 여러 input이 동시에 1일 수 있으면 priority encoder가 필요하다.

## Comparator

Comparator는 두 값을 비교해 equal, greater-than, less-than 등의 결과를 만든다.

```verilog
assign eq = (a == b);
assign gt = (a > b);
```

signed 비교인지 unsigned 비교인지에 따라 결과가 달라질 수 있다.

## Adder / Subtractor

Adder는 combinational datapath에서 가장 기본적인 산술 연산기이다.

```verilog
assign sum = a + b;
assign diff = a - b;
```

큰 bit width의 adder는 critical path가 될 수 있다. timing이 부족하면 carry propagation 구조, pipelining, architecture 변경을 고려한다.

## Priority logic

`if-else` chain은 priority 구조를 만들 수 있다.

```verilog
always @(*) begin
    y = 2'b00;
    if (req[0])
        y = 2'b00;
    else if (req[1])
        y = 2'b01;
    else if (req[2])
        y = 2'b10;
    else if (req[3])
        y = 2'b11;
end
```

Priority logic은 의도한 경우 유용하지만, 불필요한 priority는 delay와 area를 증가시킬 수 있다.

## Glitch / Hazard

조합논리에서는 input이 동시에 바뀌더라도 각 path의 delay가 다르기 때문에 output에 짧은 pulse가 생길 수 있다. 이를 glitch 또는 hazard라고 한다.

특히 다음 신호에서 위험하다.

- clock
- reset
- clock enable
- asynchronous control signal
- CDC input

일반 datapath signal의 glitch는 register sampling 시점에 안정되면 문제가 되지 않을 수 있다. 하지만 clock/reset 같은 민감한 신호에 조합논리 glitch가 들어가면 심각한 문제가 된다.

## Combinational loop

Combinational loop는 조합논리 출력이 다시 자기 입력으로 돌아가는 구조이다.

```text
a → logic → b → logic → a
```

의도하지 않은 oscillation, simulation 불안정, timing 분석 실패를 만들 수 있다. 대부분 RTL bug로 간주한다.

## RTL 작성 기준

조합논리 RTL 작성 시 기준은 다음과 같다.

- `assign` 또는 `always @(*)` 사용
- blocking assignment 사용
- 모든 output에 default assignment
- `case`에는 필요한 모든 branch와 default 처리
- latch inference warning 확인
- combinational loop warning 확인

## 정리

Combinational logic은 현재 입력으로 출력이 즉시 결정되는 구조이다. 설계 관점에서는 function correctness뿐 아니라 delay, priority, glitch, latch inference, combinational loop를 함께 고려해야 한다.
