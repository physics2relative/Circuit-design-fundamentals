# 01. 저항 부하 Common-Source의 DC 동작점 설정

## 1. 실습 목표

저항 부하 NMOS common-source 회로에서 다음 DC 동작점을 동시에 만족시키는 것을 목표로 한다.

- `VDD = 1.1 V`
- `ID ≈ 100 µA`
- `VOUT ≈ 0.55 V`
- NMOS saturation 유지

사용한 NMOS의 시작 크기는 `W=800 nm`, `L=80 nm`, `m=1`, `nf=1`이다. `VIN_BIAS`를 `0~1.1 V`, 간격 `1 mV`로 sweep하여 drain current와 output voltage를 확인한다.

## 2. 동작점 설정 원리

저항 부하 CS의 DC 출력은 다음 관계를 따른다.

```text
VOUT = VDD - ID × RD
```

`VIN_BIAS`는 NMOS의 `VGS`를 바꾸어 drain current를 결정하고, `RD`는 해당 전류에 의해 발생하는 전압 강하를 통해 `VOUT`을 결정한다. 따라서 목표 전류를 먼저 확인한 다음 그 전류에서 원하는 출력 전압이 만들어지도록 `RD`를 계산한다.

## 3. RD = 1 kΩ에서 첫 sweep

첫 회로는 `RD=1 kΩ`으로 구성하였다. Sweep 결과 `ID≈100 µA`가 되는 지점은 다음과 같다.

| 항목 | 결과 |
|---|---:|
| VIN_BIAS | 0.685 V |
| ID | 100.08 µA |
| VOUT | 0.9999 V |
| VTH | 0.5004 V |
| VOV | 0.1846 V |
| VDSAT | 0.1638 V |
| 동작 영역 | saturation |

계산으로도 같은 결과를 예상할 수 있다.

```text
VOUT = 1.1 V - (100 µA × 1 kΩ) ≈ 1.0 V
```

따라서 `RD=1 kΩ`에서는 목표 전류를 유지할 때 출력이 약 `1.0 V`가 된다. 입력을 더 높여도 sweep 범위 안에서 확인한 최소 출력은 약 `0.739 V`이므로 `ID≈100 µA`와 `VOUT≈0.55 V`를 동시에 만족시킬 수 없다.

- [RD = 1 kΩ 결과](../figures/generated/tb_p01_cs_basic/01_rd_1k/)

## 4. 필요한 부하 저항 계산

목표 전류와 출력 전압으로 필요한 저항을 역산한다.

```text
RD = (VDD - VOUT) / ID
   = (1.1 V - 0.55 V) / 100 µA
   = 5.5 kΩ
```

목표값에 가까운 부하로 `RD=5.6 kΩ`을 선택하였다. 이는 `ID≈100 µA`를 유지하면서 저항 전압 강하를 약 `0.55 V`로 늘려 출력 동작점을 supply 중앙 부근으로 이동시키기 위한 변경이다.

## 5. RD = 5.6 kΩ에서 재실행

같은 NMOS 크기, 공급전압과 sweep 조건에서 저항만 `5.6 kΩ`으로 변경하였다.

| 기준 | VIN_BIAS | ID | VOUT | VOV | 동작 영역 |
|---|---:|---:|---:|---:|---|
| VOUT≈0.55 V | 0.714 V | 98.21 µA | 0.5500 V | 0.2079 V | saturation |
| ID≈100 µA | 0.718 V | 99.83 µA | 0.5409 V | 0.2118 V | saturation |

`RD=5.6 kΩ`에서 두 목표를 거의 동시에 만족한다. 저항이 바뀌면 `VDS`도 달라지므로 channel-length modulation 등의 영향으로 동일한 `VIN_BIAS`에서 전류가 완전히 같지는 않다. 따라서 저항 변경 후 `VIN_BIAS`를 다시 sweep하여 최종 동작점을 확인해야 한다.

- 출력 중앙값을 우선하면 `VIN_BIAS≈0.714 V`를 사용한다.
- 전류 100 µA를 우선하면 `VIN_BIAS≈0.718 V`를 사용한다.
- 두 값을 정확히 맞춰야 한다면 `RD≈5.5 kΩ` 부근과 `VIN_BIAS`를 함께 미세 조정한다.

- [RD = 5.6 kΩ 결과](../figures/generated/tb_p01_cs_basic/02_rd_5p6k/)

## 6. 이번 실습에서 확인한 내용

1. `VIN_BIAS`는 NMOS의 도통 정도와 `ID`를 정한다.
2. `RD`는 정해진 전류를 출력 전압으로 변환한다.
3. 목표 `ID`와 `VOUT`이 주어지면 `RD=(VDD-VOUT)/ID`로 시작값을 계산할 수 있다.
4. 저항 변경은 출력 동작점뿐 아니라 gain, 출력 swing과 saturation margin에도 영향을 준다.
5. 손계산은 시작값을 정하고, BSIM operating point와 sweep 결과로 최종값을 보정한다.

## 7. 다음 실습

DC 동작점을 기준으로 고정한 뒤 같은 회로의 small-signal AC 특성을 확인한다.

1. `RD=5.6 kΩ`, `VIN_BIAS≈0.714 V`를 nominal 조건으로 설정한다.
2. 단일 operating-point 해석으로 `ID`, `gm`, `gds`, `ro`, `VDSAT`과 saturation margin을 다시 기록한다.
3. 입력 source의 AC magnitude를 `1 V`로 설정한다.
4. `1 Hz~10 GHz`, decade당 100 point로 AC sweep한다.
5. `VOUT/VIN`의 magnitude와 phase를 plot한다.
6. 저주파 이득을 `-gm(RD || ro)` 근사값과 비교한다.
7. `CL={10 fF, 100 fF, 1 pF}`로 바꾸어 -3 dB bandwidth와 dominant output pole 변화를 비교한다.

이후 같은 목표 전류 조건에서 PMOS current-source load CS로 넘어가 저항 부하와 gain, output resistance, swing 및 bias 민감도를 비교한다.
