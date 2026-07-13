# CDC Interview Checklist

## CDC의 본질

CDC(clock domain crossing)는 서로 다른 clock domain 사이에서 signal을 전달하는 문제이다. Source domain에서 안정적인 signal도 destination clock edge 기준으로는 setup/hold를 만족한다는 보장이 없다.

따라서 CDC의 핵심 문제는 다음 두 가지이다.

```text
1. metastability
2. data coherency 또는 event loss
```

## Metastability

Metastability는 flip-flop input이 setup/hold window를 위반했을 때 output이 일정 시간 동안 0 또는 1로 안정되지 못하는 현상이다.

중요한 점은 synchronizer가 metastability를 완전히 없애는 것이 아니라, 다음 logic으로 전파될 확률을 매우 낮춘다는 것이다.

## 2FF synchronizer

2FF synchronizer는 single-bit level signal을 destination clock domain으로 넘길 때 가장 기본적인 구조이다.

```text
async signal -> FF1 -> FF2 -> dst logic
```

FF1이 metastable해져도 다음 clock edge까지 resolve될 시간을 주고, FF2 output을 destination logic에서 사용한다.

한계는 다음과 같다.

- multi-bit bus에 bit별로 적용하면 coherency가 깨질 수 있다.
- short pulse는 destination clock에서 miss될 수 있다.
- event가 어느 cycle에 보일지는 1~2 cycle 흔들릴 수 있다.

## Pulse crossing

Source domain의 1-cycle pulse는 destination clock이 더 느리거나 phase가 맞지 않으면 sampling되지 않을 수 있다. 따라서 pulse를 그대로 넘기는 것은 위험하다.

해결 방법은 다음과 같다.

- pulse를 level로 늘린다.
- toggle synchronizer를 사용한다.
- request/ack handshake를 사용한다.

## Toggle synchronizer

Toggle synchronizer는 source event가 발생할 때마다 toggle bit를 반전시킨다. Destination에서는 동기화된 toggle 값의 변화 여부를 edge detect해서 1-cycle pulse를 만든다.

핵심은 short pulse를 직접 넘기지 않고, event를 유지되는 state 변화로 바꾸는 것이다.

## Handshake CDC

Handshake는 request와 acknowledge를 사용해 source와 destination이 event 수신 여부를 확인하는 구조이다.

장점은 event loss를 막기 쉽다는 점이다. 단점은 latency와 throughput overhead가 있다는 점이다.

## Multi-bit CDC

Multi-bit bus를 bit별 2FF synchronizer로 넘기면 각 bit가 서로 다른 cycle에 capture될 수 있다. 이 경우 destination에서 존재하지 않는 중간 값을 볼 수 있다.

해결 방법은 다음과 같다.

- data를 stable하게 유지하고 valid/control만 synchronize한다.
- request/ack handshake를 사용한다.
- async FIFO를 사용한다.
- pointer/status에는 Gray code를 사용한다.

## Async FIFO

Async FIFO는 source와 destination clock이 다른 data stream을 전달할 때 사용하는 대표 구조이다. Data 자체는 memory에 저장하고, write/read pointer를 Gray code로 변환해 서로의 domain으로 동기화한다.

핵심은 다음과 같다.

```text
data는 memory로 공유하고,
CDC는 pointer/control 정보에 제한한다.
```

## Reset synchronizer와 RDC

Reset assertion은 asynchronous로 허용할 수 있지만, deassertion은 각 clock domain에서 synchronizer를 거쳐 release하는 것이 일반적이다. Reset release가 clock edge 근처에서 발생하면 recovery/removal violation이나 metastability 문제가 생길 수 있다.

## CDC와 STA

CDC path는 일반적인 single-clock STA만으로 안전성을 보장할 수 없다. Async crossing 구간에는 false path나 clock group constraint를 줄 수 있지만, 이것은 STA report를 정리하는 것이지 CDC 구조 검증을 대체하지 않는다.

## 핵심 답변 문장

- CDC 문제는 destination clock 기준으로 setup/hold를 보장할 수 없기 때문에 발생한다.
- 2FF synchronizer는 metastability 전파 확률을 낮추지만 event loss나 multi-bit coherency를 해결하지는 않는다.
- Pulse는 toggle 또는 handshake로 event state로 바꿔 넘기는 것이 안전하다.
- Multi-bit data는 bit별 synchronizer가 아니라 handshake 또는 async FIFO 구조를 사용해야 한다.
- Reset은 async assert, sync deassert가 기본 원칙이다.
