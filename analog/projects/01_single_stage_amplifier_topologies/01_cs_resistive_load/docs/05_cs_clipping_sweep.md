# 05. 저항 부하 Common-Source의 clipping sweep

## 1. 실습 목표

입력 peak 진폭을 `180~380 mV`로 증가시키며 저항 부하 NMOS common-source의 양쪽 출력 한계를 확인한다.

1. 입력이 증가할 때 NMOS가 triode로 진입하며 발생하는 low-side compression을 확인한다.
2. 입력이 감소할 때 NMOS가 약하게 켜지며 출력이 VDD에 접근하는 high-side clipping을 확인한다.
3. Fundamental gain, THD와 MOS 동작영역 비율을 함께 사용해 clipping을 정량화한다.

## 2. Simulation 조건

```text
VDD      = 1.1 V
RD       = 5.6 kΩ
VIN_BIAS = 0.714 V
FIN      = 1 MHz
CL       = 100 fF
VIN_AMP  = {180, 200, 220, 250, 300, 350, 380 mV peak}
```

`VIN_AMP`는 peak 값이다. 따라서 가장 큰 `380 mV` 조건에서도 입력 범위는 약 `0.334~1.094 V`이며 nominal supply 범위를 넘지 않는다. 각 조건은 `5 µs` 동안 실행하고 마지막 3 cycle을 분석한다.

## 3. 측정 결과

| VIN peak | Gain | Gain 변화 | VOUT THD | VOUT 범위 | Triode | Saturation | Weak conduction | High rail |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 180 mV | 1.9893 V/V | -1.134 dB | 6.631% | 0.242~0.927 V | 12.0% | 88.0% | 0.0% | 0.0% |
| 200 mV | 1.9313 V/V | -1.391 dB | 7.761% | 0.226~0.957 V | 18.5% | 81.5% | 0.0% | 0.0% |
| 220 mV | 1.8718 V/V | -1.663 dB | 8.875% | 0.212~0.985 V | 22.5% | 69.5% | 8.0% | 0.0% |
| 250 mV | 1.7817 V/V | -2.091 dB | 10.477% | 0.195~1.020 V | 26.5% | 56.0% | 17.5% | 0.0% |
| 300 mV | 1.6344 V/V | -2.841 dB | 12.954% | 0.174~1.061 V | 31.5% | 44.0% | 24.5% | 0.0% |
| 350 mV | 1.4948 V/V | -3.616 dB | 15.276% | 0.159~1.085 V | 34.1% | 36.4% | 29.5% | 0.0% |
| 380 mV | 1.4163 V/V | -4.085 dB | 16.630% | 0.152~1.092 V | 35.5% | 33.4% | 31.0% | 7.0% |

Gain 변화는 `10 mV peak`의 small-signal 기준 gain인 `2.2667 V/V`에 대한 값이다. Region과 high rail 비율은 Spectre의 adaptive timestep에 영향을 받지 않도록 정상상태 구간을 시간 가중하여 계산한다. High rail은 `VOUT >= 1.09 V`인 시간 비율이다.

- [Clipping sweep 통합 결과](../figures/generated/tb_p01_cs_transient/05_clipping_comparison/)

## 4. Low-side clipping

입력이 증가하면 NMOS drain current가 증가하고 `VOUT`이 내려간다. `VOUT`이 낮아져 `VDS`가 `VDSAT`보다 작아지면 NMOS가 saturation에서 triode로 이동하고, small-signal gain을 유지하지 못한다.

현재 동작점에서는 `180 mV`부터 한 주기의 `12.0%` 동안 triode에 진입한다. 이때 high rail 체류는 없으므로 clipping의 시작은 출력의 낮은 전압 방향에서 먼저 나타난다.

## 5. High-side clipping

입력이 감소하면 NMOS drain current가 줄고 저항의 전압 강하도 감소하여 `VOUT`이 `VDD`에 접근한다. 입력이 threshold 부근보다 낮아지면 NMOS는 weak-conduction 또는 cutoff에 가까워지고 출력 위쪽이 더 이상 이상적인 sine 형태로 증가하지 못한다.

`220 mV`부터 weak-conduction 구간이 나타나며, `380 mV`에서는 출력 최대값이 `1.092 V`에 도달하고 주기의 `7.0%`가 `1.09 V` 이상에 머문다. 따라서 큰 진폭에서는 low-side와 high-side clipping이 동시에 존재한다.

## 6. 핵심 해석

1. 현재 회로에서는 low-side saturation headroom이 더 작아 triode 진입이 먼저 발생한다.
2. `VOUT=0.55 V`로 rail 중앙에 bias했더라도 MOS saturation 조건까지 대칭인 것은 아니다.
3. Hard rail clipping 이전에도 gain compression과 THD 증가는 이미 크게 나타난다.
4. 출력 swing은 rail 도달 여부만이 아니라 허용 gain compression과 THD 기준으로 정해야 한다.
5. NMOS common-source의 낮은 출력 한계는 triode 진입, 높은 출력 한계는 cutoff 접근과 VDD에 의해 결정된다.

## 7. 자동 재실행

```bash
./scripts/run_cs_transient.sh
```

명령은 11개 transient case를 실행하고 각 case의 측정값, 비교 CSV와 다음 SVG를 생성한다.

1. Gain compression과 THD
2. 180~380 mV 출력 파형
3. 입력 진폭별 VOUT minimum/maximum output swing envelope
4. 입력 진폭별 MOS 동작영역 비율

## 8. 다음 실습

`cdf_analog_tb/tb_p01_cs_current_load`에서 PMOS current-source load의 DC 동작점을 설정한다. 동일한 공급전압과 유사한 drain current에서 저항 부하 CS와 gain, output resistance, bandwidth와 output swing을 비교한다.
