# 1-5. Voltage and Current Division

Voltage division과 current division은 저항 network를 빠르게 해석하는 기본 도구이다.

## Voltage divider

두 저항이 직렬로 연결되고 입력 전압이 걸리면 출력은 저항 비율로 나뉜다.

```text
Vout = Vin * R2 / (R1 + R2)
```

단, 이 식은 출력 node에 load가 거의 없거나 load resistance가 충분히 클 때 정확하다.

## Loading effect

Voltage divider 출력에 load가 붙으면 `R2`와 load가 병렬이 된다.

```text
R2_eff = R2 || RL
Vout = Vin * R2_eff / (R1 + R2_eff)
```

Load resistance가 작으면 출력 전압이 의도보다 낮아진다. 그래서 voltage signal을 전달할 때는 다음 조건이 유리하다.

```text
source output resistance 낮음
load input resistance 높음
```

## Current divider

병렬 저항에 전류가 들어오면 전류는 conductance에 비례해 나뉜다.

두 저항의 경우:

```text
I1 = Itotal * R2 / (R1 + R2)
I2 = Itotal * R1 / (R1 + R2)
```

작은 저항 쪽으로 더 큰 전류가 흐른다.

## 회로설계 연결

- Resistor feedback op-amp gain은 voltage divider와 virtual short로 해석한다.
- Bias network는 load가 붙으면 bias voltage가 변할 수 있다.
- Source follower나 buffer는 loading effect를 줄이기 위해 사용된다.
- Current mirror branch 전류 분배는 device ratio와 current division 관점으로 볼 수 있다.
