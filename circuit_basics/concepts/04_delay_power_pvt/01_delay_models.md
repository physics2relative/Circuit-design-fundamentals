# 4-1. Delay Models

VLSI에서 delay는 여러 수준의 모델로 설명할 수 있다. 정확도는 다르지만 공통적으로 “저항이 capacitance를 충전/방전하는 시간”이라는 관점을 가진다.

## RC delay

가장 기본적인 모델은 RC delay이다.

```text
tdelay ≈ R * C
```

Transistor는 on 상태에서 effective resistance처럼 볼 수 있고, output node에는 load capacitance가 있다.

## Elmore delay

Elmore delay는 RC tree에서 각 capacitance가 보는 upstream resistance를 합산해 delay를 근사하는 방법이다.

```text
Elmore delay = sum(R_shared_to_Ci * Ci)
```

배선이 길고 branching이 있는 interconnect delay를 직관적으로 이해하는 데 유용하다.

## Linear delay model

Linear delay model은 cell delay를 input slew와 output load의 함수로 근사한다.

```text
cell delay = f(input slew, output load)
```

STA tool의 library table도 이와 비슷한 관점에서 cell delay를 다룬다.

## RTL 관점

RTL 설계자는 Elmore delay를 직접 계산하지는 않지만, 다음을 이해해야 한다.

- long wire와 high fanout은 delay를 키운다.
- wide mux와 deep logic은 critical path를 만들기 쉽다.
- load가 커지면 driving cell sizing이나 buffer insertion이 필요할 수 있다.
- pipeline은 한 cycle 안의 logic depth와 wire burden을 줄인다.
