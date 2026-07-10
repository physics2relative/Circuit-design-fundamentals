# Pulse and Toggle Synchronizer

## Pulse crossing 문제

Source domain의 1-cycle pulse는 source clock 기준 폭을 가진다.

```text
src_pulse: ___|‾|________
```

Destination clock이 더 느리거나 phase가 맞지 않으면 destination은 이 pulse를 sampling하지 못할 수 있다.

```text
src_pulse: ___|‾|________
clk_dst:   ______↑_______↑
```

따라서 짧은 pulse를 CDC 경계에 그대로 넘기는 것은 안전하지 않다. Pulse를 destination이 볼 수 있는 level 또는 event state로 바꿔야 한다.

## Toggle synchronizer의 기본 아이디어

Toggle synchronizer는 source pulse를 직접 넘기지 않고, event가 발생할 때마다 source-domain toggle state를 반전시킨다.

```text
if (src_pulse)
    src_toggle <= ~src_toggle;
```

`src_toggle`은 짧은 pulse가 아니라 다음 event 전까지 유지되는 level이다.

```text
src_pulse:  ___|‾|_____________________|‾|____
src_toggle: ____‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾_______
```

## 구조

```text
clk_src domain                         clk_dst domain
--------------                         --------------
src_pulse -> [toggle FF] ----CDC----> [FF1] -> [FF2] -> [FF3]
                                                   |       |
                                                   +--XOR--+--> dst_pulse
```

Destination domain에서는 `src_toggle`을 synchronizer chain으로 받은 뒤, 현재 값과 이전 cycle 값을 XOR해서 pulse를 복원한다.

```text
dst_sync_2 = 현재 동기화된 toggle 값
dst_sync_3 = 이전 cycle의 toggle 값

dst_pulse = dst_sync_2 ^ dst_sync_3
```

동작 예는 다음과 같다.

```text
cycle:       0   1   2   3   4
FF2:         0   0   1   1   1
FF3:         0   0   0   1   1
FF2 ^ FF3:   0   0   1   0   0
```

## Toggle synchronizer의 장점

```text
- source pulse가 짧아도 event 정보가 toggle level로 유지된다.
- destination은 pulse 자체가 아니라 toggle 변화만 보면 된다.
- rising/falling 변화 모두 XOR로 event pulse로 복원할 수 있다.
```

## 한계

Source event가 너무 빠르게 두 번 발생하면 toggle이 다시 원래 값으로 돌아올 수 있다.

```text
event1: toggle 0 -> 1
event2: toggle 1 -> 0
```

Destination이 중간의 `1` 상태를 보지 못하면 변화가 없었던 것처럼 보일 수 있다. 따라서 toggle synchronizer는 low-rate event 전달에 적합하다. Event loss를 반드시 막아야 하거나 back-pressure가 필요하면 request/ack handshake를 사용한다.
