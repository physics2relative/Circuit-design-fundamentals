# SK hynix 산학장학생/석사 진학 면접 대비

SK hynix 산학장학생 또는 석사 진학 면접에서 직무지식과 반도체 기초지식을 본다면, 특정 회로 하나를 깊게 외우기보다 **반도체 회사에서 공통 기본기로 보는 내용**을 우선순위화해서 정리하는 것이 좋다.

SK hynix는 메모리 반도체 중심 회사이므로, 회로설계 지원자라도 **소자, 메모리, CMOS/VLSI, 공정, test/reliability** 기본을 함께 준비하는 것이 중요하다.

## 전체 우선순위

```text
1. 반도체 소자 기본
2. 메모리 반도체 기본
3. CMOS / VLSI 기본
4. 반도체 공정 기본
5. Analog 회로 기본
6. Digital / RTL 기본
7. Test / Package / Reliability 기본
```

---

## 1. 반도체 소자 기본

가장 먼저 준비해야 하는 영역이다. MOSFET, diode, PN junction, carrier transport를 설명할 수 있어야 이후 메모리, CMOS, analog 회로 질문에 연결할 수 있다.

### 핵심 내용

```text
carrier: electron / hole
doping: n-type / p-type
drift current / diffusion current
mobility
PN junction
depletion region
built-in potential
diode I-V
MOS capacitor
accumulation / depletion / inversion
threshold voltage
MOSFET operating region
short-channel effect 기본
PVT variation과 소자 파라미터 변화
```

### 예상 질문

- PN junction에서 depletion region은 왜 생기는가?
- Drift current와 diffusion current의 차이는 무엇인가?
- Diode I-V가 exponential 형태를 갖는 이유는 무엇인가?
- MOS capacitor에서 accumulation, depletion, inversion은 무엇인가?
- Threshold voltage는 어떤 의미인가?
- NMOS와 PMOS가 켜지는 조건은 무엇인가?
- MOSFET의 cutoff, triode, saturation region을 설명할 수 있는가?
- Mobility, VTH, Cox가 drain current에 어떤 영향을 주는가?
- 공정이 바뀌면 소자 파라미터가 어떻게 바뀌고 회로 성능에 어떤 영향을 주는가?

### 레포 내 관련 섹션

```text
circuit_basics/concepts/02_microelectronics_basics/
circuit_basics/concepts/04_delay_power_pvt/
```

---

## 2. 메모리 반도체 기본

SK hynix 면접에서는 메모리 반도체 기본을 별도로 준비하는 것이 좋다. 깊은 DRAM 설계까지는 아니어도, cell 구조와 read/write 동작, peripheral circuit의 역할은 설명할 수 있어야 한다.

### 핵심 내용

```text
memory hierarchy
volatile / non-volatile memory
SRAM 6T cell
DRAM 1T1C cell
bitline / wordline
precharge
sense amplifier
row decoder / column decoder
read / write 동작
DRAM refresh
retention time
read disturb / write disturb
memory array와 peripheral circuit
ECC 기본
```

### 예상 질문

- SRAM과 DRAM의 차이는 무엇인가?
- SRAM 6T cell은 어떤 transistor로 구성되는가?
- DRAM 1T1C cell은 데이터를 어떻게 저장하는가?
- DRAM은 왜 refresh가 필요한가?
- DRAM read가 destructive read라고 하는 이유는 무엇인가?
- Bitline precharge는 왜 필요한가?
- Sense amplifier의 역할은 무엇인가?
- Retention time은 무엇에 의해 결정되는가?
- Row decoder와 column decoder는 어떤 역할을 하는가?
- 메모리 array와 peripheral circuit은 왜 함께 필요한가?

### 추가 권장 섹션

추후 별도 최상위 섹션으로 분리하는 것이 좋다.

```text
memory_semiconductor/
  concepts/
    01_memory_overview/
    02_sram_basics/
    03_dram_basics/
    04_sense_amplifier/
    05_memory_peripheral_circuits/
    06_memory_reliability/
    07_memory_interview_checklist/
```

