# 2-5. Beta-multiplier and Bandgap Overview

Beta-multiplier reference와 bandgap reference는 bias/reference 회로를 이해하기 위한 대표 구조이다.

## Beta-multiplier reference

Beta-multiplier reference는 MOS ratio와 resistor를 이용해 supply에 덜 민감한 bias current를 만든다.

대표적으로 결과식에는 VDD가 직접 들어가지 않는 형태가 된다.

```text
IREF ≈ function(K, R, device ratio)
```

하지만 `K = μCox(W/L)`와 resistor absolute value는 process variation을 받으므로 absolute current가 process independent인 것은 아니다.

```text
VDD sensitivity는 작게 만들 수 있음
process sensitivity는 K, R 때문에 남음
```

또한 self-biased loop에는 zero-current operating point가 있을 수 있어 startup 회로가 필요하다.

## Bandgap reference

Bandgap reference는 CTAT 성분인 `VBE`와 PTAT 성분인 `ΔVBE`를 더해 temperature coefficient가 작은 reference voltage를 만든다.

```text
VREF = VBE + k * ΔVBE
```

BGR은 temperature variation 보상에는 강하지만, resistor ratio mismatch, BJT mismatch, op-amp offset, process variation 때문에 absolute error가 남을 수 있다. 그래서 trimming을 쓰는 경우가 많다.

## Process 보상 관점

Process는 voltage/temperature처럼 직접 완전히 보상하기 어렵다. 보통 다음 방식으로 민감도를 줄인다.

```text
ratio 기반 설계
layout matching
replica/tracking
feedback
trim/calibration
```
