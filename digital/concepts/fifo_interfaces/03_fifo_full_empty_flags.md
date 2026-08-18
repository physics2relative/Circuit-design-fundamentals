# 08-03. FIFO Full / Empty Flags

FIFO flag는 외부 block이 write/read 가능 여부를 판단하는 기준이다. flag가 틀리면 overflow, underflow, data loss가 발생한다.

## Empty 조건

가장 기본적인 empty 조건은 write pointer와 read pointer가 같은 경우이다.

```text
empty = (write_pointer == read_pointer)
```

두 pointer가 같다는 것은 write된 data를 모두 읽었거나, 아직 아무 data도 쓰지 않았다는 의미이다.

## Full 조건의 모호성

단순히 address pointer만 비교하면 full과 empty가 모두 pointer equality로 보일 수 있다. 예를 들어 depth 8 FIFO에서 write pointer와 read pointer의 하위 3 bit가 같으면 다음 두 경우가 모두 가능하다.

- 아무 data도 없는 empty 상태
- 한 바퀴 돌아 모든 entry가 찬 full 상태

이 모호성을 해결하려면 추가 정보가 필요하다.

## 방법 1: 한 칸 비워두기

가장 단순한 방법은 FIFO를 완전히 채우지 않고 한 entry를 비워두는 것이다.

```text
full = (next_write_address == read_address)
```

구현은 쉽지만 실제 사용 가능한 depth가 `N-1`이 된다.

## 방법 2: pointer에 extra bit 추가

실무에서 흔한 방법은 pointer를 address width보다 1 bit 크게 두는 것이다.

```text
empty = (wptr == rptr)
full  = (wptr[MSB] != rptr[MSB]) &&
        (wptr[ADDR_BITS-1:0] == rptr[ADDR_BITS-1:0])
```

하위 bit가 같고 wrap bit만 다르면 write pointer가 read pointer보다 정확히 한 바퀴 앞선 상태로 볼 수 있다. 이때 FIFO는 full이다.

## Almost full / almost empty

Almost flag는 system-level flow control을 위해 사용한다.

- almost full은 downstream이 느릴 때 upstream을 미리 멈추기 위한 신호이다.
- almost empty는 burst read를 준비하거나 underflow를 피하기 위한 신호이다.

Almost flag는 보통 occupancy count 또는 pointer distance로 만든다.

## Overflow와 underflow

Overflow는 full 상태에서 write가 실제로 발생한 경우이다. Underflow는 empty 상태에서 read가 실제로 발생한 경우이다.

RTL에서는 다음과 같은 assertion 관점이 중요하다.

```text
full  상태에서는 push만 단독으로 발생하면 안 된다.
empty 상태에서는 pop만 단독으로 발생하면 안 된다.
```

단, full 상태에서 pop과 push가 동시에 들어올 때 push를 허용할지 여부는 설계 정책에 따라 달라진다. 이 정책은 RTL과 testbench에서 동일하게 정의해야 한다.

## 핵심 정리

FIFO flag는 pointer 비교 문제이다. Empty는 pointer equality로 자연스럽게 표현되지만, full은 wrap-around 때문에 extra bit 또는 한 칸 비우기 같은 구분 방법이 필요하다.
