# Datapath and Number Systems Interview Checklist

## Binary pattern과 값의 차이

디지털 회로에서 signal은 정수 그 자체가 아니라 정해진 width를 가진 bit pattern이다. 같은 bit pattern도 unsigned로 볼지 signed로 볼지에 따라 값이 달라진다.

면접에서는 다음을 구분해서 말해야 한다.

```text
bit pattern: 회로에 저장된 0/1 배열
value interpretation: 그 bit pattern을 어떤 숫자 체계로 해석하는가
```

## Signed와 unsigned

Unsigned는 모든 bit를 magnitude로 해석한다. Signed는 보통 two's complement를 사용해 MSB를 sign bit처럼 해석한다.

Verilog에서는 operand가 signed인지 unsigned인지에 따라 비교, 확장, 산술 결과가 달라질 수 있다. 따라서 signed datapath에서는 signal 선언과 casting을 명확히 해야 한다.

## Two's complement

Two's complement는 signed integer를 표현하는 가장 일반적인 방식이다.

핵심 성질은 다음과 같다.

- MSB가 1이면 음수로 해석된다.
- 음수 `-x`는 `~x + 1`로 표현할 수 있다.
- 덧셈기는 signed/unsigned 모두 같은 binary adder를 사용할 수 있다.
- overflow 판단 방식은 signed/unsigned에서 다르다.

## Carry와 overflow

Carry와 overflow는 같은 의미가 아니다.

- Carry는 unsigned addition에서 MSB 밖으로 carry가 나가는지 보는 것이다.
- Signed overflow는 두 양수를 더했는데 음수가 되거나, 두 음수를 더했는데 양수가 되는 경우이다.

답변 포인트는 다음과 같다.

```text
Unsigned에서는 carry-out이 overflow 판단에 중요하고,
signed two's complement에서는 operand sign과 result sign의 관계로 overflow를 판단한다.
```

## Width extension

Width를 늘릴 때 unsigned는 zero extension을 사용하고, signed는 sign extension을 사용한다.

```text
unsigned: 상위 bit를 0으로 채움
signed: sign bit를 상위 bit로 복제
```

잘못된 extension은 값 자체를 바꾸므로 datapath bug로 이어질 수 있다.

## Truncation

Truncation은 상위 bit를 버리는 것이다. 연산 결과가 target width보다 클 때 자동 또는 명시적으로 잘릴 수 있다.

면접에서는 다음처럼 말할 수 있어야 한다.

```text
Truncation은 단순 문법 문제가 아니라 overflow, precision loss, saturation 정책과 연결된다.
```

## Fixed-point

Fixed-point는 bit 중 일부를 integer part, 일부를 fractional part로 해석하는 방식이다. Hardware에서는 floating-point보다 단순하고 빠르지만, scale과 rounding, saturation 정책을 명확히 해야 한다.

확인할 항목은 다음과 같다.

- Q format
- multiply 후 bit growth
- rounding 또는 truncation
- saturation 또는 wrap-around
- 누적 연산에서 accumulator width

## Datapath building block

면접에서 자주 나오는 datapath block은 다음과 같다.

- adder/subtractor
- comparator
- mux
- shifter
- counter
- accumulator
- multiplier

각 block은 단독으로 이해하는 것보다 width, signedness, pipeline, critical path 관점까지 연결해 설명하는 것이 좋다.

## 핵심 답변 문장

- 회로의 signal은 정해진 width의 bit pattern이고, signed/unsigned 해석에 따라 값이 달라진다.
- Carry와 signed overflow는 같은 개념이 아니다.
- Datapath 설계에서는 width growth, extension, truncation, overflow 정책을 명확히 해야 한다.
- Fixed-point 설계에서는 scale과 rounding/saturation 정책이 핵심이다.
