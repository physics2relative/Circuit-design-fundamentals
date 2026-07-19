# 1. Memory Overview

메모리는 데이터를 저장하고 필요한 시점에 읽어오는 회로이다. 회로설계 관점에서는 저장 소자 자체보다 **cell array와 peripheral 회로가 어떻게 함께 동작하는지**가 중요하다.

## 메모리 분류

크게 volatile memory와 non-volatile memory로 나눌 수 있다.

```text
volatile memory:
전원이 꺼지면 데이터가 사라짐
예: SRAM, DRAM

non-volatile memory:
전원이 꺼져도 데이터 유지
예: NAND Flash, NOR Flash, EEPROM
```

## Random access와 sequential/block access

SRAM/DRAM은 비교적 random access 성격이 강하고, NAND flash는 page/block 단위 동작 성격이 강하다.

```text
SRAM  : word 단위 빠른 read/write
DRAM  : row activation 후 column access
NAND  : page read/program, block erase
```

NAND flash가 storage에 쓰이는 이유는 밀도가 높고 비휘발성이기 때문이다. 반면 write/program과 erase가 느리고 erase 단위가 block이라 controller와 error correction이 중요하다.

## Cell array와 peripheral

메모리는 다음 블록으로 구성된다.

```text
address decoder
wordline driver
memory cell array
bitline/precharge circuit
sense amplifier
write driver
control/timing logic
I/O interface
```

Cell은 데이터를 저장하고, peripheral은 원하는 cell을 선택하고 작은 신호를 읽고 쓰기 가능한 logic level로 변환한다.

## 메모리에서 중요한 설계 지표

```text
capacity     : 얼마나 많이 저장하는가
latency      : 요청부터 데이터가 나오기까지 시간
bandwidth    : 단위 시간당 전송 가능한 데이터량
power        : read/write/standby power
area/density : bit당 면적
reliability  : retention, disturb, soft error, endurance
yield        : 제조 후 정상 동작 비율
```

## 면접 포인트

- SRAM, DRAM, NAND가 각각 무엇에 정보를 저장하는지 설명할 수 있어야 한다.
- cell만이 아니라 decoder, sense amp, precharge, write driver가 왜 필요한지 설명할 수 있어야 한다.
- latency와 bandwidth의 차이를 구분해야 한다.
- volatile/non-volatile, random/block access 차이를 설명할 수 있어야 한다.
