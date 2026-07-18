# 5-2. Loop Gain and Closed-loop Gain

Feedback loop의 핵심은 loop gain이다.

```text
T = Aβ
```

여기서 `A`는 amplifier open-loop gain, `β`는 feedback factor이다.

## Closed-loop gain

Negative feedback의 closed-loop gain은 다음과 같다.

```text
Acl = A / (1 + Aβ)
```

`Aβ >> 1`이면:

```text
Acl ≈ 1 / β
```

즉 closed-loop gain이 amplifier open-loop gain보다 feedback network에 의해 정해진다.

## Loop gain 의미

Loop gain이 클수록 gain error가 작고 distortion/variation 억제가 좋아진다. 하지만 주파수가 올라가면 loop gain magnitude는 감소하고 phase lag가 커져 stability 문제가 생긴다.
