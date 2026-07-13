# Low Power Interview Checklist

## Static power와 dynamic power의 차이

Dynamic power는 회로가 switching할 때 발생하는 power이다. Static power는 switching이 없어도 leakage 때문에 발생하는 power이다.

```text
Total Power = Dynamic Power + Static Power
```

면접에서는 줄이는 기법도 함께 연결해서 말하면 좋다.

```text
Clock gating은 dynamic power를 줄이고,
Power gating은 static leakage power를 줄인다.
```

## Dynamic power 식 설명

Dynamic power는 다음 식으로 설명할 수 있다.

```text
Pdynamic = α C V^2 f
```

- `α`: switching activity
- `C`: capacitance
- `V`: supply voltage
- `f`: frequency

Voltage는 제곱으로 들어가기 때문에 voltage scaling 효과가 크다. Clock gating은 activity를 줄이는 기법이다.

## Switching power와 short-circuit power

Switching power는 capacitance를 charge/discharge하면서 발생한다. Short-circuit power는 input transition 동안 PMOS와 NMOS가 동시에 켜져 VDD에서 GND로 current가 흐르면서 발생한다.

## Multi-Vt를 쓰는 이유

Multi-Vt는 leakage와 timing의 trade-off를 조절하기 위한 기법이다. Critical path에는 빠른 Low-Vt cell을 쓰고, timing 여유가 있는 path에는 leakage가 작은 High-Vt cell을 쓸 수 있다.

## Clock gating은 어떤 power를 줄이는가

Clock gating은 idle block의 clock switching을 막아 dynamic power를 줄인다. 특히 clock tree와 flip-flop clock pin switching을 줄이는 효과가 있다.

## Clock gating에서 glitch가 위험한 이유

Clock에 glitch가 생기면 의도하지 않은 clock edge처럼 동작해 flip-flop이 잘못 update될 수 있다. 그래서 ASIC에서는 단순 AND gate가 아니라 integrated clock gating cell을 사용한다.

## Enable flop과 clock gating의 차이

Enable flop은 enable이 0일 때 data update를 막지만 clock은 계속 toggle될 수 있다. Clock gating은 clock 자체를 막아 clock pin과 clock tree switching을 줄인다.

## Power gating은 어떤 power를 줄이는가

Power gating은 idle domain의 supply를 차단해 static leakage power를 줄인다. 하지만 state loss, wake-up latency, isolation, retention 같은 설계 복잡도가 생긴다.

## Isolation cell이 왜 필요한가

Power gated domain이 off되면 output이 unknown 상태가 될 수 있다. 이 signal이 on domain으로 전달되면 오동작을 유발할 수 있으므로 isolation cell로 safe value에 clamp한다.

## Level shifter는 언제 필요한가

서로 다른 voltage domain 사이에서 signal을 전달할 때 필요하다. Low voltage signal이 high voltage domain에서 logic high로 인식되지 않거나, high voltage signal이 low voltage domain device에 stress를 줄 수 있기 때문이다.

## Retention cell은 왜 필요한가

Power gating으로 domain power를 끄면 일반 flip-flop state는 사라진다. Sleep 이후에도 state를 유지해야 하는 register에는 retention cell을 사용한다.

## UPF는 무엇인가

UPF는 power intent를 RTL과 분리해서 표현하는 형식이다. Power domain, power switch, isolation, level shifter, retention, power state table 등을 정의한다.

## 핵심 답변 문장

- Dynamic power는 switching에 의해 발생하고, static power는 leakage에 의해 발생한다.
- Dynamic power는 `α C V^2 f`로 설명할 수 있다.
- Clock gating은 dynamic power를 줄이고, power gating은 static power를 줄인다.
- Multi-Vt는 speed와 leakage의 trade-off이다.
- Isolation cell은 off domain output을 safe value로 clamp한다.
- Level shifter는 voltage domain crossing에 필요하다.
- Retention cell은 power-gated domain의 state를 보존하기 위해 사용한다.
- UPF는 power intent를 표현하는 표준 형식이다.
