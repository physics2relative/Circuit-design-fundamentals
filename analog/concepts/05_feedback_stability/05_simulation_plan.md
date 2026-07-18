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
