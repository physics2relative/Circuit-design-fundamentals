# 6-3. Velocity Saturation and Mobility Degradation

Long-channel model에서는 carrier velocity가 electric field에 비례한다고 본다.

```text
v = μE
```

하지만 높은 electric field에서는 velocity가 더 이상 선형적으로 증가하지 않고 포화된다.

## Velocity saturation

```text
high lateral field -> carrier velocity saturation
```

이 현상은 short-channel MOSFET의 current와 delay 특성을 long-channel square-law와 다르게 만든다.

## Mobility degradation

Gate vertical field가 커지면 surface scattering이 증가해 mobility가 감소할 수 있다.

```text
vertical field 증가 -> mobility 감소 -> drive current 감소
```

## 회로 영향

- square-law model과 실제 current 차이
- gm, delay, saturation behavior 변화
- low-voltage/high-field 공정에서 중요
