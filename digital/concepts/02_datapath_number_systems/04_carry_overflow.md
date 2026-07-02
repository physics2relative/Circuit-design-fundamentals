# Carry and Overflow

## Carry

Carry는 unsigned 연산에서 bit width를 넘어가는 carry-out과 관련된다.

```text
4-bit unsigned
1111 + 0001 = 0000 with carry-out
15 + 1 = 0 with carry-out
```

## Overflow

Overflow는 signed 연산에서 표현 가능한 범위를 벗어나는 경우이다.

```text
4-bit signed range: -8 ~ 7
0111 + 0001 = 1000
7 + 1 → overflow
```

## Signed overflow 판단

Signed overflow의 핵심은 같은 부호의 두 수를 더했는데 결과 부호가 달라지는 경우이다.

```text
positive + positive → negative : overflow
negative + negative → positive : overflow
```

## 구분

Carry와 overflow는 같은 개념이 아니다.

```text
carry    → unsigned 관점
overflow → signed 관점
```

동일한 adder output이라도 어떤 numeric interpretation을 쓰는지에 따라 flag 의미가 달라진다.
