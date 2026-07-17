# 1. Microelectronics Basics

Microelectronics 기본기는 MOSFET부터 바로 시작하기보다, 학부 반도체소자에서 다루는 **carrier, drift/diffusion, PN junction, MOS capacitor**를 먼저 잡고 MOSFET으로 넘어가는 흐름이 자연스럽다. 이 장에서는 Razavi식 회로 해석 흐름에 맞춰 소자 물리의 핵심만 회로설계 관점으로 정리한다.

## 목차

1. [Signals, Models, and Bias Point](./01_signals_models_bias.md)
2. [Semiconductor Device Basics](./02_semiconductor_device_basics.md)
3. [PN Junction and Diode Basics](./03_pn_junction_diode.md)
4. [MOS Capacitor and Threshold Formation](./04_mos_capacitor_threshold.md)
5. [MOSFET Device Basics](./05_mosfet_device_basics.md)
6. [MOSFET I-V Regions](./06_mosfet_iv_regions.md)
7. [BJT Basics](./07_bjt_basics.md)
8. [Small-signal Modeling](./08_small_signal_modeling.md)
9. [Microelectronics Interview Checklist](./09_microelectronics_interview_checklist.md)

## 학습 방향

- 회로는 large-signal bias point와 small-signal variation을 나누어 본다.
- Carrier, mobility, drift/diffusion current를 통해 전류가 왜 흐르는지 이해한다.
- PN junction과 diode로 depletion region, built-in potential, exponential I-V를 잡는다.
- MOS capacitor로 accumulation, depletion, inversion과 threshold 형성을 이해한다.
- MOSFET은 MOS capacitor에 source/drain이 붙어 channel current가 흐르는 구조로 본다.
- BJT는 MOS와 비교하면서 current-controlled처럼 보이는 exponential device로 이해한다.
- Small-signal model은 amplifier 해석을 위한 선형 근사 도구로 본다.

## 이 장의 목표

이 장의 목표는 반도체 물리 전체를 깊게 전개하는 것이 아니다. 면접에서 “MOSFET이 왜 켜지는가”, “diode current는 왜 exponential인가”, “threshold voltage는 어떤 의미인가”, “bias point 근처에서 왜 gm과 ro로 모델링하는가”를 회로 관점으로 설명할 수 있게 만드는 것이다.
