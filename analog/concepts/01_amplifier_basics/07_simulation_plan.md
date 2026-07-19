# 1-7. Simulation Plan

Amplifier basics는 Virtuoso/Spectre 또는 HSPICE로 다음 항목을 확인하면 좋다.

## Common-source amplifier

### DC operating point

확인할 값:

```text
ID, VGS, VDS, VTH, gm, ro
```

목표:

```text
transistor가 saturation인지 확인
bias current와 output DC level 확인
```

### AC simulation

확인할 값:

```text
low-frequency gain
-3 dB bandwidth
phase
load capacitance 변화에 따른 bandwidth
```

예상:

```text
Av ≈ -gm * Rout
load capacitance 증가 -> bandwidth 감소
```

### Transient simulation

확인할 것:

```text
sine input에 대한 output inversion
input amplitude 증가 시 clipping/distortion
output swing limit
```

## Source follower

확인할 것:

```text
voltage gain이 1보다 작음
load resistance 변화에 대한 output 유지 능력
output resistance가 낮은 buffer 특성
body effect 유무에 따른 gain 변화
```

## Common-gate amplifier

확인할 것:

```text
input resistance ≈ 1/gm
non-inverting voltage gain
wideband 특성
input source resistance 변화 영향
```

## 결과 정리 방식

각 실습 결과는 다음 형식으로 정리한다.

```text
simulation type -> 관찰한 metric -> 이론 예상값 -> simulation 결과 -> 차이 원인
```

PDK model, proprietary netlist, raw result directory는 commit하지 않고, 공개 가능한 회로 설명과 plot 캡처만 남긴다.
