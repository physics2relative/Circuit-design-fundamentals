# 1-3. Common-source Amplifier

Common-source amplifier는 MOS analog amplifier의 가장 기본적인 구조이다. 입력은 gate, 출력은 drain에서 보고 source는 AC ground에 가깝게 둔다.

## 동작 원리

NMOS common-source에서 입력 전압이 증가하면 drain current가 증가한다. Load를 통해 더 큰 전류가 흐르면 output voltage는 감소한다.

```text
Vin 증가 -> ID 증가 -> Vout 감소
```

따라서 common-source amplifier는 inverting voltage amplifier이다.

## Gain

Small-signal gain은 대략 다음과 같이 본다.

```text
Av ≈ -gm * Rout
```

저항 load이면:

```text
Rout ≈ RD || ro
Av ≈ -gm * (RD || ro)
```

Active load를 사용하면 output resistance를 키워 gain을 높일 수 있다.

## Bias 조건

Common-source amplifier가 선형 증폭기로 동작하려면 transistor가 saturation region에 있어야 한다.

```text
VDS >= VGS - VTH
```

Bias point가 맞지 않으면 출력 swing이 줄거나, distortion이 커지거나, gain이 크게 떨어진다.

## 설계 trade-off

- bias current 증가 -> gm 증가 -> gain/bandwidth 개선 가능, power 증가
- output resistance 증가 -> gain 증가, voltage headroom 감소 가능
- load capacitance 증가 -> bandwidth 감소
- input swing 증가 -> large-signal distortion 증가
