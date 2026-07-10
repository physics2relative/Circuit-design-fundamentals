# Timing and STA

Timing과 static timing analysis를 정리하는 대단원이다. 목표 clock frequency에서 sequential circuit이 안정적으로 동작하는지 판단하는 기준을 다룬다.

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

## 정리 방향

- Flip-flop to flip-flop timing path를 기준으로 setup/hold를 먼저 정리한다.
- Clock skew, jitter, uncertainty가 setup/hold margin에 어떤 영향을 주는지 정리한다.
- Critical path와 Fmax를 연결해서 timing closure 관점으로 확장한다.
- False path, multicycle path 같은 예외 constraint는 개념과 위험성을 중심으로 정리한다.
- CDC나 reset release처럼 clock domain과 관련된 내용은 `../07_clock_reset_cdc/`와 연결한다.
