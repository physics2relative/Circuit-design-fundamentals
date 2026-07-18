# 1-6. Thevenin and Norton Equivalent

Thevenin/Norton equivalent는 복잡한 linear network를 source와 resistance 하나로 단순화하는 방법이다.

## Thevenin equivalent

어떤 linear network를 한 port에서 보면 이상 전압원과 직렬 저항으로 표현할 수 있다.

```text
Vth + series Rth
```

- `Vth`: open-circuit voltage
- `Rth`: independent source를 껐을 때 port에서 본 resistance

## Norton equivalent

같은 network를 이상 전류원과 병렬 저항으로 표현할 수도 있다.

```text
In || Rn
```

Thevenin과 Norton은 서로 변환 가능하다.

```text
In = Vth / Rth
Rn = Rth
```

## Source transformation

Voltage source with series resistance와 current source with parallel resistance는 동등하게 변환할 수 있다.

```text
Vth = In * R
In = Vth / R
```

## 회로설계 연결

- 실제 voltage source의 output resistance를 Thevenin model로 본다.
- 실제 current source의 output resistance를 Norton model로 본다.
- Amplifier input/output resistance 해석에 유용하다.
- Bias network가 load에 의해 얼마나 변하는지 빠르게 판단할 수 있다.
