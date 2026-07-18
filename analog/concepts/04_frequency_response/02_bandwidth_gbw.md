# 4-2. Bandwidth and Gain-bandwidth Trade-off

Bandwidth는 amplifier가 충분한 gain으로 신호를 처리할 수 있는 주파수 범위이다.

## -3 dB bandwidth

Low-frequency gain 대비 gain이 3 dB 낮아지는 주파수를 bandwidth로 자주 사용한다.

```text
|A(f3dB)| = |A0| / sqrt(2)
```

## Gain-bandwidth product

Dominant pole이 하나인 amplifier에서는 gain과 bandwidth의 곱이 거의 일정하게 보일 수 있다.

```text
GBW ≈ A0 * f3dB
```

Closed-loop gain을 낮추면 bandwidth가 늘어나는 이유가 여기에 있다.

## 설계 trade-off

- gain을 키우려면 output resistance를 키우거나 gm을 키운다.
- output resistance가 커지면 pole frequency가 낮아질 수 있다.
- bias current를 키우면 gm과 bandwidth가 좋아질 수 있지만 power가 증가한다.
- load capacitance가 커지면 bandwidth가 감소한다.
