# 6-3. Stability and Phase Margin

Feedback 회로는 loop gain의 크기와 phase에 따라 안정하거나 발진할 수 있다.

## Loop gain

Loop gain은 feedback loop를 한 바퀴 돌 때의 gain이다.

```text
loop gain = Aol * beta
```

여기서 beta는 feedback factor이다.

## Phase margin

Phase margin은 loop gain magnitude가 1이 되는 주파수에서 phase가 -180도까지 얼마나 남았는지를 나타낸다.

```text
phase margin = 180도 + phase at unity loop gain
```

Phase margin이 작으면 ringing이 커지고, 너무 작으면 oscillation이 발생할 수 있다.

## Compensation

Two-stage op-amp에서는 여러 pole 때문에 stability가 나빠질 수 있다. Miller compensation capacitor를 사용해 dominant pole을 만들고 phase margin을 확보한다.

## 직관

- gain이 높고 pole이 많으면 feedback 안정성이 어려워진다.
- capacitive load는 op-amp stability에 큰 영향을 준다.
- phase margin은 transient response의 overshoot/ringing과 연결된다.
