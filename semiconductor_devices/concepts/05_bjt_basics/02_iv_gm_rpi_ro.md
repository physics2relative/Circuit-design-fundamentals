# 5-2. I-V, gm, rpi, and ro

Forward active region에서 collector current는 base-emitter voltage에 대해 exponential하게 증가한다.

```text
IC ≈ IS * exp(VBE / VT)
VT = kT/q ≈ 25.9 mV at 300 K
```

## gm

```text
gm = ∂IC / ∂VBE = IC / VT
```

## rpi

Hybrid-pi model에서 input resistance는 다음이다.

```text
rπ = β / gm = VT / IB
```

## Early effect와 ro

VCE가 증가하면 effective base width가 줄어 collector current가 증가한다. 이를 Early effect라고 한다.

```text
IC ≈ IS exp(VBE/VT) * (1 + VCE/VA)
ro ≈ VA / IC
```

`ro`가 클수록 current source에 가깝고 gain이 커진다.
