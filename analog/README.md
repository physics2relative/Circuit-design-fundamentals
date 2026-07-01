# Analog Design

Virtuoso + Spectre 기반 실습과 아날로그 회로 기본 개념을 공개 가능한 노트 형태로 정리합니다.

## Structure

```text
analog/
  concepts/             # MOSFET, small-signal, OP AMP 등 개념 정리
  projects/             # Virtuoso/Spectre 실습 및 회로 프로젝트
  interview_questions/  # 아날로그 면접 질문과 답변 가이드
  assets/               # 회로도, 파형 캡처, 직접 그린 그림
```

## Concepts

- [MOSFET Basics](./concepts/01_mosfet_basics/README.md)
- [Small-Signal Model](./concepts/02_small_signal_model/README.md)
- [Current Mirror](./concepts/03_current_mirror/README.md)
- [Differential Pair](./concepts/04_differential_pair/README.md)
- [OP AMP](./concepts/05_opamp/README.md)
- [Frequency Response](./concepts/06_frequency_response/README.md)
- [Virtuoso/Spectre Lab Notes](./concepts/07_virtuoso_spectre_labs/README.md)

## Projects

- [OP AMP Lab](./projects/opamp_lab/README.md)

## Interview Questions

- [Analog Design Interview Questions](./interview_questions/analog_questions.md)

## Assets 역할

`analog/assets/`는 공개 가능한 회로도 이미지, AC/DC/Transient 파형 캡처, 직접 그린 블록 다이어그램을 저장하는 곳입니다.

주의:

- PDK/model/netlist/library 원본은 올리지 않습니다.
- Spectre 전체 결과 폴더나 대용량 raw data는 올리지 않습니다.
- 문서 설명에 필요한 캡처 이미지와 직접 작성한 그림만 올립니다.
