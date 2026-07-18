# 1-1. Voltage, Current, and Power

전압, 전류, 전력은 모든 회로 해석의 기본 변수이다.

## Voltage

전압은 두 지점 사이의 electric potential difference이다.

```text
Vab = Va - Vb
```

전압은 항상 두 node 사이에서 정의된다. `5 V`라고 말할 때도 실제로는 어떤 기준 node, 보통 ground에 대한 전압이다.

## Current

전류는 단위 시간당 흐르는 전하량이다.

```text
I = dQ / dt
```

회로 해석에서는 current direction을 먼저 가정하고 식을 세운다. 계산 결과가 음수이면 실제 전류 방향이 가정과 반대라는 뜻이다.

## Power

전력은 단위 시간당 에너지 전달량이다.

```text
P = V * I
```

Passive sign convention에서는 전류가 소자의 양전압 단자로 들어가면 소자가 전력을 흡수한다고 본다.

```text
P > 0 : power absorbed
P < 0 : power delivered
```

## 회로설계 관점

- 전압은 node potential 차이이다.
- 전류 방향은 해석자가 정한 reference direction이다.
- power 부호는 source와 load를 구분하는 데 중요하다.
- Analog 회로에서 bias current와 supply voltage는 power budget으로 바로 연결된다.
