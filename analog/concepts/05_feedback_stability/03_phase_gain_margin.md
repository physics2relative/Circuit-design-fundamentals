# 5-3. Phase Margin and Gain Margin

Feedback stability는 loop gain `T = Aβ`의 magnitude와 phase로 판단한다. `5-2`에서 loop gain이 클수록 feedback 효과가 좋아진다고 했지만, phase delay가 커지면 negative feedback이 사실상 positive feedback처럼 동작할 수 있다.

## 왜 phase가 중요한가

Negative feedback은 feedback signal을 입력에서 빼는 구조이다.

```text
e = x - βy
```

하지만 loop 안의 amplifier와 capacitor node들이 주파수에 따라 phase lag를 만든다. Loop를 한 바퀴 돌았을 때 phase가 `-180°`에 가까워지면, 입력에서 빼야 할 feedback이 부호상 더하는 것처럼 작동할 수 있다.

```text
phase lag 작음  -> negative feedback 유지
phase lag ≈ 180° -> positive feedback 성격 증가
```

## Unity loop-gain frequency

Unity loop-gain frequency는 loop gain magnitude가 1이 되는 주파수이다.

```text
|T(jωu)| = |Aβ| = 1
```

이 주파수에서 phase가 얼마나 `-180°`에서 떨어져 있는지가 phase margin이다.

## Phase margin

Phase margin은 unity loop-gain frequency에서 phase가 `-180°`까지 얼마나 남았는지를 나타낸다.

```text
PM = 180° + phase(T) at |T| = 1
```

예를 들어 `|T| = 1`인 주파수에서 loop phase가 `-120°`이면:

```text
PM = 180° - 120° = 60°
```

Phase margin이 작으면 step response에서 overshoot와 ringing이 커지고, 너무 작으면 oscillation이 발생할 수 있다.

```text
PM 큼     -> 안정적, overshoot 작음, 느릴 수 있음
PM 작음   -> 빠르게 보일 수 있으나 ringing 증가
PM 부족   -> oscillation 가능
```

## Gain margin

Gain margin은 loop phase가 `-180°`가 되는 주파수에서 loop gain이 0 dB보다 얼마나 낮은지를 나타낸다.

```text
phase(T) = -180°인 주파수에서
GM = 1 / |T|
```

또는 dB로는 다음처럼 본다.

```text
GM(dB) = -20log10|T| at phase(T) = -180°
```

즉 phase가 이미 positive feedback 조건에 가까워졌을 때, loop gain이 1보다 충분히 작아야 안정적이다.

## Pole과 phase lag

각 pole은 magnitude를 낮추고 phase lag를 만든다.

```text
pole 1개 -> 최대 -90° phase lag
pole 2개 -> 최대 -180° phase lag
```

따라서 unity loop-gain frequency 전에 여러 pole의 영향이 들어오면 phase margin이 나빠진다.

```text
non-dominant pole이 낮음
-> unity gain 근처 phase lag 증가
-> PM 감소
```

## Transient와 연결

Phase margin은 closed-loop step response와 직접 연결된다.

```text
낮은 phase margin -> overshoot/ringing 증가
충분한 phase margin -> 안정적인 settling
```

다만 phase margin은 small-signal stability 지표이다. 큰 step에서는 slew-rate limited 구간이 먼저 나타날 수 있고, 목표값 근처에서 small-signal settling과 phase margin 효과가 보인다.

## 5-4와의 연결

Compensation은 pole/zero 위치를 조정해 unity loop-gain frequency에서 phase margin을 확보하는 작업이다. Dominant pole compensation, Miller compensation, capacitive load에 따른 output pole 변화는 `5-4`에서 다룬다.

## 면접 답변 포인트

- Phase margin은 `|Aβ|=1`에서 phase가 `-180°`까지 얼마나 남았는지이다.
- Gain margin은 phase가 `-180°`일 때 loop gain이 1보다 얼마나 작은지이다.
- Phase margin이 낮으면 overshoot/ringing이 증가하고, 부족하면 oscillation이 발생할 수 있다.
- Pole이 unity loop-gain frequency 근처에 많으면 phase lag가 커져 stability가 나빠진다.
- Compensation은 phase margin을 확보하기 위해 pole/zero 위치를 조정하는 것이다.
