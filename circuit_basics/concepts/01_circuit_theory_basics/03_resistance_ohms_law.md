# 1-3. Resistance and Ohm's Law

저항은 전압과 전류의 비례 관계를 만드는 가장 기본적인 passive element이다.

## Ohm's law

```text
V = I * R
```

저항이 클수록 같은 전압에서 전류가 작고, 같은 전류에서 전압 강하가 크다.

## Series resistance

직렬 저항은 더해진다.

```text
Req = R1 + R2 + ...
```

같은 전류가 모든 저항을 지나며, 각 저항에 걸리는 전압은 저항값에 비례한다.

## Parallel resistance

병렬 저항은 conductance가 더해진다.

```text
1/Req = 1/R1 + 1/R2 + ...
```

같은 전압이 모든 저항에 걸리며, 각 branch 전류는 저항값에 반비례한다.

## Conductance

Conductance는 저항의 역수이다.

```text
G = 1 / R
I = G * V
```

병렬 회로에서는 conductance 표현이 직관적이다.

## 회로설계 연결

- 저항은 bias current를 전압으로 바꾸거나, 전압을 current로 바꾼다.
- Resistor ratio는 absolute resistor 값보다 공정 변화에 덜 민감하다.
- MOSFET의 triode region은 voltage-controlled resistor처럼 동작할 수 있다.
- 출력 저항과 입력 저항은 loading effect와 gain에 직접 연결된다.
