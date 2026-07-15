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


## 정량적 depth 계산의 기본식

FIFO occupancy는 누적 write 수와 누적 read 수의 차이로 볼 수 있다. 따라서 필요한 FIFO depth는 어떤 시간 구간에서든 occupancy가 가장 커지는 값을 기준으로 잡는다.

```text
occupancy(t) = cumulative_write(t) - cumulative_read(t)

required_depth >= max_t [cumulative_write(t) - cumulative_read(t)]
```

즉, FIFO depth 계산은 결국 “특정 관찰 구간 동안 들어온 data 수에서 빠져나간 data 수를 뺀 값의 최대치”를 찾는 문제이다.

기존에 FIFO에 data가 남아 있는 상태에서 burst가 들어올 수 있다면 초기 occupancy도 더해야 한다.

```text
required_depth >= initial_occupancy
                + input_arrival_during_window
                - output_drain_during_window
```

## Frequency 기반 rate 계산

한 entry를 한 beat라고 하면 write/read rate는 clock frequency와 cycle당 처리 가능한 beat 수로 계산한다.

```text
write_rate = f_write * write_beats_per_cycle * write_utilization
read_rate  = f_read  * read_beats_per_cycle  * read_utilization
```

보통 1 cycle에 최대 1 beat씩 쓰고 읽는 FIFO라면 다음처럼 단순화된다.

```text
write_rate = f_write * write_utilization
read_rate  = f_read  * read_utilization
```

여기서 utilization은 valid/ready가 실제 transaction으로 이어지는 비율이다. 예를 들어 write clock이 200 MHz이지만 평균적으로 두 cycle에 한 번만 push가 발생하면 write utilization은 0.5이고 평균 write rate는 100 Mbeat/s이다.

```text
write_rate = 200 MHz * 1 beat/cycle * 0.5
           = 100 Mbeat/s
```

중요한 전제는 장기 평균에서 다음 조건이 만족되어야 한다는 점이다.

```text
average_read_rate >= average_write_rate
```

이 조건이 깨지면 FIFO depth를 키워도 full이 되는 시간을 늦출 뿐, steady-state 문제를 해결하지 못한다.

## Burst size 기준 계산 예시

Producer가 `B`개의 burst를 보내고, write clock이 `f_write`, read clock이 `f_read`라고 하자. Write 쪽이 매 write clock마다 1 beat씩 쓰면 burst가 지속되는 시간은 다음이다.

```text
T_burst = B / f_write
```

그동안 consumer가 읽을 수 있는 data 수는 다음이다.

```text
read_during_burst = floor(T_burst * f_read * read_beats_per_cycle * read_utilization)
```

따라서 burst를 흡수하기 위해 필요한 FIFO 여유 공간은 다음처럼 잡을 수 있다.

```text
required_free_space >= B - read_during_burst
```

예를 들어 다음 조건을 보자.

```text
f_write    = 200 MHz
f_read     = 100 MHz
burst_size = 64 entries
write_beats_per_cycle = 1
read_beats_per_cycle  = 1
read_utilization      = 1.0
```

Burst duration은 다음이다.

```text
T_burst = 64 / 200 MHz
        = 320 ns
```

Read 쪽은 320 ns 동안 100 MHz로 1 beat/cycle을 읽을 수 있다.

```text
read_during_burst = 320 ns * 100 MHz
                  = 32 entries
```

따라서 필요한 FIFO 여유 공간은 다음이다.

```text
required_free_space >= 64 - 32
                    >= 32 entries
```

즉, burst 시작 시 FIFO가 비어 있다는 가정이면 최소 32 entry가 필요하다. 만약 burst 시작 전에 이미 10 entry가 차 있었다면 total depth는 다음 이상이어야 한다.

```text
required_depth >= initial_occupancy + required_free_space
               >= 10 + 32
               >= 42 entries
```

실제 구현에서는 power-of-two depth를 쓰는 경우가 많으므로 42가 계산되면 64 entry FIFO로 올리는 식의 선택을 할 수 있다.


