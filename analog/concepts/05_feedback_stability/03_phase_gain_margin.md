# 5-3. Phase Margin and Gain Margin

Feedback stability는 loop gain의 magnitude와 phase로 판단한다.

## Phase margin

Unity loop-gain frequency에서 phase가 -180도까지 얼마나 남았는지를 phase margin이라고 한다.

```text
PM = 180° + phase(T) at |T| = 1
```

Phase margin이 작으면 step response에서 overshoot와 ringing이 커지고, 너무 작으면 oscillation이 발생할 수 있다.

## Gain margin

Loop phase가 -180도가 되는 주파수에서 gain이 0 dB보다 얼마나 낮은지를 gain margin이라고 한다.

## Transient와 연결

```text
낮은 phase margin -> overshoot/ringing 증가
충분한 phase margin -> 안정적인 settling
```

일반적으로 op-amp closed-loop 설계에서는 phase margin을 중요한 안정성 지표로 본다.
