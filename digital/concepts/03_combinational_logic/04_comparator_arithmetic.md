# Comparator and Arithmetic Logic

## Comparator

Comparator는 두 값을 비교해 equal, greater-than, less-than 등의 결과를 만든다.

```verilog
assign eq = (a == b);
assign gt = (a > b);
```

signed 비교인지 unsigned 비교인지에 따라 결과가 달라질 수 있다.

## Adder

Adder는 combinational datapath에서 가장 기본적인 산술 연산기이다.

```verilog
assign sum = a + b;
```

큰 bit width의 adder는 critical path가 될 수 있다.

## Subtractor

Subtractor는 2's complement 기반으로 adder를 활용해 구현할 수 있다.

```verilog
assign diff = a - b;
```

## Timing 관점

산술 연산기는 bit width가 커질수록 delay와 area가 증가한다. timing이 부족하면 architecture 변경, pipelining, resource sharing 등을 고려한다.
