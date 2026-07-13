# Clock Gating

## Clock gating의 목적

Clock gating은 block이 동작할 필요가 없는 cycle에 clock switching을 막아 dynamic power를 줄이는 기법이다. Clock은 activity가 매우 높고 fanout이 크기 때문에 gating 효과가 클 수 있다.

```text
idle block -> clock off -> clock tree/flop switching 감소
```

Clock gating은 주로 dynamic power의 `α` 항을 줄인다.

## Clock enable과 clock gating

RTL에서 흔히 쓰는 enable register는 다음과 같다.

```verilog
always @(posedge clk) begin
  if (en) q <= d;
end
```

이 구조는 `en=0`일 때 data update는 막지만 clock은 flip-flop에 계속 들어간다. 따라서 clock pin switching power는 그대로 발생한다.

Clock gating은 실제 clock 자체를 gated clock으로 바꾸어 idle cycle에 flip-flop clock pin toggle을 막는다.

## Integrated clock gating cell

실제 ASIC에서는 단순 AND gate로 clock을 gating하지 않고 integrated clock gating(ICG) cell을 사용한다.

ICG cell은 보통 enable을 latch로 안정화한 뒤 clock과 결합해 glitch-free gated clock을 만든다.

```text
clk ---- ICG ---- gated_clk
          ^
          |
         enable
```

## 왜 latch가 필요한가

Enable이 clock high 구간에서 바뀌면 gated clock에 glitch가 생길 수 있다. ICG cell은 enable을 clock의 안전한 phase에서 latch해 clock active edge 주변에서 enable이 흔들리지 않도록 만든다.

즉 latch-based gating은 glitch-free clock gating을 위한 구조이다.

## Clock gating check

Clock gating에는 일반 data path timing과 다른 check가 필요하다. Enable이 clock gating cell 내부 latch에 안정적으로 들어와야 하고, gated clock에 glitch가 생기면 안 된다.

STA에서는 clock gating setup/hold check 또는 enable timing check를 확인한다.

## DFT 관점

Scan test에서는 clock을 제어해야 하므로 clock gating이 scan 동작을 방해하면 안 된다. ICG cell에는 scan enable 또는 test enable이 포함되는 경우가 많다.

면접에서는 다음처럼 설명할 수 있다.

```text
Clock gating은 power에는 유리하지만 clock network를 바꾸는 기법이므로 STA와 DFT 관점의 검증이 필요하다.
```

## RTL coding 관점

RTL 설계자는 보통 명시적으로 clock을 AND하지 않는다. 대신 enable 조건을 명확히 작성하고, synthesis tool이 clock gating으로 변환할 수 있도록 coding style을 유지한다.

주의할 점은 다음과 같다.

- Gating enable이 안정적이어야 한다.
- 너무 작은 register group에 gating을 걸면 overhead가 이득보다 클 수 있다.
- Clock gating 조건이 기능 동작을 바꾸면 안 된다.
- CDC clock을 임의로 gating하면 안 된다.

## 핵심 정리

- Clock gating은 clock switching을 막아 dynamic power를 줄인다.
- Clock enable은 data update를 막지만 clock toggle은 계속 발생할 수 있다.
- ASIC에서는 glitch-free 동작을 위해 ICG cell을 사용한다.
- Clock gating은 STA, DFT, CDC 관점에서 검증이 필요하다.
