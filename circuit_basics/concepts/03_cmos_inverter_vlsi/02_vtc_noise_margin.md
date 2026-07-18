# 3-2. VTC and Noise Margin

VTC는 voltage transfer characteristic의 약자로, input voltage 변화에 따른 output voltage를 나타낸 곡선이다.

```text
Vout = f(Vin)
```

CMOS inverter의 VTC는 logic 0과 logic 1을 얼마나 안정적으로 구분할 수 있는지 보여준다.

## Switching threshold

Switching threshold는 input과 output이 같아지는 근처의 전압으로 볼 수 있다.

```text
Vin ≈ Vout
```

NMOS와 PMOS의 drive strength가 비슷하면 switching point가 VDD/2 근처에 온다. PMOS가 약하면 switching point가 낮아지고, NMOS가 약하면 높아진다.

## Noise margin

Noise margin은 logic 0/1에 noise가 섞여도 다음 gate가 올바르게 해석할 수 있는 여유이다.

```text
NMH = VOH - VIH
NML = VIL - VOL
```

- VOH: output high로 보장되는 최소 전압
- VOL: output low로 보장되는 최대 전압
- VIH: input high로 인식되는 최소 전압
- VIL: input low로 인식되는 최대 전압

## 왜 중요한가

Noise margin이 작으면 작은 noise에도 logic error가 발생할 수 있다. Digital gate가 단순히 0/1만 다루는 것처럼 보여도 실제 신호는 analog voltage이므로 noise margin은 매우 중요하다.

## 설계 관점

- VTC가 steep할수록 logic 전환이 명확하다.
- switching threshold는 NMOS/PMOS sizing에 영향을 받는다.
- noise margin은 supply voltage scaling에서 중요해진다.
- VDD가 낮아질수록 noise margin과 delay margin이 줄어든다.
