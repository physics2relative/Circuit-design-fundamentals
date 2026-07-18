# 3-4. Active Load and Single-ended Output

Differential pair는 resistor load 또는 active load와 함께 사용된다. CMOS analog 회로에서는 current mirror active load가 자주 쓰인다.

## Active load 역할

Active load는 큰 small-signal resistance를 제공해 gain을 키운다.

```text
Av ≈ gm * Rout
```

`Rout`이 커질수록 gain이 증가한다.

## Differential-to-single-ended 변환

Current mirror load를 사용하면 differential current 변화를 single-ended voltage output으로 변환할 수 있다.

```text
differential current -> mirror action -> single-ended output voltage
```

Op-amp 첫 번째 gain stage에서 자주 사용된다.

## 주의점

- Active load matching이 offset과 CMRR에 영향을 준다.
- Output node capacitance가 pole을 만든다.
- Output swing은 load transistor와 input transistor의 saturation 조건에 의해 제한된다.
