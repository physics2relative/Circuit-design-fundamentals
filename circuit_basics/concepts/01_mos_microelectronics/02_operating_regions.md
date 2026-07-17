# 1-2. Operating Regions

MOSFET 동작 영역은 cutoff, triode, saturation으로 나누어 설명한다. 회로설계에서는 각 영역을 전류식 자체보다 “회로에서 어떤 역할을 하는가”로 이해하는 것이 중요하다.

## Cutoff

Cutoff는 channel이 충분히 형성되지 않은 상태이다.

NMOS 기준:

```text
VGS < VTH
```

이상적으로는 drain current가 0이지만, 실제로는 subthreshold leakage가 흐른다. 디지털 회로의 static power는 이런 off current와 관련된다.

## Triode / Linear region

Triode region은 MOSFET이 저항처럼 동작하는 영역이다.

NMOS 기준:

```text
VGS > VTH
VDS < VGS - VTH
```

이 영역에서는 VDS가 작고 channel이 drain까지 형성되어 있다. Switch, transmission gate, on-resistance 관점에서 중요하다.

## Saturation region

Saturation region은 drain 쪽 channel이 pinch-off 되어 drain current가 주로 VGS에 의해 결정되는 영역이다.

NMOS 기준:

```text
VGS > VTH
VDS >= VGS - VTH
```

Analog amplifier에서는 saturation region이 중요하다. MOSFET을 current source나 transconductance device로 사용하려면 보통 saturation에 머물러야 한다.

## Digital과 analog에서의 해석 차이

Digital CMOS inverter에서는 transition 중 NMOS/PMOS가 순간적으로 여러 영역을 지나간다. 입력이 천천히 변하면 NMOS와 PMOS가 동시에 켜지는 시간이 길어져 short-circuit current가 증가한다.

Analog amplifier에서는 특정 transistor가 saturation을 유지하는지가 gain과 output swing을 결정한다.

## 핵심 정리

```text
cutoff     : 꺼진 상태, leakage가 중요
triode     : 저항/스위치처럼 동작
saturation : current source/gm device처럼 동작
```

면접에서는 영역 조건을 말한 뒤, “그래서 회로에서 어떤 의미인지”까지 연결해 설명하는 것이 좋다.
