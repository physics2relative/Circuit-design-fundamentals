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
10. [SDC Constraint Syntax Basics](./10_sdc_constraint_syntax_basics.md)

## 핵심 관점

- STA는 simulation처럼 vector를 넣어 동작을 확인하는 방식이 아니다.
- STA는 clock, delay, constraint를 기준으로 모든 timing path를 정적으로 검사하는 방식이다.
- 기본 단위는 launch flip-flop에서 capture flip-flop으로 가는 register-to-register path이다.
- Setup check는 data가 다음 capture edge 전에 충분히 일찍 도착하는지 보는 것이다.
- Hold check는 data가 현재 capture edge 직후 너무 빨리 바뀌지 않는지 보는 것이다.
- Slack은 required time과 arrival time의 차이이며, timing margin을 의미한다.
- Critical path는 timing margin이 가장 작은 path이며, 보통 Fmax를 제한한다.
- Timing exception은 실제로 검사하지 않아야 하는 path 또는 여러 cycle을 허용하는 path를 STA에 알려주는 constraint이다.

## 학습 방향

STA는 waveform simulation보다 constraint와 timing report 해석이 핵심이다. 따라서 이 대단원은 개념, SDC 문법, timing report를 읽는 기준을 중심으로 정리한다. 면접 대비 체크리스트는 [Digital Interview Questions](../../interview_questions/sta_interview_checklist.md)에 둔다.
