# 3-4. Threshold Voltage

Threshold voltage는 strong inversion channel이 형성되기 시작하는 gate voltage이다.

## 구성 요소

Threshold voltage는 여러 항에 의해 결정된다.

```text
VTH = flat-band voltage + surface potential term + depletion charge term + body effect term
```

정확한 수식보다 중요한 것은 다음 인과관계이다.

```text
doping 증가 -> depletion charge 증가 -> VTH 변화
oxide 두께 감소 -> Cox 증가 -> gate control 증가
body bias 증가 -> depletion charge 증가 -> VTH 증가
```

## Body effect

NMOS에서 source-body reverse bias가 커지면 depletion region charge가 증가하고 VTH가 증가한다.

```text
VSB 증가 -> VTH 증가
```

## 회로 연결

```text
VTH 감소 -> drive current 증가 -> delay 감소 -> leakage 증가
VTH 증가 -> drive current 감소 -> delay 증가 -> leakage 감소
```

Threshold voltage는 device physics와 circuit PPA를 연결하는 핵심 파라미터이다.
