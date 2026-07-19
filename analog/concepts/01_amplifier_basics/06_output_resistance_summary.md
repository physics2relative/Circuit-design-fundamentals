# 1-6. Amplifier Output Resistance Summary

Amplifier의 output resistance는 출력 노드에서 바라본 small-signal 저항이다. Voltage output stage에서는 낮은 `Rout`이 load driving에 유리하고, current source나 active load에서는 높은 `Rout`이 current를 일정하게 유지하는 데 유리하다.

## 기본 관점

Output resistance는 출력 포트에 test voltage 또는 test current를 걸어서 구한다.

```text
Rout = vtest / itest
```

계산할 때는 독립 입력 신호를 small-signal ground로 두고, bias source는 small-signal 모델로 바꿔서 본다.

```text
voltage input gate    -> AC ground
VDD                   -> AC ground
ideal current source  -> infinite small-signal resistance
real current source   -> finite ro
```

## Common-source amplifier

Drain에서 출력을 보는 common-source stage의 output resistance는 drain 쪽 저항과 MOSFET의 `ro`가 병렬로 보인다.

```text
resistive load CS:
Rout ≈ RD || ro

active load CS:
Rout ≈ ron || rop
```

Gain은 대략 다음처럼 정리된다.

```text
Av ≈ -gm Rout
```

따라서 common-source에서는 `Rout`이 클수록 gain이 커진다. 다만 `Rout`이 커지고 출력 노드 capacitance가 크면 pole이 낮아져 bandwidth가 줄 수 있다.

## Source follower

Source follower는 source에서 출력을 보기 때문에 output resistance가 낮다.

```text
Rout ≈ 1/gm || ro || Rs_bias
```

Body effect를 포함하면 다음과 같이 볼 수 있다.

```text
Rout ≈ 1/(gm + gmb) || ro || Rs_bias
```

따라서 source follower는 voltage gain을 크게 만들기보다는 낮은 output resistance로 load를 구동하는 buffer에 가깝다.

## Common-gate amplifier

Common-gate stage는 source로 입력을 넣고 drain에서 출력을 본다. Drain 출력 노드에서 보면 common-source와 비슷하게 drain 쪽 저항과 transistor `ro`가 output resistance를 만든다.

```text
resistive load CG:
Rout ≈ RD || ro

active load CG:
Rout ≈ ron || rop
```

Common-gate의 특징은 output resistance보다 input resistance가 낮다는 점이다.

```text
Rin ≈ 1/gm
```

그래서 low input resistance가 필요한 current-mode 입력이나 wideband stage에서 사용된다.

## Differential pair with active load

Single-ended active-load differential pair의 gain도 출력 노드의 등가 저항으로 많이 결정된다.

```text
Rout ≈ ron || rop
Av ≈ gm Rout
```

여기서 `ron`은 NMOS input transistor 쪽 output resistance, `rop`는 PMOS active load 쪽 output resistance이다. Cascode를 사용하면 `Rout`을 키워 gain을 높일 수 있지만 voltage headroom이 줄어든다.

## Current mirror / current source

Current mirror는 voltage output stage가 아니라 current source로 쓰이는 경우가 많다. 이때는 output resistance가 클수록 좋다.

```text
basic current mirror:
Rout ≈ ro

cascode current mirror:
Rout ≈ gm ro^2
```

Output resistance가 크면 output voltage가 변해도 current 변화가 작다.

```text
Rout 큼 -> ΔVout에 대한 ΔIout 작음 -> 좋은 current source
```

## 요약 표

| 회로 | 출력 위치 | 대략적 output resistance | 의미 |
| --- | --- | --- | --- |
| Common-source, RD load | drain | `RD || ro` | `Rout`이 gain을 결정한다 |
| Common-source, active load | drain | `ron || rop` | active load의 큰 `ro`로 gain 증가 |
| Source follower | source | `1/(gm+gmb) || ro || Rs_bias` | 낮은 `Rout`의 buffer |
| Common-gate | drain | `RD || ro` 또는 `ron || rop` | 출력은 drain, 입력은 source |
| Differential pair active load | output drain | `ron || rop` | single-ended gain 결정 |
| Basic current mirror | mirror output | `ro` | current source 정확도 결정 |
| Cascode current mirror | mirror output | `gm ro^2` 수준 | 높은 `Rout`, headroom 감소 |

## 면접 답변 포인트

- Voltage amplifier는 보통 낮은 output resistance가 load driving에 유리하다.
- Gain stage에서는 `Av ≈ gm Rout`이므로 `Rout`이 gain에 직접 영향을 준다.
- Current source/current mirror는 output resistance가 높을수록 이상적인 current source에 가깝다.
- Source follower는 `Rout ≈ 1/gm` 수준으로 낮아서 buffer로 쓰인다.
- Cascode는 output resistance를 키우지만 voltage headroom과 swing을 희생한다.
