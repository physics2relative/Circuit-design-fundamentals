# 09-01. Memory Basics

Memory는 여러 cycle에 걸쳐 data를 보관하기 위한 storage 구조이다. RTL에서는 register array처럼 작성할 수 있지만, 실제 구현에서는 크기와 access pattern에 따라 flip-flop array, latch array, SRAM macro, register file 등으로 달라질 수 있다.

## Register와 memory의 차이

Register는 보통 control state, pipeline stage, 작은 data 저장에 사용한다. 개별 bit 또는 word를 직접 제어하기 쉽지만, 용량이 커지면 area와 clock power 부담이 커진다.

Memory는 address를 통해 여러 entry 중 하나를 선택해서 read/write하는 구조이다. 큰 buffer나 table에는 register를 무작정 늘리는 것보다 memory 구조가 적합하다.

## Port 개념

Memory port는 한 cycle에 수행할 수 있는 access 수를 의미한다.

- single-port memory는 한 시점에 하나의 access만 수행한다.
- simple dual-port memory는 write port와 read port를 분리하는 형태로 자주 쓰인다.
- true dual-port memory는 두 port가 각각 read/write를 수행할 수 있다.

Port 수가 많아지면 사용은 편해지지만 회로가 커지고 timing도 어려워진다. RTL 설계에서는 필요한 access 수를 먼저 정하고, memory 구조를 그에 맞게 잡아야 한다.

## Synchronous read와 asynchronous read

Synchronous read는 clock edge에서 address를 받고 다음 cycle 또는 같은 cycle의 registered output으로 data를 내보내는 방식이다. SRAM macro나 FPGA block RAM에서 흔하다.

Asynchronous read는 address가 바뀌면 combinational하게 data가 바뀌는 방식이다. 작은 register file이나 LUT성 구조에서는 직관적이지만, 큰 memory에서는 timing path가 길어지기 쉽다.

## Read-during-write 동작

같은 address에 read와 write가 동시에 들어올 때 어떤 값이 보이는지는 명확히 정해야 한다.

- old data를 읽는 방식
- new data를 읽는 방식
- don't care 또는 macro dependent 방식

FIFO나 register file을 설계할 때 이 동작을 가정하지 않고 넘어가면 simulation과 실제 macro mapping 사이에서 차이가 날 수 있다.

## RTL 설계 포인트

Memory를 설계할 때는 다음을 먼저 정한다.

1. depth와 data width이다.
2. read/write port 수이다.
3. read latency이다.
4. 같은 address read/write 충돌 시 동작이다.
5. reset이 필요한 storage인지, valid bit만 reset하면 되는지이다.

큰 memory 전체를 reset하는 구조는 reset fanout과 initialization time 측면에서 부담이 될 수 있다. 보통 data array 자체보다 pointer, valid bit, control register를 reset하는 방식이 더 현실적이다.
