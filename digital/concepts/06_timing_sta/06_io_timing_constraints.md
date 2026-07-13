# Input/Output Timing Constraints

## 왜 IO constraint가 필요한가

STA tool은 현재 block 내부의 register, logic, net delay는 분석할 수 있다. 하지만 block 밖에 있는 다른 IP, package, board, chip-to-chip connection delay는 자동으로 알 수 없다.

따라서 input/output port에 대해서는 외부 timing 환경을 constraint로 알려줘야 한다.

```text
external IP ---- input port ---- internal FF ---- internal logic ---- output port ---- external IP
```

이때 STA가 보는 timing path는 크게 4가지로 나눌 수 있다.

```text
1. input port  -> internal FF
2. internal FF -> internal FF
3. internal FF -> output port
4. input port  -> output port
```

2번 internal FF-to-FF path는 clock만 정의해도 기본적인 1-cycle setup/hold check가 가능하다. 하지만 1, 3, 4번처럼 port가 포함된 path는 외부에서 data가 언제 들어오는지, 외부가 data를 언제까지 필요로 하는지 알려줘야 한다.

SDC 문법 예시는 별도 문서인 [SDC Constraint Syntax Basics](./11_sdc_constraint_syntax_basics.md)에 정리한다. 이 문서에서는 IO timing constraint의 의미를 중심으로 정리한다.

## Internal FF-to-FF path

가장 기본적인 register-to-register path는 다음과 같다.

```text
internal FF ---- combinational logic ---- internal FF
```

이 path에서는 launch FF와 capture FF가 모두 현재 block 내부에 있다. 따라서 clock period, clock-to-Q, combinational delay, setup/hold time을 기준으로 내부 timing을 분석할 수 있다.

예를 들어 다음 조건이라고 하자.

```text
clock period = 5ns
launch FF clock-to-Q = 0.5ns
capture FF setup time = 1ns
```

그러면 내부 combinational logic에 허용되는 최대 delay는 단순화해서 다음과 같다.

```text
5ns - 0.5ns - 1ns = 3.5ns
```

즉, 내부 FF-to-FF path는 clock period 안에서 launch, logic, capture setup requirement를 만족해야 한다.

## Input delay의 의미

Input delay는 외부 block에서 출발한 data가 현재 block의 input port에 도착하기까지 이미 사용한 시간을 의미한다.

```text
external launch FF ---- external logic ---- input port ---- internal logic ---- internal capture FF
        |                                                       |
 external launch clock                                  internal capture clock
```

현재 block 입장에서는 external launch FF와 external logic이 block 밖에 있으므로 STA tool이 직접 알 수 없다. 그래서 input port에 data가 얼마나 늦게 도착할 수 있는지를 알려줘야 한다.

Input delay가 크다는 것은 외부에서 이미 많은 시간을 사용했다는 뜻이다. 따라서 현재 block 내부 input path에 남는 timing budget은 줄어든다.

예를 들어 다음 조건이라고 하자.

```text
clock period = 5ns
input delay = 1.5ns
capture FF setup time = 1ns
clock uncertainty = 0.75ns
clock transition/margin = 0.1ns
```

그러면 input port 이후 현재 block 내부 logic에 쓸 수 있는 시간은 다음처럼 볼 수 있다.

```text
5 - 1.5 - 1 - 0.75 - 0.1 = 1.65ns
```

핵심은 input delay가 input port 이후의 내부 delay가 아니라는 점이다. Input delay는 input port에 도착하기 전, 외부 구간에서 이미 사용된 시간이다.

## Output delay의 의미

Output delay는 현재 block의 output port 이후 외부 block이 data를 capture하기 위해 필요한 시간을 의미한다.

```text
internal launch FF ---- internal logic ---- output port ---- external logic ---- external capture FF
        |                                                                  |
 internal launch clock                                             external capture clock
```

현재 block 입장에서는 output port 뒤쪽의 external logic과 external capture FF setup time을 직접 알 수 없다. 그래서 output port 이후 외부에서 필요한 시간을 알려줘야 한다.

Output delay가 크다는 것은 외부 쪽에서 시간이 많이 필요하다는 뜻이다. 따라서 현재 block은 output port까지 data를 더 빨리 내보내야 한다.

```text
internal output path budget ≈ clock period - output delay - clock margin
```

핵심은 output delay도 output port까지의 내부 delay가 아니라는 점이다. Output delay는 output port 이후 외부 구간에서 필요한 시간이다.

## Port-to-port combinational path

Input port에서 output port로 register 없이 바로 이어지는 combinational path도 있을 수 있다.

```text
input port ---- combinational logic ---- output port
```

이 path는 내부 register가 없기 때문에 내부 FF-to-FF timing처럼 분석할 수 없다. Input 쪽 외부에서 이미 사용한 시간과 output 쪽 외부가 필요로 하는 시간을 모두 고려해서, 현재 block 내부 combinational logic이 사용할 수 있는 시간을 계산해야 한다.

```text
internal combinational budget
≈ clock period - input delay - output delay - margin
```

## Virtual clock의 의미

현재 block 안에 실제 clock port가 없는 pure combinational block도 timing constraint가 필요할 수 있다.

```text
input port ---- combinational logic ---- output port
```

이런 경우에는 input/output delay의 기준이 될 실제 내부 clock이 없다. 그래서 외부 system timing을 표현하기 위한 기준 clock을 가상으로 만든다. 이것이 virtual clock이다.

Virtual clock은 실제 port나 pin에 연결된 clock이 아니다. 외부 system timing을 표현하기 위한 기준점이다.

## Time budgeting

실제 SoC에서는 각 IP가 서로 연결된다.

```text
IP-2 ---- current IP ---- IP-3
```

전체 clock period는 정해져 있고, IP-2 output logic, current IP input/output logic, IP-3 input logic이 그 시간을 나누어 쓴다. 이때 각 IP에 얼마만큼의 시간을 줄지 정하는 것이 time budgeting이다.

예를 들어 clock period가 5ns라고 해서 현재 IP가 input/output path에서 항상 2.5ns씩 써도 된다고 가정하면 margin이 부족할 수 있다. 실제로는 skew, uncertainty, routing, integration margin을 고려해서 보수적으로 budget을 잡는다.

## 자주 헷갈리는 점

### Input delay는 내부 delay가 아니다

Input delay는 input port 이후의 내부 combinational delay가 아니다. Input port에 data가 도착하기 전까지 외부에서 이미 사용한 시간이다.

### Output delay도 내부 delay가 아니다

Output delay는 output port까지의 내부 delay가 아니다. Output port 이후 외부 capture FF가 data를 받기 위해 필요한 시간이다.

### Clock만 정의하면 IO path가 충분히 constrain되지 않는다

내부 FF-to-FF path는 clock만으로 기본 분석이 가능하다. 하지만 port가 포함된 path는 외부 timing 정보가 없으므로 input/output delay가 필요하다.

## 핵심 정리

- IO timing은 block 내부 timing과 외부 timing budget을 연결하는 문제이다.
- Input delay는 외부에서 input port까지 이미 사용한 시간을 의미한다.
- Output delay는 output port 이후 외부에서 필요한 시간을 의미한다.
- Port-to-port combinational path는 input delay와 output delay를 모두 고려한다.
- Virtual clock은 실제 내부 clock이 없는 block의 IO timing 기준으로 사용한다.
- 구체적인 SDC 문법은 [SDC Constraint Syntax Basics](./11_sdc_constraint_syntax_basics.md)에 따로 정리한다.
