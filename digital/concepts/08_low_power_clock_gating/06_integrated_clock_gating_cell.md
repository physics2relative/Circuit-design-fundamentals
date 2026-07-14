# Integrated Clock Gating Cell

## ICG cell의 목표

Integrated clock gating(ICG) cell은 idle cycle에 clock switching을 막아 dynamic power를 줄이기 위한 전용 cell이다. 핵심 목표는 functional enable이 0인 동안 downstream flip-flop에 clock이 전달되지 않도록 하되, clock waveform 자체는 안전하게 유지하는 것이다.

즉 ICG cell은 다음 두 조건을 동시에 만족해야 한다.

```text
1. enable = 0이면 gated clock을 막는다.
2. enable = 1이면 정상 clock edge를 깨끗하게 전달한다.
```

## ICG cell의 기본 구조

Positive-edge triggered flip-flop을 구동하는 active-high clock gating의 대표 구조는 다음과 같다.

```text
             ┌──────────────┐
enable ----->│ latch         │
             │ transparent   │
             │ when clk = 0  │
clk -------->│              │
             └──────┬───────┘
                    │ latched_enable
                    v
clk -------------> AND ----> gated_clk
```

이 구조에서 봐야 할 핵심은 세 가지이다.

1. `enable`을 clock과 바로 조합하지 않는다.
2. `clk=0`인 안전한 phase에서 enable을 latch한다.
3. `clk=1`인 동안에는 `latched_enable`을 고정한 뒤 clock과 조합한다.

즉 ICG의 기본형은 `enable latch`와 `clock gating logic`으로 구성된다. 내부에 AND/NAND류 gating logic이 있지만, 중요한 차이는 그 앞에 enable을 안정화하는 latch가 있다는 점이다.

## Enable latch가 하는 일

Positive-edge triggered flop에서는 clock rising edge가 state update 시점이다. 따라서 gated clock이 정상적으로 동작하려면 rising edge가 오기 전에 clock을 통과시킬지 막을지가 이미 결정되어 있어야 한다.

Latch-based ICG는 이 조건을 다음 방식으로 만족한다.

```text
clk = 0: enable latch open, enable 값을 미리 sampling
clk = 1: enable latch closed, latched_enable 고정
```

그 결과 clock이 high인 동안 functional enable이 변해도 gated clock에 바로 반영되지 않는다. Enable 변화는 다음 clock low phase에서 latch되고, 그 다음 정상 clock edge부터 적용된다.

## AND gating logic은 왜 필요한가

ICG는 결국 clock을 통과시키거나 막아야 하므로 clock과 enable 정보를 결합하는 gating logic이 필요하다. Active-high gated clock의 개념 모델에서는 이를 AND로 표현할 수 있다.

```text
latched_enable = 1 -> gated_clk = clk
latched_enable = 0 -> gated_clk = 0
```

따라서 문제는 AND gate 자체가 아니다. 문제는 안정화되지 않은 raw enable을 clock과 바로 AND하는 것이다.

## 단순 AND gating과의 차이

단순 AND gating은 latch 없이 다음처럼 raw enable을 바로 사용한다.

```text
clk -----------\
                AND ---- gated_clk
enable --------/
```

이 구조의 문제는 AND gate 자체가 아니라, `enable`이 안정화되지 않은 채 clock과 바로 조합된다는 점이다.

`enable`이 `clk=1`인 동안 0에서 1로 바뀌면 `gated_clk`에도 즉시 rising edge가 생긴다. 이 edge는 원래 clock source의 정상 rising edge가 아니라 enable 변화로 만들어진 mid-cycle edge이다.

반대로 `enable`이 clock high 구간에서 1에서 0으로 바뀌면 gated clock high pulse가 중간에 잘려 pulse width 문제가 생길 수 있다.

정리하면 다음과 같다.

```text
Naive AND:
  enable 변화가 clock high 구간에 바로 gated_clk로 전달됨

ICG:
  latch가 clock high 구간의 enable 변화를 막고,
  clock low 구간에서만 다음 enable 값을 준비함
```

## 왜 flip-flop이 아니라 latch를 사용하는가

Enable을 flip-flop으로 sampling한 뒤 clock과 AND하는 구조도 생각할 수 있다.

```text
enable ----> FF ---- sampled_enable
clk ----------------> AND ---- gated_clk
```

하지만 positive-edge triggered logic에서 enable FF가 같은 rising edge에서 enable을 sampling하면, 그 clock edge는 이미 지나간 뒤이다. 우리가 원하는 것은 다음과 같다.

```text
clock active edge가 오기 전에 enable이 안정되어 있어야 한다.
```

