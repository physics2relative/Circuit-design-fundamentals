# 10-06. Scoreboard and Reference Model

Scoreboard는 DUT의 실제 output과 testbench가 예측한 expected output을 비교하는 구조이다. Reference model은 expected output을 만드는 기준 model이다.

## Reference model

Reference model은 DUT보다 추상적인 방식으로 정답을 계산한다.

예를 들어 adder DUT라면 reference model은 단순 덧셈이다.

```text
expected = a + b
```

FIFO DUT라면 reference model은 queue이다.

```text
push 발생 -> expected_queue에 data 저장
pop 발생  -> expected_queue의 front와 out_data 비교
```

Reference model은 DUT와 같은 bug를 공유하지 않도록 가능하면 더 단순하고 독립적인 방식으로 작성하는 것이 좋다.

## Scoreboard

Scoreboard는 expected transaction과 actual transaction을 모아 비교한다.

```text
expected stream ---> scoreboard <--- actual stream
                         |
                         v
                    pass / fail
```

Latency가 고정된 DUT라면 expected output을 몇 cycle delay해서 비교할 수 있다. Latency가 변할 수 있는 DUT라면 transaction ID, order, queue 등을 이용한다.

## FIFO scoreboard 예시

FIFO는 scoreboard를 설명하기 좋은 예시이다.

```text
push = in_valid && in_ready
pop  = out_valid && out_ready
```

- push가 발생하면 input data를 expected queue에 넣는다.
- pop이 발생하면 output data와 expected queue의 front를 비교한다.
- 비교 후 expected queue에서 front를 제거한다.

이 방식은 FIFO 내부 pointer를 직접 보지 않고도 end-to-end ordering을 검증할 수 있다.

## Latency가 있는 DUT 비교

Pipeline이나 synchronous memory처럼 output latency가 있는 DUT는 입력 직후 바로 output을 비교하면 안 된다.

예를 들어 3-cycle latency DUT라면:

```text
cycle N input -> cycle N+3 expected output
```

Testbench에서는 expected value를 delay line이나 queue에 저장해두고, output valid가 발생할 때 비교한다.

## In-order와 out-of-order

FIFO처럼 output order가 input order와 같으면 queue 기반 scoreboard가 충분하다.

하지만 transaction이 out-of-order로 완료될 수 있는 구조라면 ID 기반 scoreboard가 필요하다.

```text
expected[id] = expected_result
actual id가 오면 expected[id]와 비교
```

AXI 같은 protocol에서 outstanding transaction을 다루려면 이런 관점이 필요하다.

## Scoreboard 작성 포인트

- transaction 발생 조건을 명확히 정의한다.
- expected와 actual을 같은 clock/event 기준으로 capture한다.
- latency와 ordering rule을 반영한다.
- mismatch 시 expected, actual, time, transaction index를 log로 남긴다.
- DUT 내부 구현 signal에 과하게 의존하지 않는다.

## 핵심 정리

Reference model은 정답을 만드는 model이고, scoreboard는 expected와 actual을 비교하는 구조이다. FIFO, pipeline, protocol block을 검증할 때 output sequence를 자동으로 확인하려면 scoreboard 관점이 필요하다.
