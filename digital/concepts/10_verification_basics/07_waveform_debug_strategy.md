# 10-07. Waveform Debug Strategy

Waveform debug는 simulation 실패 원인을 signal 변화로 추적하는 과정이다. 좋은 debug는 모든 신호를 무작정 보는 것이 아니라, control path와 data path를 나누고 transaction 기준으로 원인을 좁혀간다.

## 먼저 log를 본다

Waveform을 열기 전에 simulation log를 먼저 본다.

확인할 항목은 다음이다.

- 어떤 test가 실패했는가
- fail time은 언제인가
- expected와 actual 값은 무엇인가
- error가 한 번만 발생했는가, 연속적으로 발생했는가

Log가 부실하면 waveform debug가 오래 걸린다. Self-checking testbench는 실패 시 time, expected, actual, transaction index를 남기는 것이 좋다.

## 관찰 신호 선정

처음부터 모든 내부 signal을 보지 말고 interface signal부터 본다.

Valid-ready interface라면:

```text
valid
ready
data
transaction = valid && ready
```

FIFO라면:

```text
in_valid, in_ready, in_data
out_valid, out_ready, out_data
full, empty
wptr, rptr, count 또는 gray pointer
```

FSM이라면:

```text
state
next_state
input condition
registered output
```

## Control path와 data path 분리

Debug할 때는 control path와 data path를 나누어 본다.

Control path는 “언제 동작하는가”를 결정한다.

```text
valid, ready, enable, state, full, empty, counter
```

Data path는 “무슨 값이 이동하는가”를 보여준다.

```text
data, address, pointer, accumulator, output register
```

예를 들어 FIFO output mismatch가 발생했다면 먼저 pop transaction timing이 맞는지 보고, 그 다음 data ordering을 본다.

## Reset 이후부터 본다

많은 bug는 reset 직후 초기 상태에서 시작된다.

확인할 항목은 다음이다.

- reset polarity가 맞는가
- reset release 후 state가 정상인가
- FIFO empty/full 초기값이 맞는가
- counter/pointer가 0에서 시작하는가
- X가 남아 있지 않은가

## X-propagation 추적

`X`가 보이면 다음 순서로 추적한다.

1. reset되지 않은 register인지 확인한다.
2. case default가 빠졌는지 확인한다.
3. combinational always에서 default assignment가 빠졌는지 확인한다.
4. multiple driver가 있는지 확인한다.
5. testbench가 input을 X로 두고 있지 않은지 확인한다.

X를 무조건 0으로 덮어버리면 bug를 숨길 수 있다. X가 어디서 시작되는지를 찾는 것이 중요하다.

## CDC/FIFO waveform에서 볼 것

Async FIFO waveform에서는 다음을 중점적으로 본다.

- `wclk`, `rclk`
- `winc`, `wfull`, `wdata`
- `rinc`, `rempty`, `rdata`
- binary pointer와 Gray pointer
- synchronized pointer

핵심 질문은 다음이다.

```text
write pointer는 wclk에서만 증가하는가?
read pointer는 rclk에서만 증가하는가?
Gray pointer가 synchronizer를 거쳐 상대 domain에서 사용되는가?
full/empty가 각 domain에서 만들어지는가?
```

## Clock gating waveform에서 볼 것

Clock gating 실습에서는 다음을 본다.

- 원본 clock
- enable
- latched enable
- gated clock
- counter output

핵심은 enable이 clock high 구간에서 흔들릴 때 naive AND gating은 glitch가 생기고, latch-based ICG는 clock low 동안 enable을 capture해서 high 구간에서 안정적인 gated clock을 만든다는 점이다.

## Debug 순서

추천하는 순서는 다음이다.

1. 실패 log에서 fail time과 mismatch 값을 확인한다.
2. 해당 time 근처의 transaction을 찾는다.
3. reset 이후 첫 번째 이상 징후까지 거슬러 올라간다.
4. control signal이 맞는지 확인한다.
5. data path 값이 어디서 달라졌는지 확인한다.
6. DUT bug인지 testbench timing bug인지 구분한다.

## 핵심 정리

Waveform debug는 signal을 많이 보는 일이 아니라 원인을 좁히는 일이다. Interface transaction, control path, data path, reset, X-propagation을 순서대로 보면 CDC/FIFO/FSM 같은 RTL bug를 훨씬 빠르게 찾을 수 있다.
