# CS AC Load-Capacitance Comparison

`RD=5.6 kΩ`, `VIN_BIAS=0.714 V`, `VDD=1.1 V`, 입력 AC magnitude `1` 조건에서 부하 커패시턴스만 변경한 결과이다.

## 조건별 결과

1. [CL = 10 fF](./01_cl_10f/)
2. [CL = 100 fF](./02_cl_100f/)
3. [CL = 1 pF](./03_cl_1p/)
4. [통합 gain/phase 비교](./04_cl_comparison/)

| CL | 저주파 이득 | -3 dB bandwidth | Unity-gain frequency |
|---:|---:|---:|---:|
| 10 fF | 2.268 V/V, 7.111 dB | 3.477 GHz | 7.077 GHz |
| 100 fF | 2.268 V/V, 7.111 dB | 365.2 MHz | 743.3 MHz |
| 1 pF | 2.268 V/V, 7.111 dB | 36.71 MHz | 74.71 MHz |

부하 커패시턴스는 DC에서 open circuit이므로 저주파 이득과 동작점은 거의 변하지 않는다. 반면 `CL`이 10배 증가할 때 output pole이 약 10분의 1로 낮아져 bandwidth도 거의 10분의 1로 감소한다.

## 동작점과 손계산

`VIN_BIAS=0.714 V`의 Spectre operating point는 다음과 같다.

- `ID=98.21 µA`
- `VOUT=0.5500 V`
- `gm=528.39 µS`
- `gds=52.73 µS`
- `ro=18.97 kΩ`
- NMOS region: saturation

```text
Rout ≈ RD || ro = 5.6 kΩ || 18.97 kΩ = 4.323 kΩ
|Av| ≈ gm(RD || ro) = 2.284 V/V = 7.176 dB
```

시뮬레이션 저주파 이득은 `2.268 V/V`, `7.111 dB`로 근사 계산과 약 `0.065 dB` 차이이다.
