# 6-2. Short-channel Effect and DIBL

Short-channel effect는 channel length가 짧아지면서 gate가 channel을 완전히 지배하지 못하고 drain/source 전계 영향이 커지는 현상이다.

## Threshold roll-off

Channel이 짧아지면 threshold voltage가 낮아지는 경향이 나타날 수 있다.

```text
Leff 감소 -> VTH roll-off -> leakage 증가
```

## DIBL

DIBL은 drain-induced barrier lowering이다. Drain voltage가 커지면 source-channel barrier가 낮아져 off current가 증가한다.

```text
VDS 증가 -> barrier lowering -> off current 증가
```

## 회로 영향

- leakage 증가
- short-channel device의 VTH 안정성 저하
- output resistance 감소
- PVT/process variation 민감도 증가
