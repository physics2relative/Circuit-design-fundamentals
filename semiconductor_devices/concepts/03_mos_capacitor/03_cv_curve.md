# 3-3. MOS C-V Curve

MOS capacitor C-V curve는 gate voltage에 따른 capacitance 변화를 보여준다.

## Accumulation region

Accumulation에서는 oxide capacitance가 주로 보인다.

```text
C ≈ Cox
```

## Depletion region

Depletion에서는 oxide capacitance와 depletion capacitance가 series로 연결된 것처럼 보인다.

```text
1/Ctotal = 1/Cox + 1/Cdep
```

Depletion width가 증가하면 capacitance가 감소한다.

## Inversion region

Low-frequency C-V에서는 minority carrier가 AC signal을 따라갈 수 있어 capacitance가 다시 증가할 수 있다. High-frequency C-V에서는 inversion charge가 빠르게 응답하지 못해 capacitance가 낮게 유지될 수 있다.

## 면접 포인트

MOS C-V는 accumulation/depletion/inversion을 전기적으로 확인하는 방법이다. Threshold voltage와 oxide/interface 특성 추출에도 사용된다.
