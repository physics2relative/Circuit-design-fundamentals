# Setup Timing Analysis

## Setup check의 의미

Setup timing은 launch FF에서 나온 data가 combinational logic을 지나 capture FF의 setup time 이전까지 안정되어야 한다는 조건이다.

```text
launch edge                 capture edge
    |----------------------------|
      clk-to-Q + logic delay       setup time 필요
```

즉, capture FF는 clock edge 바로 직전에 바뀌는 data를 안정적으로 받을 수 없다. Data는 capture edge보다 setup time만큼 먼저 도착해 있어야 한다.

## 기본 관계

단순화하면 setup 조건은 다음과 같다.

```text
clk_to_Q_max + comb_delay_max + setup_time <= clock_period
```

Clock skew와 uncertainty를 포함하면 실제 분석은 더 복잡해진다. 하지만 기본 구조는 동일하다. Data path delay와 setup time의 합이 사용 가능한 clock period 안에 들어와야 한다.

## Setup slack

Setup slack은 setup timing에서 남은 margin이다.

```text
setup slack = required time - arrival time
```

- Positive slack: setup timing 만족
- Zero slack: margin이 거의 없음
- Negative slack: setup violation

## Setup violation의 원인

Setup violation은 data가 너무 늦게 도착할 때 발생한다. 대표 원인은 다음과 같다.

- Combinational logic depth가 너무 깊음
- Routing delay가 큼
- Fanout이 커서 net delay가 증가함
- Clock period가 너무 짧음
- Clock uncertainty가 큼
- Capture clock이 launch clock보다 불리한 방향으로 skew됨

## Setup violation 해결 방법

Setup violation은 보통 data path를 빠르게 만들거나, 사용할 수 있는 시간을 늘려서 해결한다.

- Logic depth를 줄인다.
- Pipeline stage를 추가한다.
- 느린 cell을 빠른 cell로 바꾼다.
- Gate sizing을 조정한다.
- Buffering 또는 register duplication으로 fanout을 줄인다.
- Critical path의 RTL 구조를 단순화한다.
- 가능하다면 clock period를 완화한다.

## Pipeline과 setup timing

Pipeline은 긴 combinational path를 여러 cycle로 나누는 대표적인 setup fix이다.

```text
Before:
FF ---- long combinational logic ---- FF

After:
FF ---- shorter logic ---- FF ---- shorter logic ---- FF
```

Pipeline을 추가하면 각 stage의 combinational delay가 줄어들기 때문에 Fmax를 높일 수 있다. 대신 latency가 증가하고 control logic이 복잡해질 수 있다.

## 핵심 정리

- Setup timing은 data가 다음 capture edge 전에 충분히 일찍 도착하는지 보는 check이다.
- Setup violation은 max delay 문제이다.
- Clock period를 늘리면 setup margin은 좋아진다.
- Pipeline 추가는 setup timing을 개선하는 가장 직관적인 구조적 해결책이다.
