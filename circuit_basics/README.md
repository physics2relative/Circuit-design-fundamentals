# Circuit Basics

회로설계 면담/면접에서 디지털과 아날로그를 가리지 않고 공통으로 필요한 **회로 해석 기본과 CMOS/VLSI 관점**을 정리한다. 반도체 소자 물리는 `semiconductor_devices/`, analog amplifier/op-amp block은 `analog/`에서 다룬다.

## Structure

```text
circuit_basics/
  concepts/   # circuit theory, CMOS inverter, delay/power/PVT
  projects/   # 기초 회로 실습 placeholder
  assets/     # 직접 그린 회로도, VTC, waveform, small-signal 그림
```

## Concepts

1. [Circuit Theory Basics](./concepts/01_circuit_theory_basics/README.md)
2. [CMOS Inverter and VLSI Basics](./concepts/02_cmos_inverter_vlsi/README.md)
3. [Delay, Power, and PVT](./concepts/03_delay_power_pvt/README.md)

## 관련 섹션

- [Semiconductor Devices](../semiconductor_devices/README.md): carrier, PN junction, MOS capacitor, MOSFET, BJT, device non-ideality
- [Analog Design](../analog/README.md): amplifier, current mirror, differential pair, feedback, op-amp
- [Digital Design](../digital/README.md): RTL, timing, CDC, FIFO, low power, verification

## 정리 기준

```text
회로이론 기본 → CMOS gate 동작 → delay/power/PVT trade-off → 면접 답변 포인트
```
