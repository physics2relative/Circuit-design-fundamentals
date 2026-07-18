# 3-2. Differential and Common-mode Gain

Differential pair는 differential signal은 증폭하고 common-mode signal은 억제하도록 설계한다.

## Differential input

```text
Vid = Vin+ - Vin-
```

Differential input은 두 입력의 차이이다. 원하는 신호가 여기에 실린다.

## Common-mode input

```text
Vcm = (Vin+ + Vin-) / 2
```

Common-mode input은 두 입력에 공통으로 들어가는 성분이다. Supply noise, substrate noise, 외부 간섭이 common-mode로 들어올 수 있다.

## Differential gain

Differential gain은 differential input이 output에 얼마나 증폭되는지 나타낸다.

```text
Ad = Vout / Vid
```

## Common-mode gain

Common-mode gain은 common-mode input이 output에 얼마나 나타나는지 나타낸다.

```text
Acm = Vout / Vcm
```

## CMRR

CMRR은 common-mode rejection ratio이다.

```text
CMRR = |Ad / Acm|
CMRR_dB = 20 log10 |Ad / Acm|
```

CMRR이 클수록 differential signal을 잘 증폭하고 common-mode noise를 잘 억제한다.
