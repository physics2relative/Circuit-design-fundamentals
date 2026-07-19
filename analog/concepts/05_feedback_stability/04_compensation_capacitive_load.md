# 5-4. Compensation and Capacitive Load

Compensation은 feedback loop를 안정하게 만들기 위해 pole/zero 위치를 조정하는 기법이다.

## Dominant pole compensation

Dominant pole을 낮은 주파수에 만들어 unity loop-gain frequency에서 나머지 pole들의 phase lag 영향을 줄인다.

Two-stage op-amp에서는 Miller compensation capacitor를 자주 사용한다.

## Capacitive load

Capacitive load는 output pole을 낮춰 phase margin을 악화시킬 수 있다.

```text
CL 증가 -> output pole 감소 -> phase lag 증가 -> PM 감소 가능
```

따라서 op-amp는 구동할 load capacitance 조건을 명확히 해야 한다.


## Slew rate와 feedback compensation

Slew rate는 output이 시간에 따라 변할 수 있는 최대 기울기이다.

```text
SR = max(dVout/dt)
```

Feedback stability 문맥에서 slew rate를 같이 봐야 하는 이유는, compensation capacitor가 loop stability에는 유리하지만 large-signal 속도에는 불리할 수 있기 때문이다.

Two-stage op-amp에서 Miller compensation capacitor `Cc`가 있을 때, 큰 step input이 들어오면 differential pair의 한쪽으로 current가 몰리고 `Cc`를 충전/방전할 수 있는 current가 제한된다. 이때 출력 기울기는 capacitor 전류식으로 제한된다.

```text
i = C dv/dt

SR ≈ Iavailable / Cc
```

즉 `Cc`를 크게 하면 dominant pole을 낮춰 phase margin을 개선할 수 있지만, 같은 bias current에서는 slew rate가 낮아질 수 있다.

```text
Cc 증가
-> dominant pole 감소
-> phase margin 개선 가능
-> bandwidth 감소
-> slew rate 감소 가능
```

반대로 bias current를 키우면 `Cc`를 더 빠르게 충전/방전할 수 있어 slew rate가 개선된다.

```text
Ibias 증가
-> gm 증가 가능
-> bandwidth 개선 가능
-> Cc 충전/방전 current 증가
-> slew rate 개선
-> power 증가
```

## Slew rate와 bandwidth의 차이

Bandwidth는 small-signal frequency response의 한계이고, slew rate는 large-signal transient에서 output slope가 current limit에 걸리는 현상이다.

```text
small input:
linear region 동작
frequency response / bandwidth가 중요

large step input:
internal node 또는 output node를 충전/방전하는 current가 포화
slew rate가 중요
```

따라서 bandwidth가 충분해 보여도 큰 신호에서는 slew rate 때문에 output이 선형적으로 따라가지 못할 수 있다.

Sine wave에서는 필요한 slew rate를 다음처럼 근사할 수 있다.

```text
Vout = Vpk sin(2πft)
max(dVout/dt) = 2πf Vpk

필요 조건:
SR >= 2πf Vpk
```

즉 주파수가 높거나 output amplitude가 클수록 더 큰 slew rate가 필요하다.

## Settling과 slew의 관계

Step response는 보통 두 구간으로 나눠 볼 수 있다.

```text
large-signal 구간:
slew-rate limited slope로 빠르게 이동

small-signal 구간:
목표값 근처에서 feedback loop의 bandwidth/phase margin에 따라 settling
```

그래서 settling time은 slew rate만으로 결정되지 않는다. 큰 step에서는 먼저 slew 구간이 시간을 잡아먹고, 목표값 근처에서는 closed-loop bandwidth와 phase margin이 overshoot/ringing/settling을 결정한다.

## Trade-off

- Compensation capacitor 증가 -> phase margin 개선 가능, bandwidth 감소, slew rate 감소 가능
- Bias current 증가 -> bandwidth/slew 개선 가능, power 증가
- Output buffer 추가 -> load driving 개선, stability 구조 복잡도 증가
