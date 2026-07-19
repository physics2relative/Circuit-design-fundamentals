# 5-1. Negative Feedback Basics

Negative feedback은 output의 일부를 input으로 되돌려 amplifier 입력의 **error signal**을 줄이는 구조이다. 이 문서에서는 feedback block diagram과 각 신호의 의미만 잡고, closed-loop gain 수식은 `5-2`, phase/gain margin은 `5-3`에서 다룬다.

## 기본 block diagram

```text
                 error e
Vin = x  -----> (+)Σ(-) -----> [  A(s)  ] -----> y = Vout
                 ^                                |
                 |                                |
                 |---------- [  β(s)  ] <---------|
                         feedback xf = β(s)y
```

Negative feedback에서는 summing node에서 입력과 feedback이 빼진다.

```text
e  = x - xf
xf = βy
y  = A e
```

즉 amplifier가 직접 증폭하는 신호는 외부 입력 `x` 자체가 아니라, 입력과 feedback의 차이인 `e`이다.

## Parameter 의미

| 기호 | 의미 | 설명 |
| --- | --- | --- |
| `x` 또는 `Vin` | input signal | 외부에서 넣는 기준 입력이다. |
| `y` 또는 `Vout` | output signal | amplifier 출력이다. |
| `xf` | feedback signal | 출력의 일부가 feedback network를 거쳐 입력 쪽으로 돌아온 신호이다. |
| `e` | error signal | 실제 amplifier 입력으로 들어가는 차이 신호이다. `e = x - xf`이다. |
| `A(s)` | forward/open-loop gain | error signal을 output으로 증폭하는 forward path gain이다. |
| `β(s)` | feedback factor | 출력 중 얼마가 입력으로 되돌아오는지 나타내는 비율이다. |

여기서 `(s)`는 frequency-dependent parameter라는 뜻이다. 실제 회로에서는 pole/zero 때문에 `A(s)`와 `β(s)`가 주파수에 따라 달라질 수 있다.

## Error가 줄어든다는 의미

`error`가 줄어든다는 것은 출력이 feedback 조건을 만족하도록 조정되어 `x`와 `βy`의 차이가 작아진다는 뜻이다.

```text
e = x - βy
```

예를 들어 출력이 너무 작으면 `βy < x`가 되어 `e`가 양수가 되고, amplifier는 출력이 증가하는 방향으로 동작한다. 반대로 출력이 너무 크면 `βy > x`가 되어 `e`가 음수가 되고, 출력이 감소하는 방향으로 동작한다.

결과적으로 feedback loop는 다음 상태를 향해 움직인다.

```text
βy ≈ x
```

Op-amp 회로에서 자주 말하는 `V+ ≈ V-`도 같은 의미이다. 단, error가 완전히 0이 되는 것은 아니다. 유한한 open-loop gain으로 출력을 만들기 위해 아주 작은 error는 필요하다.

## Negative feedback의 직관

Negative feedback의 핵심 직관은 다음과 같다.

```text
출력이 목표보다 작음 -> error 증가 -> output 증가 방향으로 보정
출력이 목표보다 큼   -> error 반대 부호 -> output 감소 방향으로 보정
```

그래서 negative feedback은 output이 입력이 요구하는 값에 가까워지도록 계속 보정한다.

## 장점

- closed-loop gain 정확도 개선
- distortion 감소
- bandwidth 증가 가능
- input/output resistance 개선 가능
- process/temperature/bias variation에 대한 민감도 감소

## 비용

- loop stability 문제
- phase margin 확보 필요
- compensation으로 bandwidth나 slew rate trade-off 발생
- feedback network 자체의 noise, loading, power 고려 필요

## 면접 답변 포인트

- Negative feedback은 `e = input - feedback` 구조이다.
- Amplifier가 증폭하는 것은 입력 자체가 아니라 error signal이다.
- Feedback은 `βVout`이 `Vin`에 가까워지도록 output을 보정한다.
- Closed-loop gain의 수식과 loop gain은 `5-2`, phase/gain margin은 `5-3`에서 정리한다.
