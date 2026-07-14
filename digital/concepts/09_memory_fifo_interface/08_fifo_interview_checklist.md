# 09-08. FIFO Interview Checklist

FIFO 관련 면접 질문은 pointer, full/empty 판단, valid-ready, async FIFO CDC로 이어지는 경우가 많다. 단순 구현 암기보다 왜 그런 구조가 필요한지 설명할 수 있어야 한다.

## 기본 개념

- FIFO가 어떤 문제를 해결하는 회로인지 설명할 수 있는가?
- FIFO와 shift register의 차이를 설명할 수 있는가?
- FIFO depth와 data width가 각각 무엇을 의미하는지 설명할 수 있는가?
- FIFO latency와 throughput을 구분해서 설명할 수 있는가?

## Synchronous FIFO

- write pointer와 read pointer의 역할을 설명할 수 있는가?
- circular buffer에서 pointer wrap-around가 어떻게 동작하는지 설명할 수 있는가?
- full 상태에서 write가 들어오면 어떤 문제가 생기는지 설명할 수 있는가?
- empty 상태에서 read가 들어오면 어떤 문제가 생기는지 설명할 수 있는가?
- read와 write가 동시에 발생할 때 occupancy가 어떻게 변하는지 설명할 수 있는가?

## Full / empty flag

- pointer가 같을 때 왜 empty와 full이 혼동될 수 있는지 설명할 수 있는가?
- 한 칸 비워두는 방식과 extra bit 방식의 차이를 설명할 수 있는가?
- almost full / almost empty가 왜 필요한지 설명할 수 있는가?
- overflow와 underflow를 어떻게 검출할 수 있는지 설명할 수 있는가?

## Valid-ready interface

- `valid && ready`가 transaction이라는 의미를 설명할 수 있는가?
- FIFO 입력에서 `ready = !full`이 되는 이유를 설명할 수 있는가?
- FIFO 출력에서 `valid = !empty`가 되는 이유를 설명할 수 있는가?
- backpressure가 FIFO를 통해 어떻게 전달되는지 설명할 수 있는가?
- ready path가 길어질 때 어떤 문제가 생기는지 설명할 수 있는가?

## Asynchronous FIFO

- async FIFO가 필요한 상황을 설명할 수 있는가?
- multi-bit bus를 bit별 synchronizer로 넘기면 왜 위험한지 설명할 수 있는가?
- async FIFO에서 data memory와 pointer crossing이 어떻게 분리되는지 설명할 수 있는가?
- write domain에서 full을 판단하고 read domain에서 empty를 판단하는 이유를 설명할 수 있는가?
- pointer synchronizer가 필요한 이유를 설명할 수 있는가?

## Gray pointer

- Binary pointer를 그대로 넘기면 왜 문제가 되는지 설명할 수 있는가?
- Gray code가 한 번에 한 bit만 바뀐다는 특징을 설명할 수 있는가?
- Gray code가 synchronizer를 대체하지 않는다는 점을 설명할 수 있는가?
- Binary pointer와 Gray pointer를 둘 다 유지하는 이유를 설명할 수 있는가?

## 실무형 질문

- FIFO depth를 어떻게 정할 것인지 설명할 수 있는가?
- Producer와 consumer의 평균 bandwidth가 다르면 FIFO만으로 해결 가능한지 설명할 수 있는가?
- Reset 후 FIFO flag가 어떤 상태여야 하는지 설명할 수 있는가?
- FIFO 검증에서 가장 중요한 corner case가 무엇인지 설명할 수 있는가?

## 핵심 답변 방향

FIFO는 단순 memory가 아니라 data ordering과 flow control을 함께 담당하는 block이다. Synchronous FIFO는 pointer와 flag가 핵심이고, asynchronous FIFO는 CDC 문제를 pointer synchronizer와 Gray code로 해결하는 구조이다.
