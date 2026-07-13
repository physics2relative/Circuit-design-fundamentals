# Static Power

## Static power의 의미

Static power는 회로가 switching하지 않아도 발생하는 power이다. CMOS logic은 이상적으로는 steady state에서 DC current가 거의 없어야 하지만, 실제 transistor에는 leakage current가 존재한다.

```text
Pstatic ≈ VDD × Ileakage
```

즉 supply voltage가 걸려 있고 leakage current가 흐르면 switching이 없어도 power가 소모된다.

## Leakage의 주요 원인

### Subthreshold leakage

Subthreshold leakage는 transistor가 off 상태일 때도 source와 drain 사이에 흐르는 leakage이다. Threshold voltage가 낮아질수록 증가하기 쉽다.

### Gate leakage

Gate oxide가 얇아지면 gate를 통해 leakage current가 흐를 수 있다. 공정 미세화와 관련이 크다.

### Junction leakage

Diffusion junction에서 발생하는 reverse-biased leakage이다. Temperature와 process condition의 영향을 받는다.

## Temperature 영향

Leakage current는 온도에 민감하다. 일반적으로 temperature가 올라가면 leakage가 증가한다. 따라서 static power는 high-temperature corner에서 더 심각해질 수 있다.

## Multi-Vt design

Multi-Vt design은 threshold voltage가 다른 cell을 함께 사용하는 기법이다.

- Low-Vt cell은 빠르지만 leakage가 크다.
- High-Vt cell은 느리지만 leakage가 작다.

Timing critical path에는 Low-Vt cell을 사용하고, 여유가 있는 path에는 High-Vt cell을 사용하면 성능과 leakage를 trade-off할 수 있다.

## Power gating과 static power

Static power를 크게 줄이는 대표 기법은 power gating이다. Idle block의 supply를 sleep transistor로 차단하면 leakage를 줄일 수 있다.

다만 power gating은 다음 비용을 만든다.

- Wake-up latency
- In-rush current
- State loss
- Isolation cell 필요
- Retention cell 필요 가능성
- Power sequence 검증 필요

## 핵심 정리

- Static power는 switching이 없어도 leakage 때문에 발생한다.
- Leakage는 temperature와 process scaling에 민감하다.
- Multi-Vt design은 speed와 leakage의 trade-off이다.
- Power gating은 static power를 줄이는 강력한 기법이지만 설계 복잡도를 증가시킨다.
