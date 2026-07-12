# Timing Model Basics

## 기본 timing path

STA에서 가장 기본이 되는 path는 flip-flop에서 flip-flop으로 전달되는 register-to-register path이다.

```text
launch FF ---- combinational logic ---- capture FF
    ^                                      ^
    |                                      |
 launch clock                         capture clock
```

launch FF는 clock edge에서 data를 내보내는 register이고, capture FF는 그 data를 다음 clock edge에서 받아들이는 register이다. 두 register 사이에는 combinational logic이 존재하며, 이 logic의 delay가 timing margin을 결정하는 주요 요소가 된다.

## 주요 delay 요소

### Clock-to-Q delay

Clock-to-Q delay는 launch FF의 clock edge 이후 Q output이 실제로 바뀌기까지 걸리는 시간이다. Data path의 시작점은 이상적인 clock edge가 아니라, clock edge 이후 Q가 바뀌는 시점이다.

### Combinational delay

Combinational delay는 launch FF의 Q에서 capture FF의 D까지 가는 logic delay이다. Gate delay, net delay, fanout, routing delay 등이 여기에 포함된다.

### Setup time

Setup time은 capture FF가 data를 안정적으로 sampling하기 위해 capture clock edge 이전에 data가 미리 안정되어 있어야 하는 시간이다.

### Hold time

Hold time은 capture clock edge 이후에도 data가 일정 시간 동안 유지되어야 하는 시간이다.

## Arrival time과 required time

STA는 각 path에 대해 data가 실제로 도착하는 시점과, 도착해야 하는 제한 시점을 비교한다.

- Arrival time은 data가 capture FF의 D pin에 도착하는 시간이다.
- Required time은 timing을 만족하기 위해 data가 도착해야 하는 한계 시간이다.
- Slack은 required time에서 arrival time을 뺀 값이다.

```text
slack = required time - arrival time
```

Slack이 양수이면 timing margin이 남아 있는 것이고, 음수이면 violation이다.

## Setup과 hold의 차이

Setup check는 data가 너무 늦게 도착하는 문제를 본다. 따라서 긴 combinational delay, 짧은 clock period, 큰 clock uncertainty가 문제가 된다.

Hold check는 data가 너무 빨리 바뀌는 문제를 본다. 따라서 너무 짧은 data path, clock skew, clock tree 불균형이 문제가 된다. Hold check는 보통 clock period를 늘린다고 해결되지 않는다.

## 핵심 정리

- STA의 기본 path는 launch FF에서 capture FF로 가는 path이다.
- Setup은 다음 capture edge까지 data가 도착해야 하는 조건이다.
- Hold는 현재 capture edge 직후 data가 너무 빨리 바뀌지 않아야 하는 조건이다.
- Setup은 max delay 관점이고, hold는 min delay 관점이다.
- Slack은 timing margin을 수치로 표현한 값이다.
