# Power Gating

## Power gating의 목적

Power gating은 idle 상태의 block 또는 power domain의 supply를 차단해 static leakage power를 줄이는 기법이다.

```text
active mode: supply on
sleep mode : supply off
```

Clock gating이 dynamic power를 줄이는 기법이라면, power gating은 static power를 줄이는 기법이다.

## Power switch

Power gating에는 sleep transistor 또는 power switch가 사용된다. Power switch는 항상 켜져 있는 power rail과 gated power rail 사이에 위치한다.

```text
VDD ---- power switch ---- virtual VDD ---- power gated domain
```

Sleep signal이 power switch를 제어해 domain의 supply를 켜거나 끈다.

## Power domain

Power domain은 같은 power control을 공유하는 logic 묶음이다. Power gated domain은 off 상태가 될 수 있으므로 주변 always-on domain과의 interface를 신중히 설계해야 한다.

Power domain을 나눌 때 고려할 점은 다음과 같다.

- 어떤 block이 함께 sleep 가능한가
- wake-up latency를 허용할 수 있는가
- state를 보존해야 하는가
- off domain output이 다른 domain에 영향을 주는가

## State loss

Power가 꺼지면 일반 flip-flop의 state는 사라진다. Power-up 이후 reset으로 다시 초기화할 수 있다면 문제가 없지만, sleep 전 state를 유지해야 한다면 retention cell이 필요하다.

## Isolation 필요성

Power gated domain이 off되면 output이 unknown 또는 floating처럼 보일 수 있다. 이 신호가 always-on domain으로 들어가면 X propagation이나 잘못된 동작을 유발할 수 있다.

따라서 off domain output에는 isolation cell을 두어 안전한 clamp value로 묶는다.

## Wake-up sequence

Power gating은 단순히 power switch를 켜고 끄는 문제가 아니다. 일반적인 sequence는 다음과 같다.

```text
sleep entry:
  stop request -> idle 확인 -> isolation enable -> retention save -> power off

wake-up:
  power on -> power stable 대기 -> retention restore -> isolation disable -> clock/reset release
```

정확한 순서는 design과 power intent에 따라 달라진다.

## 비용과 trade-off

Power gating의 비용은 다음과 같다.

- Power switch area
- Isolation/retention cell overhead
- Wake-up latency
- Verification complexity
- Power intent 작성 필요
- In-rush current 관리 필요

## 핵심 정리

- Power gating은 supply를 차단해 static leakage를 줄인다.
- Power gated domain은 off 상태에서 state와 output이 유효하지 않을 수 있다.
- Isolation cell과 retention cell이 함께 필요할 수 있다.
- Power gating은 power sequence와 UPF 검증이 중요하다.
