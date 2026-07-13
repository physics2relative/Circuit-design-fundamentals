# False Path and Multicycle Path

## Timing exception이 필요한 이유

STA tool은 기본적으로 timing path를 보수적으로 분석한다. Clock이 정의되어 있으면 register 사이의 path는 보통 1 cycle 안에 data가 전달되어야 한다고 본다.

```text
launch edge ---- 1 cycle ---- capture edge
```

하지만 실제 design에는 다음과 같은 path가 존재할 수 있다.

- 논리적으로 절대 활성화되지 않는 path
- 서로 다른 mode에서만 쓰이는 path
- data가 1 cycle이 아니라 여러 cycle 뒤에 capture되는 path
- CDC synchronizer처럼 일반적인 single-clock setup/hold check와 의미가 다른 path

이런 path에 기본 STA rule을 그대로 적용하면 실제로는 문제가 아닌 violation이 보고될 수 있다. 반대로 exception을 너무 넓게 걸면 실제 bug를 숨길 수 있다.

따라서 timing exception은 “STA가 기본으로 가정하는 path 의미”와 “실제 회로 동작 의미”가 다를 때 사용하는 constraint이다.

## False path

False path는 실제 동작에서 timing을 맞출 필요가 없는 path이다. 더 정확히는 STA가 setup/hold check를 해도 의미가 없거나, 실제 functional mode에서 data가 그 path를 통해 capture되지 않는 경우이다.

```text
set_false_path -from A -to B
```

False path로 지정하면 STA는 해당 path의 timing violation을 보지 않는다.

## False path 예시 1: mode exclusive path

두 mode가 서로 동시에 켜질 수 없다고 하자.

```text
mode0 logic ---- mux ---- capture FF
mode1 logic ----/
```

Mode0에서만 의미 있는 path와 mode1에서만 의미 있는 path가 섞여 있을 수 있다. 실제로 동시에 활성화될 수 없는 조합인데 STA가 모든 조합을 분석하면 불필요한 violation이 나올 수 있다.

이런 경우에는 mode constraint, case analysis, false path 등을 사용해서 실제 가능한 path만 분석하도록 만든다.

## False path 예시 2: static configuration signal

초기 설정 후 동작 중에는 변하지 않는 configuration signal이 있다고 하자.

```text
config_reg ---- slow decode logic ---- datapath control
```

이 signal이 normal operation 중 cycle-by-cycle timing을 요구하지 않는다면 일반적인 high-speed timing path처럼 분석할 필요가 없을 수 있다. 다만 정말 static인지, 동작 중 바뀌는 경우가 없는지 설계적으로 확실해야 한다.

## False path 예시 3: CDC crossing

서로 다른 clock domain 사이의 async crossing은 일반적인 single-clock setup/hold 분석으로 안전성을 판단할 수 없다.

```text
src_clk domain ---- synchronizer ---- dst_clk domain
```

이 경우 async crossing 구간에는 false path 또는 clock group constraint를 줄 수 있다. 하지만 이것은 CDC를 해결했다는 뜻이 아니다. CDC 구조가 올바른지는 synchronizer, handshake, async FIFO 구조와 CDC checker로 따로 확인해야 한다.

## False path의 위험성

False path는 STA에게 “이 path는 보지 마라”라고 말하는 것과 같다. 따라서 잘못 걸면 실제 setup/hold violation이 report에서 사라진다.

면접 관점에서는 다음 문장을 기억하면 좋다.

```text
False path는 timing을 완화하는 constraint가 아니라, 실제로 timing check가 의미 없는 path를 분석 대상에서 제외하는 constraint이다.
```

## Multicycle path

Multicycle path는 data가 1 cycle 안에 capture될 필요가 없고, 여러 cycle 뒤에 capture되는 path이다.

기본 STA는 다음처럼 가정한다.

```text
cycle 0 launch -> cycle 1 capture
```

Multicycle 2 setup path는 다음처럼 해석할 수 있다.

```text
cycle 0 launch -> cycle 2 capture
```

즉 data path가 1 cycle보다 길어도 되고, 2 cycle 안에만 도착하면 된다.

## Multicycle path 예시

