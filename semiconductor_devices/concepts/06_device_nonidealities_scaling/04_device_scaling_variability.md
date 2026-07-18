# 6-4. Device Scaling and Variability

공정 scaling은 density와 speed를 개선하지만 leakage, variability, reliability 문제를 키운다.

## Scaling 영향

```text
channel length 감소
oxide thickness 감소
VDD 감소
wire pitch 감소
```

## 생기는 문제

```text
short-channel effect
DIBL
subthreshold leakage 증가
gate leakage
random variation
matching 악화 가능
interconnect RC 증가
```

## Variation

Process variation은 die-to-die, within-die, random mismatch로 나눠 볼 수 있다.

```text
VTH variation
Leff variation
Cox/tox variation
mobility variation
line edge roughness
random dopant fluctuation
```

회로에서는 delay, leakage, gain, offset, noise margin 변화로 나타난다.
