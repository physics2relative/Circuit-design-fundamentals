# 5-4. Compensation and Capacitive Load

Compensation은 feedback loop를 안정하게 만들기 위해 pole/zero 위치를 조정하는 기법이다.

## Dominant pole compensation

Dominant pole을 낮은 주파수에 만들어 unity loop-gain frequency에서 나머지 pole들의 phase lag 영향을 줄인다.

Two-stage op-amp에서는 Miller compensation capacitor를 자주 사용한다.

## Capacitive load

Capacitive load는 output pole을 낮춰 phase margin을 악화시킬 수 있다.

```text
CL 증가 -> output pole 감소 -> phase lag 증가 -> PM 감소 가능
```

따라서 op-amp는 구동할 load capacitance 조건을 명확히 해야 한다.

## Trade-off

- Compensation capacitor 증가 -> phase margin 개선 가능, bandwidth 감소
- Bias current 증가 -> bandwidth/slew 개선 가능, power 증가
- Output buffer 추가 -> load driving 개선, stability 구조 복잡도 증가
