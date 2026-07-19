# 6. Memory Timing and Interface

Memory timing은 address/control이 들어온 뒤 cell array와 peripheral이 순서대로 동작해 data가 유효해지는 시간을 의미한다.

## Access time과 cycle time

```text
access time:
요청 후 유효 data가 나오기까지 시간

cycle time:
다음 access를 시작할 수 있을 때까지 필요한 시간
```

Access time이 짧아도 내부 restore/precharge 때문에 cycle time이 더 길 수 있다.

## Read path timing

일반적인 read path는 다음 흐름으로 볼 수 있다.

```text
address valid
-> decoder delay
-> wordline rise
-> cell current/charge sharing
-> bitline development
-> sense amplifier enable
-> I/O mux/output driver
-> data valid
```

가장 느린 구간은 memory 종류와 array 크기에 따라 달라진다.

## Write path timing

Write는 data와 address/control이 모두 안정적으로 들어와야 한다.

```text
address decode
-> wordline enable
-> write driver enable
-> bitline forcing
-> cell state update
-> write recovery/precharge
```

SRAM에서는 write margin, DRAM에서는 restore/write recovery, NAND에서는 program/verify 시간이 중요하다.

## DRAM timing 예시

DRAM은 row/column 동작이 분리되어 있어 timing parameter가 많다.

```text
tRCD : ACTIVATE 후 READ/WRITE까지 대기 시간
tCL  : READ command 후 data가 나오기까지 CAS latency
tRP  : PRECHARGE에 필요한 시간
tRAS : row가 열린 상태로 유지되어야 하는 최소 시간
```

면접에서 세부 수치를 외우는 것보다, row activation, sensing, precharge 단계가 있어서 이런 timing이 필요하다는 구조를 이해하는 것이 중요하다.

## Bandwidth와 latency

Memory 성능은 latency와 bandwidth를 구분해서 봐야 한다.

```text
latency   : 하나의 요청이 완료되는 데 걸리는 시간
bandwidth : 연속 transfer에서 단위 시간당 전송량
```

Burst transfer는 command overhead를 amortize하여 bandwidth를 높일 수 있지만, 첫 data latency 자체를 없애지는 않는다.

## 면접 포인트

- Access time과 cycle time의 차이를 설명할 수 있어야 한다.
- Read path에서 decoder, wordline, bitline, sense amp가 순서대로 delay를 만든다는 점을 설명할 수 있어야 한다.
- DRAM의 ACTIVATE/READ/PRECHARGE 개념을 큰 흐름으로 설명할 수 있어야 한다.
- Latency와 bandwidth를 혼동하지 않아야 한다.
