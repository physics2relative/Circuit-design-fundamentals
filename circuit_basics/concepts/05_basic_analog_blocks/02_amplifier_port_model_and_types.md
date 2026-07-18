# 5-2. Amplifier Port Model and Types

Amplifier는 단순히 “gain을 만든다”가 아니라, 입력 source와 출력 load 사이에서 신호를 원하는 형태로 변환하고 전달하는 two-port network로 볼 수 있다. 이때 input resistance와 output resistance는 실제 회로 연결에서 gain이 얼마나 유지되는지를 결정한다.

## Amplifier를 two-port로 보기

Amplifier는 입력 port와 출력 port를 가진 block으로 모델링할 수 있다.

```text
source -> [ input port | amplifier | output port ] -> load
```

입력 port에서는 source를 얼마나 loading하는지가 중요하고, 출력 port에서는 load를 얼마나 잘 구동하는지가 중요하다.

## Input resistance

Input resistance는 입력 port에서 바라본 등가 저항이다.

```text
Rin = vin / iin
```

Voltage signal을 받는 amplifier에서는 보통 input resistance가 큰 것이 좋다. 그래야 source에서 만든 전압이 amplifier 입력에 거의 그대로 전달된다.

```text
Rin >> Rs -> input voltage loss 작음
```

반대로 current signal을 받는 amplifier에서는 input resistance가 낮은 것이 유리할 수 있다. 그래야 입력 current가 amplifier input으로 잘 들어간다.

## Output resistance

Output resistance는 출력 port에서 바라본 등가 저항이다. 출력 source가 load 변화에 얼마나 영향을 받는지를 나타낸다.

Voltage output amplifier에서는 output resistance가 낮은 것이 좋다.

```text
Rout << RL -> output voltage loss 작음
```

Current output amplifier에서는 output resistance가 높은 것이 좋다. 그래야 load voltage가 변해도 output current가 거의 일정하다.

```text
Rout >> RL -> output current variation 작음
```

## Voltage amplifier: V to V

Voltage amplifier는 입력 전압을 출력 전압으로 증폭한다.

```text
input  : voltage
output : voltage
Av = vout / vin
```

이상적인 voltage amplifier는 다음 특성을 가진다.

```text
Rin  -> infinity
Rout -> 0
```

이유는 입력 voltage를 source에서 빼앗지 않고, 출력 voltage를 load와 무관하게 유지해야 하기 때문이다.

대표 예시는 common-source amplifier, common-emitter amplifier, op-amp closed-loop voltage amplifier이다.

## Transconductance amplifier: V to I

Transconductance amplifier는 입력 전압을 출력 전류로 변환한다.

```text
input  : voltage
output : current
Gm = iout / vin
```

이상적인 transconductance amplifier는 다음 특성을 가진다.

```text
Rin  -> infinity
Rout -> infinity
```

입력은 voltage를 받아야 하므로 input resistance가 커야 하고, 출력은 current source처럼 동작해야 하므로 output resistance가 커야 한다.

MOSFET 자체가 대표적인 transconductance device이다.

```text
id = gm * vgs
```

Differential pair도 differential input voltage를 output current 차이로 바꾸는 transconductance stage로 볼 수 있다.

## Transresistance amplifier: I to V

Transresistance amplifier는 입력 전류를 출력 전압으로 변환한다.

```text
input  : current
output : voltage
Rm = vout / iin
```

이상적인 transresistance amplifier는 다음 특성을 가진다.

```text
Rin  -> 0
Rout -> 0
```

입력 current를 잘 받아들이려면 input node 전압 변화가 작아야 하고, 출력은 voltage source처럼 load를 구동해야 한다.

대표 예시는 photodiode current를 voltage로 바꾸는 transimpedance amplifier이다.

## Current amplifier: I to I

Current amplifier는 입력 전류를 출력 전류로 증폭한다.

```text
input  : current
output : current
Ai = iout / iin
```

이상적인 current amplifier는 다음 특성을 가진다.

```text
Rin  -> 0
Rout -> infinity
```

입력은 current를 받아야 하므로 낮은 input resistance가 좋고, 출력은 current source처럼 동작해야 하므로 높은 output resistance가 좋다.

Current mirror는 가장 기본적인 current transfer/current scaling block이다.

## 네 종류의 amplifier 요약

```text
Voltage amplifier        : V -> V, high Rin, low Rout
Transconductance amp     : V -> I, high Rin, high Rout
Transresistance amp      : I -> V, low Rin, low Rout
Current amplifier        : I -> I, low Rin, high Rout
```

## Loading effect와 실제 gain

Amplifier의 내부 gain이 커도 source resistance와 load resistance 때문에 실제 gain은 줄어들 수 있다.

Voltage amplifier를 예로 들면 입력 쪽에서 voltage division이 생긴다.

```text
vin_amp = vsig * Rin / (Rs + Rin)
```

출력 쪽에서도 load와 output resistance가 voltage division을 만든다.

```text
vload = vout_open * RL / (Rout + RL)
```

따라서 전체 voltage gain은 단순히 amplifier 내부 gain이 아니라 source loading과 load driving까지 포함해서 봐야 한다.

```text
vload / vsig = input attenuation * amplifier gain * output attenuation
```

## 회로별 직관

```text
Common-source amplifier:
  voltage amplifier로 자주 사용한다. 입력 저항은 gate 기준으로 크고, 출력 저항은 비교적 크다.

Source follower:
  voltage buffer이다. voltage gain은 약 1이지만 output resistance가 낮아 load driving에 유리하다.

Common-gate amplifier:
  input resistance가 낮아 current input이나 wideband input stage에 유용하다.

Current mirror:
  current를 복사하거나 scaling한다. 좋은 current source가 되려면 output resistance가 커야 한다.

Differential pair:
  differential voltage를 current 차이로 변환하는 transconductance stage로 볼 수 있다.
```

## 면접 포인트

Amplifier 종류를 말할 때는 gain 식만 말하지 말고, 이상적인 input/output resistance 조건까지 같이 말하는 것이 좋다.

예를 들어 voltage amplifier라면 다음처럼 답한다.

```text
Voltage amplifier는 입력 전압을 출력 전압으로 바꾸는 block이다. 입력 전압을 source에서 손실 없이 받아야 하므로 input resistance가 커야 하고, load에 출력 전압을 유지해야 하므로 output resistance가 작아야 한다.
```
