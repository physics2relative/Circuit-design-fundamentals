# 4-3. Source Follower and Common-gate

Common-source 외에도 source follower와 common-gate 구조는 analog 회로에서 자주 쓰인다.

## Source follower

Source follower는 gate에 입력을 넣고 source에서 출력을 보는 구조이다.

```text
Vout ≈ Vin - VGS
```

전압 gain은 1보다 약간 작고, high input impedance와 low output impedance 특성이 있다. Buffer로 사용하기 좋다.

## Common-gate

Common-gate는 gate를 AC ground로 두고 source에 입력을 넣으며 drain에서 출력을 본다.

Common-gate는 낮은 input impedance를 가지며, current buffer나 wideband amplifier 구조에서 사용될 수 있다.

## 비교

```text
common-source : voltage gain 큼, inversion
source follower : voltage buffer, gain ≈ 1
common-gate : low input impedance, non-inverting current path
```

각 구조는 gain, input/output impedance, bandwidth 요구에 따라 선택된다.
