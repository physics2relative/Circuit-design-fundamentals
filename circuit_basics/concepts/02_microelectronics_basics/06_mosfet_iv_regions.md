# 2-6. MOSFET I-V Regions

MOSFET의 동작 영역은 cutoff, triode, saturation으로 나눈다. Razavi식 회로 해석에서는 각 영역의 수식보다 “어떤 회로 역할을 하는가”가 중요하다.

## Cutoff

NMOS 기준으로 `VGS < VTH`이면 channel이 충분히 형성되지 않는다.

```text
cutoff -> off에 가까운 상태
```

실제로는 subthreshold current가 흐르지만, 1차 회로 해석에서는 꺼진 소자로 근사한다.

## Triode region

NMOS 기준:

```text
VGS > VTH
VDS < VGS - VTH
```

Triode region에서는 MOSFET이 voltage-controlled resistor처럼 동작한다. Switch, transmission gate, sampling switch 해석에서 중요하다.

## Saturation region

NMOS 기준:

```text
VGS > VTH
VDS >= VGS - VTH
```

Saturation region에서는 drain current가 주로 `VGS`에 의해 결정된다. Analog amplifier에서 MOSFET을 transconductance device로 쓰려면 보통 saturation region에 bias한다.

## Transconductance gm

`gm`은 gate-source voltage 변화가 drain current 변화를 얼마나 만드는지 나타낸다.

```text
gm = dID / dVGS
```

Common-source amplifier의 gain은 기본적으로 `gm`과 output resistance로 결정된다.

## Output resistance ro

Channel length modulation 때문에 saturation current는 `VDS`에 완전히 무관하지 않다. 이 때문에 MOSFET은 유한한 output resistance `ro`를 가진다.

```text
ro가 클수록 ideal current source에 가까움
```

## 핵심 정리

```text
cutoff     : off에 가까움
triode     : voltage-controlled resistor
saturation : current source / gm device
```
