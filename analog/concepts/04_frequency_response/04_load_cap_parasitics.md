# 4-4. Load Capacitance and Parasitics

Load capacitance와 parasitic capacitance는 amplifier frequency response를 제한한다.

## Output pole

Output node에 resistance와 capacitance가 있으면 pole이 생긴다.

```text
fp ≈ 1 / (2π Rout CL)
```

`CL`이 커지거나 `Rout`이 커지면 pole frequency가 낮아지고 bandwidth가 줄어든다.

## Parasitic capacitance

MOSFET에는 gate capacitance, junction capacitance, overlap capacitance가 있다. Layout 이후에는 wire capacitance도 추가된다.

```text
device parasitic + interconnect parasitic -> extra pole/zero
```

## 설계 관점

- Gain을 위해 `Rout`을 키우면 bandwidth가 줄 수 있다.
- 큰 load capacitor는 phase margin을 악화시킬 수 있다.
- PEX simulation에서 schematic simulation과 다른 주파수 응답이 나올 수 있다.
