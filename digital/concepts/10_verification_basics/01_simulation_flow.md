# 10-01. Simulation Flow

Simulation은 RTL이 clock과 input stimulus에 대해 어떤 동작을 하는지 확인하는 과정이다. 기본 flow는 compile, elaborate, run으로 나누어 볼 수 있다.

## Compile

Compile 단계에서는 Verilog/SystemVerilog source를 분석하고 syntax error, module definition, port connection 문제를 확인한다.

```text
RTL files + testbench files -> compile
```

이 단계에서 주로 잡히는 문제는 다음과 같다.

- syntax error
- module name mismatch
- port width mismatch
- undeclared signal
- duplicate module definition

## Elaborate

Elaborate 단계에서는 top module 아래의 instance hierarchy를 만들고 parameter override, generate block, module instance 연결을 확정한다.

```text
compiled modules -> design hierarchy
```

이 단계에서 중요한 것은 “내가 생각한 DUT 구조가 실제로 연결되었는가”이다. Port가 잘못 연결되거나 parameter가 의도와 다르면 simulation은 돌아가도 의미가 없어질 수 있다.

## Run

Run 단계에서는 testbench가 clock/reset/stimulus를 만들고, simulator가 time을 진행하면서 signal 변화를 계산한다.

```text
initial/always block + event scheduling -> waveform + log
```

이 단계의 결과물은 보통 다음이다.

- console log
- pass/fail message
- waveform database
- coverage report

## RTL simulation

RTL simulation은 합성 전 RTL code를 대상으로 수행한다. 가장 빠르게 기능을 확인할 수 있고, 설계자가 대부분의 bug를 잡아야 하는 단계이다.

RTL simulation에서 중점적으로 볼 것은 다음이다.

- reset 후 초기 상태
- 정상 transaction 흐름
- boundary condition
- invalid input에 대한 방어
- stall, backpressure, full/empty 같은 corner case

## Gate-level simulation 개념

Gate-level simulation은 synthesis 이후 netlist를 대상으로 하는 simulation이다. RTL simulation보다 느리며, timing annotation을 포함할 수도 있다.

Gate-level simulation은 주로 다음을 확인하는 데 사용된다.

- synthesis 후 기능 equivalence 관점
- reset 초기화 문제
- X-propagation 문제
- scan/test mode 관련 연결
- timing annotation이 있는 경우 hold/setup 관련 issue

다만 일반 RTL 학습 단계에서는 RTL simulation을 먼저 제대로 하는 것이 훨씬 중요하다.

## Regression 개념

Regression은 여러 test를 자동으로 반복 실행해서 기존 기능이 깨지지 않았는지 확인하는 과정이다.

```text
수정 전 PASS했던 test set
        |
        v
수정 후 다시 실행
        |
        v
기존 기능 유지 여부 확인
```

작은 프로젝트에서도 regression 관점은 중요하다. 예를 들어 FIFO RTL을 수정했다면 basic test만 돌리는 것이 아니라 full/empty, valid-ready, async clock ratio test를 함께 돌려야 한다.

## 실습 연결

현재 repo의 CDC, ICG, FIFO 실습은 모두 xrun 기반으로 compile/elaborate/run을 한 번에 수행한다.

```text
bash sim/run_xrun.sh
```

이 스크립트는 각 testbench를 별도 run directory에서 실행하고, log와 SHM waveform을 남긴다. 즉 작은 regression script 역할을 한다.

## 핵심 정리

Simulation flow는 compile, elaborate, run으로 나뉜다. RTL 설계자는 waveform을 보는 것뿐 아니라, 어떤 test가 자동으로 pass/fail을 판단하는지, 수정 후 어떤 regression을 다시 돌릴지까지 생각해야 한다.
