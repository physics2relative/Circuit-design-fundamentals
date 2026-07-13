# Isolation, Level Shifter, and Retention

## Multi-domain special cell

Multi-power domain 또는 multi-voltage domain 설계에서는 일반 logic cell만으로는 안전한 동작을 보장하기 어렵다. Domain의 power 상태와 voltage 차이에 대응하기 위해 special cell이 필요하다.

대표 cell은 다음과 같다.

- Isolation cell
- Level shifter cell
- Retention cell

## Isolation cell

Isolation cell은 power gated domain이 off될 때 그 domain의 output을 안전한 값으로 clamp하는 cell이다.

```text
power gated domain output ---- isolation cell ---- always-on domain input
```

Power off 상태의 output은 X 또는 floating처럼 동작할 수 있으므로, 이를 다른 domain에 그대로 전달하면 잘못된 동작이 생길 수 있다.

## Clamping concept

Isolation은 output을 특정 값으로 고정한다. 이를 clamp라고 한다.

대표 clamp value는 다음과 같다.

```text
clamp 0
clamp 1
latch/hold 형태
```

Clamp value는 receiving logic이 safe state로 동작하도록 정해야 한다. 예를 들어 request signal은 보통 off 상태에서 0으로 clamp하는 것이 자연스럽다.

## Level shifter cell

Level shifter는 서로 다른 voltage domain 사이에서 signal voltage level을 변환하는 cell이다.

```text
low VDD domain ---- level shifter ---- high VDD domain
high VDD domain --- level shifter ---- low VDD domain
```

Low-to-high crossing에서는 low voltage의 1이 high voltage domain에서 충분한 logic high로 인식되지 않을 수 있다. High-to-low crossing에서는 device overstress나 reliability 문제가 생길 수 있다.

## Retention cell

Retention cell은 power gated domain이 off될 때 중요한 state를 보존하기 위한 cell이다. 일반 flip-flop은 power off 시 state를 잃지만, retention flop은 always-on retention supply를 사용해 state를 저장한다.

Power가 다시 켜지면 저장된 state를 restore해 이전 상태에서 동작을 이어갈 수 있다.

## 왜 retention이 필요한가

모든 state를 reset으로 초기화해도 되는 block이라면 retention이 필요 없을 수 있다. 하지만 sleep wake-up 이후 context를 유지해야 하는 block은 retention이 필요하다.

예시는 다음과 같다.

- CPU context register
- configuration register
- protocol state
- wake-up 이후 복구 비용이 큰 state

## Master/slave alive retention flop

Retention flop은 구현 방식에 따라 master 또는 slave latch 중 일부를 always-on supply에 연결해 state를 보존할 수 있다. 핵심은 main domain power가 꺼져도 state를 저장하는 작은 storage element가 alive 상태로 남는다는 점이다.

구현 세부는 library cell에 따라 다르지만, 설계 관점에서는 save/restore control과 retention supply가 중요하다.

## 배치 위치와 제어

Special cell은 power intent에 따라 삽입된다. 일반적으로 다음을 고려한다.

- Isolation cell은 off domain output 경계에 둔다.
- Level shifter는 voltage domain crossing 경계에 둔다.
- Retention cell은 state 보존이 필요한 register에 적용한다.
- Control signal은 always-on domain에서 안전하게 생성되어야 한다.

## 핵심 정리

- Isolation cell은 off domain output을 safe value로 clamp한다.
- Level shifter는 서로 다른 voltage domain 사이의 logic level을 변환한다.
- Retention cell은 power gating 중에도 중요한 state를 보존한다.
- Clamp value와 save/restore sequence는 functional correctness와 직접 연결된다.
