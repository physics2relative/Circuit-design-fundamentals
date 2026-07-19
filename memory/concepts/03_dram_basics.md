# 3. DRAM Basics

DRAM은 dynamic random access memory이다. 대표적인 DRAM cell은 1T1C 구조로, access transistor 1개와 storage capacitor 1개로 데이터를 저장한다.

## 1T1C cell 구조

```text
        BL
        |
      access transistor
        |
       Cs
        |
      cell plate

WL controls access transistor
```

데이터는 capacitor의 charge로 저장된다.

```text
charged capacitor   -> 1
 discharged capacitor -> 0
```

실제 전압 레벨과 sensing 방식은 설계에 따라 다르지만, 핵심은 capacitor charge가 정보라는 점이다.

## Read 동작

DRAM read는 bitline과 cell capacitor 사이 charge sharing으로 시작된다.

```text
1. bitline precharge
2. WL enable
3. cell capacitor와 bitline charge sharing
4. bitline 전압이 아주 작게 변함
5. sense amplifier가 증폭
6. cell에 값을 restore
```

DRAM read는 destructive read이다. Cell capacitor의 charge가 bitline과 공유되므로 원래 cell charge가 변한다. 그래서 read 후 restore가 필요하다.

## Refresh가 필요한 이유

Capacitor charge는 leakage 때문에 시간이 지나면 사라진다.

```text
junction leakage
subthreshold leakage
capacitor dielectric leakage
```

따라서 DRAM은 일정 시간마다 cell을 다시 읽고 restore해야 한다. 이것이 refresh이다.

## Sense amplifier

DRAM bitline capacitance는 cell capacitance보다 훨씬 크다. 따라서 charge sharing 후 bitline 전압 변화는 매우 작다.

```text
small ΔV on BL -> sense amplifier가 full logic level로 증폭
```

Sense amplifier는 단순 증폭기라기보다, differential bitline의 작은 차이를 latch 구조로 빠르게 증폭하고 cell에 restore하는 역할까지 한다.

## Row / column 동작

DRAM은 row activation 후 column access를 한다.

```text
ACTIVATE : wordline open, row sense
READ/WRITE: column select
PRECHARGE: row close, bitline precharge
```

그래서 DRAM timing에는 `tRCD`, `tCL`, `tRP`, `tRAS` 같은 row/column 관련 시간이 등장한다.

## DRAM의 장단점

```text
장점:
1T1C라 bit density 높음
main memory에 적합

단점:
refresh 필요
read destructive
SRAM보다 느림
analog sensing 난이도 존재
```

## 면접 포인트

- DRAM이 capacitor charge에 데이터를 저장한다는 점을 설명할 수 있어야 한다.
- DRAM read가 destructive이고 restore가 필요한 이유를 설명할 수 있어야 한다.
- refresh가 leakage 때문에 필요한 동작임을 설명할 수 있어야 한다.
- SRAM과 DRAM의 cell 면적/속도/refresh 차이를 비교할 수 있어야 한다.
