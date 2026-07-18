# 1-9. Circuit Theory Interview Checklist

## Voltage / current / power

- 전압은 절대값인가, 두 node 사이의 차이인가?
- 전류 방향을 임의로 잡았을 때 계산 결과가 음수이면 무슨 뜻인가?
- Passive sign convention에서 power 부호는 어떻게 해석하는가?

## Source

- Ideal voltage source와 ideal current source의 차이는 무엇인가?
- 실제 voltage source의 output resistance는 어느 쪽이 이상적인가?
- 실제 current source의 output resistance는 어느 쪽이 이상적인가?
- Current mirror가 current source처럼 동작하려면 왜 output resistance가 커야 하는가?

## Resistance / KCL / KVL

- 직렬 저항과 병렬 저항의 equivalent resistance를 설명할 수 있는가?
- KCL과 KVL의 물리적 의미는 무엇인가?
- Nodal analysis는 어떤 법칙을 기반으로 하는가?

## Divider / loading

- Voltage divider 식을 유도할 수 있는가?
- Voltage divider에 load가 붙으면 왜 출력이 바뀌는가?
- High input impedance와 low output impedance가 왜 중요한가?
- Current divider에서 작은 저항 branch에 더 큰 전류가 흐르는 이유는 무엇인가?

## Equivalent circuit

- Thevenin equivalent와 Norton equivalent는 무엇인가?
- `Vth`, `Rth`, `In` 사이의 관계를 설명할 수 있는가?
- 복잡한 bias network를 Thevenin equivalent로 바꾸면 무엇이 좋은가?

## RC / frequency

- Capacitor current `i = C dv/dt`의 의미는 무엇인가?
- RC time constant `τ = RC`는 transient에서 무엇을 의미하는가?
- 1차 RC low-pass의 pole frequency는 무엇인가?
- Capacitor impedance는 주파수가 올라가면 어떻게 변하는가?
- RC delay와 CMOS gate delay는 어떻게 연결되는가?
