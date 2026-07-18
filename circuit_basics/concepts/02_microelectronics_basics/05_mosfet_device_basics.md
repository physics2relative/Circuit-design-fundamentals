# 2-5. MOSFET Device Basics

MOSFET은 gate 전압으로 channel의 전도도를 조절하는 field-effect device이다. Analog와 digital 모두에서 가장 중요한 소자이며, 회로 해석에서는 terminal voltage와 operating region을 기준으로 본다.

## Terminal

MOSFET의 terminal은 네 개이다.

```text
Gate, Source, Drain, Body
```

Gate는 oxide로 channel과 절연되어 있어 DC gate current가 이상적으로 거의 없다. Source와 drain 사이의 channel은 gate voltage에 의해 형성된다.

## NMOS와 PMOS

NMOS는 gate가 source보다 충분히 높을 때 켜진다.

```text
VGS > VTH
```

PMOS는 gate가 source보다 충분히 낮을 때 켜진다.

```text
VSG > |VTHP|
```

## Body terminal

Body는 threshold voltage에 영향을 줄 수 있다. Source-body 전압이 변하면 body effect 때문에 VTH가 바뀐다.

Analog 회로에서는 body connection과 source 전압이 동작점에 영향을 줄 수 있으므로, body를 단순히 없는 terminal처럼 보면 안 된다.

## MOSFET을 보는 두 관점

MOSFET은 회로에 따라 다르게 해석된다.

```text
switch 관점      : triode/cutoff를 이용해 on/off 경로 형성
amplifier 관점   : saturation에서 gm device로 사용
current source 관점 : saturation과 큰 ro를 이용
```

이 장에서는 amplifier 관점을 위해 MOSFET의 I-V region과 small-signal parameter를 중점적으로 본다.
