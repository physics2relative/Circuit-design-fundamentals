# 365.235 MHz / 10 mV Transient Measurements

- 입력 fundamental 진폭: `10.0000 mV`
- 출력 fundamental 진폭: `16.0288 mV`
- 입력 Vpp: `20.0000 mV`
- 출력 Vpp: `32.0571 mV`
- Fundamental gain: `1.602885 V/V`, `4.0980 dB`
- 10 mV 기준 gain 변화: `0.0000 dB`
- 출력 THD(2~10차): `0.2536%`
- 입력 범위: `0.704000~0.724000 V`
- 출력 범위: `0.533940~0.565997 V`
- Region 0/1/2/3 비율: `0.00% / 0.00% / 100.00% / 0.00%`
- VOUT >= 1.09 V 체류 비율: `0.00%`
- VOUT <= 0.01 V 체류 비율: `0.00%`
- 최소 `VDS-VDSAT` margin: `0.355539 V`
- 출력 위상: 입력 기준 `134.941°`

마지막 정상상태 구간을 10차 harmonic least-squares fitting하여 fundamental gain과 THD를 계산하였다.

현재 PDK 모델의 region 표기는 0=cutoff/off, 1=triode, 2=saturation, 3=weak-conduction/subthreshold로 해석하였다.
