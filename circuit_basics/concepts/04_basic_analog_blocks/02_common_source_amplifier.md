# 4-2. Common-source Amplifier

Common-source amplifier는 MOS analog amplifier의 기본 구조이다. 입력은 gate, 출력은 drain에서 보고 source는 AC ground에 가깝게 둔다.

## 동작 원리

NMOS common-source에서 input voltage가 증가하면 drain current가 증가한다. Load를 통해 흐르는 전류가 증가하면 output drain voltage는 감소한다.

```text
Vin 증가 -> ID 증가 -> Vout 감소
```

따라서 common-source amplifier는 inverting amplifier이다.

## Gain

저항 load를 쓰면 gain은 대략 다음과 같다.

```text
Av ≈ -gm * RD
```

Active load를 쓰면 출력 저항이 커지고 gain을 더 크게 만들 수 있다.

```text
Av ≈ -gm * Rout
```

## 설계 trade-off

- gain을 키우려면 gm 또는 output resistance를 키워야 한다.
- bias current를 키우면 gm은 커지지만 power가 증가한다.
- output swing과 saturation 조건을 동시에 만족해야 한다.
- load capacitance가 커지면 bandwidth가 감소한다.
