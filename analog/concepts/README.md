# Analog Concepts

아날로그 회로 설계 개념은 기초 소자 자체보다 **회로 block이 어떤 신호를 어떻게 변환하고, 그 성능을 어떤 simulation으로 검증하는가**를 중심으로 정리한다.

Microelectronics, MOS/BJT small-signal parameter, RC/impedance 기초는 `circuit_basics/`에서 다루고, 이 섹션은 실제 analog building block으로 넘어간다.

## 목차

1. [Amplifier Basics](./01_amplifier_basics/README.md)
2. [Current Mirror and Biasing](./02_current_mirror_biasing/README.md)
3. [Differential Pair](./03_differential_pair/README.md)
4. [Frequency Response](./04_frequency_response/README.md)
5. [Feedback and Stability](./05_feedback_stability/README.md)
6. [Op-Amp Basics](./06_opamp_basics/README.md)

## 정리 기준

```text
회로 구조 → 동작 원리 → 주요 성능 지표 → simulation으로 확인할 항목 → 면접 포인트
```

Virtuoso/Spectre/HSPICE 자체 사용법을 설명하기보다, 각 회로 구조의 성질을 DC/AC/transient/noise/corner simulation으로 검증하는 관점으로 정리한다.
