# 09-08. FIFO Verification Checklist

FIFO 검증은 단순히 data가 몇 개 들어가고 나오는지 보는 수준에서 끝나면 부족하다. 경계 조건, 동시 read/write, full/empty flag, reset, backpressure를 함께 확인해야 한다.

## 기본 동작

- reset 후 empty가 1인지 확인한다.
- empty 상태에서 read가 발생하지 않거나 underflow로 잡히는지 확인한다.
- 한 개 write 후 read하면 같은 data가 나오는지 확인한다.
- 여러 data를 연속 write/read했을 때 순서가 유지되는지 확인한다.

## Full / empty 경계

- FIFO를 정확히 depth만큼 채웠을 때 full이 올라오는지 확인한다.
- full 상태에서 추가 write가 막히는지 확인한다.
- full에서 read가 발생하면 full이 내려가는지 확인한다.
- 모든 data를 읽은 뒤 empty가 올라오는지 확인한다.
- empty 상태에서 추가 read가 막히는지 확인한다.

## 동시 read/write

- 중간 상태에서 push와 pop이 동시에 발생하면 occupancy가 유지되는지 확인한다.
- full 상태에서 pop과 push가 동시에 들어오는 정책을 확인한다.
- empty 상태에서 push와 pop이 동시에 들어오는 정책을 확인한다.

## Pointer wrap-around

- write pointer와 read pointer가 여러 번 wrap-around해도 data 순서가 유지되는지 확인한다.
- pointer 하위 bit가 같아지는 상황에서 full과 empty가 혼동되지 않는지 확인한다.

## Valid-ready / backpressure

- full이면 input ready가 내려가는지 확인한다.
- empty이면 output valid가 내려가는지 확인한다.
- downstream stall이 걸리면 FIFO가 data를 유지하는지 확인한다.
- upstream valid가 유지되는 동안 ready가 나중에 올라오면 data가 정상적으로 capture되는지 확인한다.

## Async FIFO 추가 항목

- write clock과 read clock ratio를 여러 경우로 바꿔본다.
- write clock이 더 빠른 경우 full 동작을 확인한다.
- read clock이 더 빠른 경우 empty 동작을 확인한다.
- pointer synchronizer reset 후 flag가 안정적으로 시작되는지 확인한다.
- Gray pointer가 한 번에 한 bit만 바뀌는지 확인한다.

## Assertion 관점

FIFO에서 유용한 assertion은 다음과 같다.

```text
full && push && !pop     -> overflow violation
empty && pop && !push    -> underflow violation
pop 발생 시 output data는 reference queue의 front와 같아야 한다
occupancy는 0 이상 depth 이하를 유지해야 한다
```

## 핵심 정리

FIFO 검증의 핵심은 data ordering과 boundary condition이다. 특히 full/empty 근처, wrap-around, 동시 push/pop, reset 직후 동작을 반드시 확인해야 한다.
