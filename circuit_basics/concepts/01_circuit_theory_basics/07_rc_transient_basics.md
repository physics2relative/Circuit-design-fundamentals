# 1-7. RC Transient Basics

RC transient는 capacitor가 resistor를 통해 충전/방전되는 시간 응답이다. Digital delay, analog bandwidth, sample-and-hold settling을 이해하는 기본이다.

## Capacitor current

Capacitor current는 전압 변화율에 비례한다.

```text
i = C * dv/dt
```

Capacitor 전압은 순간적으로 바뀔 수 없다. 전압을 바꾸려면 전류가 필요하다.

## RC time constant

저항 R을 통해 capacitor C가 충전/방전될 때 time constant는 다음이다.

```text
τ = R * C
```

1차 RC 회로에서 step response는 exponential 형태이다.

```text
V(t) = Vfinal + (Vinitial - Vfinal) * exp(-t/RC)
```

## Settling

대략적인 settling 기준은 다음처럼 기억할 수 있다.

```text
1τ : 약 63% 변화
3τ : 약 95% 변화
5τ : 약 99% 이상 변화
```

## Delay와 bandwidth 연결

RC가 클수록 transient가 느려지고 bandwidth는 낮아진다.

1차 low-pass pole은 다음이다.

```text
fp = 1 / (2πRC)
```

Digital gate delay도 output capacitance를 effective resistance로 충방전하는 시간으로 볼 수 있다.

```text
tpd ≈ Ron * CL
```

## 회로설계 연결

- CMOS inverter delay는 load capacitance 충방전이다.
- Op-amp output settling은 RC와 loop bandwidth에 의해 제한된다.
- Sample-and-hold 회로는 switch resistance와 sampling capacitor의 RC settling을 고려한다.
- Long wire는 distributed RC로 delay와 waveform distortion을 만든다.
