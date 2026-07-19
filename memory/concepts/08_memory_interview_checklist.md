# 8. Memory Interview Checklist

## Memory overview

- Volatile memory와 non-volatile memory의 차이는 무엇인가?
- SRAM, DRAM, NAND flash는 각각 무엇에 데이터를 저장하는가?
- Latency와 bandwidth의 차이는 무엇인가?
- Cell array 외에 peripheral circuit이 필요한 이유는 무엇인가?

## SRAM

- 6T SRAM cell 구조를 설명할 수 있는가?
- SRAM read 동작에서 bitline precharge가 필요한 이유는 무엇인가?
- Sense amplifier가 필요한 이유는 무엇인가?
- SRAM read stability와 write ability trade-off는 무엇인가?
- SRAM이 cache에 적합한 이유는 무엇인가?

## DRAM

- 1T1C DRAM cell 구조를 설명할 수 있는가?
- DRAM read가 destructive read인 이유는 무엇인가?
- Refresh가 필요한 이유는 무엇인가?
- DRAM sense amplifier가 read와 restore를 함께 수행한다는 의미는 무엇인가?
- SRAM과 DRAM의 density/speed/refresh 차이는 무엇인가?

## NAND flash

- NAND flash에서 데이터가 `Vth` 상태로 저장된다는 의미는 무엇인가?
- Program, erase, read 동작의 차이는 무엇인가?
- Page 단위 read/program과 block 단위 erase가 controller 설계에 주는 영향은 무엇인가?
- SLC/MLC/TLC/QLC의 trade-off는 무엇인가?
- ECC, wear leveling, bad block management가 필요한 이유는 무엇인가?

## Peripheral / timing

- Decoder, wordline driver, precharge, sense amplifier, write driver의 역할은 무엇인가?
- Wordline/bitline RC delay가 access time에 미치는 영향은 무엇인가?
- Access time과 cycle time의 차이는 무엇인가?
- DRAM의 ACTIVATE, READ, PRECHARGE 흐름을 설명할 수 있는가?

## Reliability / yield

- Retention, disturb, endurance, soft error를 구분할 수 있는가?
- DRAM row hammer는 어떤 종류의 disturb 문제인가?
- NAND flash endurance가 제한되는 이유는 무엇인가?
- Spare row/column, ECC, BIST가 yield와 reliability에 어떻게 기여하는가?
