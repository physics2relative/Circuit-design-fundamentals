# 08-02. Synchronous FIFO

Synchronous FIFO는 write와 read가 같은 clock domain에서 동작하는 FIFO이다. data를 입력된 순서대로 저장하고, 출력도 같은 순서로 내보낸다.

## 기본 구조

Synchronous FIFO는 보통 다음 block으로 구성된다.

```text
write_data/write_en --> memory array --> read_data/read_en
                         ^         ^
                         |         |
                    write ptr   read ptr
```

- write pointer는 다음 write 위치를 가리킨다.
- read pointer는 다음 read 위치를 가리킨다.
- memory array는 data entry를 저장한다.
- full/empty flag는 pointer 관계로 만든다.

## Write 동작

`write_en`이 들어오고 FIFO가 full이 아니면 현재 write pointer 위치에 data를 저장한다. 이후 write pointer를 다음 entry로 증가시킨다.

Full 상태에서 write를 허용하면 아직 읽지 않은 data를 덮어쓰게 된다. 따라서 일반적인 FIFO에서는 `write_en && !full`일 때만 write를 수행한다.

## Read 동작

`read_en`이 들어오고 FIFO가 empty가 아니면 현재 read pointer 위치의 data를 출력 대상으로 사용한다. 이후 read pointer를 다음 entry로 증가시킨다.

Empty 상태에서 read를 허용하면 유효하지 않은 data를 읽게 된다. 따라서 `read_en && !empty`일 때만 read pointer를 증가시킨다.

## Pointer wrap-around

FIFO는 circular buffer로 동작한다. 마지막 entry 다음에는 다시 0번 entry로 돌아간다. 이 때문에 pointer는 address bit 외에 wrap 정보를 포함하는 경우가 많다.

Depth가 8이면 address는 3 bit로 충분하지만, full/empty 구분을 위해 pointer를 4 bit로 두는 방식이 흔하다. 하위 3 bit는 memory address이고, 최상위 bit는 몇 바퀴 돌았는지를 구분하는 wrap bit처럼 사용한다.

## 동시 read/write

Full도 empty도 아닌 상태에서 read와 write가 동시에 일어나면 FIFO occupancy는 변하지 않는다. write pointer와 read pointer가 둘 다 증가하고, data 순서는 유지된다.

경계 상태에서는 정책을 명확히 해야 한다.

- empty 상태에서 read와 write가 동시에 들어온 경우 read를 허용할지 여부
- full 상태에서 read와 write가 동시에 들어온 경우 write를 허용할지 여부

실무 RTL에서는 `push = wr_valid && wr_ready`, `pop = rd_valid && rd_ready`처럼 실제 발생한 transaction을 먼저 정의하고 pointer update를 작성하는 편이 안전하다.

## 핵심 정리

Synchronous FIFO의 핵심은 memory 자체보다 pointer와 flag이다. write pointer, read pointer, occupancy 또는 wrap bit를 일관되게 관리하면 FIFO 동작은 비교적 명확해진다.
