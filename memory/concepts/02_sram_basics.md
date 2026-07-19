# 2. SRAM Basics

SRAM은 static random access memory이다. 일반적으로 6T SRAM cell은 두 개의 cross-coupled inverter와 두 개의 access transistor로 구성된다.

## 6T SRAM cell 구조

```text
        BL              BLB
        |                |
       Macc            Macc
        |                |
        Q ---- INV ---- QB
        |              |
        ---- INV <-----

WL controls access transistors
```

두 inverter가 서로 feedback을 걸어 `Q/QB` 상태를 유지한다. 전원이 유지되는 한 refresh 없이 데이터를 보존한다.

## Hold 동작

WL이 꺼져 있으면 cell은 bitline과 분리된다.

```text
WL = 0
access transistor off
cross-coupled inverter가 상태 유지
```

이때 중요한 것은 leakage와 noise가 있어도 저장 상태가 뒤집히지 않는 hold stability이다.

## Read 동작

Read 전에 보통 bitline pair를 precharge한다.

```text
1. BL/BLB precharge
2. WL enable
3. cell state에 따라 한쪽 bitline이 조금 discharge
4. sense amplifier가 작은 differential voltage를 증폭
```

Read 중에는 access transistor를 통해 cell 내부 node가 bitline에 연결되므로, cell state가 disturb될 수 있다. 따라서 read stability가 중요하다.

## Write 동작

Write driver가 BL/BLB에 원하는 값을 강하게 인가하고 WL을 켠다.

```text
1. BL/BLB에 write data 인가
2. WL enable
3. access transistor를 통해 cell 내부 node 강제
4. cross-coupled inverter state 전환
```

Write가 성공하려면 write driver와 access transistor가 cell pull-up/pull-down보다 충분히 강해야 한다.

## Read margin / write margin

SRAM sizing은 read stability와 write ability 사이 trade-off가 있다.

```text
pull-down 강함 -> read 안정성 증가
access 강함    -> write 쉬움, read disturb 증가 가능
pull-up 약함    -> write 쉬움
```

대표적으로 다음 비율을 본다.

```text
cell ratio  : pull-down / access
write ratio : access / pull-up
```

정확한 정의와 값은 공정/설계 방식마다 다르지만, 핵심은 read와 write가 서로 다른 sizing 요구를 가진다는 점이다.

## SRAM의 장단점

```text
장점:
빠른 read/write
refresh 불필요
logic CMOS 공정과 잘 맞음

단점:
6T 이상 cell 필요
면적 큼
대용량 메모리에는 불리
```

## 면접 포인트

- 6T SRAM cell을 그림으로 설명할 수 있어야 한다.
- read 전에 bitline precharge가 필요한 이유를 설명할 수 있어야 한다.
- sense amplifier가 필요한 이유는 bitline swing이 작기 때문이다.
- SRAM read stability와 write ability trade-off를 설명할 수 있어야 한다.
