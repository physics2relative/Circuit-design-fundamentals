# 7. Device Interview Checklist

## Semiconductor fundamentals

- Electron과 hole은 무엇인가?
- Intrinsic/extrinsic semiconductor의 차이는 무엇인가?
- n-type과 p-type doping은 Fermi level을 어떻게 이동시키는가?
- Drift current와 diffusion current의 차이는 무엇인가?
- Mobility는 drive current와 delay에 어떤 영향을 주는가?

## PN junction / diode

- PN junction에서 depletion region은 왜 생기는가?
- Built-in potential은 어떤 역할을 하는가?
- Forward bias와 reverse bias에서 depletion width는 어떻게 변하는가?
- Diode I-V가 exponential인 이유는 무엇인가?
- Diode small-signal resistance `rd = nVT/ID`는 어떤 의미인가?
- Junction capacitance는 reverse bias에서 어떻게 변하는가?

## MOS capacitor

- MOS capacitor 구조를 설명할 수 있는가?
- Accumulation, depletion, inversion은 각각 무엇인가?
- MOS C-V curve에서 depletion region capacitance가 감소하는 이유는 무엇인가?
- Threshold voltage는 어떤 의미인가?
- Body effect가 VTH를 증가시키는 이유는 무엇인가?

## MOSFET

- NMOS/PMOS가 켜지는 조건은 무엇인가?
- Cutoff, triode, saturation region의 조건과 회로적 의미는 무엇인가?
- `gm`과 `ro`는 무엇인가?
- Channel length modulation은 왜 `ro`를 유한하게 만드는가?
- Subthreshold leakage는 왜 생기는가?
- Short-channel effect와 DIBL은 무엇인가?

## BJT

- Forward active region의 bias 조건은 무엇인가?
- `IC ≈ IS exp(VBE/VT)`의 의미는 무엇인가?
- `gm = IC/VT`, `rπ = β/gm`, `ro ≈ VA/IC`를 설명할 수 있는가?
- Early effect는 무엇인가?
- MOSFET과 BJT의 입력 특성 차이는 무엇인가?

## 좋은 답변 구조

```text
구조 설명 → 전하/전계 변화 → 전류/전압 특성 → 회로 파라미터 영향
```
