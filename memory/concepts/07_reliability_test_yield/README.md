# 7. Reliability, Test, and Yield

메모리는 매우 많은 cell을 반복적으로 배치하므로, 작은 defect나 variation도 전체 chip yield와 reliability에 큰 영향을 줄 수 있다.

## Retention

Retention은 저장된 데이터가 시간이 지나도 유지되는 능력이다.

```text
SRAM  : supply 유지와 noise margin 중요
DRAM  : capacitor charge leakage 때문에 refresh 필요
NAND  : trapped charge loss로 Vth distribution 변화
```

## Disturb

선택하지 않은 cell이 read/write/program 과정에서 영향을 받는 현상이다.

```text
SRAM read disturb
DRAM row hammer
NAND read disturb / program disturb
```

Disturb는 array가 고밀도화될수록 더 중요해진다.

## Soft error

Alpha particle, neutron 등에 의해 저장 node charge가 바뀌면 soft error가 발생할 수 있다.

```text
critical charge Qcrit 감소
-> soft error 민감도 증가
```

SRAM cache나 register file에서는 ECC/parity가 사용될 수 있다.

## Endurance

Endurance는 write/program/erase를 반복했을 때 견딜 수 있는 정도이다.

```text
SRAM/DRAM : 일반적으로 endurance보다 soft error/retention이 주요 관심
NAND      : program/erase cycle에 따른 oxide/trap degradation 중요
```

NAND flash는 endurance 한계 때문에 wear leveling이 필요하다.

## Test and repair

메모리는 cell 수가 매우 많기 때문에 모든 cell이 완벽하기 어렵다. 그래서 test와 repair 구조가 중요하다.

```text
BIST        : built-in self test
redundancy  : spare row/column
repair      : defective row/column을 spare로 대체
ECC         : error correction code
```

## Yield 관점

Memory는 반복 구조라 defect density와 bit cell 수가 yield에 강하게 영향을 준다. Spare row/column과 ECC는 product yield를 높이는 데 중요하다.

```text
cell area 감소 -> density 증가
하지만 variation/noise margin/reliability 악화 가능
```

## 면접 포인트

- Retention, disturb, endurance, soft error를 구분할 수 있어야 한다.
- DRAM refresh와 NAND wear leveling/ECC가 왜 필요한지 설명할 수 있어야 한다.
- 메모리에서 redundancy와 repair가 yield에 중요한 이유를 설명할 수 있어야 한다.
- Scaling이 density에는 유리하지만 margin과 reliability에는 불리할 수 있음을 설명할 수 있어야 한다.
