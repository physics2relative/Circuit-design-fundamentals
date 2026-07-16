# 08-04. FIFO Interface and Valid-Ready

FIFO는 단순 storage가 아니라 block 사이의 dataflow를 조절하는 interface 역할을 한다. 이때 가장 흔한 방식이 valid-ready handshake이다.

## Valid-ready 기본 원리

Valid-ready interface에서는 sender가 `valid`로 data가 유효함을 알리고, receiver가 `ready`로 받을 수 있음을 알린다. 실제 transaction은 두 신호가 같은 cycle에 1일 때 발생한다.

```text
transfer = valid && ready
```

이 원칙을 기준으로 FIFO write/read도 정의할 수 있다.

```text
push = in_valid  && in_ready
pop  = out_valid && out_ready
```

## FIFO 입력 측

FIFO 입력 측에서는 FIFO가 full이 아니면 새 data를 받을 수 있다.

```text
in_ready = !full
push     = in_valid && in_ready
```

`push`가 발생하면 input data를 FIFO에 저장하고 write pointer를 증가시킨다.

## FIFO 출력 측

FIFO 출력 측에서는 FIFO가 empty가 아니면 내보낼 data가 있다.

```text
out_valid = !empty
pop       = out_valid && out_ready
```

`pop`이 발생하면 read pointer를 증가시킨다.

## Backpressure

Backpressure는 downstream이 받을 수 없을 때 upstream으로 멈춤 상태를 전달하는 메커니즘이다. FIFO가 full에 가까워지면 `in_ready`를 낮춰 upstream의 push를 막는다.

```text
consumer stall -> FIFO fills -> in_ready deassert -> producer stalls
```

FIFO는 producer와 consumer의 순간적인 속도 차이를 흡수한다. 하지만 평균적으로 producer가 계속 더 빠르면 FIFO는 결국 full이 된다. FIFO depth는 burst 차이를 흡수하기 위한 것이지, 평균 bandwidth 부족을 해결하는 장치가 아니다.

## Ready combinational path 주의

Valid-ready를 여러 stage로 연결하면 ready가 뒤에서 앞으로 combinational하게 길게 이어질 수 있다. 이 path가 길어지면 timing 문제가 생긴다.

이를 완화하기 위해 skid buffer, register slice, small FIFO를 넣어 ready path를 끊는 경우가 많다.

## Latency와 throughput

FIFO를 넣으면 보통 latency는 증가한다. 하지만 stall이 있는 system에서는 throughput을 안정화하는 데 도움이 된다.

- latency는 data가 들어와서 나가기까지 걸리는 cycle 수이다.
- throughput은 단위 cycle당 처리 가능한 transaction 수이다.

좋은 FIFO interface 설계는 full/empty 조건뿐 아니라 valid-ready timing, backpressure propagation, burst absorption까지 함께 고려한다.

## 핵심 정리

FIFO를 interface 관점에서 보면 `push = valid && ready`, `pop = valid && ready`가 핵심이다. FIFO는 storage이면서 동시에 backpressure를 전달하는 flow-control block이다.
