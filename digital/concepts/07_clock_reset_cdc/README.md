# Clock, Reset, and CDC

## 작성 범위

Clock/reset 사용 원칙과 clock domain crossing을 정리하는 대단원이다.

## 포함할 주제

- clock tree 개념
- derived clock 주의
- clock enable
- reset 종류
- reset deassertion
- reset synchronizer
- metastability
- 2-flop synchronizer
- pulse crossing
- multi-bit CDC
- handshake synchronizer
- asynchronous FIFO의 CDC 관점

## 정리 방향

Clock과 reset은 synchronous design의 기준이고, CDC는 서로 다른 clock domain 사이의 안전한 전달 문제이다. Timing 자체는 `../06_timing_sta/`에서, low-power clock gating은 `../08_low_power_clock_gating/`에서 다룬다.
