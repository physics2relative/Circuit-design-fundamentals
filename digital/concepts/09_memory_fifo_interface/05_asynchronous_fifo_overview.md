# 09-05. Asynchronous FIFO Overview

Asynchronous FIFO는 write clock과 read clock이 서로 다른 FIFO이다. 서로 다른 clock domain 사이에서 multi-bit data를 안전하게 전달하기 위해 사용한다.

## 왜 async FIFO가 필요한가

Single-bit control signal은 2FF synchronizer, pulse synchronizer, toggle synchronizer로 넘길 수 있다. 그러나 multi-bit data bus를 bit별로 synchronizer에 넣으면 각 bit가 서로 다른 cycle에 도착해서 깨진 값이 보일 수 있다.

Async FIFO는 이 문제를 다음 방식으로 해결한다.

1. data 자체는 memory에 저장한다.
2. write는 write clock domain에서 수행한다.
3. read는 read clock domain에서 수행한다.
4. 상대 domain에는 data bus가 아니라 pointer 정보만 넘긴다.
5. pointer는 Gray code로 바꿔 synchronizer를 통과시킨다.

## 기본 구조

```text
write clock domain                       read clock domain

wr_en, wr_data                           rd_en, rd_data
     |                                        ^
     v                                        |
 write pointer --> shared memory --> read pointer
     |                                        |
     |                                        |
 gray wptr --sync--> read domain             |
     |                                        |
     |             write domain <--sync-- gray rptr
```

Memory는 양쪽 domain이 공유하지만, write pointer는 write clock으로만 갱신하고 read pointer는 read clock으로만 갱신한다.

## Full / empty 판단

Async FIFO에서 full은 write domain에서 판단한다. 그러려면 read pointer가 어디 있는지 write domain이 알아야 한다. 따라서 read pointer를 Gray code로 바꾸고 synchronizer를 통해 write domain으로 가져온다.

Empty는 read domain에서 판단한다. 그러려면 write pointer가 어디 있는지 read domain이 알아야 한다. 따라서 write pointer를 Gray code로 바꾸고 synchronizer를 통해 read domain으로 가져온다.

## 왜 data bus를 직접 synchronizer에 넣지 않는가

Data bus는 여러 bit가 동시에 의미를 갖는다. 각 bit를 따로 synchronizer에 넣으면 metastability resolve timing이 bit마다 달라질 수 있고, receiver가 송신자가 만든 적 없는 조합을 볼 수 있다.

Async FIFO는 data bus를 CDC synchronizer에 직접 통과시키지 않는다. 대신 source domain에서 memory에 안정적으로 써두고, destination domain은 pointer를 통해 읽을 수 있는 entry만 읽는다.

## Async FIFO가 해결하는 문제와 아닌 문제

Async FIFO는 서로 다른 clock domain 사이의 data transfer 문제를 구조적으로 해결한다. 하지만 설계자가 다음을 잘못하면 여전히 문제가 생긴다.

- full 상태에서 write를 허용하는 경우
- empty 상태에서 read를 허용하는 경우
- pointer synchronizer를 빠뜨리는 경우
- binary pointer를 그대로 넘기는 경우
- reset release를 domain별로 안전하게 처리하지 않는 경우

## 핵심 정리

Async FIFO는 CDC 문제를 FIFO 구조로 해결하는 대표적인 회로이다. 핵심은 shared memory, domain별 pointer, pointer synchronizer, Gray code pointer이다.
