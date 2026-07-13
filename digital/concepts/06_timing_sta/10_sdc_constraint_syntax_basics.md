# SDC Constraint Syntax Basics

## 목적

이 문서는 STA 이론이 아니라 SDC(Synopsys Design Constraints) 스타일의 기본 constraint 문법을 정리한다. Tool마다 세부 option이나 object query 문법은 다를 수 있지만, 기본 개념은 유사하다.

이론적인 의미는 다음 문서와 함께 보는 것이 좋다.

- [Timing Model Basics](./01_timing_model_basics.md)
- [Setup Timing Analysis](./02_setup_timing_analysis.md)
- [Input/Output Timing Constraints](./06_io_timing_constraints.md)
- [False Path and Multicycle Path](./07_false_path_multicycle_path.md)

## 기본 object query

Constraint는 특정 port, pin, cell, clock, register에 적용된다. 따라서 먼저 design object를 지정해야 한다.

```tcl
[get_ports CLK]
[get_ports Input1]
[get_ports Output1]
[get_clocks CLK]
[get_registers A]
[get_registers B]
```

`get_ports`는 top-level port를 찾고, `get_clocks`는 정의된 clock object를 찾는다. `get_registers`는 register object를 찾을 때 사용한다.

## create_clock

`create_clock`은 STA의 기준 clock을 정의한다.

```tcl
create_clock -period 5 [get_ports CLK]
```

의미는 다음과 같다.

```text
CLK port에 period 5ns인 clock이 들어온다고 정의한다.
```

이 clock이 정의되면 tool은 해당 clock에 의해 구동되는 internal FF-to-FF path를 기본적으로 1-cycle path로 분석한다.

Clock 이름을 명시할 수도 있다.

```tcl
create_clock -name CLK -period 5 [get_ports CLK]
```

## set_clock_uncertainty

`set_clock_uncertainty`는 clock edge 위치의 불확실성을 timing margin으로 반영한다.

```tcl
set_clock_uncertainty -setup 0.75 [get_clocks CLK]
set_clock_uncertainty -hold  0.10 [get_clocks CLK]
```

일반적으로 uncertainty는 jitter, skew margin, modeling margin 등을 보수적으로 반영하기 위해 사용한다. 값이 커질수록 timing check는 더 빡빡해진다.

## set_clock_transition

`set_clock_transition`은 clock edge의 transition time을 모델링한다.

```tcl
set_clock_transition -max 0.1 [get_clocks CLK]
```

Synthesis 초기에는 clock network가 아직 실제로 구현되지 않았기 때문에 ideal clock에 가까운 상태로 분석될 수 있다. 이때 clock transition을 지정하면 좀 더 보수적인 delay 계산에 도움이 된다.

## set_input_delay

`set_input_delay`는 외부에서 input port까지 data가 도착하는 데 이미 사용한 시간을 정의한다.

```tcl
set_input_delay -max 1.5 -clock CLK [get_ports Input1]
```

의미는 다음과 같다.

```text
외부 launch clock 기준으로 Input1 port에 data가 최대 1.5ns 뒤 도착한다고 가정한다.
```

Setup 분석에는 보통 `-max` 값을 사용한다. Hold 분석까지 고려하려면 `-min`도 함께 정의한다.

```tcl
set_input_delay -max 1.5 -clock CLK [get_ports Input1]
set_input_delay -min 0.2 -clock CLK [get_ports Input1]
```

핵심은 `set_input_delay`가 input port 이후의 내부 delay가 아니라는 점이다.

## set_output_delay

`set_output_delay`는 output port 이후 외부 block이 data를 capture하기 위해 필요한 시간을 정의한다.

```tcl
set_output_delay -max 2.0 -clock CLK [get_ports Output1]
```

의미는 다음과 같다.

```text
Output1 port 이후 외부 capture FF까지 setup을 만족하기 위해 최대 2.0ns가 필요하다고 가정한다.
```

Hold 분석까지 고려하려면 `-min`도 함께 정의한다.

