# 1-7. BJT Basics

BJT는 base-emitter junction 전압에 의해 collector current가 exponential하게 결정되는 소자이다. CMOS 공정 중심으로 공부하더라도 BJT는 diode, gm, exponential I-V, small-signal model, current mirror, bandgap reference를 이해하는 데 유용하다.

## Terminal

BJT의 terminal은 세 개이다.

```text
Emitter, Base, Collector
```

NPN 기준으로 보면 emitter는 carrier를 주입하고, base는 매우 얇은 제어 영역이며, collector는 carrier를 수집한다.

## 동작 영역

BJT의 주요 동작 영역은 다음과 같다.

```text
cutoff       : BE junction off, BC junction off
forward active : BE junction forward bias, BC junction reverse bias
saturation   : BE junction forward bias, BC junction forward bias
reverse active : BE junction reverse bias, BC junction forward bias
```

Analog amplifier에서는 보통 forward active region을 사용한다.

## Forward active region

NPN BJT가 forward active region에 있으려면 base-emitter junction은 forward bias, base-collector junction은 reverse bias되어야 한다.

```text
VBE ≈ 0.7 V 근처에서 forward bias
VCB > 0 또는 VCE가 충분히 큼
```

이때 collector current는 base-emitter voltage에 대해 exponential하게 증가한다.

```text
IC ≈ IS * exp(VBE / VT)
```

여기서 `VT`는 thermal voltage이다.

```text
VT = kT / q ≈ 25.9 mV at 300 K
```

## Current gain beta

Base current와 collector current의 비를 current gain `β`라고 한다.

```text
IC = β * IB
IE = IC + IB
α = IC / IE = β / (β + 1)
```

`β`가 크면 base current는 collector current보다 작다. 하지만 analog 회로 해석에서는 β만으로 충분하지 않고, `gm`, `rπ`, `ro`를 함께 봐야 한다.

## Transconductance gm

BJT의 small-signal transconductance는 bias collector current로 정해진다.

```text
gm = ∂IC / ∂VBE = IC / VT
```

예를 들어 `IC = 1 mA`이면:

```text
gm ≈ 1 mA / 25.9 mV ≈ 38.6 mS
```

같은 bias current에서 BJT의 gm은 MOSFET보다 큰 경우가 많다. 그래서 BJT는 높은 transconductance와 gain을 얻기 유리하다.

## Input resistance rπ

Hybrid-π model에서 base-emitter 사이의 small-signal resistance를 `rπ`라고 한다.

```text
rπ = β / gm
```

또는:

```text
rπ = VT / IB
```

즉 β가 클수록, 또는 bias current가 작을수록 input resistance가 커진다. MOSFET gate와 달리 BJT base에는 current가 흐르므로 input resistance가 유한하다.

## Early effect

Forward active region에서 ideal BJT는 `IC`가 `VCE`와 무관하다고 가정한다. 실제로는 `VCE`가 증가하면 base width가 줄어들고 collector current가 약간 증가한다. 이를 Early effect 또는 base-width modulation이라고 한다.

Collector current를 간단히 쓰면 다음처럼 표현할 수 있다.

```text
IC ≈ IS * exp(VBE / VT) * (1 + VCE / VA)
```

여기서 `VA`는 Early voltage이다. `VA`가 클수록 collector current가 VCE에 덜 의존하므로 더 ideal한 current source에 가깝다.

## Output resistance ro

Early effect 때문에 BJT의 output resistance는 유한하다.

```text
ro = VA / IC
```

더 정확히는 bias point 근처에서 다음처럼 본다.

```text
ro ≈ (VA + VCE) / IC ≈ VA / IC
```

보통 `VA >> VCE`인 경우가 많아서 `ro ≈ VA / IC`로 근사한다.

예를 들어 `VA = 100 V`, `IC = 1 mA`이면:

```text
ro ≈ 100 V / 1 mA = 100 kΩ
```

`ro`가 클수록 collector current가 output voltage 변화에 덜 흔들리고, amplifier gain이 커진다.

## Hybrid-π small-signal model

Forward active region에서 BJT는 다음 small-signal model로 자주 해석한다.

```text
base-emitter: rπ
collector-emitter: ro
controlled current source: gm * vπ from collector to emitter
```

여기서 `vπ`는 base-emitter small-signal voltage이다.

```text
ic = gm * vπ
ib = vπ / rπ
```

## Common-emitter amplifier gain

Common-emitter amplifier는 MOS의 common-source amplifier와 비슷하게 inverting gain을 가진다.

Collector에 저항 `RC`가 있고 emitter가 AC ground라면 voltage gain은 대략 다음과 같다.

```text
Av ≈ -gm * (RC || ro)
```

`ro`가 충분히 크면:

```text
Av ≈ -gm * RC
```

Active load를 사용하면 effective output resistance가 커지고 gain이 증가할 수 있다.

## MOSFET과 비교

```text
MOSFET : gate voltage가 channel을 제어, 이상적으로 DC gate current 작음
BJT    : VBE가 collector current를 exponential하게 제어, base current 존재
```

Small-signal 관점에서는 다음처럼 비교할 수 있다.

```text
MOSFET gm : bias current와 overdrive voltage에 의해 결정
BJT gm    : IC / VT

MOSFET input resistance : gate 기준으로 매우 큼
BJT input resistance    : rπ = β/gm 로 유한

MOSFET ro : channel length modulation 때문에 유한
BJT ro    : Early effect 때문에 유한
```

## 왜 알아야 하는가

- Diode exponential I-V와 small-signal resistance의 확장으로 이해할 수 있다.
- Bandgap reference는 BJT의 `VBE`와 thermal voltage 특성을 이용한다.
- CMOS IC에서도 parasitic BJT, ESD, latch-up 이해에 필요하다.
- Analog amplifier에서 gm, input resistance, output resistance 개념을 비교하기 좋다.

## 핵심 정리

```text
IC ≈ IS * exp(VBE / VT)
gm = IC / VT
rπ = β / gm
ro ≈ VA / IC
Av(common-emitter) ≈ -gm * (RC || ro)
```

BJT는 β만 외우는 소자가 아니다. 회로 해석에서는 bias current가 정하는 `gm`, base current 때문에 생기는 `rπ`, Early effect 때문에 생기는 `ro`를 함께 봐야 한다.
