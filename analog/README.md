# Analog Design

아날로그 회로 설계 개념과 Virtuoso/Spectre 또는 HSPICE 기반 회로 검증 실습을 정리한다. 이 섹션은 tool 사용법 자체보다, common-source amplifier, current mirror, differential pair, op-amp 같은 회로 구조의 동작을 simulation으로 확인하는 데 초점을 둔다.

## Structure

```text
analog/
  concepts/             # amplifier, bias, differential pair, frequency response, feedback, op-amp 개념
  projects/             # Spectre/HSPICE 기반 회로 검증 실습 계획과 결과 요약
  interview_questions/  # 아날로그 면접 질문과 답변 가이드
  assets/               # 회로도, 파형 캡처, 직접 그린 그림
```

## Concepts

1. [Amplifier Basics](./concepts/01_amplifier_basics/README.md)
2. [Current Mirror and Biasing](./concepts/02_current_mirror_biasing/README.md)
3. [Differential Pair](./concepts/03_differential_pair/README.md)
4. [Frequency Response](./concepts/04_frequency_response/README.md)
5. [Feedback and Stability](./concepts/05_feedback_stability/README.md)
6. [Op-Amp Basics](./concepts/06_opamp_basics/README.md)

## Projects

1. [Common-source Amplifier Simulation](./projects/01_common_source_amp_sim/README.md)
2. [Source Follower and Common-gate Simulation](./projects/02_source_follower_common_gate_sim/README.md)
3. [Current Mirror and Bias Simulation](./projects/03_current_mirror_bias_sim/README.md)
4. [Differential Pair Simulation](./projects/04_differential_pair_sim/README.md)
5. [Frequency Response Simulation](./projects/05_frequency_response_sim/README.md)
6. [Feedback Stability Simulation](./projects/06_feedback_stability_sim/README.md)
7. [Two-stage Op-Amp Simulation](./projects/07_two_stage_opamp_sim/README.md)

## Assets 역할

`analog/assets/`는 공개 가능한 회로도 이미지, AC/DC/transient 파형 캡처, 직접 그린 블록 다이어그램을 저장하는 곳이다.

주의:

- PDK/model/netlist/library 원본은 올리지 않는다.
- Spectre/HSPICE 전체 결과 폴더나 대용량 raw data는 올리지 않는다.
- 문서 설명에 필요한 캡처 이미지와 직접 작성한 그림만 올린다.
