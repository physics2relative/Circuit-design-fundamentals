# 1-2. Amplifier Types

Amplifier는 입력과 출력 신호의 형태에 따라 네 종류로 분류할 수 있다.

## Voltage amplifier: V to V

```text
Av = vout / vin
```

이상적인 조건은 다음이다.

```text
Rin -> infinity
Rout -> 0
```

Common-source amplifier, common-emitter amplifier, closed-loop op-amp voltage amplifier가 대표적이다.

## Transconductance amplifier: V to I

```text
Gm = iout / vin
```

이상적인 조건은 다음이다.

```text
Rin -> infinity
Rout -> infinity
```

MOSFET 자체가 `id = gm * vgs` 형태의 transconductance device이다. Differential pair도 differential voltage를 output current로 바꾸는 transconductance stage로 볼 수 있다.

## Transresistance amplifier: I to V

```text
Rm = vout / iin
```

이상적인 조건은 다음이다.

```text
Rin -> 0
Rout -> 0
```

Photodiode current를 voltage로 바꾸는 transimpedance amplifier가 대표적이다.

## Current amplifier: I to I

```text
Ai = iout / iin
```

이상적인 조건은 다음이다.

```text
Rin -> 0
Rout -> infinity
```

Current mirror는 current를 복사하거나 scaling하는 기본 current-mode 회로이다.

## 요약

```text
V -> V : voltage amplifier        : high Rin, low Rout
V -> I : transconductance amp     : high Rin, high Rout
I -> V : transresistance amp      : low Rin, low Rout
I -> I : current amplifier        : low Rin, high Rout
```
