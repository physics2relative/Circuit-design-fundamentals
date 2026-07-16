# 10. Verification Basics

Verification은 작성한 RTL이 의도한 기능과 protocol rule을 만족하는지 확인하는 과정이다. RTL 설계 관점에서는 testbench를 단순히 waveform을 만들기 위한 코드로 보지 않고, design assumption과 corner case를 체계적으로 확인하는 환경으로 봐야 한다.

## 목차

1. [Simulation Flow](./01_simulation_flow.md)
2. [Testbench Structure](./02_testbench_structure.md)
3. [Directed and Self-checking Test](./03_directed_self_checking_test.md)
4. [Assertion Basics](./04_assertion_basics.md)
5. [Coverage Basics](./05_coverage_basics.md)
6. [Scoreboard and Reference Model](./06_scoreboard_reference_model.md)
7. [Waveform Debug Strategy](./07_waveform_debug_strategy.md)

## 학습 방향

- 먼저 simulation flow와 testbench의 기본 block을 이해한다.
- 그 다음 directed test를 self-checking testbench로 바꾸는 관점을 잡는다.
- Assertion은 design/protocol rule을 즉시 잡는 장치로 본다.
- Coverage는 “무엇을 테스트했는가”를 확인하는 지표로 보고, pass/fail check와 구분한다.
- Waveform debug는 control path와 data path를 분리해서 본다.

## 이 섹션의 목표

이 섹션의 목표는 전문 검증 엔지니어 수준의 UVM 전체 흐름을 다루는 것이 아니다. RTL 설계자가 자신의 block을 설명하고 검증할 때 필요한 기본기, 즉 testbench 구조, pass/fail 자동 판정, assertion, coverage, scoreboard, waveform debug 관점을 정리하는 것이다.
