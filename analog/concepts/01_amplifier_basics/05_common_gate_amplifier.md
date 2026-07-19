# 1-5. Common-gate Amplifier

Common-gate amplifier는 gate를 AC ground로 두고 source에 입력을 넣으며 drain에서 출력을 보는 구조이다. Source에 입력을 넣고 drain에서 출력이 나오므로 common-source와 달리 non-inverting gain을 가진다.

## 기본 구조

```text
        VDD
         |
        RD 또는 active load
         |
Vout ---- drain
         |
        NMOS
         |
Vin ----- source
         |
      input source / bias current path

Gate = DC bias, AC ground
```

## 입력 저항

Common-gate의 중요한 특징은 낮은 input resistance이다.

```text
Rin ≈ 1 / gm
```

Source에 입력이 들어오면 source 전압 변화가 곧 `vgs` 변화를 만들고, MOSFET이 그 변화를 강하게 받아들이기 때문에 source에서 바라본 저항이 낮게 보인다.

따라서 common-gate는 다음 상황에서 유용하다.

```text
current input을 voltage로 변환
낮은 impedance source를 받음
wideband input stage 구성
```

## Gain

Drain 쪽에 저항 load가 있으면 voltage gain은 대략 다음과 같다.

```text
Av ≈ gm Rout
```

Common-source와 달리 입력 source 전압이 올라가면 drain current가 줄어드는 방향이 아니라, 출력 전압이 같은 방향으로 움직이는 non-inverting gain을 가진다.

## Output resistance

Common-gate의 output은 drain에서 본다. 따라서 출력 저항의 기본 형태는 common-source처럼 drain 쪽 load와 MOSFET의 drain output resistance가 결정한다.

Source가 AC ground에 가깝게 고정되어 있다고 보면 다음처럼 단순화된다.

```text
resistive load:
Rout ≈ RD || ro

active load:
Rout ≈ ron || rop
```

하지만 common-gate에서는 source가 완전히 AC ground가 아니라 입력 source 저항 `Rs`를 통해 ground로 보일 수 있다. 이때 source degeneration 효과 때문에 transistor 자체의 drain output resistance가 커질 수 있다.

```text
transistor만 drain에서 본 저항:
rout,drain ≈ ro + Rs(1 + gm ro)
           ≈ ro(1 + gm Rs)    when gm ro >> 1
```

따라서 load까지 포함한 전체 output resistance는 대략 다음처럼 볼 수 있다.

```text
Rout,total ≈ RD || [ro + Rs(1 + gm ro)]
```

또는 active load이면 다음처럼 본다.

```text
Rout,total ≈ rop || [ron + Rs(1 + gm ron)]
```

다만 실제 amplifier gain 계산에서는 drain에 달린 `RD`, active load의 `ro`, 출력 capacitance가 함께 영향을 주므로, 면접 수준에서는 먼저 아래처럼 잡으면 충분하다.

```text
source가 AC ground에 가까움 -> Rout ≈ RD || ro
source 쪽 저항 Rs가 큼      -> transistor drain 저항이 source degeneration으로 증가
```

## Wideband 특성

Common-gate는 input node voltage swing이 작아서 Miller effect가 작다. 이 때문에 wideband input stage로 사용될 수 있다.

Common-source에서는 gate-drain capacitance가 Miller effect로 크게 보일 수 있지만, common-gate에서는 gate가 AC ground이고 source 입력 node의 voltage swing도 작기 때문에 input pole이 상대적으로 유리할 수 있다.

## Common-source와 비교

```text
Common-source:
입력 = gate
출력 = drain
Rin 높음
inverting gain
Miller effect 큼

Common-gate:
입력 = source
출력 = drain
Rin 낮음
non-inverting gain
Miller effect 작음
```

## 설계 포인트

- 낮은 input resistance가 장점이자 단점이다.
- output resistance는 기본적으로 drain 쪽 load와 `ro`가 만든다.
- source 쪽 `Rs`가 크면 source degeneration 때문에 drain에서 본 transistor output resistance가 커질 수 있다.
- input common-mode와 source voltage가 bias 조건에 직접 영향을 준다.
- gain, bandwidth, headroom을 함께 고려해야 한다.
