# Timing Closure Techniques

## Timing closure

Timing closure는 design이 모든 timing constraint를 만족하도록 RTL, synthesis, placement, routing, constraint를 조정하는 과정이다. Setup violation과 hold violation은 원인과 해결 방향이 다르기 때문에 구분해서 접근해야 한다.

## Setup timing 개선 방법

Setup violation은 data path가 너무 느린 문제이다. 따라서 path delay를 줄이거나 사용 가능한 시간을 늘려야 한다.

### Logic depth 줄이기

Combinational logic이 너무 깊으면 delay가 커진다. RTL 구조를 단순화하거나 연산을 나누면 delay를 줄일 수 있다.

### Pipeline stage 추가

긴 path 중간에 register를 추가하면 한 cycle에 통과해야 하는 logic이 줄어든다. Fmax 개선에 효과적이지만 latency가 증가한다.

### Register balancing / retiming

Register 위치를 조정해서 각 stage의 delay를 균등하게 만드는 방법이다. 일부 tool은 retiming을 자동으로 수행할 수 있지만, RTL 의도와 reset/enable 구조 때문에 제한될 수 있다.

### Fanout 줄이기

하나의 register output이 너무 많은 load를 구동하면 delay가 증가한다. Register duplication이나 buffering으로 fanout을 줄일 수 있다.

### Cell sizing / faster cell

더 큰 cell 또는 더 빠른 cell을 사용해 gate delay를 줄일 수 있다. 다만 area와 power가 증가할 수 있다.

## Hold timing 개선 방법

Hold violation은 data가 너무 빨리 도착하는 문제이다. 따라서 minimum delay를 늘리는 방향으로 해결한다.

- Buffer 또는 delay cell을 삽입한다.
- Routing delay를 늘린다.
- Clock skew를 조정한다.
- 너무 짧은 bypass path를 제거한다.

Hold fix는 setup fix와 반대로 data path를 느리게 만드는 경우가 많다.

## RTL 단계에서 유리한 습관

- Long combinational chain을 피한다.
- 큰 mux tree를 무의식적으로 만들지 않는다.
- FSM output이 datapath critical path에 직접 들어가는지 확인한다.
- Valid/ready path가 combinational loop 또는 긴 control path가 되지 않게 한다.
- Multicycle로 처리할 path는 RTL 구조와 constraint가 일치해야 한다.

## 핵심 정리

- Setup fix는 path를 빠르게 하거나 cycle budget을 늘리는 방향이다.
- Hold fix는 너무 빠른 path에 delay를 추가하는 방향이다.
- Pipeline은 setup closure에 강력하지만 latency와 control 정합성을 고려해야 한다.
- Timing closure는 RTL, constraint, physical implementation을 함께 보는 과정이다.
