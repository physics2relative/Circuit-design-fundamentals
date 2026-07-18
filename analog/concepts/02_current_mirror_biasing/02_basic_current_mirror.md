# 2-2. Basic Current Mirror

Basic current mirror는 기준 current를 다른 branch로 복사하는 회로이다.

## 동작 원리

Diode-connected MOS가 기준 current에 맞는 `VGS`를 만든다. 같은 `VGS`를 가진 output MOS가 비슷한 current를 흘린다.

```text
IREF -> diode-connected MOS -> VGS 생성
same VGS -> output MOS -> IOUT 생성
```

## Current ratio

두 transistor가 같은 region에 있고 matching이 좋다면 current ratio는 W/L ratio로 정해진다.

```text
IOUT / IREF ≈ (W/L)out / (W/L)ref
```

## 정확도를 제한하는 요인

- channel length modulation
- VDS mismatch
- VTH mismatch
- mobility/process variation
- layout mismatch
- finite output resistance

## 좋은 mirror 조건

- 같은 orientation과 가까운 placement
- 충분한 device area로 mismatch 감소
- output transistor saturation 유지
- 필요한 경우 cascode로 output resistance 증가
