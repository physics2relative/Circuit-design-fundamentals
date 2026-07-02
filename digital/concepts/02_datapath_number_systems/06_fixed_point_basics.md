# Fixed-Point Basics

## 핵심 관점

Fixed-point는 정해진 bit 중 일부를 integer part, 일부를 fractional part로 해석하는 방식이다. Hardware에서 floating-point보다 단순한 연산기로 구현할 수 있다.

## Q format

```text
Qm.n format
m: integer bits
n: fractional bits
```

예시로 Q4.4 format은 8-bit 중 상위 4 bit를 정수부, 하위 4 bit를 소수부로 해석한다.

## Scaling

Fixed-point 값은 실제 값에 scale factor가 곱해진 integer처럼 저장된다.

```text
stored_value = real_value * 2^fractional_bits
```

## 연산 주의점

- 덧셈/뺄셈은 fractional bit 위치가 같은 값끼리 수행해야 한다.
- 곱셈 후 fractional bit 수가 증가한다.
- rounding, truncation, saturation 정책이 필요할 수 있다.
- overflow 처리가 중요하다.

## Hardware 관점

Fixed-point는 DSP, image processing, ML accelerator 등에서 자주 사용된다. 정확도와 hardware cost 사이의 trade-off를 bit width로 조절한다.
