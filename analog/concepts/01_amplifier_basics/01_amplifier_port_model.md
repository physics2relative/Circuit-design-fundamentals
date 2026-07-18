# 1-1. Amplifier Port Model

Amplifier는 입력 port와 출력 port를 가진 two-port network로 볼 수 있다.

```text
signal source -> input port | amplifier | output port -> load
```

이 모델에서 중요한 값은 input resistance, output resistance, gain이다.

## Input resistance

Input resistance는 입력 port에서 바라본 저항이다.

```text
Rin = vin / iin
```

Voltage signal을 받는 회로에서는 `Rin`이 클수록 source loading이 작다.

```text
vin = vsig * Rin / (Rs + Rin)
```

`Rin >> Rs`이면 source voltage가 amplifier input에 거의 그대로 전달된다.

## Output resistance

Output resistance는 출력 port에서 바라본 저항이다. Voltage output을 만들고 싶다면 `Rout`이 작을수록 좋다.

```text
vload = vout_open * RL / (Rout + RL)
```

`Rout << RL`이면 load가 붙어도 output voltage가 크게 줄지 않는다.

## Current source 관점

Current output을 만들고 싶다면 output resistance가 커야 한다.

```text
Rout >> RL -> load voltage가 변해도 current 변화가 작음
```

Current mirror, active load, tail current source는 모두 높은 output resistance가 중요한 회로이다.

## 핵심 정리

```text
voltage input  : high Rin 선호
current input  : low Rin 선호
voltage output : low Rout 선호
current output : high Rout 선호
```
