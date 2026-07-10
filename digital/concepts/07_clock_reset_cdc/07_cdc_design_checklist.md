# CDC Design Checklist

## 신호 성격 먼저 분류한다

CDC 구조는 신호의 성격에 따라 달라진다.

```text
single-bit level인가?
single-bit pulse/event인가?
multi-bit data인가?
reset인가?
throughput이 중요한가?
event loss가 허용되는가?
latency가 허용되는가?
```

## Single-bit level

```text
추천 구조:
    2FF synchronizer

조건:
    신호가 충분히 오래 유지된다.
    destination에서 latency uncertainty를 허용한다.
    event count가 중요하지 않다.
```

## Pulse/Event

```text
문제:
    source 1-cycle pulse를 destination이 놓칠 수 있다.

추천 구조:
    toggle synchronizer
    request/ack handshake
```

Toggle synchronizer는 event rate가 낮고 back-pressure가 필요 없을 때 적합하다. Handshake는 accepted event를 확실히 전달해야 할 때 적합하다.

## Multi-bit data

```text
피해야 할 구조:
    data bus bit별 2FF synchronizer

추천 구조:
    async FIFO
    handshake + stable data
    Gray code counter/pointer
```

Multi-bit data는 bit별 old/new가 섞여 source가 만든 적 없는 값을 만들 수 있다.

## Reset

```text
원칙:
    async assert
    sync deassert

구조:
    clock domain마다 reset synchronizer를 둔다.
```

## 면접 답변용 요약

CDC를 설명할 때는 다음 순서로 말하면 좋다.

1. 서로 다른 clock domain 사이에는 setup/hold timing 관계가 보장되지 않는다.
2. 비동기 신호가 destination clock edge 근처에서 변하면 receiver FF가 metastability에 빠질 수 있다.
3. Single-bit level은 2FF synchronizer로 metastability 전파 확률을 낮춘다.
4. Pulse는 destination이 놓칠 수 있으므로 toggle이나 handshake로 level화해서 넘긴다.
5. Multi-bit data는 bit별 sync 시 coherency가 깨지므로 async FIFO 또는 handshake protocol을 사용한다.
6. Reset deassertion도 recovery/removal 문제가 있으므로 domain별 reset synchronizer를 사용한다.

짧게 답하면 다음과 같다.

> CDC는 서로 다른 clock domain 사이에서 sampling timing을 보장할 수 없어 metastability와 data coherency 문제가 생기는 상황이다. Single-bit level 신호는 2FF synchronizer로 resolve time을 확보하고, pulse/event는 toggle 또는 request/ack handshake로 level화한다. Multi-bit data는 bit별 synchronizer로 넘기면 incoherent value가 생길 수 있으므로 async FIFO처럼 data는 memory에 저장하고 Gray pointer만 CDC한다. Reset은 assert는 비동기로 허용하되 deassert는 각 clock domain에서 synchronizer를 거쳐 release한다.
