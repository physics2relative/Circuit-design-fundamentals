# 5-1. Negative Feedback Basics

Negative feedback은 output의 일부를 input으로 되돌려 error를 줄이는 구조이다. Amplifier 자체의 open-loop gain이 크고 변동이 있더라도, feedback network가 안정적으로 정해져 있으면 closed-loop gain을 더 정확하게 만들 수 있다.

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
e = x - xf
xf = βy
y = A e
```

따라서 다음 관계가 나온다.

```text
y = A(x - βy)
y(1 + Aβ) = Ax

closed-loop gain:
y/x = A / (1 + Aβ)
```

## Parameter 의미

| 기호 | 의미 | 설명 |
| --- | --- | --- |
| `x` 또는 `Vin` | input signal | 외부에서 넣는 기준 입력이다. |
| `y` 또는 `Vout` | output signal | amplifier 출력이다. |
| `e` | error signal | 실제 amplifier 입력으로 들어가는 차이 신호이다. `e = x - βy`이다. |
| `A(s)` | open-loop gain | feedback을 끊고 본 forward path gain이다. 주파수에 따라 gain과 phase가 변한다. |
| `β(s)` | feedback factor | 출력 중 입력으로 되돌아오는 비율이다. resistor divider, capacitor network 등으로 정해질 수 있다. |
| `Aβ` | loop gain | loop를 한 바퀴 도는 gain이다. feedback의 정확도와 stability를 결정하는 핵심 값이다. |
| `1 + Aβ` | desensitivity factor | open-loop gain variation이 closed-loop gain에 미치는 영향을 줄이는 정도이다. |
| `A/(1+Aβ)` | closed-loop gain | feedback이 걸린 전체 gain이다. |

여기서 `(s)`는 frequency-dependent parameter라는 뜻이다. 실제 회로에서는 pole/zero 때문에 `A(s)`와 `β(s)`가 모두 주파수에 따라 달라질 수 있다.

## Loop gain이 충분히 큰 경우

`Aβ >> 1`이면 closed-loop gain은 다음처럼 근사된다.

```text
A/(1 + Aβ) ≈ 1/β
```

즉 전체 gain이 transistor의 `gm`, `ro`, process variation에 직접 의존하기보다 feedback network `β`에 의해 주로 결정된다.

예를 들어 non-inverting op-amp feedback에서 resistor divider가 `β`를 정하면 closed-loop gain은 대략 `1/β`가 된다.

```text
open-loop gain A가 충분히 큼
-> error e가 작아짐
-> Vout이 βVout ≈ Vin이 되도록 움직임
-> closed-loop gain ≈ 1/β
```

## Error가 줄어든다는 의미

Feedback이 없으면 출력은 open-loop gain과 입력에 직접 의존한다.

```text
y = A x
```

Negative feedback이 있으면 amplifier 입력은 전체 입력 `x`가 아니라 error `e`가 된다.

```text
e = x - βy
```

Loop gain이 크면 작은 error만으로도 큰 output을 만들 수 있다.

```text
e = y/A
A가 큼 -> 필요한 e가 작음
```

따라서 feedback 회로는 output을 계속 조정해서 `βy`가 `x`에 가까워지도록 만든다.

## Gain 정확도 개선

Open-loop gain `A`가 공정, 온도, bias에 의해 변해도 `Aβ`가 충분히 크면 closed-loop gain은 `1/β`에 가까워진다.

```text
A 변동 큼
하지만 Aβ >> 1이면
A/(1+Aβ) ≈ 1/β
```

그래서 feedback은 gain accuracy를 개선한다.

## Bandwidth와 feedback

일반적인 single-pole amplifier에서 feedback을 걸면 closed-loop gain은 낮아지지만 bandwidth는 늘어날 수 있다.

```text
closed-loop gain 감소
-> usable bandwidth 증가
-> gain-bandwidth trade-off
```

단, 모든 상황에서 무조건 좋아지는 것은 아니다. 여러 pole이 있으면 phase delay가 커지고 stability 문제가 생길 수 있다.

## Stability와 phase

Loop gain은 크기뿐 아니라 phase도 중요하다.

```text
loop gain = Aβ
```

Loop를 한 바퀴 돌았을 때 phase가 `-180°`에 가까워지고 loop gain magnitude가 1 이상이면 negative feedback이 사실상 positive feedback처럼 동작할 수 있다.

```text
|Aβ| ≥ 1 near phase -180°
-> ringing 또는 oscillation 가능
```

그래서 feedback 회로에서는 phase margin과 gain margin을 확인해야 한다.

## 장점

- closed-loop gain 정확도 개선
- distortion 감소
- bandwidth 증가 가능
- input/output resistance 개선
- process variation에 대한 민감도 감소

## 비용

- loop stability 문제
- phase margin 확보 필요
- compensation으로 bandwidth나 slew rate trade-off 발생
- feedback network 자체의 noise, loading, power 고려 필요

## 면접 답변 포인트

- Negative feedback은 `e = input - feedback` 구조이다.
- Closed-loop gain은 `A/(1+Aβ)`이고, `Aβ >> 1`이면 `1/β`로 근사된다.
- `Aβ`는 loop gain이며 feedback 정확도와 stability를 동시에 결정한다.
- Feedback은 gain 정확도와 linearity를 개선하지만, phase delay가 크면 oscillation이 발생할 수 있다.
- Frequency response에서는 `A(s)`, `β(s)`가 주파수에 따라 변하므로 phase margin을 확인해야 한다.
