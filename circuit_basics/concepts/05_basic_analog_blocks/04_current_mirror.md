# 5-4. Current Mirror

Current mirror는 기준 전류를 다른 branch에 복사하는 회로이다. Bias 회로와 active load에서 핵심적으로 사용된다.

## 기본 구조

가장 단순한 NMOS current mirror는 diode-connected transistor와 output transistor로 구성된다.

```text
reference current -> diode-connected MOS -> VGS 생성
같은 VGS를 output MOS에 인가 -> 비슷한 current 생성
```

## 전류 복사 비율

두 transistor의 W/L 비율이 다르면 current ratio를 만들 수 있다.

```text
Iout / Iref ≈ (W/L)out / (W/L)ref
```

## 정확도를 제한하는 요인

- channel length modulation
- VDS mismatch
- threshold mismatch
- layout mismatch
- finite output resistance

## Analog 회로에서의 역할

- bias current 생성
- active load
- differential pair tail current source
- gain stage load

Current mirror는 ideal current source가 아니므로 output compliance와 output resistance를 고려해야 한다.
