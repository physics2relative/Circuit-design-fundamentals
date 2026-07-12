# STA Reports and Debug Flow

## Timing report에서 보는 항목

STA report는 violation path의 시작점, 끝점, data path delay, clock path delay, required time, arrival time, slack을 보여준다.

대표적으로 봐야 할 항목은 다음과 같다.

- Startpoint
- Endpoint
- Path group
- Launch clock
- Capture clock
- Data arrival time
- Data required time
- Slack
- Cell delay
- Net delay
- Clock path delay
- Uncertainty
- Derate / OCV margin

## Startpoint와 endpoint

Startpoint는 timing path가 시작되는 지점이다. 보통 launch FF의 clock pin 또는 input port가 된다.

Endpoint는 timing path가 끝나는 지점이다. 보통 capture FF의 data pin 또는 output port가 된다.

Startpoint와 endpoint를 보면 violation이 어떤 register 사이에서 발생했는지 파악할 수 있다.

## Data path 분석

Data path에서는 cell delay와 net delay 중 어느 쪽이 큰지 확인한다.

- Cell delay가 크면 logic depth, gate sizing, cell choice를 본다.
- Net delay가 크면 placement, routing, fanout 문제를 본다.
- 특정 mux, adder, comparator, priority encoder가 path를 지배하는지 확인한다.

## Clock path 분석

Clock path에서는 launch clock과 capture clock의 arrival time 차이를 본다. Skew가 setup 또는 hold에 불리하게 작용하는지 확인한다.

Clock uncertainty, jitter, generated clock constraint가 제대로 들어갔는지도 함께 확인해야 한다.

## WNS와 TNS

WNS(worst negative slack)는 가장 나쁜 slack 값이다. 가장 심한 violation 하나를 나타낸다.

TNS(total negative slack)는 negative slack의 총합이다. 전체적으로 timing이 얼마나 나쁜지 보는 지표이다.

```text
WNS: 가장 나쁜 path의 slack
TNS: violation path들의 negative slack 합
```

## Debug flow

Setup violation debug는 보통 다음 순서로 진행한다.

1. WNS가 가장 나쁜 path를 확인한다.
2. Startpoint와 endpoint를 확인한다.
3. Data path에서 cell delay와 net delay 비중을 본다.
4. Clock path와 skew, uncertainty를 확인한다.
5. Constraint가 의도와 맞는지 확인한다.
6. RTL 구조, synthesis option, physical placement 중 원인을 분류한다.
7. Pipeline, logic optimization, fanout reduction 등의 fix를 적용한다.

Hold violation debug는 다음 관점이 중요하다.

1. 너무 짧은 data path인지 확인한다.
2. Clock skew가 불리한지 확인한다.
3. Scan/reset/enable path 같은 특수 path인지 확인한다.
4. Buffer insertion 또는 clock skew 조정으로 fix 가능한지 본다.

## 핵심 정리

- STA report는 startpoint, endpoint, arrival, required, slack을 중심으로 읽는다.
- WNS는 가장 나쁜 violation이고, TNS는 전체 violation 규모이다.
- Setup debug는 긴 data path를 찾는 과정이다.
- Hold debug는 너무 짧은 data path와 clock skew를 확인하는 과정이다.
