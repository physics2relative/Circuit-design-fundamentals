# 4-5. Delay, Power, and PVT Interview Checklist

## Delay

- propagation delay가 왜 RC 관점으로 설명되는가?
- load capacitance가 증가하면 delay가 왜 증가하는가?
- fanout이 큰 signal은 왜 문제가 되는가?
- Elmore delay는 어떤 직관을 주는가?

## Power

- dynamic power 식의 각 항을 설명할 수 있는가?
- leakage power와 dynamic power의 차이는 무엇인가?
- VTH를 낮추면 timing과 leakage가 어떻게 바뀌는가?
- clock gating과 power gating의 차이는 무엇인가?

## PVT

- PVT가 무엇인가?
- setup timing은 어떤 corner에서 나빠지는가?
- hold timing은 왜 fast corner도 봐야 하는가?
- voltage가 낮아지면 power와 delay는 어떻게 변하는가?

## RTL 연결

- RTL 설계자가 timing을 고려해 구조를 바꿀 수 있는 예는 무엇인가?
- high fanout enable/reset을 어떻게 완화할 수 있는가?
- pipeline이 timing에는 유리하지만 어떤 비용을 만드는가?
