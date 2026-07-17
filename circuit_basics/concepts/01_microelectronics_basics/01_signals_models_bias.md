# 1-1. Signals, Models, and Bias Point

Microelectronics에서 가장 먼저 구분해야 할 것은 large-signal 동작과 small-signal 동작이다.

## Large-signal

Large-signal 해석은 소자의 전체 nonlinear I-V 관계를 사용해 DC operating point나 큰 입력 변화에 대한 동작을 보는 것이다.

예를 들어 MOSFET의 DC drain current, diode의 exponential current, op-amp의 output swing limit은 large-signal 관점이다.

## Bias point

Bias point는 회로가 신호를 받기 전에 놓여 있는 DC 동작점이다.

```text
DC input, supply, bias current -> operating point
```

Amplifier는 보통 transistor를 적절한 operating region에 bias한 뒤, 그 근처에서 작은 신호를 증폭한다.

## Small-signal

Small-signal 해석은 bias point 주변의 작은 변화만 선형화해서 보는 방법이다.

```text
v(t) = VBIAS + small variation
```

Nonlinear device도 특정 bias point 근처에서는 기울기와 저항으로 근사할 수 있다.

## 왜 bias가 중요한가

Transistor가 원하는 region에 있지 않으면 amplifier로 동작하지 않는다.

- MOS common-source amplifier는 보통 saturation region에 bias해야 gain을 얻는다.
- Differential pair는 tail current와 input common-mode에 의해 동작 범위가 정해진다.
- Diode-connected device도 DC current에 따라 small-signal resistance가 달라진다.

## 핵심 정리

```text
large-signal : DC 동작점과 큰 변화
bias point   : small-signal 해석의 기준점
small-signal : bias 근처의 작은 변화에 대한 선형 근사
```
