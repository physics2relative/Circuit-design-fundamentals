# 5-5. Simulation Plan

Feedback stability는 loop gain AC simulation과 closed-loop transient simulation을 함께 확인한다.

## Loop gain simulation

확인:

```text
DC loop gain
unity loop-gain frequency
phase margin
gain margin
```

Loop를 끊는 방법은 회로와 tool setup에 따라 다르며, DC operating point를 깨지 않도록 주의해야 한다.

## Closed-loop AC simulation

Feedback을 닫은 상태에서 closed-loop gain과 bandwidth를 확인한다.

## Step transient

Step input을 넣고 overshoot, ringing, settling time을 확인한다.

```text
phase margin 낮음 -> ringing 증가
phase margin 충분 -> 안정적인 settling
```

## Load capacitance sweep

`CL`을 sweep하면서 phase margin과 step response가 어떻게 변하는지 확인한다.


## Slew rate transient

Large step input을 넣고 output waveform의 최대 기울기를 측정한다.

```text
SR+ = max rising dVout/dt
SR- = max falling dVout/dt
```

작은 step에서는 closed-loop bandwidth와 phase margin이 주로 보이고, 큰 step에서는 current limit 때문에 slew-rate limited 구간이 나타난다.

확인할 sweep은 다음과 같다.

```text
Cc 증가    -> SR 감소 가능, PM 개선 가능
Ibias 증가 -> SR 증가, power 증가
CL 증가    -> output slope와 settling 악화 가능
```
