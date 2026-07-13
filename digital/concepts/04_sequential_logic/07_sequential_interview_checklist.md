# Sequential Logic Interview Checklist

## 순차논리의 정의

Sequential logic은 현재 입력뿐 아니라 저장된 state에 의해 출력과 다음 state가 결정되는 logic이다. 대부분 clock edge에서 state가 update된다.

```text
next state = f(current state, input)
state update at clock edge
```

## Latch와 flip-flop

Latch는 level-sensitive이고, enable이 active인 동안 input이 output으로 전달될 수 있다. Flip-flop은 edge-sensitive이고, clock edge에서만 input을 capture한다.

면접에서는 latch가 왜 조심스러운지 설명할 수 있어야 한다.

```text
Latch는 transparency 때문에 timing 분석과 검증이 어려워지고, 의도하지 않은 latch는 RTL bug로 보는 경우가 많다.
```

## Register

Register는 clock edge에서 값을 저장하는 sequential element이다. RTL에서는 보통 `always @(posedge clk)`와 non-blocking assignment로 표현한다.

Register 설계 시 확인할 점은 다음과 같다.

- reset value
- enable 조건
- update condition
- bit width
- pipeline alignment

## Counter

Counter는 현재 값에 일정 값을 더하거나 빼는 sequential circuit이다. 설계할 때 terminal count, wrap-around, saturation, enable, reset behavior를 명확히 해야 한다.

## Shift register

Shift register는 clock마다 data를 한 bit 또는 한 word씩 이동시키는 구조이다. Serial/parallel 변환, delay line, pipeline alignment에 사용된다.

## Enable

Enable은 register가 특정 cycle에만 update되도록 하는 control signal이다.

```verilog
if (en) q <= d;
else    q <= q;
```

RTL에서는 else branch를 생략해도 register hold로 해석될 수 있지만, 의도한 hold 동작인지 명확히 해야 한다.

## Pipeline register

Pipeline register는 긴 combinational path를 여러 stage로 나누어 timing을 개선한다. Setup timing에는 유리하지만 latency가 증가한다.

면접에서는 다음 trade-off를 말하면 좋다.

```text
pipeline은 Fmax를 높일 수 있지만 latency와 control alignment 비용이 생긴다.
```

## Reset

Reset은 sequential state를 known state로 초기화한다. Synchronous reset은 clock edge에서만 반영되고, asynchronous reset은 clock과 무관하게 assertion될 수 있다.

Reset deassertion은 clock domain별로 동기화하는 것이 안전하다. Reset release가 clock edge 근처에서 발생하면 recovery/removal violation이나 metastability 문제가 생길 수 있다.

## 핵심 답변 문장

- 순차논리는 state를 저장하고 clock edge 기준으로 update된다.
- Latch는 level-sensitive, flip-flop은 edge-sensitive이다.
- 의도하지 않은 latch는 timing과 검증을 어렵게 하므로 피해야 한다.
- Pipeline은 timing을 개선하지만 latency와 control alignment 비용이 있다.
- Reset은 assertion보다 deassertion timing이 중요하다.