## Burst-to-burst gap 기준 계산

Burst-to-burst gap은 한 burst가 끝난 뒤 다음 burst가 시작되기 전까지 producer가 data를 보내지 않는 시간이다. FIFO depth 계산에서는 이 gap 동안 consumer가 FIFO를 얼마나 비울 수 있는지가 중요하다.

```text
burst 1: B entries write
gap:     T_gap 동안 write 없음
burst 2: B entries write
gap:     T_gap 동안 write 없음
```

Burst 중 FIFO가 차오른 양은 다음처럼 볼 수 있다.

```text
fill_during_burst = burst_size - read_during_burst
```

Gap 동안 FIFO가 비워지는 양은 다음이다.

```text
drain_during_gap = T_gap * read_rate
```

반복 burst에서 중요한 값은 burst 하나가 끝나고 다음 burst가 오기 전까지 occupancy가 순증가하는지이다.

```text
net_increase_per_burst = fill_during_burst - drain_during_gap
```

- `net_increase_per_burst <= 0`이면 gap 동안 이전 burst에서 쌓인 data를 모두 비울 수 있다.
- `net_increase_per_burst > 0`이면 burst가 반복될수록 FIFO occupancy가 누적된다.

예를 들어 다음 조건을 보자.

```text
f_write    = 200 MHz
f_read     = 100 MHz
burst_size = 64 entries
T_gap      = 400 ns
```

앞의 계산처럼 burst duration은 320 ns이고, burst 동안 read 가능한 양은 32 entries이다. 따라서 burst 중 FIFO가 차오른 양은 다음이다.

```text
fill_during_burst = 64 - 32
                  = 32 entries
```

Gap 동안 read 가능한 양은 다음이다.

```text
drain_during_gap = 400 ns * 100 MHz
                 = 40 entries
```

따라서 반복 burst 사이에서 occupancy는 누적되지 않는다.

```text
net_increase_per_burst = 32 - 40
                       = -8 entries
```

반대로 gap이 100 ns라면 다음과 같다.

```text
drain_during_gap = 100 ns * 100 MHz
                 = 10 entries

net_increase_per_burst = 32 - 10
                       = 22 entries
```

이 경우 burst가 반복될 때마다 FIFO에 22 entry씩 추가로 쌓인다. 예를 들어 FIFO free space가 64 entry라면 대략 세 번째 burst 근처에서 full 위험이 생긴다.

```text
number_of_bursts_until_full ≈ available_free_entries / net_increase_per_burst
                             ≈ 64 / 22
                             ≈ 2.9 bursts
```

따라서 반복 burst traffic에서는 burst size 하나만 보면 부족하다. Burst duration, burst-to-burst gap, read bandwidth를 함께 보고 worst-case occupancy peak를 계산해야 한다.

## Stall duration 기준 계산 예시

Consumer가 일정 시간 동안 stall되면 그 시간 동안 FIFO occupancy가 증가한다. Stall window 동안 필요한 여유 공간은 다음이다.

```text
required_free_space >= input_arrival_during_stall - output_drain_during_stall
```

Consumer가 완전히 멈춘 경우에는 output drain이 0이므로 더 단순해진다.

```text
required_free_space >= write_rate * T_stall
```

예를 들어 다음 조건을 보자.

```text
f_write = 200 MHz
producer는 매 write clock마다 1 entry write
T_stall = 100 ns
consumer는 stall 동안 read 불가
```

Stall 동안 들어오는 data 수는 다음이다.

```text
input_arrival = 200 MHz * 100 ns
              = 20 entries
```

따라서 consumer stall만 흡수하려면 최소 20 entry의 free space가 필요하다.

```text
required_free_space >= 20 entries
```

Burst와 stall이 동시에 있는 경우에는 같은 관찰 구간 안에서 계산한다. 예를 들어 앞의 64-beat burst 조건에서 read 쪽이 처음 100 ns 동안 stall된다고 하자.

```text
f_write    = 200 MHz
f_read     = 100 MHz
burst_size = 64 entries
T_burst    = 320 ns
T_stall    = 100 ns
```

