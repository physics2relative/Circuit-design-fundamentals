# CS AC Load-Capacitance Overlay

동일한 DC 동작점에서 `CL`만 변경한 gain/phase 중첩 그래프이다.

![CS AC load comparison](./01_cs_ac_load_comparison.svg)

| CL | Low-frequency gain | -3 dB bandwidth |
|---:|---:|---:|
| 10 fF | 7.111 dB | 3.477 GHz |
| 100 fF | 7.111 dB | 365.2 MHz |
| 1 pF | 7.111 dB | 36.71 MHz |

`CL`이 커질수록 저주파 이득은 거의 유지되지만 output pole이 낮아져 bandwidth가 감소한다.
원 표식은 각 곡선의 저주파 이득 대비 `-3 dB` 지점이다.

## 재생성

```bash
python3 scripts/plot_cs_ac_load_comparison.py
```
