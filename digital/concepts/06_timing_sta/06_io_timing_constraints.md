# Input/Output Timing Constraints

## Internal path와 IO path

Register-to-register path는 chip 내부의 launch FF와 capture FF 사이를 분석한다. 반면 IO timing은 chip 밖의 device와 chip 내부 register 사이의 timing을 다룬다.

```text
external device ---- input port ---- internal FF
internal FF ---- output port ---- external device
```

STA tool은 chip 내부 delay는 알 수 있지만, 외부 device의 clock-to-Q, setup/hold, board delay는 자동으로 알 수 없다. 그래서 IO timing constraint가 필요하다.

## Input delay constraint

Input delay는 외부 device가 data를 내보낸 뒤 chip input port까지 도착하는 데 걸리는 시간을 STA에 알려주는 constraint이다.

개념적으로 input path는 다음을 포함한다.

- External launch clock 기준
- External device의 clock-to-Q
- Board/package delay
- Chip input port에서 internal capture FF까지의 delay

Input delay를 제대로 주지 않으면 STA tool은 input data가 언제 들어오는지 알 수 없기 때문에 실제 board 환경을 반영한 timing 분석을 할 수 없다.

## Output delay constraint

Output delay는 chip output data가 외부 device에 capture되기 위해 필요한 외부 timing requirement를 STA에 알려주는 constraint이다.

개념적으로 output path는 다음을 포함한다.

- Internal launch FF
- Chip output port까지의 delay
- Board/package delay
- External device의 setup/hold requirement

Output delay는 외부 device가 data를 언제까지 필요로 하는지 표현하는 constraint이다.

## System-synchronous interface

System-synchronous interface는 source와 destination이 같은 기준 clock을 공유하는 구조이다. Board delay와 clock distribution 차이를 고려해야 한다.

```text
shared clock -> device A
shared clock -> device B
```

Clock이 같더라도 실제 도착 시간은 다를 수 있으므로 skew와 board delay를 constraint에 반영해야 한다.

## Source-synchronous interface

Source-synchronous interface는 data와 함께 clock 또는 strobe를 같이 보내는 구조이다.

```text
source device ---- data ---- destination device
source device ---- strobe --- destination device
```

고속 interface에서는 source-synchronous 구조가 자주 사용된다. 이 경우 data와 strobe의 상대 timing, skew, board matching이 중요하다.

## 핵심 정리

- IO timing은 chip 내부뿐 아니라 외부 device와 board delay를 함께 고려한다.
- Input delay는 외부에서 chip input까지 data가 언제 도착하는지 알려준다.
- Output delay는 chip output이 외부 device requirement를 만족해야 하는 조건을 알려준다.
- IO constraint가 없으면 chip 밖 timing은 STA에 제대로 반영되지 않는다.
