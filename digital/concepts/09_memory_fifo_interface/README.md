# Memory, FIFO, and Interfaces

## 작성 범위

Data buffering, storage, block interface를 정리하는 대단원이다.

## 포함할 주제

- register file
- SRAM 기본 개념
- single-port / dual-port memory
- synchronous FIFO
- asynchronous FIFO
- full / empty
- almost full / almost empty
- pointer wrap-around
- valid-ready handshake
- backpressure
- request/grant
- UART / SPI / I2C 개념 수준
- AXI-lite 개념 수준

## 정리 방향

Memory와 FIFO는 data를 저장하고 흐름을 조절하는 구조이다. Interface는 block 사이에서 data와 control을 안전하게 전달하기 위한 규약이다. Async FIFO의 CDC 상세는 `../07_clock_reset_cdc/`와 연결해 정리한다.
