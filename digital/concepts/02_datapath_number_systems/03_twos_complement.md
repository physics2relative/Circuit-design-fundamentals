# Two's Complement

## 핵심 관점

2's complement는 음수를 표현하기 위한 방식이다. 장점은 addition과 subtraction을 같은 adder 구조로 처리할 수 있다는 점이다.

## 음수 만들기

어떤 값 `x`의 음수는 bit inversion 후 1을 더해 얻을 수 있다.

```text
+3 = 4'b0011
~3 = 4'b1100
-3 = 4'b1101
```

## 범위

N-bit 2's complement의 범위는 다음과 같다.

```text
-2^(N-1) ~ 2^(N-1)-1
```

4-bit 예시는 다음과 같다.

```text
0111 =  7
0001 =  1
0000 =  0
1111 = -1
1000 = -8
```

## Hardware 관점

Subtraction은 보통 다음 형태로 구현할 수 있다.

```text
a - b = a + (~b + 1)
```

따라서 adder, inverter, carry-in을 조합해 subtractor를 만들 수 있다.
