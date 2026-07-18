# 4-1. Pole, Zero, and Bode Plot

Pole과 zero는 transfer function의 주파수 응답을 결정한다.

## Pole

1차 low-pass의 transfer function은 다음과 같다.

```text
H(s) = A0 / (1 + s/ωp)
```

Pole 이후 gain은 대략 -20 dB/decade로 감소하고 phase는 -90도 방향으로 이동한다.

## Zero

Zero는 transfer function의 numerator에 생기는 항이다.

```text
H(s) = A0 * (1 + s/ωz)
```

Zero는 magnitude slope와 phase를 바꾼다. Right-half-plane zero는 phase margin을 악화시킬 수 있다.

## Bode plot

Bode plot은 gain magnitude와 phase를 주파수에 대해 그린 것이다.

```text
magnitude plot
phase plot
```

AC simulation에서 amplifier의 gain, bandwidth, phase margin을 보는 기본 형식이다.
