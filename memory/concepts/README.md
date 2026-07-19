# Memory Concepts

메모리 회로는 cell array만으로 동작하지 않는다. 실제 메모리는 cell, wordline/bitline, decoder, sense amplifier, precharge, write driver, timing control, test/repair 구조가 함께 동작한다.

## 목차

1. [Memory Overview](./01_memory_overview.md)
2. [SRAM Basics](./02_sram_basics.md)
3. [DRAM Basics](./03_dram_basics.md)
4. [NAND Flash Basics](./04_nand_flash_basics.md)
5. [Memory Peripheral Circuits](./05_memory_peripheral_circuits.md)
6. [Memory Timing and Interface](./06_memory_timing_interface.md)
7. [Reliability, Test, and Yield](./07_reliability_test_yield.md)
8. [Memory Interview Checklist](./08_memory_interview_checklist.md)

## 핵심 비교축

| 항목 | SRAM | DRAM | NAND Flash |
| --- | --- | --- | --- |
| 저장 방식 | latch state | capacitor charge | floating gate / charge trap charge |
| 휘발성 | volatile | volatile | non-volatile |
| refresh | 불필요 | 필요 | 불필요 |
| read disturb | 상대적으로 작음 | read destructive 후 restore 필요 | read disturb 존재 |
| write/erase | 빠름 | 빠름 | program/erase 느림 |
| 밀도 | 낮음 | 높음 | 매우 높음 |
| 주요 용도 | cache, register file | main memory | storage |
