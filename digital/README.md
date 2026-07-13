# Digital Design

디지털 회로 설계 기본 개념을 RTL 구현, 타이밍, 검증 관점으로 정리한다.

## Structure

```text
digital/
  concepts/             # 개념 정리
  projects/             # RTL 미니 프로젝트
  interview_questions/  # 면접 질문과 답변 가이드
  assets/               # 블록도, 파형, timing diagram
```

## Concepts

- [Verilog](./concepts/01_verilog/README.md)
- [Datapath and Number Systems](./concepts/02_datapath_number_systems/README.md)
- [Combinational Logic](./concepts/03_combinational_logic/README.md)
- [Sequential Logic](./concepts/04_sequential_logic/README.md)
- [Finite State Machine](./concepts/05_fsm/README.md)
- [Timing and STA](./concepts/06_timing_sta/README.md)
- [Clock, Reset, and CDC](./concepts/07_clock_reset_cdc/README.md)
- [Low Power Design](./concepts/08_low_power_clock_gating/README.md)
- [Memory, FIFO, and Interfaces](./concepts/09_memory_fifo_interface/README.md)

## Projects

- [Digital Counter](./projects/digital_counter/README.md)

## Interview Questions

- [Digital Design Interview Questions](./interview_questions/digital_questions.md)
- [RTL Interview Study Guide](./interview_questions/rtl_interview_study_guide.md)

## Assets 역할

`digital/assets/`는 GitHub README나 개념 문서에 넣을 직접 제작 이미지 저장소이다.

예시:

- RTL block diagram
- simulation waveform
- valid-ready timing diagram
- FSM state diagram

대용량 시뮬레이션 dump 파일(`.vcd`, `.fsdb`, `.wlf` 등)은 올리지 않고, 필요한 경우 캡처 이미지만 올린다.

## 정리 기준

```text
정의 → 회로/RTL 관점 설명 → trade-off → 검증/디버깅 포인트 → 직접 해본 예시
```
