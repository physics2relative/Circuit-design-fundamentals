# 09-05. FIFO Depth, Burst Size, and Rate Matching

FIFO depth는 producer가 data를 넣는 속도와 consumer가 data를 가져가는 속도 사이의 차이를 얼마나 오래 흡수할지를 정하는 값이다. 단순히 “넉넉하게 크게” 잡는 문제가 아니라, burst, stall, 평균 bandwidth, 순간 throughput을 기준으로 계산해야 한다.

## FIFO depth를 왜 계산하는가

FIFO가 너무 얕으면 consumer가 잠깐 stall되는 동안 producer data를 받을 공간이 없어져 backpressure가 빨리 걸린다. backpressure를 걸 수 없는 구조라면 overflow 또는 data loss가 발생한다.

반대로 FIFO가 너무 깊으면 area, leakage, dynamic power, latency가 증가한다. 따라서 FIFO depth는 system 요구사항을 만족하는 최소 수준으로 잡는 것이 좋다.

## Producer rate와 consumer rate

Producer rate는 FIFO에 data가 들어오는 속도이고, consumer rate는 FIFO에서 data가 빠져나가는 속도이다.

```text
producer rate = input data / time
consumer rate = output data / time
```

RTL 관점에서는 보통 cycle 단위로 생각한다.

```text
push rate = 평균 push transaction 수 / cycle
pop rate  = 평균 pop transaction 수 / cycle
```

`push = in_valid && in_ready`, `pop = out_valid && out_ready`이므로 실제 rate는 valid/ready handshake 결과로 결정된다.

## 평균 rate와 순간 burst

FIFO는 평균 rate mismatch를 근본적으로 해결하지 못한다. 평균적으로 producer가 consumer보다 계속 빠르면 FIFO는 언젠가 full이 된다.

FIFO가 해결하는 것은 보통 다음과 같은 순간적인 불균형이다.

- producer가 burst로 data를 몰아서 보내는 경우
- consumer가 잠시 stall되는 경우
- write clock과 read clock의 순간 phase 차이가 있는 경우
- downstream arbitration 때문에 일정 시간 read가 막히는 경우

따라서 depth 계산에서는 평균 throughput뿐 아니라 burst size와 stall duration을 같이 봐야 한다.

## Burst size 기준 직관식

가장 단순한 경우를 생각한다. Producer가 `B`개의 data를 burst로 넣고, 그동안 consumer가 `D`개를 처리할 수 있다면 필요한 FIFO 여유 공간은 다음과 같다.

```text
required depth >= B - D
```

예를 들어 producer가 16 beat burst를 보내는 동안 consumer가 4 beat를 읽을 수 있으면, 최소 12 entry 이상의 여유 공간이 필요하다.

```text
required depth >= 16 - 4 = 12
```

이미 FIFO에 data가 남아 있을 수 있다면 그 occupancy까지 고려해야 한다.

```text
required total depth >= existing occupancy + burst input - consumer drain
```

## Stall duration 기준 직관식

Consumer가 `Tstall` cycle 동안 완전히 멈추고, producer가 매 cycle 1개씩 data를 넣을 수 있다면 최소 여유 공간은 다음과 같다.

```text
required free space >= producer_rate * Tstall
```

Consumer가 stall 중에도 일부 data를 처리할 수 있다면 drain되는 양을 빼면 된다.

```text
required free space >= input_arrival_during_window - output_drain_during_window
```

cycle 단위로 쓰면 다음과 같다.

```text
required free space >= push_rate * Ncycle - pop_rate * Ncycle
```

## Clock이 다른 경우

Async FIFO에서는 write clock과 read clock이 다르므로 rate를 시간 기준으로 맞춰 봐야 한다.

```text
write bandwidth = write_clock_frequency * write_data_per_cycle
read bandwidth  = read_clock_frequency  * read_data_per_cycle
```

write bandwidth가 평균적으로 read bandwidth보다 크면 FIFO는 언젠가 full이 된다. 이 경우 FIFO depth를 늘리는 것은 overflow 시점을 늦출 뿐, 구조적인 해결책은 아니다.

## Backpressure 가능 여부

FIFO depth 계산에서 중요한 질문은 producer를 멈출 수 있는지이다.

- `ready`로 producer를 멈출 수 있으면 full 근처에서 backpressure를 걸 수 있다.
- producer를 멈출 수 없으면 worst-case burst를 반드시 모두 저장할 수 있어야 한다.
- 외부 interface처럼 data drop이 허용되지 않는 경우 depth 산정이 더 보수적이어야 한다.

즉, FIFO depth는 data rate뿐 아니라 flow control 정책과 함께 정해야 한다.

## Almost full의 역할

Full이 된 뒤에 producer를 멈추면 이미 늦을 수 있다. Ready deassert가 producer까지 전달되는 데 latency가 있거나, bus protocol상 이미 발행된 beat가 더 들어올 수 있기 때문이다.

이때 almost full threshold를 사용한다.

```text
almost_full threshold >= response latency 동안 추가로 들어올 수 있는 data 수
```

예를 들어 ready를 낮춘 뒤에도 최대 4 beat가 더 들어올 수 있으면, 최소 4 entry 이상 남았을 때 almost full을 올려야 안전하다.

## RTL 설계 포인트

FIFO depth를 정할 때는 다음을 확인한다.

1. Producer의 최대 burst size이다.
2. Consumer의 최대 stall duration이다.
3. 평균 input bandwidth와 output bandwidth이다.
4. Backpressure를 걸 수 있는 구조인지이다.
5. Backpressure가 실제로 반영되기까지 latency가 몇 cycle인지이다.
6. Full 직전까지 허용할지, almost full로 미리 막을지이다.

## 핵심 정리

FIFO depth는 burst와 stall을 흡수하기 위한 buffer 크기이다. 평균적으로 input bandwidth가 output bandwidth보다 크면 FIFO depth만으로 해결할 수 없다. 실무적으로는 burst size, stall duration, backpressure latency, almost full threshold를 함께 고려해서 depth를 잡는다.
