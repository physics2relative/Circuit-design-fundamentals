# 1-2. Ideal Voltage and Current Sources

이상 전압원과 이상 전류원은 회로 해석에서 기준이 되는 source model이다. 실제 source는 이상적이지 않으므로 output resistance를 함께 생각해야 한다.

## Ideal voltage source

이상 전압원은 어떤 전류가 흐르더라도 단자 전압을 일정하게 유지한다.

```text
V = constant
```

이상 전압원의 output resistance는 0이다. 실제 voltage source나 regulator는 낮은 output resistance를 가질수록 이상 전압원에 가깝다.

## Ideal current source

이상 전류원은 단자 전압과 관계없이 일정한 전류를 공급한다.

```text
I = constant
```

이상 전류원의 output resistance는 무한대이다. 실제 current source는 output resistance가 클수록 이상 전류원에 가깝다.

## 실제 source model

실제 voltage source는 이상 전압원과 series resistance로 모델링할 수 있다.

```text
ideal voltage source + series Rout
```

실제 current source는 이상 전류원과 parallel resistance로 모델링할 수 있다.

```text
ideal current source || Rout
```

## 왜 output resistance가 중요한가

Current mirror나 bias current source는 output voltage가 바뀌어도 current가 거의 변하지 않아야 한다. 그래서 output resistance가 커야 한다.

Voltage regulator나 op-amp buffer는 load current가 변해도 output voltage가 거의 변하지 않아야 한다. 그래서 output resistance가 작아야 한다.

## 핵심 정리

```text
ideal voltage source : Rout = 0
ideal current source : Rout = infinity
real voltage source  : low Rout가 좋음
real current source  : high Rout가 좋음
```
