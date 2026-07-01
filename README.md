# Circuit Design Fundamentals

대학원 면담 및 반도체/회로설계 직무 면접 준비를 위해 디지털 회로 설계와 아날로그 회로 실습 내용을 정리하는 공개용 저장소입니다.

## Scope

- **Digital Design**: 조합논리, 순차논리, FSM, 타이밍, Verilog/SystemVerilog, RTL 미니 프로젝트
- **Analog Design**: MOSFET 기초, 소신호 모델, current mirror, differential pair, OP AMP, Virtuoso/Spectre 실습 노트
- **Interview Prep**: 디지털/아날로그/혼합 관점 예상 질문과 답변 템플릿

## Repository Structure

```text
digital/              # 디지털 회로 설계 기본 개념
analog/               # 아날로그 회로 및 Virtuoso/Spectre 실습 노트
projects/             # RTL 및 회로 설계 미니 프로젝트
interview_questions/  # 면담/면접 예상 질문
assets/               # 직접 제작한 그림, 파형 캡처, 블록 다이어그램
resources.md          # 참고 자료 링크와 책
glossary.md           # 용어 정리
```

## Public Repository Policy

이 저장소에는 직접 작성한 설명, 직접 만든 코드, 공개 가능한 파형/그림만 올립니다.

올리지 않는 항목:

- PDK/model 파일
- Cadence/Virtuoso 라이브러리 원본
- 라이선스 파일
- 학교/회사/강의자료 원문
- 출처가 불분명한 netlist, `.scs`, `.cdl`, `.oa` 파일
- 대용량 시뮬레이션 산출물

## Study Flow

1. 개념을 짧게 정의합니다.
2. 회로/RTL 관점에서 동작을 설명합니다.
3. 간단한 예제나 실습 결과를 붙입니다.
4. 면접에서 말할 수 있는 답변 형태로 정리합니다.
5. 검증 방법과 corner case를 기록합니다.
