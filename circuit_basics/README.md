# Circuit Basics

회로설계 면담/면접에서 디지털과 아날로그를 가리지 않고 자주 연결되는 기본 개념을 정리한다. 이 섹션은 RTL 문법이나 특정 analog topology보다 아래 단계의 공통 기반, 즉 MOSFET, CMOS inverter, delay/power/PVT, basic analog blocks, op-amp 기본 개념을 다룬다.

## Structure

```text
circuit_basics/
  concepts/   # microelectronics/CMOS/VLSI/analog 기본 개념
  projects/   # Spectre/Virtuoso 기반 기초 회로 실습
  assets/     # 직접 그린 회로도, VTC, waveform, small-signal 그림
```

## Concepts

1. [Microelectronics Basics](./concepts/01_microelectronics_basics/README.md)
2. [CMOS Inverter and VLSI Basics](./concepts/02_cmos_inverter_vlsi/README.md)
3. [Delay, Power, and PVT](./concepts/03_delay_power_pvt/README.md)
4. [Basic Analog Blocks](./concepts/04_basic_analog_blocks/README.md)
5. [Op-Amp Basics](./concepts/05_opamp_basics/README.md)

## 정리 기준

```text
물리적 의미 → 회로 동작 → 설계 trade-off → 면접에서 설명할 포인트
```

이 섹션의 목표는 소자 물리를 깊게 전개하는 것이 아니라, 회로설계 관점에서 MOS/CMOS/analog 기본 개념을 정확히 연결해서 설명할 수 있게 만드는 것이다.
