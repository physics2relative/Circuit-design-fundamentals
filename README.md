# Circuit Design Fundamentals

대학원 면담 및 반도체/회로설계 직무 면접 준비를 위해 디지털 회로 설계와 아날로그 회로 실습 내용을 정리하는 공개용 저장소입니다.

## Repository Structure

```text
analog/
  concepts/             # MOSFET, small-signal, current mirror, differential pair, OP AMP 등 개념 정리
  projects/             # Virtuoso/Spectre, OP AMP 등 아날로그 실습/프로젝트
  interview_questions/  # 아날로그 면담/면접 질문
  assets/               # 아날로그 회로도 이미지, 파형 캡처, 직접 그린 그림

digital/
  concepts/             # 조합논리, 순차논리, FSM, timing/CDC, Verilog 등 개념 정리
  projects/             # counter, UART, FIFO 등 RTL 프로젝트
  interview_questions/  # 디지털/RTL 면담/면접 질문
  assets/               # RTL 블록도, simulation waveform, timing diagram

docs/                   # 공통 정책, mixed-signal 질문 등 보조 문서
resources.md            # 참고 자료
glossary.md             # 용어 정리
```

## Main Sections

- [Analog Design](./analog/README.md)
- [Digital Design](./digital/README.md)
- [Resources](./resources.md)
- [Glossary](./glossary.md)

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
