# 1-4. Carrier Concentration and Recombination

Carrier concentration은 반도체의 전기적 특성을 결정한다. Doping, temperature, generation/recombination에 따라 electron과 hole 농도가 달라진다.

## Majority / minority carrier

```text
n-type: electron majority, hole minority
p-type: hole majority, electron minority
```

Minority carrier는 diode reverse current, BJT 동작, leakage와 관련된다.

## Mass action law

Thermal equilibrium에서 electron과 hole 농도는 다음 관계를 갖는다.

```text
n * p = ni^2
```

Doping으로 majority carrier가 증가하면 minority carrier는 감소한다.

## Recombination / generation

Electron과 hole은 recombination으로 사라질 수 있고, thermal generation으로 생성될 수 있다.

```text
recombination: electron + hole 소멸
generation   : electron-hole pair 생성
```

이 과정은 diode reverse leakage, DRAM retention, photodiode, sensor 동작과 연결된다.

## Temperature 영향

Temperature가 올라가면 intrinsic carrier concentration과 leakage가 증가한다. 그래서 memory retention이나 off-state leakage는 temperature에 민감하다.
