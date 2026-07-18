# 4-1. Terminal and Operation

MOSFET terminal은 gate, source, drain, body이다.

```text
Gate   : channel 제어
Source : carrier 기준 terminal
Drain  : carrier 수집 terminal
Body   : substrate/well
```

NMOS는 gate가 source보다 충분히 높으면 inversion channel이 형성된다.

```text
VGS > VTH
```

PMOS는 gate가 source보다 충분히 낮으면 켜진다.

```text
VSG > |VTHP|
```

MOSFET은 회로에 따라 switch, transconductance device, current source로 해석된다.
