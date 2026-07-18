# 4-4. Leakage and Capacitance

MOSFET은 off 상태에서도 leakage가 있고, terminal 사이 capacitance가 있다.

## Leakage

주요 leakage는 다음이다.

```text
subthreshold leakage
gate leakage
junction leakage
GIDL 등 field-induced leakage
```

Subthreshold leakage는 VGS가 VTH보다 낮아도 diffusion 성분으로 current가 흐르는 현상이다.

## Capacitance

MOSFET capacitance는 speed와 frequency response에 영향을 준다.

```text
Cgs, Cgd, Cgb
source/drain junction capacitance
overlap capacitance
```

Digital에서는 load capacitance와 delay에, analog에서는 pole/zero와 Miller effect에 연결된다.