---

## 3. CMOS / VLSI 기본

CMOS inverter와 digital VLSI 기본은 회로설계와 반도체 기초지식 사이를 연결한다.

### 핵심 내용

```text
CMOS inverter 동작
VTC
switching threshold
noise margin
propagation delay
load capacitance
fanout
dynamic power
short-circuit power
static/leakage power
PVT corner
process scaling 영향
```

### 예상 질문

- CMOS inverter의 pull-up/pull-down 동작을 설명할 수 있는가?
- VTC는 무엇인가?
- Noise margin은 왜 중요한가?
- Propagation delay는 왜 생기는가?
- Fanout이 커지면 왜 delay가 증가하는가?
- Dynamic power 식 `P = αCV²f`의 각 항은 무엇인가?
- Short-circuit current는 언제 흐르는가?
- Static power와 leakage의 관계는 무엇인가?
- PVT variation은 timing과 power에 어떤 영향을 주는가?

### 레포 내 관련 섹션

```text
circuit_basics/concepts/03_cmos_inverter_vlsi/
circuit_basics/concepts/04_delay_power_pvt/
```

---

## 4. 반도체 공정 기본

회로설계 지원자라도 공정 기본은 알고 있어야 한다. 공정 변화가 소자 파라미터와 회로 성능으로 이어지는 인과관계를 설명할 수 있으면 좋다.

### 핵심 내용

```text
wafer
oxidation
photolithography
etch
deposition
ion implantation
diffusion
CMP
metal interconnect
FEOL / BEOL
process variation
yield
defect
```

### 예상 질문

- Photolithography는 어떤 공정인가?
- Etch와 deposition의 차이는 무엇인가?
- Ion implantation은 왜 하는가?
- FEOL과 BEOL의 차이는 무엇인가?
- Metal interconnect가 회로 delay에 영향을 주는 이유는 무엇인가?
- 공정 variation이 VTH, mobility, capacitance, leakage에 어떤 영향을 주는가?
- 수율이란 무엇인가?
- Defect density가 수율에 어떤 영향을 주는가?

### 답변 핵심 인과관계

```text
공정 변화
→ 소자 파라미터 변화
→ current / capacitance / resistance / leakage / matching 변화
→ timing / power / gain / bandwidth / margin 변화
→ 새 PDK와 corner 기준으로 재검증 필요
```

---

## 5. Analog 회로 기본

회로설계 직무지식으로 자주 연결된다. 특히 current source, current mirror, differential pair, op-amp, feedback은 기본으로 준비하는 것이 좋다.

### 핵심 내용

```text
ideal voltage/current source
input resistance / output resistance
voltage amplifier / transconductance amplifier / transresistance amplifier / current amplifier
common-source amplifier
source follower
common-gate amplifier
current mirror
cascode mirror
BMR / BGR 개요
differential pair
CMRR
frequency response
pole / zero
Miller effect
negative feedback
phase margin
op-amp metrics
```

### 예상 질문

- Ideal voltage source와 current source의 차이는 무엇인가?
- Input resistance와 output resistance가 왜 중요한가?
- Common-source amplifier gain은 어떻게 근사되는가?
- Source follower가 buffer로 쓰이는 이유는 무엇인가?
- Current mirror의 동작 원리는 무엇인가?
- Current mirror의 output resistance가 왜 중요한가?
- Cascode mirror는 어떤 장단점이 있는가?
- BMR은 왜 VDD에 덜 민감한가?
- BGR은 어떻게 temperature compensation을 하는가?
- Differential pair는 어떻게 동작하는가?
- CMRR은 무엇인가?
- Phase margin이 낮으면 어떤 문제가 생기는가?

### 레포 내 관련 섹션

```text
circuit_basics/concepts/01_circuit_theory_basics/
analog/concepts/
```

---

## 6. Digital / RTL 기본

