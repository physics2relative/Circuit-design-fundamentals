# Analog Projects

Analog projects는 Virtuoso/Spectre 또는 HSPICE로 회로 구조의 성질을 검증하는 실습이다. Tool 사용법 자체보다 **어떤 회로를 어떤 simulation으로 검증할지**를 정리한다.

## Projects

1. [Common-source Amplifier Simulation](./01_common_source_amp_sim/README.md)
2. [Source Follower and Common-gate Simulation](./02_source_follower_common_gate_sim/README.md)
3. [Current Mirror and Bias Simulation](./03_current_mirror_bias_sim/README.md)
4. [Differential Pair Simulation](./04_differential_pair_sim/README.md)
5. [Frequency Response Simulation](./05_frequency_response_sim/README.md)
6. [Feedback Stability Simulation](./06_feedback_stability_sim/README.md)
7. [Two-stage Op-Amp Simulation](./07_two_stage_opamp_sim/README.md)

## 공통 정리 형식

```text
Objective
Circuit under test
Simulation setup
Metrics to observe
Expected result
Result summary
Debug notes
Interview takeaway
```

## Commit 제외 대상

- PDK/model file
- Cadence library database
- proprietary generated netlist
- raw result directory
- 대용량 waveform database
