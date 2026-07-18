# 3-4. Power in CMOS Logic

CMOS logic의 power는 크게 dynamic power, short-circuit power, static/leakage power로 나누어 볼 수 있다.

## Dynamic switching power

Dynamic power는 load capacitance를 충전/방전할 때 소모되는 전력이다.

```text
Pdynamic ≈ alpha * CL * VDD^2 * f
```

- alpha: switching activity
- CL: load capacitance
- VDD: supply voltage
- f: clock frequency

VDD가 제곱으로 들어가기 때문에 voltage scaling은 power 절감에 매우 효과적이다.

## Short-circuit power

Input transition 중 NMOS와 PMOS가 동시에 켜지면 VDD에서 GND로 직접 전류가 흐른다. 이 전류에 의한 power가 short-circuit power이다.

Inverter 기준으로 입력이 중간 전압을 지나는 동안 PMOS와 NMOS가 모두 on 조건을 만족할 수 있다. 이때 두 transistor는 각각 triode 또는 saturation 영역을 지나며 전류 path를 만든다.

Input transition이 느릴수록 두 소자가 동시에 켜지는 시간이 길어져 short-circuit power가 증가한다.

## Static / leakage power

Switching하지 않는 상태에서도 leakage current가 흐르면 static power가 소모된다.

```text
Pstatic ≈ VDD * Ileakage
```

Leakage에는 subthreshold leakage, gate leakage, junction leakage 등이 포함된다.

## 설계 관점

- Clock gating은 alpha를 줄여 dynamic power를 줄인다.
- DVFS는 VDD와 f를 함께 조절해 power/performance를 맞춘다.
- Power gating은 sleep 상태에서 leakage를 줄인다.
- Multi-VTH는 timing critical path와 non-critical path의 leakage/speed trade-off를 조절한다.
