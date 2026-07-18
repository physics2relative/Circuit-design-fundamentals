# 4-2. I-V Regions

NMOS 기준 동작 영역은 cutoff, triode, saturation으로 나눈다.

## Cutoff

```text
VGS < VTH
```

Channel이 충분히 형성되지 않은 상태이다. 실제로는 subthreshold leakage가 흐른다.

## Triode region

```text
VGS > VTH
VDS < VGS - VTH
```

MOSFET이 voltage-controlled resistor처럼 동작한다. Switch, transmission gate, sampling switch에서 중요하다.

## Saturation region

```text
VGS > VTH
VDS >= VGS - VTH
```

Drain current가 주로 VGS에 의해 결정된다. Analog amplifier에서는 MOSFET을 saturation에 bias해 gm device로 사용한다.

## 회로 연결

```text
triode     -> switch / resistor
saturation -> current source / amplifier device
cutoff     -> off device, leakage 고려
```