Read가 실제로 동작 가능한 시간은 다음이다.

```text
T_read_active = T_burst - T_stall
              = 320 ns - 100 ns
              = 220 ns
```

그동안 read 가능한 data 수는 다음이다.

```text
read_during_burst = 220 ns * 100 MHz
                  = 22 entries
```

따라서 필요한 FIFO 여유 공간은 다음이다.

```text
required_free_space >= 64 - 22
                    >= 42 entries
```

Stall이 없을 때는 32 entry였지만, 100 ns stall이 추가되면 42 entry가 필요해진다.

## Clock이 다른 경우

Async FIFO에서는 write clock과 read clock이 다르므로 cycle 수가 아니라 시간 기준 bandwidth를 비교해야 한다.

```text
write_bandwidth = f_write * write_beats_per_cycle * write_utilization
read_bandwidth  = f_read  * read_beats_per_cycle  * read_utilization
```

예를 들어 다음 조건을 보자.

```text
f_write = 250 MHz, write_utilization = 0.4
f_read  = 100 MHz, read_utilization  = 1.0
각 cycle당 1 beat 처리
```

평균 bandwidth는 다음이다.

```text
write_bandwidth = 250 MHz * 1 * 0.4 = 100 Mbeat/s
read_bandwidth  = 100 MHz * 1 * 1.0 = 100 Mbeat/s
```

이 경우 장기 평균은 같으므로 FIFO는 burst와 phase 차이를 흡수하는 용도로 동작할 수 있다. 반면 write utilization이 0.6이면 다음이 된다.

```text
write_bandwidth = 250 MHz * 1 * 0.6 = 150 Mbeat/s
read_bandwidth  = 100 MHz * 1 * 1.0 = 100 Mbeat/s
```

이 경우 평균적으로 write가 더 빠르므로 FIFO는 언젠가 full이 된다. Depth를 늘리면 full까지 걸리는 시간은 늘어나지만, steady-state overflow 문제를 해결하지는 못한다.

평균 write bandwidth가 read bandwidth보다 큰 경우, full까지 걸리는 시간은 대략 다음처럼 볼 수 있다.

```text
time_to_full ≈ available_free_entries / (write_rate - read_rate)
```

예를 들어 free space가 64 entry이고 net accumulation rate가 50 Mbeat/s이면:

```text
time_to_full ≈ 64 / 50 Mbeat/s
             ≈ 1.28 us
```

따라서 async FIFO depth 계산에서는 CDC 안전성뿐 아니라 write/read bandwidth의 장기 평균 조건도 반드시 확인해야 한다.

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
almost_full_margin >= write_rate * backpressure_response_latency
```

cycle 단위로 보면 다음과 같다.

```text
almost_full_margin >= additional_writes_after_ready_deassert
```

예를 들어 ready를 낮춘 뒤에도 producer pipeline, bus latency, arbitration 때문에 최대 4 beat가 더 들어올 수 있으면, 최소 4 entry 이상 남았을 때 almost full을 올려야 안전하다.

```text
if free_space <= 4:
    almost_full = 1
```

## RTL 설계 포인트

FIFO depth를 정할 때는 다음을 확인한다.

1. Producer의 최대 burst size이다.
2. Burst-to-burst gap이 충분한지이다.
3. Consumer의 최대 stall duration이다.
4. 평균 input bandwidth와 output bandwidth이다.
5. Backpressure를 걸 수 있는 구조인지이다.
6. Backpressure가 실제로 반영되기까지 latency가 몇 cycle인지이다.
7. Full 직전까지 허용할지, almost full로 미리 막을지이다.

## 핵심 정리

FIFO depth는 burst와 stall을 흡수하기 위한 buffer 크기이다. 평균적으로 input bandwidth가 output bandwidth보다 크면 FIFO depth만으로 해결할 수 없다. 실무적으로는 burst size, burst-to-burst gap, stall duration, backpressure latency, almost full threshold를 함께 고려해서 depth를 잡는다.
