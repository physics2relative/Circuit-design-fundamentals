# 2-4. Junction Capacitance and Breakdown

PN junction은 reverse bias에서 capacitance와 breakdown 특성을 가진다.

## Junction capacitance

Reverse-biased PN junction의 depletion region은 capacitor dielectric처럼 동작한다.

```text
Cj ≈ εA / Wdep
```

Reverse bias가 커지면 depletion width가 증가하고 junction capacitance는 감소한다.

## Diffusion capacitance

Forward bias에서는 injected minority carrier charge 때문에 diffusion capacitance가 중요해질 수 있다.

## Breakdown

Reverse bias가 너무 커지면 breakdown이 발생한다.

```text
Zener breakdown
Avalanche breakdown
```

Breakdown은 ESD device, voltage reference, reliability 관점에서 중요하다.

## 회로 연결

Junction capacitance는 digital delay와 analog pole에 영향을 준다. Source/drain diffusion capacitance는 MOSFET의 중요한 parasitic capacitance이다.
