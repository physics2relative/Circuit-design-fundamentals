# 3-5. Offset, Noise, and CMRR

Differential pair의 실제 성능은 mismatch, noise, tail current source 품질에 영향을 받는다.

## Offset

Input offset은 output을 0으로 만들기 위해 필요한 작은 differential input voltage이다.

Offset 원인:

```text
VTH mismatch
gm mismatch
load mismatch
tail current imbalance
layout asymmetry
```

Device area를 키우고 common-centroid layout을 사용하면 random mismatch를 줄일 수 있다.

## Noise

Input pair는 op-amp input-referred noise에 큰 영향을 준다.

주요 noise:

```text
thermal noise
flicker noise
```

저주파 precision 회로에서는 flicker noise가 중요하다.

## CMRR 저하 원인

- tail current source output resistance가 낮음
- load mismatch
- input pair mismatch
- layout asymmetry
- finite output resistance
