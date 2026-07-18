# 1-4. KCL and KVL

KCL과 KVL은 회로 해석의 기본 법칙이다. 복잡한 회로도 결국 node current와 loop voltage 관계로 해석한다.

## KCL

Kirchhoff's Current Law는 한 node로 들어오고 나가는 전류의 합이 0이라는 법칙이다.

```text
sum of currents at a node = 0
```

이는 전하가 node에 무한히 쌓일 수 없다는 의미이다.

## KVL

Kirchhoff's Voltage Law는 닫힌 loop를 따라 전압 변화의 합이 0이라는 법칙이다.

```text
sum of voltages around a loop = 0
```

이는 에너지 보존 관점에서 이해할 수 있다.

## Nodal analysis

Analog 회로에서는 nodal analysis가 매우 자주 쓰인다. 각 node에서 KCL을 세우고 unknown node voltage를 구한다.

예를 들어 저항 두 개가 연결된 node에서는 다음처럼 쓸 수 있다.

```text
(Vx - Va)/R1 + (Vx - Vb)/R2 = 0
```

## 회로설계 연결

- Current mirror node의 전류 관계는 KCL로 본다.
- Op-amp feedback 회로의 입력 node도 KCL로 해석한다.
- Small-signal equivalent circuit의 gain 계산도 대부분 KCL/KVL에서 시작한다.
- Capacitor가 있는 회로에서는 KCL에 `i = C dv/dt`가 들어가 transient equation이 된다.
