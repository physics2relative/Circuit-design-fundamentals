# 5-6. Differential Pair

Differential pair는 두 입력의 차이를 증폭하는 analog 회로의 핵심 구조이다. Op-amp input stage의 기본이 된다.

## 기본 동작

Differential pair는 두 transistor가 tail current를 나눠 갖는다.

```text
Vin+ > Vin- -> 한쪽 current 증가, 반대쪽 current 감소
Vin+ < Vin- -> 반대쪽 current 증가
```

출력은 한쪽 drain 또는 differential output으로 얻을 수 있다.

## Common-mode와 differential-mode

Differential-mode signal은 두 입력의 차이이다.

```text
Vdiff = Vin+ - Vin-
```

Common-mode signal은 두 입력에 공통으로 들어가는 성분이다.

```text
Vcm = (Vin+ + Vin-) / 2
```

좋은 differential amplifier는 differential signal은 크게 증폭하고 common-mode signal은 억제해야 한다.

## CMRR

CMRR은 common-mode rejection ratio이다.

```text
CMRR = differential gain / common-mode gain
```

CMRR이 클수록 공통 잡음에 강하다.

## 설계 포인트

- input common-mode range
- tail current source의 output resistance
- transistor matching
- offset
- gain과 bandwidth
- output swing
