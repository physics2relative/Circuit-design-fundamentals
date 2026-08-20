# 1 MHz / 50 mV Transient Measurements

- 입력 fundamental 진폭: `50.0000 mV`
- 출력 fundamental 진폭: `112.2925 mV`
- 입력 Vpp: `100.0000 mV`
- 출력 Vpp: `223.8571 mV`
- Fundamental gain: `2.245850 V/V`, `7.0276 dB`
- 10 mV 기준 gain 변화: `-0.0804 dB`
- 출력 THD(2~10차): `1.1340%`
- 입력 범위: `0.664000~0.764000 V`
- 출력 범위: `0.440514~0.664371 V`
- Region 0/1/2/3 비율: `0.00% / 0.00% / 100.00% / 0.00%`
- VOUT >= 1.09 V 체류 비율: `0.00%`
- VOUT <= 0.01 V 체류 비율: `0.00%`
- 최소 `VDS-VDSAT` margin: `0.243056 V`
- 출력 위상: 입력 기준 `179.843°`

마지막 정상상태 구간을 10차 harmonic least-squares fitting하여 fundamental gain과 THD를 계산하였다.

현재 PDK 모델의 region 표기는 0=cutoff/off, 1=triode, 2=saturation, 3=weak-conduction/subthreshold로 해석하였다.
