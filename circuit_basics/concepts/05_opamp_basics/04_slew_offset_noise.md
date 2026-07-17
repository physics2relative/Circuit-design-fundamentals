# 5-4. Slew Rate, Offset, and Noise

Op-amp의 실제 성능은 gain과 bandwidth만으로 결정되지 않는다. Large-signal 동작에서는 slew rate, small-signal 정확도에서는 offset과 noise가 중요하다.

## Slew rate

Slew rate는 output voltage가 시간당 얼마나 빠르게 변할 수 있는지를 나타낸다.

```text
SR = max(dVout/dt)
```

내부 compensation capacitor를 충전/방전할 수 있는 current가 제한되어 있기 때문에 slew rate가 생긴다.

## Offset

Input offset voltage는 output을 0으로 만들기 위해 입력에 추가로 걸어야 하는 작은 differential voltage이다.

Offset은 transistor mismatch, layout mismatch, systematic imbalance에서 발생한다.

## Noise

Analog 회로에서는 thermal noise, flicker noise 등이 중요하다. 입력단 transistor 크기, bias current, bandwidth가 noise에 영향을 준다.

## 설계 관점

- 빠른 large-signal step에는 slew rate가 중요하다.
- 작은 DC signal 정확도에는 offset이 중요하다.
- 저주파 precision 회로에서는 flicker noise가 중요할 수 있다.
- bandwidth를 넓히면 integrated noise가 증가할 수 있다.