디지털 설계 직무가 아니어도 회로설계/반도체 기본으로 나올 수 있다. 다만 SK hynix 산학/석사 면접에서 회로 전반을 본다면, 디지털 심화보다 기본 timing과 sequential logic 위주로 준비하는 것이 효율적이다.

### 핵심 내용

```text
combinational logic
sequential logic
latch / flip-flop
setup time / hold time
clock skew / jitter
FSM
CDC / metastability
synchronizer
FIFO
clock gating
STA 기본
```

### 예상 질문

- Combinational logic과 sequential logic의 차이는 무엇인가?
- Latch와 flip-flop의 차이는 무엇인가?
- Setup time과 hold time은 무엇인가?
- Metastability는 언제 발생하는가?
- 2FF synchronizer는 왜 사용하는가?
- FIFO는 어떤 상황에서 필요한가?
- Clock gating은 dynamic power를 어떻게 줄이는가?
- STA는 simulation과 어떻게 다른가?

### 레포 내 관련 섹션

```text
digital/concepts/
digital/projects/cdc_behavioral_models/
digital/projects/fifo_design_models/
digital/projects/clock_gating_icg_experiment/
```

---

## 7. Test / Package / Reliability 기본

메모리 회사에서는 제품 검증, 품질, 수율, 신뢰성 관점도 중요하다.

### 핵심 내용

```text
wafer test
package test
burn-in
yield
binning
failure analysis
retention fail
disturb fail
soft error
ECC
thermal reliability
ESD
latch-up
```

### 예상 질문

- Wafer test와 package test는 왜 나누는가?
- Burn-in test는 왜 하는가?
- Yield가 낮다는 것은 무슨 의미인가?
- Binning은 무엇인가?
- Failure analysis는 어떤 목적을 갖는가?
- 메모리에서 retention fail은 무엇인가?
- Disturb fail은 무엇인가?
- Soft error와 hard error의 차이는 무엇인가?
- ECC는 왜 필요한가?
- ESD와 latch-up은 왜 문제가 되는가?

---

## 추천 준비 순서

시간이 제한되어 있다면 다음 순서로 준비한다.

```text
1. 소자 기본: PN junction, MOS capacitor, MOSFET, VTH, PVT
2. 메모리 기본: SRAM/DRAM, bitline/wordline, sense amp, refresh
3. CMOS/VLSI: inverter, delay, power, noise margin
4. 공정 기본: lithography, etch, deposition, ion implantation, FEOL/BEOL, yield
5. Analog 기본: current mirror, differential pair, op-amp, feedback
6. Digital 기본: FF, setup/hold, CDC, FIFO, clock gating
7. Test/reliability: wafer/package test, burn-in, retention, ECC, ESD
```

## 답변 방식

면접 답변은 단순 정의보다 인과관계를 중심으로 말하는 것이 좋다.

```text
정의
→ 물리적/회로적 원리
→ 어떤 파라미터에 영향
→ 실제 회로/메모리/공정에서 왜 중요한지
```

예를 들어 DRAM refresh 질문에는 다음처럼 답한다.

```text
DRAM은 capacitor에 charge를 저장해서 데이터를 표현한다. 하지만 capacitor charge는 junction leakage나 subthreshold leakage 등으로 시간이 지나며 줄어든다. 그래서 저장된 데이터를 잃기 전에 주기적으로 읽고 다시 써 주는 refresh가 필요하다. Retention time은 이 charge가 유효한 logic level로 유지되는 시간과 관련된다.
```

예를 들어 PVT 질문에는 다음처럼 답한다.

```text
PVT는 process, voltage, temperature 변화이다. Process가 바뀌면 VTH, mobility, Cox, Leff, capacitance, wire RC 등이 바뀌고, voltage는 overdrive와 dynamic power에 직접 영향을 준다. Temperature는 mobility, VTH, leakage를 바꾼다. 이 변화가 current drive, delay, leakage, margin을 바꾸므로 timing/power/corner 분석이 필요하다.
```
