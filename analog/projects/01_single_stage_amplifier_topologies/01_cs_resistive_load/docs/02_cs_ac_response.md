# 02. 저항 부하 Common-Source의 AC 응답

## 1. 실습 목표

앞서 설정한 DC 동작점을 유지한 상태에서 저항 부하 CS의 small-signal gain, phase와 부하 커패시턴스에 따른 bandwidth 변화를 확인한다.

- `VDD=1.1 V`
- `RD=5.6 kΩ`
- `VIN_BIAS=0.714 V`
- `ID≈98.21 µA`
- 입력 AC magnitude `1`
- AC sweep: `1 Hz~10 GHz`, decade당 100 point
- `CL={10 fF, 100 fF, 1 pF}`

## 2. Testbench

`cdf_analog_tb/tb_p01_cs_basic` schematic을 OA API로 복제하여 다음 cell을 생성하였다.

```text
cdf_analog_tb/tb_p01_cs_ac/schematic
```

회로 연결과 net label은 기본 TB와 동일하게 유지하고, `VOUT–GND` 사이에 `CLOAD=CL`인 `analogLib/cap`을 추가하였다. 입력 source는 `vdc=VIN_BIAS`, `acm=1`로 설정되어 있다. Spectre 실행 시 `VIN_BIAS=0.714 V`와 `CL`을 조건별로 지정하였다.

AC magnitude `1`은 실제 입력을 1 V 흔드는 large-signal 조건이 아니다. DC 동작점 주변에서 선형화된 small-signal 회로의 정규화 입력이므로 `VOUT/VIN`을 바로 gain으로 읽기 위한 설정이다.

## 3. Operating point

`CL`은 DC에서 open circuit이므로 세 조건의 DC 동작점은 동일하다.

| 항목 | 결과 |
|---|---:|
| VIN_BIAS | 0.714 V |
| VOUT | 0.5500 V |
| ID | 98.21 µA |
| VTH | 0.5061 V |
| VOV | 0.2079 V |
| VDSAT | 0.1749 V |
| gm | 528.39 µS |
| gds | 52.73 µS |
| ro | 18.97 kΩ |
| saturation margin | 약 0.375 V |
| 동작 영역 | saturation |

각 조건의 `operating_point_dc_dcOp.csv`는 Spectre scalar dcOp 결과에서 자동 생성된다.

## 4. 저주파 이득 비교

저항 부하 CS의 저주파 이득을 다음과 같이 근사한다.

```text
Rout ≈ RD || ro
     ≈ 5.6 kΩ || 18.97 kΩ
     ≈ 4.323 kΩ

Av ≈ -gm(RD || ro)
   ≈ -2.284 V/V

|Av| ≈ 7.176 dB
```

Spectre 결과는 `-2.268 V/V`, magnitude `7.111 dB`이다. 근사식과의 차이는 약 `0.065 dB`이며, BSIM model의 비이상성과 생략한 기생 성분을 고려하면 잘 일치한다. 저주파 phase가 약 `180°`인 것은 common-source가 입력을 반전하기 때문이다.

## 5. 부하 커패시턴스에 따른 결과

| CL | 저주파 이득 | -3 dB bandwidth | Unity-gain frequency |
|---:|---:|---:|---:|
| 10 fF | 2.268 V/V, 7.111 dB | 3.477 GHz | 7.077 GHz |
| 100 fF | 2.268 V/V, 7.111 dB | 365.2 MHz | 743.3 MHz |
| 1 pF | 2.268 V/V, 7.111 dB | 36.71 MHz | 74.71 MHz |

- [CL = 10 fF 결과](../figures/generated/tb_p01_cs_ac/01_cl_10f/)
- [CL = 100 fF 결과](../figures/generated/tb_p01_cs_ac/02_cl_100f/)
- [CL = 1 pF 결과](../figures/generated/tb_p01_cs_ac/03_cl_1p/)
- [CL별 통합 gain/phase 비교](../figures/generated/tb_p01_cs_ac/04_cl_comparison/)

![CS AC load-capacitance comparison](../figures/generated/tb_p01_cs_ac/04_cl_comparison/01_cs_ac_load_comparison.svg)

## 6. 결과 해석

1. `CL`은 DC에서 open circuit이므로 DC 동작점과 저주파 이득에는 거의 영향을 주지 않는다.
2. 출력 node의 pole은 대략 `1/(2πRoutCL)` 관계를 가지므로 `CL`이 증가하면 pole과 bandwidth가 낮아진다.
3. 이번 결과에서는 `CL`이 10배 증가할 때 -3 dB bandwidth가 거의 10분의 1로 감소하였다.
4. 저주파에서 출력은 입력에 대해 반전되고, dominant pole에 접근하면서 phase가 추가로 변한다.
5. AC 결과는 동작점 주변의 선형 응답이므로 출력 clipping이나 large-signal slew는 보여 주지 않는다.

## 7. 다음 실습

동일한 DC 동작점에서 transient로 AC 결과를 확인한다.

1. `tb_p01_cs_ac`을 복제하여 `tb_p01_cs_transient`를 만든다.
2. `VIN_BIAS=0.714 V`에 진폭 `10 mV`, 주파수 `1 MHz`의 sine을 더한다.
3. 출력이 약 `22.7 mV` 진폭으로 반전되는지 확인하여 AC 이득과 비교한다.
4. 입력 진폭을 단계적으로 증가시켜 gain compression과 clipping 시작점을 확인한다.
5. transient 검증 후 PMOS current-source load CS로 넘어가 동일 전류에서 gain, output resistance와 swing을 저항 부하와 비교한다.
