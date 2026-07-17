# 1-3. Threshold Voltage

Threshold voltage는 MOSFET에 strong inversion channel이 형성되기 시작하는 기준 전압이다. 회로설계에서는 VTH를 speed, leakage, power trade-off의 핵심 변수로 본다.

## VTH와 drive current

NMOS 기준으로 gate overdrive는 다음과 같이 본다.

```text
VOV = VGS - VTH
```

VTH가 낮아지면 같은 VGS에서 VOV가 커지고 drive current가 증가한다. 그 결과 load capacitance를 더 빨리 충전/방전할 수 있어 delay가 줄어든다.

반대로 VTH가 높아지면 drive current가 줄어 timing이 느려진다.

## VTH와 leakage

VTH가 낮아지면 off 상태에서도 subthreshold current가 증가한다. 즉 speed는 좋아지지만 leakage/static power가 증가한다.

```text
Low VTH  : fast, high leakage
High VTH : slow, low leakage
```

이 관계 때문에 multi-VTH design에서는 critical path에는 low-VTH cell을 쓰고, timing 여유가 있는 path에는 high-VTH cell을 사용한다.

## VTH와 static power / timing 관계

정리하면 다음과 같다.

```text
VTH 감소 -> drive current 증가 -> delay 감소 -> timing 개선
VTH 감소 -> off current 증가   -> leakage 증가 -> static power 증가

VTH 증가 -> drive current 감소 -> delay 증가 -> timing 악화
VTH 증가 -> off current 감소   -> leakage 감소 -> static power 감소
```

## 설계 관점

VTH는 단순 소자 파라미터가 아니라 PPA trade-off의 직접적인 knob이다.

- performance가 중요한 path에서는 낮은 VTH가 유리하다.
- standby power가 중요한 block에서는 높은 VTH가 유리하다.
- 저전압 동작에서는 VDD와 VTH의 차이가 작아져 delay가 급격히 나빠질 수 있다.

## 면접 포인트

“VTH가 낮으면 빨라진다”에서 멈추지 말고, “같은 VGS에서 overdrive가 커지고 current가 증가해서 capacitance를 더 빨리 충방전하기 때문”이라고 설명하는 것이 좋다.
