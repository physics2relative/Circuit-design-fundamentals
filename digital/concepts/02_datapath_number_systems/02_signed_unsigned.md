# Signed and Unsigned

## Unsigned representation

Unsigned N-bit 값의 범위는 다음과 같다.

```text
0 ~ 2^N - 1
```

예시:

```text
8-bit unsigned: 0 ~ 255
4'b1111 = 15
```

## Signed representation

Signed value는 보통 2's complement로 표현한다. N-bit signed 값의 범위는 다음과 같다.

```text
-2^(N-1) ~ 2^(N-1)-1
```

예시:

```text
8-bit signed: -128 ~ 127
4'b1111 = -1
4'b1000 = -8
4'b0111 = 7
```

## 같은 bit pattern, 다른 해석

```text
4'b1111
unsigned 해석: 15
signed 해석:   -1
```

같은 회로 signal이라도 연산과 비교에서 signed로 볼지 unsigned로 볼지에 따라 결과가 달라진다.

## RTL 주의점

- Verilog signal은 기본적으로 unsigned로 다뤄진다.
- signed 연산이 필요하면 선언과 연산 의도를 명확히 해야 한다.
- signed/unsigned가 섞인 expression은 lint warning과 simulation 결과를 확인해야 한다.
