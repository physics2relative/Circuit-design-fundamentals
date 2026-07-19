# Circuit Design Fundamentals

대학원 면담 및 반도체/회로설계 직무 면접 준비를 위해 디지털 회로 설계와 아날로그 회로 실습 내용을 정리하는 공개용 저장소입니다.

## Repository Structure

```text
semiconductor_devices/ # carrier, PN junction, MOS capacitor, MOSFET, BJT 등 반도체 소자 기본

circuit_basics/       # 회로이론, CMOS inverter, delay/power/PVT 등 공통 회로 기본기

memory/              # SRAM, DRAM, NAND Flash, peripheral/timing/reliability 기본

analog/
  concepts/             # amplifier, current mirror, differential pair, feedback, OP AMP 등 아날로그 회로 개념 정리
  projects/             # Virtuoso/Spectre, OP AMP 등 아날로그 실습/프로젝트
  interview_questions/  # 아날로그 면담/면접 질문
  assets/               # 아날로그 회로도 이미지, 파형 캡처, 직접 그린 그림

digital/
  concepts/             # 조합논리, 순차논리, FSM, timing/CDC, Verilog 등 개념 정리
  projects/             # counter, UART, FIFO 등 RTL 프로젝트
  interview_questions/  # 디지털/RTL 면담/면접 질문
  assets/               # RTL 블록도, simulation waveform, timing diagram

docs/                   # 저장소 공통 정책 문서
resources.md            # 참고 자료
glossary.md             # 용어 정리
```

## Main Sections

- [Semiconductor Devices](./semiconductor_devices/README.md)
- [Circuit Basics](./circuit_basics/README.md)
- [Memory Fundamentals](./memory/README.md)
- [Analog Design](./analog/README.md)
- [Digital Design](./digital/README.md)
- [Resources](./resources.md)
- [Glossary](./glossary.md)


