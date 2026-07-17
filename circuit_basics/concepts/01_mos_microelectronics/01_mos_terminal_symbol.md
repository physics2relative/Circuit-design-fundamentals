# 1-1. MOSFET Terminal and Symbols

MOSFET의 기본 terminal은 gate, source, drain, body이다.

```text
Gate   : channel을 제어하는 terminal
Source : carrier가 유입되는 기준 terminal
Drain  : carrier가 빠져나가는 terminal
Body   : substrate 또는 well terminal
```

NMOS에서는 gate 전압이 source보다 충분히 높아지면 electron channel이 형성된다. PMOS에서는 gate 전압이 source보다 충분히 낮아지면 hole channel이 형성된다.

## NMOS 기준 전압

NMOS를 설명할 때 자주 쓰는 전압은 다음이다.

```text
VGS = VG - VS
VDS = VD - VS
VBS = VB - VS
```

NMOS는 보통 `VGS > VTH`이면 on 상태로 본다. 단, on이라는 표현은 완전한 ideal switch라는 뜻이 아니라 channel이 형성되어 drain current가 흐를 수 있다는 뜻이다.

## PMOS 기준 전압

PMOS는 source가 보통 높은 전압에 연결된다. PMOS는 `VSG > |VTHP|`일 때 on 상태로 본다.

```text
VSG = VS - VG
VSD = VS - VD
```

PMOS를 NMOS와 같은 부호로 억지로 외우기보다, “PMOS는 gate가 source보다 충분히 낮아지면 켜진다”고 이해하는 것이 실수하기 어렵다.

## Body terminal의 의미

Body는 단순히 무시되는 terminal이 아니다. Body-source 전압이 바뀌면 threshold voltage가 바뀐다. 이를 body effect라고 한다.

Digital standard cell에서는 body가 보통 고정되어 있지만, analog 회로나 low-power 회로에서는 body bias가 성능과 leakage에 영향을 줄 수 있다.

## 설계 관점 요약

- MOSFET은 4-terminal 소자이다.
- NMOS는 gate가 source보다 높을 때 켜진다.
- PMOS는 gate가 source보다 낮을 때 켜진다.
- source/drain은 구조적으로 대칭에 가깝지만, 동작 해석에서는 전압 기준에 따라 source와 drain을 구분한다.
- body 전압은 threshold voltage에 영향을 준다.
