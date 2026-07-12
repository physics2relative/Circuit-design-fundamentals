# Hold Timing Analysis

## Hold check의 의미

Hold timing은 capture clock edge 직후 data가 너무 빨리 바뀌지 않아야 한다는 조건이다. Capture FF가 현재 data를 안정적으로 sampling하려면 clock edge 이후 hold time 동안 D input이 유지되어야 한다.

```text
capture edge
    |
    |---- hold time ----|
          data must remain stable
```

Setup이 다음 cycle까지 data가 도착하는지를 보는 check라면, hold는 같은 capture edge 주변에서 data가 너무 빨리 변하지 않는지를 보는 check이다.

## 기본 관계

단순화하면 hold 조건은 다음과 같다.

```text
clk_to_Q_min + comb_delay_min >= hold_time
```

즉, launch FF에서 새 data가 너무 빨리 나와서 capture FF의 hold window 안에 들어오면 hold violation이 발생한다.

## Hold slack

Hold slack은 hold timing에서 남은 margin이다. 개념적으로는 data가 hold requirement보다 얼마나 늦게 바뀌는지를 나타낸다.

- Positive hold slack: hold timing 만족
- Negative hold slack: hold violation

## Hold violation의 특징

Hold violation은 clock period를 늘린다고 해결되지 않는 경우가 많다. Setup은 다음 capture edge까지의 시간과 관련이 있지만, hold는 현재 capture edge 직후의 매우 짧은 시간과 관련이 있기 때문이다.

따라서 clock frequency를 낮추는 것은 setup에는 도움이 되지만, hold 문제의 직접적인 해결책은 아니다.

## Hold violation의 원인

대표적인 원인은 다음과 같다.

- Data path가 너무 짧음
- Minimum delay가 너무 작음
- Clock skew가 hold에 불리하게 작용함
- Clock tree insertion delay 차이가 큼
- Scan path, reset path, enable path 등에서 의도치 않은 짧은 path가 존재함

## Hold violation 해결 방법

Hold violation은 보통 data path를 일부러 느리게 만들어 해결한다.

- Data path에 buffer를 추가한다.
- 작은 delay cell을 삽입한다.
- Routing을 조정한다.
- Clock skew를 조정한다.
- 너무 짧은 bypass path를 구조적으로 제거한다.

Setup fix와 달리, hold fix는 path를 빠르게 만드는 것이 아니라 최소 delay를 확보하는 방향이다.

## 핵심 정리

- Hold timing은 현재 capture edge 직후 data가 너무 빨리 바뀌지 않는지 보는 check이다.
- Hold violation은 min delay 문제이다.
- Clock period를 늘리는 것은 hold violation의 일반적인 해결책이 아니다.
- Hold fix는 보통 buffer insertion처럼 data path delay를 늘리는 방식으로 한다.
