# 5. Memory Peripheral Circuits

Memory cell array는 매우 작고 반복적인 구조이다. 실제 read/write 동작은 주변 회로가 cell을 선택하고 작은 신호를 증폭하며 bitline을 구동하면서 이루어진다.

## Address decoder

Address decoder는 입력 address를 wordline 또는 column select 신호로 변환한다.

```text
row address    -> wordline 선택
column address -> bitline 또는 I/O mux 선택
```

Large memory에서는 decoder delay와 wordline RC delay가 access time에 큰 영향을 줄 수 있다.

## Wordline driver

Wordline은 많은 cell gate를 동시에 구동하므로 capacitance가 크다.

```text
wordline capacitance 큼
-> driver sizing 필요
-> RC delay 증가
```

SRAM/DRAM/NAND 모두 wordline 전압과 timing이 read/write margin에 직접 영향을 준다.

## Bitline and precharge

Bitline은 많은 cell과 연결되어 capacitance가 크다. Read 전에 bitline을 known voltage로 맞춰야 작은 cell signal을 감지할 수 있다.

```text
SRAM  : BL/BLB precharge 후 differential discharge 감지
DRAM  : bitline precharge 후 cell charge sharing 감지
NAND  : bitline precharge/evaluate로 string current 판단
```

## Sense amplifier

Sense amplifier는 bitline의 작은 전압 또는 전류 차이를 logic level로 증폭한다.

```text
small signal on bitline
-> sense amplifier
-> full-swing data
```

SRAM sense amp는 bitline differential voltage를 빠르게 감지하고, DRAM sense amp는 감지와 restore를 함께 수행한다.

## Write driver

Write driver는 bitline을 원하는 방향으로 강하게 구동한다.

```text
SRAM write:
BL/BLB를 강하게 구동하여 cell latch 상태 전환

DRAM write:
bitline/sense amp를 통해 capacitor charge 설정

NAND program:
high voltage pulse와 verify를 통해 Vth 상태 조정
```

## I/O mux and data path

Memory array 내부 bitline 수는 매우 많지만 외부 data width는 제한되어 있다. Column mux와 I/O path가 필요한 이유이다.

```text
many bitlines -> column mux -> local/global I/O -> output driver
```

## 면접 포인트

- Cell이 작을수록 peripheral overhead가 중요해진다.
- Precharge는 read 시작점을 맞추고 작은 signal을 감지하기 위해 필요하다.
- Sense amp는 bitline의 작은 변화를 full logic level로 변환한다.
- Wordline/bitline RC delay가 access time과 power에 영향을 준다.
