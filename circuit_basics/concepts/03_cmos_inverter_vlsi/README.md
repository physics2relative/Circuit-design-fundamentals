# 3. CMOS Inverter and VLSI Basics

CMOS inverter는 digital VLSI의 가장 기본적인 gate이다. MOSFET의 on/off 동작, noise margin, propagation delay, dynamic power, short-circuit power를 한 번에 설명할 수 있는 기준 회로이다.

## 목차

1. [CMOS Inverter Operation](./01_cmos_inverter_operation.md)
2. [VTC and Noise Margin](./02_vtc_noise_margin.md)
3. [Propagation Delay and Load Capacitance](./03_delay_load_capacitance.md)
4. [Power in CMOS Logic](./04_cmos_power.md)
5. [Sizing and Fanout](./05_sizing_fanout.md)
6. [Interview Checklist](./06_cmos_vlsi_interview_checklist.md)

## 핵심 관점

- CMOS logic은 steady state에서 이상적으로 DC path가 없다.
- switching 중에는 load capacitance 충방전 때문에 dynamic power가 소모된다.
- input transition 중 NMOS와 PMOS가 동시에 켜지면 short-circuit current가 흐른다.
- PMOS mobility가 낮기 때문에 같은 drive strength를 위해 PMOS width를 크게 잡는 경우가 많다.
