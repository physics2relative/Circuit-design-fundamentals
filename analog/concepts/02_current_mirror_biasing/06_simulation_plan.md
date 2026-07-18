# 2-6. Simulation Plan

Current mirror와 bias 회로는 DC sweep, operating point, corner simulation이 특히 중요하다.

## Basic current mirror

### DC operating point

확인:

```text
IREF, IOUT, VGS, VDS, VTH, saturation 여부
```

### Output sweep

Output voltage를 sweep하면서 `IOUT` 변화를 본다.

```text
Vout sweep -> Iout curve -> output resistance 추정
```

기울기가 작을수록 output resistance가 크다.

## Ratio sweep

Output transistor W/L ratio를 바꿔 current scaling이 예상과 맞는지 확인한다.

```text
IOUT / IREF ≈ device ratio
```

## Compliance 확인

Output voltage가 낮아질 때 어느 지점에서 transistor가 triode로 들어가고 current가 무너지는지 본다.

## Cascode mirror

Basic mirror와 cascode mirror를 비교한다.

```text
output resistance
minimum output voltage
current accuracy
```

## BMR / BGR

가능하면 다음을 확인한다.

```text
VDD sweep: line sensitivity
Temperature sweep: tempco
Process corner: process sensitivity
Startup transient: zero-current state 탈출 여부
```
