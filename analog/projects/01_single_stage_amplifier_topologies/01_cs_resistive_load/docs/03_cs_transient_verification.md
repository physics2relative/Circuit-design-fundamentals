# 03. 저항 부하 Common-Source의 transient 검증

## 1. 실습 목표

AC analysis에서 확인한 저주파 small-signal gain과 `CL=100 fF`의 -3 dB bandwidth가 실제 시간 영역 파형에서도 같은 결과를 만드는지 확인한다.

- `VDD=1.1 V`
- `RD=5.6 kΩ`
- `VIN_BIAS=0.714 V`
- `VIN_AMP=10 mV`
- `CL=100 fF`
- 저주파 조건: `FIN=1 MHz`
- half-power 조건: `FIN=365.235 MHz`

## 2. Testbench

기존 AC testbench를 OA API로 복제하여 다음 cell을 생성하였다.

```text
cdf_analog_tb/tb_p01_cs_transient/schematic
```

`cdf_analog_tb/tb_p01_cs_ac`의 DUT, 전원과 `CLOAD` 연결을 유지하고 입력 `analogLib/vdc`를 `analogLib/vsin`으로 교체하였다.

```text
vdc = VIN_BIAS
vo = VIN_BIAS
va = VIN_AMP
freq = FIN
```

`vdc`는 DC operating point를 설정하고 `vo`는 transient sine의 중심 전압을 설정한다. 두 값을 모두 `VIN_BIAS`로 두어 AC 실습과 동일한 동작점에서 시작한다.

## 3. Simulation 조건

| 조건 | FIN | Stop time | Maximum step | 분석 구간 |
|---|---:|---:|---:|---:|
| 저주파 gain | 1 MHz | 5 µs | 5 ns | 마지막 3 cycle |
| AC -3 dB 지점 | 365.235 MHz | 50 ns | 20 ps | 마지막 10 cycle |

고주파 조건에서는 한 주기가 약 `2.738 ns`이므로 maximum step을 `20 ps`로 제한하였다. 두 조건 모두 입력 진폭을 `10 mV`로 유지하여 large-signal distortion보다 동작점 주변의 선형 응답을 측정한다.

## 4. 측정 방법

DC bias를 제거한 입력과 출력에 다음 sinusoid를 least-squares fitting하였다.

```text
y(t) = a sin(2πft) + b cos(2πft) + c
Amplitude = sqrt(a²+b²)
Phase = atan2(b,a)
Gain = VOUT amplitude / VIN amplitude
```

초기 구간 대신 마지막 여러 cycle을 사용하여 정상상태 진폭과 위상을 계산하였다.

## 5. 결과

| 조건 | 입력 진폭 | 출력 진폭 | Gain | Gain (dB) | 출력 위상 |
|---|---:|---:|---:|---:|---:|
| 1 MHz | 10.000 mV | 22.667 mV | 2.2667 V/V | 7.108 dB | 179.84° |
| 365.235 MHz | 10.000 mV | 16.029 mV | 1.6029 V/V | 4.098 dB | 134.94° |

- [1 MHz 결과](../figures/generated/tb_p01_cs_transient/01_low_frequency/)
- [365.235 MHz 결과](../figures/generated/tb_p01_cs_transient/02_f3db/)
- [두 조건 측정 요약](../figures/generated/tb_p01_cs_transient/)

### 5-1. 저주파 결과

AC analysis의 저주파 결과는 `2.268 V/V`, `7.111 dB`였다. Transient 결과는 `2.2667 V/V`, `7.108 dB`로 거의 일치한다. 출력 위상은 약 `179.84°`이므로 CS의 반전 동작도 확인된다.

### 5-2. -3 dB 결과

두 조건의 gain 비는 다음과 같다.

```text
1.602885 / 2.266727 = 0.707136
1/sqrt(2)          = 0.707107
```

Gain 감소량은 `-3.0099 dB`이다. 따라서 AC analysis에서 찾은 `365.235 MHz`가 transient에서도 half-power 지점으로 재현된다. 출력 위상도 dominant output pole의 영향을 받아 약 `180°`에서 `134.94°`로 이동하였다.

## 6. 자동 재실행

프로젝트 디렉터리에서 다음 명령을 실행한다.

```bash
./scripts/run_cs_transient.sh
```

이 명령은 두 Spectre transient simulation, SVG/CSV 생성, 정상상태 sine fitting과 결과 요약 생성을 순서대로 수행한다.

## 7. 후속 실습

입력 진폭 sweep은 [04. 저항 부하 Common-Source의 gain compression](./04_cs_gain_compression.md)에서 이어서 수행한다.