어떤 datapath가 enable이 2 cycle마다 한 번만 켜질 때 동작한다고 하자.

```text
cycle 0: data launch
cycle 1: intermediate, capture하지 않음
cycle 2: final capture
```

이 path는 구조적으로 2 cycle 동안 계산하도록 설계되었을 수 있다. 이때 기본 1-cycle setup check를 적용하면 불필요한 setup violation이 나올 수 있다.

이런 경우 multicycle path constraint를 사용한다.

```tcl
set_multicycle_path 2 -setup -from [get_registers A] -to [get_registers B]
```

의미는 A에서 B로 가는 setup check를 1 cycle이 아니라 2 cycle 기준으로 보겠다는 뜻이다.

## Setup multicycle과 hold multicycle

Multicycle path에서 가장 헷갈리는 부분은 setup만 바꾸면 끝이 아니라는 점이다.

Setup multicycle을 2로 주면 capture edge가 뒤로 밀린다.

```text
기본 setup check:
cycle 0 launch -> cycle 1 capture

multicycle 2 setup check:
cycle 0 launch -> cycle 2 capture
```

하지만 hold check는 data가 너무 빨리 바뀌지 않는지를 보는 check이다. Setup capture edge를 뒤로 미루면 hold check의 기준 edge도 tool rule에 따라 같이 변할 수 있어서, 의도하지 않게 hold check가 너무 강해지거나 이상해질 수 있다.

그래서 보통 setup multicycle과 함께 hold multicycle을 명시적으로 조정한다.

```tcl
set_multicycle_path 2 -setup -from [get_registers A] -to [get_registers B]
set_multicycle_path 1 -hold  -from [get_registers A] -to [get_registers B]
```

여기서 숫자는 tool과 기준 edge 해석에 따라 정확히 이해해야 한다. 핵심은 “setup을 여러 cycle로 늘렸으면 hold check도 의도한 edge 관계가 맞는지 반드시 확인해야 한다”는 점이다.

## False path와 multicycle path의 차이

둘은 모두 timing exception이지만 의미가 완전히 다르다.

| 구분 | 의미 | STA 동작 |
|---|---|---|
| False path | 실제로 timing check가 의미 없는 path | path를 분석 대상에서 제외 |
| Multicycle path | 실제로 여러 cycle 동안 전달되는 path | capture edge 기준을 바꿔 분석 |

False path는 path를 보지 않는 것이고, multicycle path는 path를 보되 허용 cycle을 바꾸는 것이다.

## 어떤 경우에 어떤 것을 쓰는가

### False path를 고려할 수 있는 경우

- 실제 functional mode에서 절대 capture되지 않는 path
- 서로 exclusive한 mode 사이의 path
- static signal이라 normal operation timing과 무관한 path
- CDC async crossing 중 일반 STA로 분석할 수 없는 구간

### Multicycle path를 고려할 수 있는 경우

- enable 구조상 N cycle마다 한 번만 capture되는 path
- 구조적으로 여러 cycle 동안 계산하는 datapath
- slow control path가 명확히 cycle-aligned 되어 있는 경우

## CDC와 exception 주의점

CDC path에 false path를 주는 것은 metastability 문제를 해결하는 것이 아니다. STA report에서 async path violation을 제거하는 것뿐이다.

CDC에서는 다음 순서가 필요하다.

1. Crossing signal의 성격을 확인한다.
2. Single-bit control이면 synchronizer 또는 toggle/handshake를 사용한다.
3. Multi-bit data이면 handshake 또는 async FIFO를 사용한다.
4. 그 구조에 맞게 STA exception을 제한적으로 건다.
5. CDC check로 구조를 검증한다.

## 핵심 정리

- Timing exception은 기본 STA 분석과 실제 회로 동작이 다를 때 사용한다.
- False path는 timing check가 의미 없는 path를 제외하는 constraint이다.
- Multicycle path는 여러 cycle 동안 data 전달을 허용하는 constraint이다.
- Multicycle setup을 걸면 hold check도 의도한 edge 관계인지 반드시 확인해야 한다.
- CDC path는 false path만으로 안전해지지 않는다. CDC 구조 검증이 별도로 필요하다.
