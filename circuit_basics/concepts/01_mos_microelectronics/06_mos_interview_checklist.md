# 1-6. MOS Interview Checklist

## 기본 질문

- NMOS와 PMOS는 각각 어떤 조건에서 켜지는가?
- MOSFET의 terminal 네 개는 무엇인가?
- cutoff, triode, saturation region의 조건과 의미는 무엇인가?
- triode region에서 MOSFET을 저항처럼 볼 수 있는 이유는 무엇인가?
- saturation region이 analog amplifier에서 중요한 이유는 무엇인가?

## Threshold voltage

- threshold voltage란 무엇인가?
- VTH가 낮아지면 speed와 leakage는 어떻게 바뀌는가?
- Low-VTH cell과 High-VTH cell은 어디에 쓰는가?
- VTH, timing, static power의 관계를 설명할 수 있는가?

## Non-ideality

- body effect는 무엇인가?
- channel length modulation은 무엇인가?
- channel length modulation이 analog gain에 어떤 영향을 주는가?
- leakage의 종류에는 무엇이 있는가?

## 좋은 답변 방향

좋은 답변은 다음 구조를 가진다.

```text
정의 → 전압 조건 → 회로적 의미 → 설계 trade-off
```

예를 들어 VTH 질문에는 다음처럼 답한다.

```text
VTH는 channel 형성 기준 전압이다. VTH가 낮아지면 같은 VGS에서 overdrive가 커져 drive current가 증가하고 delay가 줄어든다. 대신 off 상태의 subthreshold leakage가 커져 static power가 증가한다.
```
