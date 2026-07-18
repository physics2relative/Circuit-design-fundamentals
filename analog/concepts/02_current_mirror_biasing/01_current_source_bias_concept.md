# 2-1. Current Source and Bias Concept

Bias 회로는 amplifier가 원하는 operating region에서 동작하도록 DC voltage와 current를 제공한다.

## 왜 bias가 필요한가

Transistor amplifier는 특정 DC operating point 근처에서 small-signal gain을 만든다. Bias가 없거나 틀리면 transistor가 cutoff/triode로 가거나 output swing이 부족해진다.

```text
bias point -> gm, ro, headroom, swing, power 결정
```

## Ideal current source

Ideal current source는 output voltage와 무관하게 일정한 current를 공급한다.

```text
Rout -> infinity
```

실제 current source는 output resistance가 유한하므로 output voltage가 바뀌면 current도 조금 바뀐다.

## Bias 설계의 기준

- 원하는 current magnitude
- supply sensitivity
- process/temperature sensitivity
- voltage headroom
- startup 안정성
- noise
- matching
