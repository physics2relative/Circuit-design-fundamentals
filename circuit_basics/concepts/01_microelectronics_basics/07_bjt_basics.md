# 1-7. BJT Basics

BJT는 base-emitter junction 전압에 의해 collector current가 exponential하게 결정되는 소자이다. CMOS 공정 중심으로 공부하더라도 BJT는 diode, gm, exponential I-V, amplifier 개념을 이해하는 데 유용하다.

## Terminal

BJT의 terminal은 세 개이다.

```text
Emitter, Base, Collector
```

NPN 기준으로 base-emitter junction이 forward bias되고 collector-base junction이 reverse bias되면 forward active region에서 동작한다.

## Forward active region

Forward active region에서 collector current는 base-emitter voltage에 대해 exponential하게 증가한다.

```text
IC ≈ IS * exp(VBE / VT)
```

BJT는 small-signal transconductance가 bias current에 의해 정해진다.

```text
gm = IC / VT
```

## Current gain beta

Base current와 collector current의 비를 current gain `beta`라고 한다.

```text
IC = beta * IB
```

하지만 analog 회로 해석에서는 beta만 보는 것보다 gm, rpi, ro를 함께 보는 것이 중요하다.

## MOSFET과 비교

```text
MOSFET : gate voltage가 channel을 제어, 이상적으로 DC gate current 작음
BJT    : base-emitter voltage가 collector current를 exponential하게 제어, base current 존재
```

BJT는 같은 bias current에서 큰 gm을 얻기 쉽지만, input current와 charge storage 등을 고려해야 한다.

## 왜 알아야 하는가

- diode-connected device와 exponential I-V 이해에 도움된다.
- bandgap reference, ESD, parasitic BJT 같은 실제 IC 요소와 연결된다.
- analog amplifier에서 gm, input resistance, output resistance 개념을 비교하기 좋다.
