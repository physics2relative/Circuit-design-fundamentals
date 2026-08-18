# Analog Simulation Roadmap

Virtuoso/Spectre 또는 HSPICE로 회로 구조를 검증하기 위한 진행 순서이다. 도구 사용법보다 회로 가설, simulation 조건, 측정값과 결과 해석을 남기는 것을 목표로 한다.

| Order | Planned lab | Main analyses | Observation |
| ---: | --- | --- | --- |
| 1 | Common-source amplifier | operating point, DC sweep, AC, transient | bias, gain, inversion, bandwidth, distortion |
| 2 | Source follower / common gate | DC, AC, load sweep | gain, input/output resistance, headroom |
| 3 | Current mirror and bias | DC sweep, corner sweep | current matching, compliance, output resistance |
| 4 | Differential pair | differential/common-mode sweep, AC | gain, ICMR, CMRR, output conversion |
| 5 | Frequency response | AC, load/parasitic sweep | pole, zero, Miller effect, GBW |
| 6 | Feedback stability | loop gain, transient, load sweep | gain/phase margin, settling, ringing |
| 7 | Two-stage op amp | operating point, AC, transient, slew | gain, UGB, PM, swing, slew rate |

## Completion Gate

각 lab은 다음 항목이 채워졌을 때 공개 프로젝트로 분리한다.

1. Objective와 circuit under test
2. 공개 가능한 회로도 또는 충분한 구조 설명
3. Simulation setup과 sweep 조건
4. 측정할 metric과 예상 경향
5. 핵심 결과 표 또는 plot
6. 예상과 결과의 차이 및 원인 분석
7. 재현 절차와 공개하지 않는 artifact 경계
