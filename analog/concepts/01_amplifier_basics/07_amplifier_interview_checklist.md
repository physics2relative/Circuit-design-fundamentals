# 1-7. Amplifier Interview Checklist

## Port model

- Amplifier를 two-port network로 본다는 것은 무슨 의미인가?
- Input resistance가 크면 source loading이 왜 줄어드는가?
- Output resistance가 낮으면 voltage load driving에 왜 유리한가?
- Current source로 동작하려면 output resistance가 왜 커야 하는가?

## Amplifier type

- Voltage amplifier, transconductance amplifier, transresistance amplifier, current amplifier를 구분할 수 있는가?
- 각 amplifier type의 이상적인 `Rin`, `Rout` 조건은 무엇인가?
- MOSFET을 transconductance device라고 부르는 이유는 무엇인가?

## Common-source

- Common-source amplifier가 inverting인 이유는 무엇인가?
- Gain이 `-gm * Rout` 형태로 나오는 이유는 무엇인가?
- Saturation 조건이 깨지면 어떤 문제가 생기는가?

## Source follower / common-gate

- Source follower가 buffer로 쓰이는 이유는 무엇인가?
- Source follower gain이 1보다 작은 이유는 무엇인가?
- Common-gate input resistance가 낮은 이유는 무엇인가?
- Common-gate가 wideband stage로 쓰일 수 있는 이유는 무엇인가?

## Simulation

- DC operating point에서 어떤 값을 확인해야 하는가?
- AC simulation으로 gain과 bandwidth를 어떻게 확인하는가?
- Transient simulation으로 distortion과 output swing을 어떻게 확인하는가?