FF는 active edge가 온 뒤 clock-to-Q delay 이후에야 `sampled_enable`을 바꾼다. 따라서 그 edge를 정상적으로 통과시키기에는 늦다. 경우에 따라 clock high 구간 중간에 gated clock이 열리는 형태가 되어 pulse width나 latency 문제가 생길 수 있다.

반면 latch는 clock inactive phase에서 미리 enable을 잡는다. 그래서 다음 active edge가 오기 전에 `latched_enable`이 이미 안정되어 있다.

| 구조 | enable sampling 시점 | 결과 |
| --- | --- | --- |
| Naive AND | sampling 없음 | enable 변화가 gated clock에 즉시 전달됨 |
| FF-based gating | clock active edge | enable 반영이 edge 이후라 늦음 |
| Latch-based ICG | clock inactive phase | 다음 active edge 전에 enable이 안정됨 |

따라서 ICG cell은 일반적으로 flip-flop이 아니라 latch를 사용해 enable을 clock의 inactive phase에서 미리 잡는다.

Negedge flip-flop을 사용하면 다음 posedge 전에 enable을 준비할 수 있으므로 원리상 비슷한 효과를 낼 수는 있다. 하지만 ICG에 필요한 기능은 clock low phase 동안 enable을 투명하게 받아두는 latch 하나로 충분하다. Negedge FF는 latch보다 구조가 무겁고 area/clock power overhead가 크며, 실제 ASIC flow에서는 latch-based ICG cell이 standard cell library에서 STA/DFT/CTS용으로 characterization되어 있기 때문에 보통 negedge FF + AND 구조를 직접 쓰지 않는다.

## Test enable이 필요한 이유

앞의 기본 구조에서는 functional `enable`만 표시했다. 실제 ICG cell에는 functional enable 외에 test enable 또는 scan enable이 추가되는 경우가 많다.

개념적으로는 다음처럼 볼 수 있다.

```text
effective_enable = functional_enable | test_enable
```

그리고 이 `effective_enable`이 enable latch로 들어간다.

```text
enable ----\
           OR ----> latch ----> gating logic ----> gated_clk
test_en ---/
```

Scan test에서는 functional logic이 clock을 gating하더라도 test clock이 flop까지 전달되어야 한다. 따라서 test mode에서는 clock gating을 우회하거나 강제로 열 수 있어야 한다. 단, ICG의 기본 원리를 설명할 때 `test_en`은 필수 요소가 아니라 DFT를 위한 확장으로 보면 된다.

## Clock gating timing check

ICG enable은 일반 data path와 다른 timing check를 가진다. Enable이 latch에 안정적으로 들어와야 gated clock이 glitch 없이 생성된다.

확인해야 할 항목은 다음과 같다.

- enable이 latch transparent window 안에서 안정되는가
- clock gating setup/hold check를 만족하는가
- gated clock pulse width가 충분한가
- test enable이 scan/test mode에서 올바르게 동작하는가

## RTL에서 ICG로 변환되는 흐름

RTL 설계자는 보통 clock을 직접 AND하지 않는다. 대신 clock enable 형태로 작성한다.

```verilog
always @(posedge clk) begin
  if (en)
    q <= d;
end
```

Synthesis tool은 조건이 적절하면 이를 ICG cell과 gated clock으로 변환할 수 있다. 따라서 RTL에서는 enable 조건을 명확하고 안정적으로 작성하는 것이 중요하다.

## 관련 실습

ICG 기본 구조와 비교 구조는 아래 프로젝트에서 waveform으로 확인할 수 있다.

```text
digital/projects/clock_gating_icg_experiment/
```

이 실습은 latch-based ICG를 기준 구조로 두고, naive AND gating과 FF-based gating이 왜 ICG 구조로 적절하지 않은지 비교한다. 또한 `test_en`이 functional enable과 별도로 clock을 열어주는 이유를 확인한다.

## 핵심 정리

- ICG cell의 핵심은 clock gating logic 앞에서 enable을 안전한 phase에 안정화하는 것이다.
- AND gate 자체가 문제가 아니라, 안정화되지 않은 enable을 clock과 바로 조합하는 것이 문제이다.
- Latch-based ICG는 clock inactive phase에서 enable을 미리 sampling한다.
- Flip-flop은 active edge 이후에 enable을 반영하므로 gated clock을 그 edge에 맞춰 열기에는 늦다.
- Test enable은 scan/test mode에서 gated clock을 강제로 통과시키기 위해 필요하다.
- Clock gating은 power optimization이지만 STA, DFT, CDC 관점 검증이 함께 필요하다.
