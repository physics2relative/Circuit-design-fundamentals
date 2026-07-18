# 2-4. Cascode Mirror

Cascode current mirror는 output transistor의 drain voltage 변화를 줄여 output resistance를 높이는 구조이다.

## 왜 cascode를 쓰는가

Basic mirror는 output voltage가 변하면 channel length modulation 때문에 current가 변한다. Cascode device를 추가하면 main mirror transistor의 VDS를 더 일정하게 유지할 수 있다.

```text
VDS variation 감소 -> current variation 감소 -> Rout 증가
```

## Output resistance

Cascode를 쓰면 output resistance가 대략 크게 증가한다.

```text
Rout ≈ gm * ro^2
```

정확한 값은 bias와 device parameter에 따라 달라지지만, basic mirror보다 훨씬 ideal current source에 가까워진다.

## 단점

- voltage headroom 증가
- output swing 감소
- bias voltage 추가 필요
- 낮은 supply voltage에서 사용이 어려울 수 있음

## 설계 관점

Cascode는 gain과 current source 정확도에는 좋지만, swing과 headroom을 희생한다. Op-amp 구조 선택에서 이 trade-off가 중요하다.
