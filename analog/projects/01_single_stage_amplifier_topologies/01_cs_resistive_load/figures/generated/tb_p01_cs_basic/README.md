# CS DC Sweep Load Comparison

동일한 NMOS 크기(`W=800 nm`, `L=80 nm`), `VDD=1.1 V`, `VIN_BIAS=0~1.1 V` 조건에서 drain 저항만 변경한 결과이다.

## 결과

- [RD = 1 kΩ](./01_rd_1k/)
- [RD = 5.6 kΩ](./02_rd_5p6k/)

| 조건 | 기준점 | VIN_BIAS | VOUT | ID | VOV | 동작 영역 |
|---|---|---:|---:|---:|---:|---|
| RD = 1 kΩ | ID ≈ 100 µA | 0.685 V | 0.9999 V | 100.08 µA | 0.1846 V | saturation |
| RD = 5.6 kΩ | VOUT ≈ 0.55 V | 0.714 V | 0.5500 V | 98.21 µA | 0.2079 V | saturation |
| RD = 5.6 kΩ | ID ≈ 100 µA | 0.718 V | 0.5409 V | 99.83 µA | 0.2118 V | saturation |

1 kΩ에서는 `VIN_BIAS`를 1.1 V까지 높여도 최소 `VOUT`이 약 0.739 V이므로 출력 동작점을 0.55 V 부근에 둘 수 없다. 5.6 kΩ에서는 약 100 µA가 흐를 때 저항 전압 강하가 약 0.55 V가 되어 목표 동작점에 근접한다.
