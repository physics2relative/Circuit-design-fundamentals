# Digital Design

디지털 회로 설계 기본 개념을 RTL 구현, 타이밍, 검증 관점으로 정리합니다.

## Structure

```text
digital/
  concepts/             # 개념 정리
  projects/             # RTL 미니 프로젝트
  interview_questions/  # 면접 질문과 답변 가이드
  assets/               # 블록도, 파형, timing diagram
```

## Concepts

- [Number Systems](./concepts/01_number_systems/README.md)
- [Combinational Logic](./concepts/02_combinational_logic/README.md)
- [Sequential Logic](./concepts/03_sequential_logic/README.md)
- [FSM](./concepts/04_fsm/README.md)
- [Timing and CDC](./concepts/05_timing_cdc/README.md)
- [Verilog/SystemVerilog Basics](./concepts/06_verilog_systemverilog/README.md)
- [RTL Interview Study Guide](./concepts/07_rtl_interview_study_guide/README.md)

## Projects

- [Digital Counter](./projects/digital_counter/README.md)

## Interview Questions

- [Digital Design Interview Questions](./interview_questions/digital_questions.md)

## Assets 역할

`digital/assets/`는 GitHub README나 개념 문서에 넣을 직접 제작 이미지 저장소입니다.

예시:

- RTL block diagram
- simulation waveform
- valid-ready timing diagram
- FSM state diagram

대용량 시뮬레이션 dump 파일(`.vcd`, `.fsdb`, `.wlf` 등)은 올리지 않고, 필요한 경우 캡처 이미지만 올립니다.

## 면접 답변 프레임

```text
정의 → 회로/RTL 관점 설명 → trade-off → 검증/디버깅 방법 → 직접 해본 예시
```
