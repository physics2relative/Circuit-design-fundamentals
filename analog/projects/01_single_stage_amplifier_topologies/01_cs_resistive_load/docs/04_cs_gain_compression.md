# 04. 저항 부하 Common-Source의 gain compression

## 1. 실습 목표

저주파 small-signal 조건에서 입력 진폭을 증가시키며 다음 변화를 확인한다.

1. Fundamental voltage gain 감소
2. Harmonic distortion 증가
3. 출력 파형의 비대칭과 사용 가능한 출력 범위
4. NMOS가 saturation 영역을 벗어나는 시점

회로 연결은 바뀌지 않으므로 기존 `cdf_analog_tb/tb_p01_cs_transient`를 그대로 사용한다.

## 2. Simulation 조건

```text
VDD      = 1.1 V
RD       = 5.6 kΩ
VIN_BIAS = 0.714 V
FIN      = 1 MHz
CL       = 100 fF
VIN_AMP  = {10 mV, 50 mV, 100 mV, 200 mV}
```

각 조건은 `5 µs` 동안 실행하고 마지막 3 cycle을 분석한다. 입력과 출력의 1~10차 harmonic을 least-squares fitting하여 fundamental gain과 THD를 계산한다.

```text
Gain = VOUT fundamental amplitude / VIN fundamental amplitude
Compression = Gain(dB) - Gain_10mV(dB)
THD = sqrt(V2² + ... + V10²) / V1
```

MOS operating-point waveform에서는 PDK의 `region`과 `VDS-VDSAT` margin을 함께 확인한다. 이 PDK의 현재 NMOS에서 `region=2`가 saturation에 해당한다.

## 3. 결과

| VIN 진폭 | Fundamental gain | Gain 변화 | VOUT THD | VOUT 범위 | Saturation 비율 |
|---:|---:|---:|---:|---:|---:|
| 10 mV | 2.2667 V/V | 0.000 dB | 0.213% | 0.527~0.573 V | 100.0% |
| 50 mV | 2.2458 V/V | -0.080 dB | 1.134% | 0.441~0.664 V | 100.0% |
| 100 mV | 2.1798 V/V | -0.340 dB | 2.691% | 0.345~0.775 V | 100.0% |
| 200 mV | 1.9313 V/V | -1.391 dB | 7.761% | 0.226~0.957 V | 81.5% |

- [10 mV 결과](../figures/generated/tb_p01_cs_transient/01_low_frequency/)
- [50 mV 결과](../figures/generated/tb_p01_cs_transient/03_amp_50m/)
- [100 mV 결과](../figures/generated/tb_p01_cs_transient/04_amp_100m/)
- [진폭 sweep 및 clipping 비교](../figures/generated/tb_p01_cs_transient/05_clipping_comparison/)

## 4. 결과 해석

### 4-1. 10 mV

Gain은 `2.2667 V/V`로 AC small-signal 결과와 일치하며 NMOS가 전체 cycle에서 saturation을 유지한다. 이 조건을 gain compression의 기준으로 사용한다.

### 4-2. 50 mV

NMOS는 여전히 전체 cycle에서 saturation을 유지하지만 gain은 `-0.080 dB` 감소하고 THD는 `1.134%`로 증가한다. Saturation 영역 안에 있다는 사실만으로 완전한 선형 동작이 보장되지는 않는다. MOS의 `gm`과 출력 저항이 순간 입력 전압에 따라 변하기 때문이다.

### 4-3. 100 mV

Gain 감소는 `-0.340 dB`, THD는 `2.691%`이다. 소자는 saturation을 유지하지만 large-signal 전달 특성의 곡률로 인해 출력 파형의 비선형성이 분명해진다.

### 4-4. 200 mV

Gain은 `1.9313 V/V`로 감소하여 small-signal 기준보다 `-1.391 dB` compression이 발생한다. THD는 `7.761%`이고 NMOS가 saturation인 비율은 `81.5%`로 감소한다.

최소 `VDS-VDSAT` margin은 `-39.0 mV`이므로 입력이 높은 구간에서 NMOS가 saturation을 벗어난다. 출력은 아직 전원 rail에 완전히 고정되는 hard clipping보다, gain이 감소하고 파형이 눌리는 soft compression 상태에 가깝다.

## 5. 확인해야 할 핵심

1. AC gain은 특정 DC 동작점에서의 국소 기울기이다.
2. 입력 진폭이 커지면 한 주기 동안 서로 다른 `gm`, `gds`와 동작 영역을 지나게 된다.
3. MOS가 계속 saturation이어도 전달 특성의 곡률 때문에 distortion은 증가할 수 있다.
4. 200 mV에서는 saturation 이탈이 추가되어 gain compression과 THD가 급격히 커진다.
5. 출력 swing은 단순히 rail 사이의 범위가 아니라 요구되는 gain과 distortion을 만족하는 범위로 정의해야 한다.

## 6. 자동 재실행

```bash
./scripts/run_cs_transient.sh
```

동일한 명령이 AC transient 검증과 10~380 mV 입력 진폭 조건의 Spectre 실행, 측정, 비교 SVG 생성을 모두 수행한다.

## 7. 다음 실습

[05. 저항 부하 Common-Source의 clipping sweep](./05_cs_clipping_sweep.md)에서 180~380 mV 입력에 따른 low-side와 high-side clipping을 구분한다.
