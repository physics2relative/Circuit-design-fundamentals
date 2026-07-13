# Power Dissipation Sources

## Power를 왜 나누어 보는가

Low power 설계에서는 power가 어디에서 발생하는지 먼저 분해해서 봐야 한다. 원인이 다르면 줄이는 방법도 다르기 때문이다.

가장 큰 분류는 다음과 같다.

```text
Total Power = Dynamic Power + Static Power
```

Dynamic power는 회로가 switching할 때 발생하는 전력이고, static power는 회로가 동작하지 않아도 leakage 때문에 발생하는 전력이다.

## Dynamic power

Dynamic power는 signal이 0에서 1, 1에서 0으로 전환될 때 load capacitance를 charge/discharge하면서 발생한다.

Dynamic power는 다시 다음처럼 볼 수 있다.

```text
Dynamic Power = Switching Power + Short-Circuit Power
```

Switching power는 capacitance 충방전에 의해 발생한다. Short-circuit power는 input transition 동안 PMOS와 NMOS가 순간적으로 동시에 켜지면서 VDD에서 GND로 직접 current path가 생길 때 발생한다.

## Static power

Static power는 switching이 없어도 발생하는 power이다. 주로 leakage current에 의해 발생한다.

대표 leakage 성분은 다음과 같다.

- Subthreshold leakage
- Gate leakage
- Junction leakage

공정이 미세화될수록 supply voltage와 threshold voltage가 낮아지고, leakage가 전체 power에서 차지하는 비중이 커질 수 있다.

## Clock power

Clock은 거의 모든 cycle에서 toggle되고, clock tree는 많은 flip-flop을 구동한다. 따라서 clock network는 dynamic power에서 큰 비중을 차지할 수 있다.

Clock power가 큰 이유는 다음과 같다.

- Clock switching activity가 높다.
- Clock tree capacitance가 크다.
- Flip-flop clock pin capacitance가 크다.
- Data가 변하지 않아도 clock은 계속 toggle된다.

이 때문에 clock gating은 low power 설계에서 매우 중요한 기법이다.

## Memory와 IO power

SoC에서는 logic power뿐 아니라 memory와 IO power도 중요하다. SRAM access, large bus toggle, off-chip IO switching은 큰 power를 소모할 수 있다.

RTL 설계자는 wide bus toggle, unnecessary memory access, free-running counter 같은 activity source를 줄이는 방식으로 power를 낮출 수 있다.

## 핵심 정리

- Power는 dynamic power와 static power로 나누어 본다.
- Dynamic power는 switching activity와 관련이 있다.
- Static power는 leakage와 관련이 있다.
- Clock network는 dynamic power에서 큰 비중을 차지할 수 있다.
- Low power 기법은 어떤 power 성분을 줄이는지에 따라 구분해야 한다.
