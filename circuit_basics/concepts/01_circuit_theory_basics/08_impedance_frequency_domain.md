# 1-8. Impedance and Frequency Domain

Impedance는 저항 개념을 AC/frequency domain으로 확장한 것이다. Capacitor와 inductor는 주파수에 따라 다른 impedance를 가진다.

## Resistor impedance

저항의 impedance는 주파수와 무관하다.

```text
ZR = R
```

## Capacitor impedance

Capacitor의 impedance는 다음이다.

```text
ZC = 1 / (sC)
```

주파수가 높아질수록 capacitor impedance는 작아진다.

```text
low frequency  -> capacitor open에 가까움
high frequency -> capacitor short에 가까움
```

## Inductor impedance

Inductor의 impedance는 다음이다.

```text
ZL = sL
```

주파수가 높아질수록 inductor impedance는 커진다.

```text
low frequency  -> inductor short에 가까움
high frequency -> inductor open에 가까움
```

## Pole과 zero 직관

RC low-pass filter는 낮은 주파수는 통과시키고 높은 주파수는 attenuate한다.

```text
H(s) = 1 / (1 + sRC)
```

Pole frequency는 다음이다.

```text
ωp = 1 / RC
fp = 1 / (2πRC)
```

## 회로설계 연결

- Amplifier bandwidth는 내부 node resistance와 capacitance가 만드는 pole에 의해 제한된다.
- Op-amp stability는 loop gain의 pole/zero와 phase margin으로 판단한다.
- Decoupling capacitor는 supply noise를 frequency-dependent하게 우회시킨다.
- Parasitic capacitance는 고주파 gain과 speed를 제한한다.
