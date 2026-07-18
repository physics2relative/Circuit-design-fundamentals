# 2-3. Output Resistance and Compliance

Current mirror의 품질은 output resistance와 compliance voltage로 많이 결정된다.

## Output resistance

Output resistance는 output voltage 변화에 대해 output current가 얼마나 변하는지를 나타낸다.

```text
Rout = ΔVout / ΔIout
```

MOS current source에서는 channel length modulation 때문에 output resistance가 유한하다.

```text
ro ≈ 1 / (λID)
```

`Rout`이 클수록 current source에 가깝다.

## Compliance voltage

Compliance voltage는 current mirror가 정상적으로 current source처럼 동작하기 위해 필요한 최소 output voltage headroom이다.

NMOS current sink 기준으로 output transistor가 saturation에 있으려면:

```text
VDS >= VGS - VTH = VOV
```

따라서 output node voltage가 너무 낮아지면 transistor가 triode로 들어가고 mirror current가 무너진다.

## Trade-off

- Cascode 구조는 output resistance를 키우지만 headroom을 더 요구한다.
- 낮은 VDD 공정에서는 high output resistance와 large swing을 동시에 얻기 어렵다.
- Bias current를 키우면 gm은 커지지만 power와 headroom 문제가 생길 수 있다.
