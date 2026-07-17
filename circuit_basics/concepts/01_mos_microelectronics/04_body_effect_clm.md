# 1-4. Body Effect and Channel Length Modulation

Body effect와 channel length modulation은 ideal MOSFET 모델에서 벗어나는 대표적인 non-ideality이다.

## Body effect

Body effect는 source-body 전압 변화로 threshold voltage가 변하는 현상이다.

NMOS에서 body가 source보다 더 낮아져 reverse body bias가 커지면 VTH가 증가한다.

```text
reverse body bias 증가 -> VTH 증가 -> current 감소 -> delay 증가
```

Digital standard cell에서는 body가 보통 substrate/well에 고정되어 있어 회로도에서 잘 드러나지 않는다. 하지만 source 전압이 body와 달라지는 stacked transistor나 analog 회로에서는 body effect가 동작점과 gain에 영향을 줄 수 있다.

## Channel length modulation

Saturation region에서 ideal MOSFET은 drain current가 VDS와 무관하다고 가정한다. 실제로는 VDS가 증가하면 effective channel length가 짧아져 current가 증가한다. 이를 channel length modulation이라고 한다.

Analog 관점에서는 channel length modulation이 output resistance를 유한하게 만든다.

```text
ro ≈ 1 / (lambda * ID)
```

output resistance가 유한하면 common-source amplifier의 gain이 제한된다.

```text
Av ≈ -gm * ro
```

## Digital 관점

Digital 회로에서는 body effect와 channel length modulation을 직접 계산하는 경우는 적다. 하지만 다음을 이해하는 데 중요하다.

- stacked transistor가 single transistor보다 느린 이유
- process/device corner에 따라 delay가 달라지는 이유
- leakage와 delay가 ideal switch 모델보다 복잡한 이유
- analog block에서 gain이 무한대로 나오지 않는 이유

## 핵심 정리

- body effect는 VTH를 바꾼다.
- channel length modulation은 saturation current가 VDS에 의존하게 만든다.
- CLM은 analog gain을 제한하는 중요한 원인이다.
- 디지털 설계자는 세부 수식보다 delay/leakage/PVT와 연결해서 이해하면 된다.
