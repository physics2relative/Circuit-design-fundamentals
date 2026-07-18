# 4-3. gm, ro, and Body Effect

MOSFET small-signal parameter는 회로 성능과 직접 연결된다.

## gm

Transconductance는 gate-source voltage 변화가 drain current 변화를 얼마나 만드는지 나타낸다.

```text
gm = ∂ID / ∂VGS
```

Common-source amplifier gain은 대략 `-gm * Rout` 형태로 나타난다.

## ro

Channel length modulation 때문에 saturation current가 VDS에 의존하게 되고 output resistance가 유한해진다.

```text
ro ≈ 1 / (λID)
```

`ro`가 클수록 current source에 가깝고 analog gain이 커진다.

## Body effect

Body-source 전압이 바뀌면 VTH가 바뀐다.

```text
VSB 증가 -> VTH 증가 -> current 감소
```

Body effect는 source follower gain, stacked transistor, analog bias point에 영향을 줄 수 있다.
