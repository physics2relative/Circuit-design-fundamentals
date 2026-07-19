# Memory Fundamentals

반도체/회로설계 면담에서 자주 연결되는 메모리 기본 개념을 정리한다. 이 섹션은 메모리 소자를 공정 관점으로 깊게 전개하기보다, **cell 구조, read/write 동작, peripheral 회로, timing, reliability**를 회로설계 관점에서 설명할 수 있게 만드는 것을 목표로 한다.

## Structure

```text
memory/
  concepts/             # SRAM, DRAM, NAND, peripheral, timing, reliability 개념
  projects/             # 추후 memory model / simple SRAM controller 실습
  interview_questions/  # 메모리 면접 질문 별도 정리용
  assets/               # cell 구조, timing diagram, waveform, 직접 그린 그림
```

## Concepts

1. [Memory Overview](./concepts/01_memory_overview.md)
2. [SRAM Basics](./concepts/02_sram_basics.md)
3. [DRAM Basics](./concepts/03_dram_basics.md)
4. [NAND Flash Basics](./concepts/04_nand_flash_basics.md)
5. [Memory Peripheral Circuits](./concepts/05_memory_peripheral_circuits.md)
6. [Memory Timing and Interface](./concepts/06_memory_timing_interface.md)
7. [Reliability, Test, and Yield](./concepts/07_reliability_test_yield.md)
8. [Memory Interview Checklist](./concepts/08_memory_interview_checklist.md)

## 학습 흐름

```text
메모리 계층/분류
→ SRAM cell과 read/write margin
→ DRAM capacitor cell과 refresh
→ NAND flash 저장 원리와 program/erase/read
→ decoder/sense amp/precharge/write driver
→ timing/interface
→ reliability/test/yield
```

면접 관점에서는 SRAM/DRAM/NAND를 각각 따로 외우는 것보다, 아래 질문에 답할 수 있도록 정리하는 것이 중요하다.

```text
무엇에 정보를 저장하는가?
어떻게 읽고 쓰는가?
읽을 때 저장값이 파괴되는가?
왜 refresh 또는 erase가 필요한가?
peripheral 회로는 왜 필요한가?
timing과 reliability 문제는 어디서 생기는가?
```
