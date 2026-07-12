# Timing and STA

Timing과 STA(static timing analysis)는 sequential circuit이 목표 clock에서 안정적으로 동작하는지 판단하는 기준이다. 핵심은 register 사이의 data path가 clock edge 기준으로 너무 늦게 도착하지 않는지, 또는 너무 빨리 바뀌지 않는지를 확인하는 것이다.

## 목차

1. [Timing Model Basics](./01_timing_model_basics.md)
2. [Setup Timing Analysis](./02_setup_timing_analysis.md)
3. [Hold Timing Analysis](./03_hold_timing_analysis.md)
4. [Clock Skew, Jitter, and Uncertainty](./04_clock_skew_jitter_uncertainty.md)
5. [Slack, Critical Path, and Fmax](./05_slack_critical_path_fmax.md)
6. [Input/Output Timing Constraints](./06_io_timing_constraints.md)
7. [False Path and Multicycle Path](./07_false_path_multicycle_path.md)
8. [Timing Closure Techniques](./08_timing_closure_techniques.md)
9. [STA Reports and Debug Flow](./09_sta_reports_debug_flow.md)
10. [STA Interview Checklist](./10_sta_interview_checklist.md)

## 핵심 관점

- STA는 simulation처럼 vector를 넣어 동작을 확인하는 방식이 아니다.
- STA는 clock, delay, constraint를 기준으로 모든 timing path를 정적으로 검사하는 방식이다.
- 기본 단위는 launch flip-flop에서 capture flip-flop으로 가는 register-to-register path이다.
- Setup check는 data가 다음 capture edge 전에 충분히 일찍 도착하는지 보는 것이다.
- Hold check는 data가 현재 capture edge 직후 너무 빨리 바뀌지 않는지 보는 것이다.
- Slack은 required time과 arrival time의 차이이며, timing margin을 의미한다.
- Critical path는 timing margin이 가장 작은 path이며, 보통 Fmax를 제한한다.
- Timing exception은 실제로 검사하지 않아야 하는 path 또는 여러 cycle을 허용하는 path를 STA에 알려주는 constraint이다.

## 관련 실습

STA 개념을 waveform으로 확인하기 위한 behavioral simulation 예제는 아래에 있다.

```text
digital/projects/sta_behavioral_models/
```

이 실습은 실제 STA tool을 대체하는 목적이 아니다. Setup/hold violation, clock skew, pipeline fix가 waveform에서 어떻게 보이는지 확인하기 위한 간단한 모델이다.
