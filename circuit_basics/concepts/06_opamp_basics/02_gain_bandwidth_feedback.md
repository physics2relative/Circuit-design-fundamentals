# 6-2. Gain, Bandwidth, and Feedback

Op-amp는 보통 open-loop로 쓰기보다 negative feedback을 걸어 closed-loop gain을 정한다.

## Open-loop gain

Open-loop gain은 feedback이 없을 때 differential input을 output으로 증폭하는 gain이다. 매우 크지만 주파수가 올라가면 감소한다.

## Closed-loop gain

Negative feedback을 걸면 gain은 feedback network에 의해 정해진다.

예를 들어 non-inverting amplifier는 다음과 같다.

```text
Acl ≈ 1 + R2/R1
```

Open-loop gain을 희생하는 대신 정확도, linearity, bandwidth가 좋아진다.

## Gain-bandwidth trade-off

단일 dominant pole op-amp에서는 closed-loop gain이 작을수록 bandwidth가 넓어진다.

```text
gain * bandwidth ≈ constant
```

따라서 높은 gain과 넓은 bandwidth를 동시에 얻기는 어렵다.

## 설계 관점

- DC gain은 정확도와 error에 영향을 준다.
- bandwidth는 빠른 signal을 얼마나 따라갈 수 있는지 결정한다.
- feedback은 gain을 안정화하지만 stability 문제가 생길 수 있다.
