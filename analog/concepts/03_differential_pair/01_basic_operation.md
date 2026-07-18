# 3-1. Basic Operation

Differential pair는 두 transistor가 tail current를 나누어 가지는 구조이다.

```text
Vin+ 증가, Vin- 감소 -> 한쪽 current 증가, 반대쪽 current 감소
```

## Current steering

입력 차이 `Vid = Vin+ - Vin-`가 0이면 이상적으로 tail current가 반으로 나뉜다.

```text
ID1 = ID2 = Itail / 2
```

`Vid`가 양수가 되면 한쪽 current가 증가하고 다른 쪽 current가 감소한다. 큰 differential input에서는 tail current가 거의 한쪽으로 몰린다.

## Transconductance stage

Differential pair는 differential voltage를 differential current로 바꾸는 transconductance amplifier이다.

```text
Δiout ≈ gm_eff * Vid
```

작은 입력 근처에서는 선형적으로 동작하지만, 입력이 커지면 current steering이 포화되어 nonlinear해진다.

## Tail current source

Tail current source는 전체 current를 정하고 common-mode rejection에 영향을 준다. Tail source의 output resistance가 클수록 common-mode 변화에 덜 민감하다.
