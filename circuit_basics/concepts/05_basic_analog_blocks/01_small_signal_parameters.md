# 5-1. Small-signal Parameters

Small-signal 해석은 bias point 근처의 작은 변화만 선형화해서 보는 방법이다. MOSFET은 nonlinear device이지만, 동작점 주변에서는 gm과 ro를 사용해 근사할 수 있다.

## gm

Transconductance `gm`은 gate-source voltage 변화가 drain current 변화를 얼마나 만드는지 나타낸다.

```text
gm = dID / dVGS
```

gm이 클수록 입력 전압 변화가 더 큰 전류 변화로 변환된다. Amplifier gain에서 핵심 파라미터이다.

## ro

Output resistance `ro`는 drain-source voltage 변화에 대한 drain current 변화의 역수이다. Channel length modulation 때문에 ro는 유한하다.

```text
ro ≈ 1 / (lambda * ID)
```

ro가 클수록 current source에 가깝고, voltage gain을 크게 만들기 쉽다.

## Intrinsic gain

MOSFET 하나가 낼 수 있는 기본 gain 능력은 `gm * ro`로 볼 수 있다.

```text
intrinsic gain ≈ gm * ro
```

공정이 미세화되면 ro가 작아져 analog gain 확보가 어려워질 수 있다.
