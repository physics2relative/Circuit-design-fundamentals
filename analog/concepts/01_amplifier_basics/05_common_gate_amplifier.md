# 1-5. Common-gate Amplifier

Common-gate amplifier는 gate를 AC ground로 두고 source에 입력을 넣으며 drain에서 출력을 보는 구조이다.

## 입력 저항

Common-gate의 중요한 특징은 낮은 input resistance이다.

```text
Rin ≈ 1 / gm
```

따라서 current input을 받거나, 낮은 impedance source를 받아야 하는 wideband stage에서 유용하다.

## Gain

Drain 쪽에 저항 load가 있으면 voltage gain은 대략 다음과 같다.

```text
Av ≈ gm * Rout
```

Common-source와 달리 non-inverting gain을 가진다.

## Wideband 특성

Common-gate는 input node voltage swing이 작아서 Miller effect가 작다. 이 때문에 wideband input stage로 사용될 수 있다.

## 설계 포인트

- 낮은 input resistance가 장점이자 단점이다.
- input common-mode와 source voltage가 bias 조건에 직접 영향을 준다.
- gain, bandwidth, headroom을 함께 고려해야 한다.
