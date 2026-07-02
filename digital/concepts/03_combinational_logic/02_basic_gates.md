# Basic Gates

## 기본 gate

기본 gate는 digital logic의 최소 구성 요소이다.

- AND
- OR
- NOT
- NAND
- NOR
- XOR
- XNOR

## Universal gate

NAND와 NOR는 universal gate이다. NAND 또는 NOR만으로 모든 boolean function을 구현할 수 있다.

## XOR

XOR는 두 입력이 다를 때 1이 되는 gate이다. parity, adder sum, toggle logic 등에 자주 사용된다.

```text
A B | A xor B
0 0 | 0
0 1 | 1
1 0 | 1
1 1 | 0
```

## Gate-level보다 RTL 중심

면접이나 실무 RTL에서는 gate-level primitive보다 boolean expression, mux, case 문으로 표현하는 경우가 많다. 다만 최종적으로는 gate network로 합성된다는 점을 이해해야 한다.
