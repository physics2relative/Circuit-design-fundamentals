# 1. Microelectronics Basics

Microelectronics 기본기는 특정 digital timing 문제로 바로 들어가기보다, Razavi 교재식 흐름처럼 **소자 동작 → 단순 회로 모델 → amplifier building block** 순서로 잡는 것이 좋다. 이 장에서는 반도체 물리 자체를 깊게 전개하기보다 회로 해석에 필요한 diode, MOSFET, BJT, bias, small-signal 관점을 정리한다.

## 목차

1. [Signals, Models, and Bias Point](./01_signals_models_bias.md)
2. [PN Junction and Diode Basics](./02_pn_junction_diode.md)
3. [MOSFET Device Basics](./03_mosfet_device_basics.md)
4. [MOSFET I-V Regions](./04_mosfet_iv_regions.md)
5. [BJT Basics](./05_bjt_basics.md)
6. [Small-signal Modeling](./06_small_signal_modeling.md)
7. [Microelectronics Interview Checklist](./07_microelectronics_interview_checklist.md)

## 학습 방향

- 회로는 large-signal bias point와 small-signal variation을 나누어 본다.
- Diode는 PN junction, exponential I-V, small-signal resistance의 기본 예시로 본다.
- MOSFET은 terminal voltage, operating region, transconductance 관점으로 본다.
- BJT는 MOS와 비교하면서 current-controlled처럼 보이는 exponential device로 이해한다.
- Small-signal model은 amplifier 해석을 위한 선형 근사 도구로 본다.

## 이 장의 목표

이 장의 목표는 digital CMOS inverter의 delay/power를 바로 설명하는 것이 아니다. 그보다 먼저 “왜 transistor를 증폭기로 볼 수 있는가”, “bias point 근처에서 왜 선형 모델을 쓸 수 있는가”, “gm, ro, small-signal resistance가 무슨 의미인가”를 설명할 수 있게 만드는 것이다.
