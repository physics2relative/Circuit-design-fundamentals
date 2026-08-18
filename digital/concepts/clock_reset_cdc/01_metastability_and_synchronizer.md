# Metastability and Synchronizer

## Metastability의 의미

서로 다른 clock domain 사이에는 setup/hold timing 관계가 보장되지 않는다. 비동기 입력이 destination clock edge 근처에서 변하면 receiver flip-flop은 입력 값을 0 또는 1로 즉시 확정하지 못할 수 있다. 이 상태를 metastability라고 한다.

```text
async input: ____/‾‾‾‾
clk_dst:        ↑
                sampling edge 근처에서 input 변화
```

실제 회로에서 metastability는 analog 현상이다. 최종적으로 0으로 풀릴지 1로 풀릴지, 얼마나 늦게 풀릴지는 cell 특성, PVT, clock period, slack에 따라 달라진다.

## Single-bit level에서의 해석

Single-bit level 신호에서는 metastability의 resolve 결과가 보통 논리값 오류라기보다 latency uncertainty로 해석된다.

```text
old value로 resolve:
    destination에서 변화가 한 cycle 늦게 보일 수 있다.

new value로 resolve:
    destination에서 변화가 한 cycle 빨리 보일 수 있다.
```

따라서 single-bit level synchronizer는 다음 조건에서 적합하다.

```text
- 신호가 충분히 오래 유지된다.
- destination에서 1~2 cycle latency 차이를 허용한다.
- event count가 중요하지 않다.
- 여러 bit 조합 의미가 아니다.
```

## 2FF synchronizer

Single-bit level 신호의 기본 구조는 2FF synchronizer이다.

```text
async_level ----> [FF1] ----> [FF2] ----> synced_level
                  clk_dst    clk_dst
```

FF1은 metastability가 발생할 수 있는 지점이다. FF2는 FF1의 출력이 다음 destination clock edge 전까지 안정되기를 기대하고 sampling한다.

중요한 점은 다음이다.

```text
2FF synchronizer는 metastability를 제거하지 않는다.
첫 번째 FF가 흔들렸을 때, 두 번째 FF가 sampling하기 전까지 resolve될 시간을 벌어준다.
```

## Resolved case와 unresolved case

2FF synchronizer는 보통 다음 흐름을 기대한다.

```text
clk_dst edge N:
    FF1이 async input을 sampling한다.
    edge 근처에서 input이 변하면 FF1이 metastable해질 수 있다.

clk_dst edge N+1:
    FF1 출력이 이미 0/1로 resolve되어 있으면 FF2가 안정된 값을 sampling한다.
```

반대로 resolve가 너무 늦으면 FF2가 아직 불확정한 값을 sampling할 수 있다.

```text
clk_dst edge N:
    FF1 enters metastability

clk_dst edge N+1:
    FF1 output is still unresolved
    FF2 can sample uncertain value
```

따라서 2FF synchronizer는 확률을 낮추는 구조이지 절대적인 보장은 아니다. 더 높은 신뢰성이 필요하면 3FF synchronizer를 사용하거나, 신호 성격에 맞는 handshake/FIFO protocol을 사용한다.

## Direct capture가 위험한 이유

Synchronizer 없이 비동기 신호를 FF 하나로 바로 받으면 첫 stage 출력이 그대로 downstream logic에 사용된다.

```text
clk_src domain                  clk_dst domain
--------------                  --------------
async_level ------------------> [FF] ----> logic
```

이 경우 receiver FF가 metastable해졌을 때 그 영향이 바로 control/datapath로 전달될 수 있다. CDC boundary에서는 최소한 first-stage output을 직접 쓰지 않고 synchronizer chain을 거친 값을 사용해야 한다.
