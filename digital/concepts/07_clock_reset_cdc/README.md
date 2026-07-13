# Clock, Reset, and CDC

Clock/reset 사용 원칙과 CDC(clock domain crossing), RDC(reset domain crossing)를 정리한다.

## 목차

1. [Metastability and Synchronizer](./01_metastability_and_synchronizer.md)
2. [Pulse and Toggle Synchronizer](./02_pulse_and_toggle_synchronizer.md)
3. [Multi-bit CDC](./03_multibit_cdc.md)
4. [Handshake CDC](./04_handshake_cdc.md)
5. [Async FIFO CDC View](./05_async_fifo_cdc_view.md)
6. [Reset Synchronizer and RDC](./06_reset_synchronizer_rdc.md)
7. [CDC Design Checklist](./07_cdc_design_checklist.md)
8. [CDC Interview Checklist](./08_cdc_interview_checklist.md)

## 핵심 요약

CDC의 본질은 서로 다른 clock domain 사이에서 sampling timing을 보장할 수 없다는 점이다. 비동기 신호가 destination clock edge 근처에서 변하면 receiver flip-flop은 setup/hold 조건을 만족하지 못할 수 있고, 이때 metastability 또는 불확정 sampling 문제가 발생한다.

```text
single-bit level:
    2FF synchronizer로 metastability 전파 확률을 낮춘다.
    단, destination에서 몇 cycle에 보일지는 흔들릴 수 있다.

single-bit pulse/event:
    pulse를 그대로 넘기면 miss될 수 있다.
    toggle synchronizer 또는 request/ack handshake로 level화해서 넘긴다.

multi-bit data:
    bit별 synchronizer로 넘기면 coherency가 깨질 수 있다.
    async FIFO, handshake + stable data, Gray code counter 등을 사용한다.

reset:
    reset assert는 비동기로 허용할 수 있지만,
    deassert는 각 clock domain에서 synchronizer를 거쳐 release하는 것이 기본이다.
```

## 구조 선택 기준

| 전달 대상 | 추천 구조 | 핵심 조건 |
| --- | --- | --- |
| single-bit slow level | 2FF synchronizer | 1~2 cycle latency uncertainty 허용 |
| single-bit short pulse | toggle synchronizer 또는 handshake | pulse를 level/event state로 변환 |
| low-rate control event | request/ack handshake | ack 전까지 다음 요청을 막아도 됨 |
| multi-bit status with encoded sequence | Gray code | 한 번에 한 bit만 바뀌도록 제한 |
| multi-bit data stream | async FIFO | data는 memory, pointer만 CDC |
| reset | reset synchronizer | async assert, sync deassert |
