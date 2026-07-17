# 1-8. Small-signal Modeling

Small-signal model은 nonlinear device를 bias point 근처에서 선형 회로로 바꿔 해석하는 방법이다. Amplifier 해석의 핵심 도구이다.

## 기본 절차

```text
1. DC source만 고려해 operating point를 구한다.
2. 소자의 gm, ro, small-signal resistance를 계산한다.
3. DC source는 AC ground로 둔다.
4. 소자를 small-signal equivalent circuit으로 바꾼다.
5. gain, input resistance, output resistance를 구한다.
```

## MOSFET small-signal model

Saturation region의 MOSFET은 gate-source voltage에 의해 제어되는 current source와 output resistance로 모델링한다.

```text
id = gm * vgs + vds / ro
```

Gate current는 이상적으로 0이므로 input resistance가 매우 크다.

## BJT small-signal model

BJT는 hybrid-pi model을 자주 사용한다.

```text
ic = gm * vpi
rpi = beta / gm
```

MOSFET과 달리 base input current가 존재하므로 input resistance가 유한하다.

## Gain 해석

Common-source 또는 common-emitter amplifier의 기본 voltage gain은 다음 형태로 자주 나타난다.

```text
Av ≈ -gm * Rout
```

따라서 gain을 키우려면 gm을 키우거나 output resistance를 키워야 한다.

## 핵심 정리

Small-signal model은 회로를 외우는 도구가 아니라, bias된 nonlinear device를 선형 증폭기로 해석하기 위한 방법이다.
