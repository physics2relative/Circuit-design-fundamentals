# Async FIFO CDC View

## Async FIFO가 필요한 이유

Multi-bit data를 bit별 synchronizer로 넘기면 coherency가 깨질 수 있다. Async FIFO는 multi-bit data CDC의 대표적인 해결책이다.

핵심은 다음 두 가지이다.

```text
1. data bus를 직접 CDC하지 않는다.
2. write/read pointer를 Gray code로 바꿔 반대 clock domain에 동기화한다.
```

## 구조

```text
write clock domain                     read clock domain
------------------                     -----------------
wdata -> FIFO memory[write pointer]    FIFO memory[read pointer] -> rdata
          wptr_bin / wptr_gray         rptr_bin / rptr_gray
              |                              |
              v                              v
        sync to read domain            sync to write domain
```

Write domain은 write pointer 위치에 data를 저장한다. Read domain은 read pointer 위치에서 data를 읽는다. Data bus 자체가 synchronizer chain을 통과하지 않는다.

## Pointer crossing

Read side는 write pointer가 어디까지 갔는지 알아야 empty 여부를 판단할 수 있다.

```text
wptr_gray -> read domain
```

Write side는 read pointer가 어디까지 갔는지 알아야 full 여부를 판단할 수 있다.

```text
rptr_gray -> write domain
```

따라서 async FIFO에서 CDC되는 핵심 control 정보는 pointer이다.

## 왜 Gray pointer를 쓰는가

Binary pointer는 증가할 때 여러 bit가 동시에 바뀔 수 있다.

```text
binary 3 -> 4:
    011 -> 100
```

이런 multi-bit transition을 bit별 synchronizer로 넘기면 incoherent pointer가 생길 수 있다. Gray code는 인접한 값 사이에서 한 bit만 변한다.

```text
binary: 000 001 010 011 100
gray:   000 001 011 010 110
```

따라서 CDC 중에 pointer가 old 또는 new에 가깝게 제한되고, 크게 튀는 위험을 줄일 수 있다.

## CDC 문맥에서 기억할 내용

FIFO 자체의 full/empty 구현, circular buffer, simultaneous read/write, almost full/empty는 FIFO 주제에서 자세히 다루는 것이 좋다. CDC 문맥에서는 다음만 확실히 기억하면 된다.

> Multi-bit data는 직접 CDC하지 않고 FIFO memory를 통해 전달하며, CDC되는 control 정보인 pointer는 Gray code로 변환해 synchronizer를 거친다.
