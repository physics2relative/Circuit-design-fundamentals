# 5-2. Loop Gain and Closed-loop Gain

Feedback loop의 핵심 수식은 closed-loop gain과 loop gain이다. `5-1`에서 정의한 기본 block diagram을 기준으로 하면 다음과 같다.

```text
e = x - βy
y = A e
```

## Closed-loop gain 유도

```text
y = A(x - βy)
y = Ax - Aβy
y(1 + Aβ) = Ax

Acl = y/x = A / (1 + Aβ)
```

여기서 `Acl`은 closed-loop gain이다.

## Loop gain

Loop gain은 loop를 한 바퀴 도는 gain이다.

```text
T = Aβ
```

`A`는 forward path gain이고, `β`는 feedback factor이다. Feedback 회로에서는 `A` 자체보다 `Aβ`, 즉 loop gain이 더 중요한 경우가 많다.

## Loop gain이 충분히 큰 경우

`Aβ >> 1`이면 closed-loop gain은 다음처럼 근사된다.

```text
Acl = A / (1 + Aβ) ≈ 1 / β
```

즉 closed-loop gain이 amplifier open-loop gain `A`보다 feedback network `β`에 의해 주로 정해진다.

```text
open-loop gain A가 충분히 큼
-> 작은 error만으로도 필요한 output 생성
-> βVout ≈ Vin
-> Vout/Vin ≈ 1/β
```

예를 들어 non-inverting op-amp feedback에서 resistor divider가 `β`를 정하면 closed-loop gain은 대략 `1/β`가 된다.

## Gain error와 desensitivity

Closed-loop gain은 `A`가 무한대일 때 정확히 `1/β`가 된다. 실제 `A`가 유한하면 gain error가 생긴다.

```text
Acl = A / (1 + Aβ)
ideal Acl ≈ 1/β
```

`1 + Aβ`는 desensitivity factor로 볼 수 있다. Open-loop gain `A`가 공정, 온도, bias에 의해 변해도 loop gain이 충분히 크면 closed-loop gain 변화가 줄어든다.

```text
A 변동 큼
하지만 Aβ 큼
-> Acl은 1/β 근처에 머묾
```

## Distortion 감소 직관

Amplifier 자체의 비선형성 때문에 output이 목표와 달라지면 feedback signal도 달라진다. 그러면 error가 그 차이를 보정하는 방향으로 변한다.

```text
output distortion 발생
-> βVout에도 distortion 반영
-> error가 보정 방향으로 변화
-> closed-loop distortion 감소
```

단, loop gain이 충분한 주파수 범위에서만 이 효과가 크다.

## Bandwidth와 loop gain

일반적인 single-pole amplifier에서는 feedback을 걸면 closed-loop gain은 낮아지고 bandwidth는 증가할 수 있다.

```text
closed-loop gain 감소
-> usable bandwidth 증가
-> gain-bandwidth trade-off
```

하지만 주파수가 올라가면 `A(s)`의 magnitude가 감소하고 phase lag가 커진다. 따라서 loop gain은 DC에서만 보는 값이 아니라 frequency response로 봐야 한다.

```text
low frequency  : |Aβ| 큼, feedback 효과 큼
high frequency : |Aβ| 감소, feedback 효과 감소
```

## 5-3과의 연결

Loop gain은 크기뿐 아니라 phase도 중요하다. `|Aβ| = 1` 근처에서 phase가 너무 많이 지연되면 ringing이나 oscillation이 생길 수 있다. 이 안정성 판단은 `5-3. Phase Margin and Gain Margin`에서 다룬다.

## 면접 답변 포인트

- Closed-loop gain은 `Acl = A/(1+Aβ)`이다.
- Loop gain은 `T = Aβ`이다.
- `Aβ >> 1`이면 `Acl ≈ 1/β`가 된다.
- Loop gain이 클수록 gain error, distortion, variation 민감도가 줄어든다.
- 주파수가 올라가면 loop gain이 감소하고 phase lag가 증가하므로 stability 확인이 필요하다.
