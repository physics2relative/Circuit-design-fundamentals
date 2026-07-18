# 4-5. Simulation Plan

Frequency response는 AC simulation과 transient step response를 함께 보는 것이 좋다.

## AC simulation

확인:

```text
low-frequency gain
-3 dB bandwidth
unity-gain frequency
phase
pole/zero 위치 추정
```

## Load capacitance sweep

`CL`을 바꾸면서 bandwidth와 phase가 어떻게 변하는지 본다.

```text
CL 증가 -> output pole 감소 -> bandwidth 감소 -> phase margin 악화 가능
```

## Bias current sweep

Bias current를 바꾸면 gm과 pole 위치가 변한다.

```text
bias current 증가 -> gm 증가 -> bandwidth 증가 가능 -> power 증가
```

## Transient step response

Step input을 넣고 rise/fall time, settling time, overshoot를 확인한다. Frequency response와 transient response는 서로 연결되어 있다.
