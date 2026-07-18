# 2-1. CMOS Inverter Operation

CMOS inverter는 PMOS pull-up network와 NMOS pull-down network로 구성된다.

```text
VDD
 |
PMOS
 |
OUT
 |
NMOS
 |
GND
```

## Input low

입력이 0이면 PMOS는 켜지고 NMOS는 꺼진다. 출력은 VDD로 충전되어 logic 1이 된다.

```text
IN = 0 -> PMOS on, NMOS off -> OUT = 1
```

## Input high

입력이 1이면 PMOS는 꺼지고 NMOS는 켜진다. 출력은 GND로 방전되어 logic 0이 된다.

```text
IN = 1 -> PMOS off, NMOS on -> OUT = 0
```

## Steady-state current

정상적인 steady state에서는 VDD에서 GND로 이어지는 DC path가 거의 없다. 따라서 ideal CMOS logic은 switching하지 않을 때 dynamic power를 소모하지 않는다.

하지만 실제로는 leakage current가 있으므로 static power가 0은 아니다.

## Transition 중 동작

입력이 0에서 1 또는 1에서 0으로 변하는 동안에는 NMOS와 PMOS가 동시에 일부 켜질 수 있다. 이때 VDD에서 GND로 직접 흐르는 short-circuit current가 생긴다.

또한 output load capacitance가 충전/방전되면서 dynamic power가 소모된다.

## 핵심 정리

CMOS inverter는 다음 개념을 연결한다.

- logic level restoration
- noise margin
- load capacitance 충방전
- propagation delay
- dynamic power
- leakage/static power
- short-circuit current