```tcl
set_output_delay -max 2.0 -clock CLK [get_ports Output1]
set_output_delay -min 0.3 -clock CLK [get_ports Output1]
```

핵심은 `set_output_delay`가 output port까지의 내부 delay가 아니라는 점이다.

## Port-to-port combinational path

Input port에서 output port로 register 없이 이어지는 path는 input delay와 output delay를 함께 사용해서 constrain한다.

```tcl
set_input_delay  -max 2.0 -clock CLK [get_ports Input2]
set_output_delay -max 2.5 -clock CLK [get_ports Output2]
```

이 경우 현재 block 내부 combinational logic은 전체 period에서 input delay와 output delay를 제외한 시간 안에 동작해야 한다.

## Virtual clock

실제 clock port가 없는 combinational block도 외부 system timing 기준으로 constrain해야 할 수 있다. 이때 virtual clock을 사용한다.

```tcl
create_clock -name VCLK -period 5
set_input_delay  -max 2.0 -clock VCLK [get_ports Input2]
set_output_delay -max 2.5 -clock VCLK [get_ports Output2]
```

`VCLK`는 실제 design port에 연결된 clock이 아니다. Input/output delay의 기준으로만 사용하는 가상의 clock이다.

## set_false_path

`set_false_path`는 실제 timing check가 의미 없는 path를 STA 분석 대상에서 제외한다.

```tcl
set_false_path -from [get_registers A] -to [get_registers B]
```

False path는 violation을 숨기는 효과가 있으므로, 실제로 해당 path가 functional timing을 요구하지 않는지 확실할 때만 사용해야 한다.

CDC async crossing 구간에 사용할 수 있지만, false path가 CDC 안전성을 보장하는 것은 아니다. CDC 구조 검증은 별도로 필요하다.

## set_multicycle_path

`set_multicycle_path`는 data가 1 cycle이 아니라 여러 cycle 동안 전달될 수 있는 path를 정의한다.

```tcl
set_multicycle_path 2 -setup -from [get_registers A] -to [get_registers B]
set_multicycle_path 1 -hold  -from [get_registers A] -to [get_registers B]
```

첫 줄은 setup check를 2-cycle 기준으로 보겠다는 뜻이다. 두 번째 줄은 hold check의 edge 관계를 의도에 맞게 조정하기 위한 예시이다.

Tool과 clock 관계에 따라 정확한 edge 해석이 달라질 수 있으므로, multicycle constraint를 적용한 뒤에는 timing report에서 setup/hold edge가 의도대로 잡혔는지 반드시 확인해야 한다.

## 기본 작성 흐름

초기 SDC는 보통 다음 순서로 생각하면 된다.

```text
1. clock 정의
2. clock uncertainty/transition 같은 margin 정의
3. input delay 정의
4. output delay 정의
5. 필요한 경우 false path, multicycle path 등 exception 정의
6. timing report로 constraint가 의도대로 적용됐는지 확인
```

예시는 다음과 같다.

```tcl
create_clock -name CLK -period 5 [get_ports CLK]

set_clock_uncertainty -setup 0.75 [get_clocks CLK]
set_clock_transition  -max   0.10 [get_clocks CLK]

set_input_delay  -max 1.5 -clock CLK [get_ports Input1]
set_output_delay -max 2.0 -clock CLK [get_ports Output1]
```

## 핵심 정리

- `create_clock`은 STA의 기준 clock을 정의한다.
- `set_input_delay`는 input port 전까지 외부에서 사용한 시간을 정의한다.
- `set_output_delay`는 output port 이후 외부에서 필요한 시간을 정의한다.
- `virtual clock`은 실제 clock port가 없는 block의 IO timing 기준으로 사용한다.
- `set_false_path`는 path를 분석 대상에서 제외한다.
- `set_multicycle_path`는 path의 capture cycle 기준을 바꾼다.
- Constraint를 작성한 뒤에는 반드시 report에서 의도대로 적용됐는지 확인해야 한다.
