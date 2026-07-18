# 4-4. RTL Design Awareness

RTL 설계 단계에서도 delay/power/PVT를 의식한 구조 선택이 필요하다.

## Timing을 악화시키기 쉬운 구조

- 깊은 combinational chain
- wide mux
- 큰 comparator
- high fanout control signal
- long feedback path
- registered boundary가 없는 큰 datapath

## Power를 악화시키기 쉬운 구조

- 매 cycle 불필요하게 toggle되는 wide datapath
- enable 없이 계속 동작하는 counter/shift register
- 큰 mux input이 계속 toggle되는 구조
- clock gating이 없는 idle block

## RTL에서 할 수 있는 대응

- pipeline stage 추가
- valid/enable 기반 data update
- registered output 사용
- one-hot/gray/binary encoding 선택
- operand isolation
- clock enable 구조 명확화
- CDC/FIFO 구조 정형화

## 주의점

RTL에서 너무 이른 최적화를 하면 가독성이 나빠질 수 있다. 먼저 기능과 interface를 명확히 하고, timing/power 병목이 예상되는 부분에 구조적 여유를 두는 것이 좋다.
