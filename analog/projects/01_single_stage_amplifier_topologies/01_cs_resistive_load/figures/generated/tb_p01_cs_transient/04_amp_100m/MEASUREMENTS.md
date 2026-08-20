# 1 MHz / 100 mV Transient Measurements

- 입력 fundamental 진폭: `100.0000 mV`
- 출력 fundamental 진폭: `217.9834 mV`
- 입력 Vpp: `200.0000 mV`
- 출력 Vpp: `430.0754 mV`
- Fundamental gain: `2.179834 V/V`, `6.7685 dB`
- 10 mV 기준 gain 변화: `-0.3395 dB`
- 출력 THD(2~10차): `2.6914%`
- 입력 범위: `0.614000~0.814000 V`
- 출력 범위: `0.345117~0.775192 V`
- Region 0/1/2/3 비율: `0.00% / 0.00% / 100.00% / 0.00%`
- VOUT >= 1.09 V 체류 비율: `0.00%`
- VOUT <= 0.01 V 체류 비율: `0.00%`
- 최소 `VDS-VDSAT` margin: `0.125166 V`
- 출력 위상: 입력 기준 `179.844°`

마지막 정상상태 구간을 10차 harmonic least-squares fitting하여 fundamental gain과 THD를 계산하였다.

현재 PDK 모델의 region 표기는 0=cutoff/off, 1=triode, 2=saturation, 3=weak-conduction/subthreshold로 해석하였다.
