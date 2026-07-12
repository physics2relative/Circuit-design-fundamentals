# Slack, Critical Path, and Fmax

## Slack

Slack은 timing requirement와 실제 data arrival time 사이의 여유이다.

```text
slack = required time - arrival time
```

- Positive slack은 timing을 만족한다는 뜻이다.
- Zero slack은 margin이 거의 없다는 뜻이다.
- Negative slack은 timing violation이다.

Slack은 단순히 pass/fail만 보여주는 값이 아니라, 어느 path가 얼마나 위험한지 판단하는 기준이다.

## Critical path

Critical path는 slack이 가장 작은 path이다. Setup 관점에서는 보통 가장 긴 data path가 critical path가 된다.

```text
FF ---- long combinational logic ---- FF
```

Critical path가 전체 chip 또는 block의 최대 동작 주파수를 제한한다. 따라서 timing closure에서는 WNS가 가장 나쁜 path부터 확인하는 경우가 많다.

## Fmax

Fmax는 회로가 안정적으로 동작할 수 있는 최대 clock frequency이다. 단순화하면 clock period가 가장 긴 setup path delay보다 길어야 한다.

```text
Fmax ≈ 1 / minimum feasible clock period
```

Setup path가 길면 필요한 clock period가 길어지고, Fmax는 낮아진다.

## Registered output FSM과 timing

FSM output이 combinational output이면 current state와 input 변화가 output logic을 거쳐 바로 datapath로 전달된다. 이 경우 output logic이 다음 datapath의 combinational path에 포함될 수 있다.

Registered output FSM은 output을 clock edge에서 register로 잡아 내보낸다. 이 구조에서는 output이 clock edge 기준으로 안정적으로 나오기 때문에 glitch가 줄고, 다음 stage 입장에서는 register output에서 시작하는 path로 볼 수 있다.

다만 registered output은 latency가 1 cycle 증가할 수 있다. Timing에는 유리할 수 있지만 control timing을 설계할 때 cycle alignment를 고려해야 한다.

## Pipeline과 critical path

Pipeline은 critical path를 줄이는 대표적인 방법이다. 긴 combinational path를 여러 register stage로 나누면 각 stage의 delay가 감소한다.

```text
Before:
FF ---- long logic ---- FF

After:
FF ---- logic ---- FF ---- logic ---- FF
```

Fmax를 높이는 대신 latency와 register 수가 증가한다.

## 핵심 정리

- Slack은 timing margin이다.
- Critical path는 slack이 가장 작은 path이다.
- Setup critical path는 Fmax를 제한한다.
- Pipeline은 critical path를 줄여 Fmax를 높일 수 있다.
- Registered output 구조는 downstream timing과 glitch 관점에서 유리할 수 있지만 latency를 고려해야 한다.
