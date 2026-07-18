# 3-6. Simulation Plan

Differential pair는 DC sweep, AC gain, CMRR, Monte Carlo simulation으로 확인하면 좋다.

## DC operating point

확인:

```text
Itail, branch current, VGS, VDS, VTH, saturation 여부
```

## Differential input sweep

`Vid`를 sweep하면서 branch current가 어떻게 나뉘는지 본다.

```text
Vid = 0 -> current 반분
Vid 증가 -> current steering
큰 Vid -> 한쪽으로 current 포화
```

## AC differential gain

차동 입력을 걸고 output gain을 확인한다.

```text
Ad = Vout / Vid
```

## AC common-mode gain / CMRR

두 입력에 같은 AC signal을 넣어 common-mode gain을 구한 뒤 CMRR을 계산한다.

```text
CMRR_dB = 20 log10 |Ad / Acm|
```

## Monte Carlo offset

Mismatch model이 있다면 Monte Carlo로 input offset 분포를 확인한다.

```text
offset mean
sigma
worst-case sample
```
