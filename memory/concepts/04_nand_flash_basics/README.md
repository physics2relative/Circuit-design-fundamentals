# 4. NAND Flash Basics

NAND flash는 non-volatile memory이다. 전원이 꺼져도 floating gate 또는 charge trap에 저장된 charge를 통해 데이터를 유지한다.

## 저장 원리

NAND flash cell은 저장된 charge에 따라 transistor의 threshold voltage가 달라지는 원리를 사용한다.

```text
stored charge 증가
-> effective Vth 변화
-> read voltage에서 cell current 변화
-> 저장 데이터 판별
```

즉 데이터는 capacitor의 순간 charge가 아니라, floating gate/charge trap에 저장된 charge로 인한 `Vth` 상태로 표현된다.

## Program / erase / read

NAND flash는 일반 logic write와 다르게 program과 erase를 구분한다.

```text
program : selected cell의 Vth를 원하는 상태로 이동
read    : read voltage를 걸고 cell conduction 여부 판별
erase   : block 단위로 charge 제거 후 초기 상태로 이동
```

NAND는 보통 page 단위로 program/read하고 block 단위로 erase한다.

```text
read/program unit : page
erase unit        : block
```

이 때문에 NAND controller는 address mapping, wear leveling, bad block management, ECC를 수행한다.

## SLC / MLC / TLC / QLC

한 cell에 몇 bit를 저장하느냐에 따라 구분한다.

```text
SLC : 1 bit/cell, 2 threshold states
MLC : 2 bit/cell, 4 threshold states
TLC : 3 bit/cell, 8 threshold states
QLC : 4 bit/cell, 16 threshold states
```

Cell당 bit 수가 늘수록 density는 증가하지만 Vth window가 좁아져 sensing margin, endurance, retention이 어려워진다.

## NAND string 구조

NAND flash는 여러 cell transistor가 series string으로 연결된다. 선택된 cell은 read voltage를 받고, 선택되지 않은 cell은 pass voltage로 켜서 string conduction을 판단한다.

```text
bitline
  |
select transistor
  |
cell - cell - selected cell - cell - cell
  |
select transistor
  |
source line
```

Series 구조 덕분에 density가 높지만, read disturb와 pass voltage 문제가 생긴다.

## Reliability 이슈

NAND flash에서는 다음 문제가 중요하다.

```text
program/erase endurance
retention loss
read disturb
program disturb
cell-to-cell interference
bad block
```

그래서 ECC와 controller algorithm이 필수적이다.

## 면접 포인트

- NAND flash는 charge로 인한 `Vth` 상태를 데이터로 쓴다고 설명할 수 있어야 한다.
- page read/program, block erase 구조를 설명할 수 있어야 한다.
- SLC/MLC/TLC/QLC의 density와 reliability trade-off를 설명할 수 있어야 한다.
- NAND에는 ECC, wear leveling, bad block management가 필요한 이유를 설명할 수 있어야 한다.
