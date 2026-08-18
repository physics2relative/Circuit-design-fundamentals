# Multi-bit CDC

## Bit별 synchronizer의 문제

Multi-bit bus를 bit별 2FF synchronizer로 넘기는 것은 일반적으로 안전하지 않다.

```text
src_bus[0] -> sync -> dst_bus[0]
src_bus[1] -> sync -> dst_bus[1]
src_bus[2] -> sync -> dst_bus[2]
src_bus[3] -> sync -> dst_bus[3]
```

각 bit는 독립적으로 sampling된다. 따라서 하나의 bus transition이 destination에서 하나의 coherent value로 보인다는 보장이 없다.

예를 들어 다음 전이를 생각한다.

```text
old = 0011
new = 1100
```

각 bit가 독립적으로 old 또는 new로 잡히면 destination에서는 source가 만든 적 없는 값이 나타날 수 있다.

```text
0011  old
1100  new
1111  incoherent
0000  incoherent
1010  incoherent
```

이 문제는 single-bit level synchronizer의 latency uncertainty와 다르다. Single-bit에서는 old/new 중 하나가 보이면 보통 변화가 한 cycle 빨리 또는 늦게 전달된 것으로 볼 수 있다. Multi-bit bus에서는 bit별 old/new가 섞여 잘못된 data word가 만들어질 수 있다.

## Metastability resolve와 data coherency

Metastability가 발생한 bit는 최종적으로 old value 또는 new value로 resolve될 수 있다. 실제 회로에서는 어느 쪽으로 풀릴지 확정적으로 말할 수 없다.

Multi-bit bus에서는 각 bit의 resolve 결과가 서로 다를 수 있다.

```text
bit[3] -> new
bit[2] -> new
bit[1] -> old
bit[0] -> old
```

이 경우 destination의 bus 값은 source가 의도한 old/new 둘 중 하나가 아니라 섞인 값이 된다. 이를 bus coherency가 깨진다고 한다.

## 해결 방향

Multi-bit CDC는 data 성격에 따라 별도 protocol을 사용한다.

```text
- async FIFO
- request/ack handshake + stable data bus
- Gray code counter/pointer
- source-synchronous interface
```

## Stable data + control sync

Low-rate configuration data처럼 data가 충분히 오래 유지될 수 있다면, data bus 자체를 synchronizer로 넘기지 않고 valid/control만 CDC할 수 있다.

```text
src domain                         dst domain
----------                         ----------
data bus -----------------------> sampled when valid_sync
valid ----> synchronizer -----> valid_sync
```

조건은 다음과 같다.

```text
- data가 valid 전후로 충분히 오래 안정되어 있어야 한다.
- destination이 valid를 본 뒤 data를 sampling할 때 data가 변하지 않아야 한다.
- throughput이 낮아도 되는 control/config path에 적합하다.
```

## Gray code가 필요한 경우

Counter나 pointer처럼 순차적으로 변하는 multi-bit 값은 Gray code를 사용할 수 있다. Gray code는 인접한 값 사이에서 한 bit만 변한다.

```text
binary: 000 001 010 011 100
gray:   000 001 011 010 110
```

한 번에 한 bit만 변하면 CDC 중에 old 또는 new에 가까운 값으로 제한되므로 multi-bit incoherency 위험을 줄일 수 있다. Async FIFO pointer crossing이 대표적인 사용 예이다.
