# 1-7. Microelectronics Interview Checklist

## 기본 해석

- Large-signal과 small-signal 해석의 차이는 무엇인가?
- Bias point가 왜 필요한가?
- DC 해석 후 small-signal equivalent circuit으로 바꾸는 절차를 설명할 수 있는가?

## Diode

- PN junction에서 depletion region이 생기는 이유는 무엇인가?
- Diode I-V가 exponential하다는 것은 어떤 의미인가?
- Diode의 small-signal resistance는 bias current와 어떤 관계인가?

## MOSFET

- MOSFET의 네 terminal은 무엇인가?
- NMOS와 PMOS가 켜지는 조건을 설명할 수 있는가?
- Cutoff, triode, saturation region의 조건과 회로적 의미는 무엇인가?
- MOSFET의 gm과 ro는 무엇을 의미하는가?
- Body effect와 channel length modulation은 어떤 non-ideality인가?

## BJT

- BJT의 forward active region은 어떤 bias 조건인가?
- Collector current와 VBE의 관계는 어떤 형태인가?
- BJT의 gm은 bias current와 어떤 관계인가?
- MOSFET과 BJT의 입력 특성 차이는 무엇인가?

## 좋은 답변 방향

좋은 답변은 소자 수식을 나열하는 것이 아니라 다음 흐름을 가진다.

```text
동작 조건 → I-V 특성 → small-signal parameter → 회로에서의 역할
```
