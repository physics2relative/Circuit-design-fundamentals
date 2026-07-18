# 6-1. Op-Amp Role and Ideal Model

Op-amp는 두 입력 전압의 차이를 큰 gain으로 증폭하는 회로이다.

```text
Vout = Aol * (V+ - V-)
```

여기서 `Aol`은 open-loop gain이다.

## Ideal op-amp 가정

이상적인 op-amp는 다음 특성을 가진다고 가정한다.

- infinite open-loop gain
- infinite input impedance
- zero output impedance
- infinite bandwidth
- zero offset
- infinite slew rate

실제 op-amp는 이 조건을 만족하지 않으므로 gain, bandwidth, stability, slew rate, offset을 따로 봐야 한다.

## Feedback에서의 virtual short

Negative feedback이 걸리고 op-amp가 정상 동작 범위에 있으면 두 입력 전압이 거의 같아진다.

```text
V+ ≈ V-
```

이를 virtual short라고 한다. 이는 두 입력이 실제로 short되어 있다는 뜻이 아니라, 높은 open-loop gain과 negative feedback 때문에 전압 차이가 작아진다는 뜻이다.
