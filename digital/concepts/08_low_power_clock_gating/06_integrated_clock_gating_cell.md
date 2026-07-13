# Integrated Clock Gating Cell

## 왜 ICG cell을 따로 쓰는가

Clock gating의 목적은 idle cycle에 clock switching을 막아 dynamic power를 줄이는 것이다. 가장 단순하게 생각하면 clock과 enable을 AND gate로 묶을 수 있다.

```text
gated_clk = clk & enable
```

하지만 실제 clock path에 일반 조합 gate를 직접 넣는 것은 위험하다. Enable이 clock high 구간에서 변하면 gated clock에 짧은 pulse나 의도하지 않은 edge가 생길 수 있기 때문이다. Clock path의 glitch는 data path glitch보다 훨씬 위험하다. Flip-flop이 잘못된 edge로 state를 update할 수 있기 때문이다.

그래서 ASIC flow에서는 일반적으로 integrated clock gating(ICG) cell을 사용한다.

## Naive AND clock gating의 문제

Naive AND gating은 다음과 같다.

```text
clk -----------\
                AND ---- gated_clk
enable --------/
```

이 구조에서는 `enable`이 `clk=1`인 동안 0에서 1로 바뀌면 `gated_clk`에도 즉시 rising edge가 생긴다. 이 edge는 원래 clock source의 정상 rising edge가 아니라 enable 변화로 만들어진 edge이다.

반대로 `enable`이 clock high 구간에서 1에서 0으로 바뀌면 gated clock high pulse가 중간에 잘린다. 이 역시 clock pulse width 문제를 만들 수 있다.

## ICG cell의 기본 구조

Active-high clock gating의 대표적인 개념 구조는 다음과 같다.

```text
             ┌──────────────┐
enable ----->│ latch         │
test_en ---->│ transparent   │
             │ when clk = 0  │
clk -------->│              │
             └──────┬───────┘
                    │ latched_enable
                    v
clk -------------> AND ----> gated_clk
```

핵심은 enable을 clock의 안전한 phase에서 latch한 뒤 clock과 결합한다는 점이다. Positive-edge triggered flop을 구동하는 active-high gated clock에서는 보통 `clk=0`인 동안 enable latch가 transparent하고, `clk=1`인 동안 latch가 닫힌다.

## 왜 latch가 필요한가

Clock high 구간에서 AND gate input인 enable이 변하면 gated clock도 흔들린다. 따라서 enable이 clock high 구간에서는 고정되어 있어야 한다.

Latch-based ICG는 다음 원리로 동작한다.

```text
clk = 0: enable latch open, enable 값을 미리 sampling
clk = 1: enable latch closed, latched_enable 고정
```

그 결과 clock이 high인 동안 functional enable이 변해도 gated clock에 바로 반영되지 않는다. Enable 변화는 다음 안전한 low phase에서 latch되고, 다음 clock edge부터 적용된다.

## 왜 flip-flop이 아니라 latch를 사용하는가

Enable을 flip-flop으로 sampling한 뒤 clock과 AND하는 구조도 생각할 수 있다.

```text
enable ----> FF ---- sampled_enable
clk ----------------> AND ---- gated_clk
```

하지만 positive-edge triggered logic에서 enable FF가 같은 rising edge에서 enable을 sampling하면, 그 clock edge는 이미 지나간 뒤이다. 따라서 방금 sampling한 enable로 그 edge를 안전하게 통과시킬 수 없다. 결과적으로 clock gating이 한 cycle 늦게 열리거나, FF의 clock-to-Q delay 때문에 clock high 구간 중간에 gated clock이 열리는 형태가 될 수 있다.

반면 latch-based ICG는 clock low phase 동안 enable을 미리 sampling한다. 다음 rising edge가 오기 전에 `latched_enable`이 이미 안정되어 있으므로, gated clock이 정상 clock edge부터 깨끗하게 전달될 수 있다.

정리하면 다음과 같다.

| 구조 | enable sampling 시점 | 장점 | 문제 |
| --- | --- | --- | --- |
| FF-based gating | clock active edge | 단순하게 생각하기 쉬움 | edge가 이미 지난 뒤 enable이 반영되어 latency/pulse 문제가 생김 |
| Latch-based ICG | clock inactive phase | 다음 active edge 전에 enable 안정화 | clock gating 전용 latch timing check 필요 |

따라서 ICG cell은 일반적으로 flip-flop이 아니라 latch를 사용해 enable을 clock의 inactive phase에서 미리 잡는다.

## Test enable이 필요한 이유

ICG cell에는 보통 functional enable 외에 test enable 또는 scan enable이 있다.

```text
effective_enable = functional_enable | test_enable
```

Scan test에서는 functional logic이 clock을 gating하더라도 test clock이 flop까지 전달되어야 한다. 따라서 test mode에서는 clock gating을 우회하거나 강제로 열 수 있어야 한다.

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

Naive AND gating, FF-based gating, latch-based ICG의 차이는 아래 프로젝트에서 waveform으로 확인할 수 있다.

```text
digital/projects/clock_gating_icg_experiment/
```

이 실습은 enable이 clock high 구간에서 변할 때 naive gating에는 mid-cycle gated clock edge가 생길 수 있고, FF-based gating은 enable 반영이 늦어질 수 있으며, latch-based ICG는 enable을 clock low phase에서 미리 반영해 정상 clock edge를 통과시키는 흐름을 보인다.

## 핵심 정리

- ICG cell은 glitch-free clock gating을 위해 사용하는 전용 cell이다.
- 단순 AND gate clock gating은 enable 변화 시점에 따라 gated clock glitch나 의도하지 않은 edge를 만들 수 있다.
- Latch-based ICG는 clock safe phase에서 enable을 sampling해 clock active phase 동안 enable을 고정한다.
- Test enable은 scan/test mode에서 gated clock을 강제로 통과시키기 위해 필요하다.
- Clock gating은 power optimization이지만 STA, DFT, CDC 관점 검증이 함께 필요하다.
