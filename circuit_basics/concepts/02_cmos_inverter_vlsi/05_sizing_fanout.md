# 2-5. Sizing and Fanout

Transistor sizing은 drive strength, delay, input capacitance, area, power를 동시에 바꾼다.

## PMOS가 더 큰 이유

일반적으로 hole mobility가 electron mobility보다 낮기 때문에 PMOS는 같은 width에서 NMOS보다 drive current가 작다. Rise delay와 fall delay를 비슷하게 맞추려면 PMOS width를 NMOS보다 크게 잡는 경우가 많다.

```text
PMOS width 증가 -> pull-up strength 증가 -> rise delay 감소
```

## Sizing의 trade-off

Transistor width를 키우면 drive strength는 증가하지만 input capacitance와 diffusion capacitance도 증가한다.

```text
width 증가 -> drive 증가 -> 자기 output delay 감소 가능
width 증가 -> input cap 증가 -> 이전 stage load 증가
width 증가 -> area/power 증가
```

따라서 무조건 크게 만드는 것이 항상 좋은 것은 아니다.

## Fanout

Fanout은 한 gate output이 구동하는 다음 gate input의 개수이다. Fanout이 커지면 load capacitance가 증가하고 delay가 커진다.

큰 fanout signal은 buffer insertion, register duplication, hierarchy 조정으로 완화할 수 있다.

## Logical effort 관점

Logical effort는 gate topology와 electrical effort를 이용해 delay를 비교하는 방법이다. 면접 대비 수준에서는 다음 정도를 이해하면 충분하다.

- 복잡한 gate는 inverter보다 input capacitance가 크고 느릴 수 있다.
- 큰 load를 직접 구동하기보다 buffer chain을 쓰는 것이 유리할 수 있다.
- delay는 gate 자체의 parasitic delay와 load를 구동하는 effort로 나눠 볼 수 있다.

## RTL 설계 연결

RTL에서는 sizing을 직접 하지 않지만, 다음 구조는 backend/synthesis에서 sizing 부담을 키운다.

- 하나의 control signal이 너무 많은 register enable을 구동함
- reset fanout이 매우 큼
- wide mux가 critical path에 있음
- long combinational chain이 pipeline 없이 이어짐
