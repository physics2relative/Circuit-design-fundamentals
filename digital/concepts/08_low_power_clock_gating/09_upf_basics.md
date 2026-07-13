# UPF Basics

## UPF의 목적

UPF(Unified Power Format)는 power intent를 RTL과 분리해서 표현하는 형식이다. RTL은 기능 동작을 설명하고, UPF는 power domain, power switch, isolation, retention, level shifter, power state 등을 설명한다.

UPF가 필요한 이유는 다음과 같다.

- RTL에 power switch나 special cell을 직접 넣지 않고 power intent를 표현한다.
- Simulation, synthesis, implementation, verification tool이 같은 power intent를 공유한다.
- Multi-power domain 설계의 power state와 domain crossing rule을 명확히 한다.

## Power domain 정의

Power domain은 같은 power control을 공유하는 logic 묶음이다. UPF에서는 domain을 만들고 어떤 instance가 그 domain에 속하는지 정의한다.

```tcl
create_power_domain PD_CORE -elements {u_core}
```

## Supply net과 supply set

Power domain이 어떤 supply를 사용하는지 정의한다.

```tcl
create_supply_net VDD_CORE
create_supply_net VSS
```

Tool과 UPF version에 따라 supply set 관련 문법은 달라질 수 있다. 핵심은 각 domain의 power/ground supply를 명확히 연결하는 것이다.

## create_power_switch

`create_power_switch`는 power gated domain의 supply를 켜고 끄는 power switch를 정의한다.

```tcl
create_power_switch SW_CORE \
  -domain PD_CORE \
  -input_supply_port {VIN VDD} \
  -output_supply_port {VOUT VDD_CORE} \
  -control_port {SLEEP sleep_en}
```

의미는 sleep control에 따라 always-on supply와 gated supply 사이의 switch를 제어한다는 것이다.

## set_isolation

`set_isolation`은 power gated domain output이 off 상태일 때 어떤 값으로 clamp될지 정의한다.

```tcl
set_isolation ISO_CORE \
  -domain PD_CORE \
  -clamp_value 0 \
  -applies_to outputs
```

## set_isolation_control

`set_isolation_control`은 isolation cell을 언제 enable할지 제어 signal을 정의한다.

```tcl
set_isolation_control ISO_CORE \
  -domain PD_CORE \
  -isolation_signal iso_en \
  -isolation_sense high
```

Isolation enable은 보통 domain power-off 전에 먼저 assert되어야 한다.

## set_level_shifter

`set_level_shifter`는 voltage domain crossing에 level shifter를 삽입해야 하는 rule을 정의한다.

```tcl
set_level_shifter LS_CORE \
  -domain PD_CORE \
  -applies_to outputs
```

Level shifter는 voltage 차이가 있는 crossing에서 필요하며, 위치는 설계 style과 tool flow에 따라 달라질 수 있다.

## set_retention

`set_retention`은 power gating 중 state를 보존할 register를 정의한다.

```tcl
set_retention RET_CORE \
  -domain PD_CORE \
  -elements {u_core/state_reg}
```

## set_retention_control

`set_retention_control`은 retention save/restore control signal을 정의한다.

```tcl
set_retention_control RET_CORE \
  -domain PD_CORE \
  -save_signal {save high} \
  -restore_signal {restore high}
```

정확한 save/restore sequence는 library cell과 design power sequence에 맞아야 한다.

## add_port_state

`add_port_state`는 supply port가 가질 수 있는 voltage state를 정의한다.

```tcl
add_port_state VDD_CORE -state {ON 1.0}
add_port_state VDD_CORE -state {OFF off}
```

## create_pst와 add_pst_state

PST(power state table)는 여러 supply/domain의 valid power state 조합을 정의한다.

```tcl
create_pst chip_pst -supplies {VDD_CORE VDD_AON}
add_pst_state ACTIVE -pst chip_pst -state {ON ON}
add_pst_state SLEEP  -pst chip_pst -state {OFF ON}
```

PST는 어떤 domain 조합이 합법적인지 tool에 알려준다.

## UPF 작성 흐름

주어진 power intent에 대해 UPF를 작성할 때는 다음 순서로 생각하면 된다.

```text
1. Power domain을 나눈다.
2. 각 domain의 supply를 정의한다.
3. Power switch가 필요한 domain을 정의한다.
4. Off domain output에 isolation을 정의한다.
5. Voltage crossing에 level shifter를 정의한다.
6. 보존할 state에 retention을 정의한다.
7. 각 supply의 port state와 power state table을 정의한다.
8. Power-aware simulation과 implementation report로 의도대로 적용됐는지 확인한다.
```

## 주의점

UPF command syntax는 tool, UPF version, library support에 따라 달라질 수 있다. 따라서 문법 자체를 외우기보다 다음 질문에 답할 수 있어야 한다.

- 어떤 domain이 off될 수 있는가
- off될 때 output은 어떻게 처리하는가
- state는 reset할 것인가 retention할 것인가
- voltage crossing은 어디에 있는가
- 합법적인 power state 조합은 무엇인가

## 핵심 정리

- UPF는 power intent를 RTL과 분리해서 표현한다.
- Power domain, power switch, isolation, level shifter, retention, PST를 정의한다.
- UPF는 syntax보다 power intent를 정확히 모델링하는 것이 중요하다.
- UPF 적용 후에는 power-aware simulation과 implementation report로 검증해야 한다.
