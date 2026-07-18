# 2-3. PN Junction and Diode Basics

Diode는 PN junction으로 이루어진 가장 기본적인 nonlinear device이다. Microelectronics에서 diode는 exponential I-V, rectification, small-signal resistance를 이해하는 출발점이다.

## PN junction 직관

P형과 N형 반도체가 만나면 carrier diffusion 때문에 depletion region이 생기고 built-in potential이 형성된다.

Forward bias를 걸면 barrier가 낮아져 current가 크게 흐르고, reverse bias를 걸면 barrier가 커져 이상적으로는 current가 거의 흐르지 않는다.

## Diode I-V 특성

Diode current는 대략 exponential 관계를 가진다.

```text
ID ≈ IS * exp(VD / nVT)
```

정확한 수식 암기보다 중요한 것은 forward voltage가 조금만 증가해도 current가 크게 증가한다는 점이다.

## Small-signal resistance

Bias current가 정해진 diode는 그 동작점 근처에서 작은 저항처럼 볼 수 있다.

```text
rd ≈ nVT / ID
```

즉 diode current가 클수록 small-signal resistance는 작아진다.

## Diode-connected transistor와 연결

Analog CMOS 회로에서는 diode 자체보다 diode-connected MOSFET을 더 자주 본다. 하지만 원리는 비슷하다. Nonlinear device를 특정 current에 bias하면 그 주변에서 small-signal resistance나 transconductance로 모델링할 수 있다.

## 핵심 정리

- Diode는 nonlinear I-V를 가진다.
- Forward bias에서 current가 exponential하게 증가한다.
- DC bias point 근처에서는 small-signal resistance로 근사할 수 있다.
- 이 관점이 MOS/BJT small-signal model로 이어진다.
