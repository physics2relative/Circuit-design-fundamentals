# Datapath and Number Systems

## 핵심 관점

디지털 회로에서 숫자는 정수 그 자체가 아니라 정해진 bit width를 가진 binary pattern이다. 같은 bit pattern도 signed/unsigned 해석에 따라 값이 달라진다. Datapath 설계에서는 width, overflow, extension, truncation을 명확히 관리해야 한다.

## Binary / Hexadecimal

Binary는 hardware signal을 직접 표현하기 좋고, hexadecimal은 긴 bit vector를 짧게 표현하기 좋다.

```text
4'b1010 = 4'ha = 10(decimal unsigned)
8'b1111_0000 = 8'hf0
```

Hex 한 자리는 4 bit와 대응된다. RTL debug나 waveform 확인 시 hex 표현을 많이 사용한다.

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

## 2's complement

2's complement는 음수를 표현하기 위한 방식이다. 어떤 값 `x`의 음수는 bit inversion 후 1을 더해 얻을 수 있다.

```text
+3 = 4'b0011
~3 = 4'b1100
-3 = 4'b1101
```

장점은 addition과 subtraction을 같은 adder 구조로 처리할 수 있다는 점이다.

## Carry vs Overflow

Carry는 unsigned 연산에서 bit width를 넘어가는 carry-out과 관련된다. Overflow는 signed 연산에서 표현 가능한 범위를 벗어나는 경우이다.

```text
Unsigned 4-bit: 15 + 1 = 0 with carry-out
Signed 4-bit:   7 + 1 = -8 pattern, overflow 발생
```

Signed overflow 판단의 핵심은 같은 부호의 두 수를 더했는데 결과 부호가 달라지는 경우이다.

```text
positive + positive → negative : overflow
negative + negative → positive : overflow
```

## Sign extension / Zero extension

Width를 늘릴 때 unsigned 값은 zero extension을 사용한다.

```text
4'b1010 → 8'b0000_1010
```

Signed 값은 sign extension을 사용한다. MSB, 즉 sign bit를 상위 bit로 복제한다.

```text
4'b1010 (-6) → 8'b1111_1010 (-6)
4'b0010 (+2) → 8'b0000_0010 (+2)
```

## Truncation

Width를 줄이면 상위 bit가 잘릴 수 있다. 이 과정은 의도하지 않은 overflow나 값 손실을 만들 수 있다.

```text
8'b0001_0010 → 4'b0010
```

하위 bit만 필요한 counter, address offset 등에서는 의도된 truncation일 수 있으나 산술 연산에서는 주의가 필요하다.

## Fixed-point 기본

Fixed-point는 정해진 bit 중 일부를 integer part, 일부를 fractional part로 해석하는 방식이다.

```text
Qm.n format
m: integer bits
n: fractional bits
```

예시로 Q4.4 format은 8-bit 중 상위 4 bit를 정수부, 하위 4 bit를 소수부로 해석한다. 곱셈 후 fractional bit 수가 증가하므로 scaling과 rounding/truncation 처리가 필요하다.

## Datapath 관점

Datapath는 data가 연산되고 이동하는 hardware 경로이다. 기본 구성 요소는 다음과 같다.

- adder
- subtractor
- comparator
- mux
- shifter
- register
- multiplier

Datapath 설계에서는 연산 자체보다 width와 timing을 함께 고려해야 한다. 예를 들어 wide adder는 delay가 커질 수 있고, multiplier는 area와 timing 부담이 크다.

## 정리

Number system은 단순 변환 문제가 아니라 RTL datapath의 정확성을 결정하는 기준이다. signed/unsigned, width extension, overflow, truncation을 명확히 관리해야 의도한 hardware 연산이 된다.
