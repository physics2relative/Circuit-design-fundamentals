# 1-4. Source Follower

Source follower는 gate에 입력을 넣고 source에서 출력을 보는 구조이다. Common-drain amplifier라고도 한다. 출력이 source에서 나오므로 DC 관점에서는 `Vout ≈ Vin - VGS` 형태의 level shift가 생기고, small-signal 관점에서는 출력이 입력을 따라가는 buffer처럼 동작한다.

## 기본 구조

```text
      VDD
       |
      drain
       |
Vin -> gate   NMOS
       |
     source ---- Vout
       |
       Rs
       |
      GND 또는 AC ground
```

여기서 `Rs`는 source 노드에서 AC ground로 보이는 등가 저항이다. 실제 회로에서는 단순 source resistor일 수도 있고, bias current source의 output resistance, load resistance, 다음 단 입력 저항 등이 합쳐진 값일 수도 있다.

```text
Rs = source 쪽에서 보이는 small-signal 등가 저항
```

## `Rs` 기준 voltage gain

Body effect와 `ro`를 일단 무시하면 source follower의 small-signal gain은 다음과 같이 볼 수 있다.

```text
Av = vout / vin ≈ gm Rs / (1 + gm Rs)
```

따라서 `gm Rs`가 충분히 크면 gain은 1에 가까워진다.

```text
gm Rs >> 1  ->  Av ≈ 1
gm Rs 작음 ->  Av가 1보다 많이 작아짐
```

직관적으로는 gate 입력 변화가 `vgs` 변화를 만들고, 그 결과 drain current 변화가 생기며, 이 전류 변화가 `Rs`에 전압 변화를 만든다. Source 전압이 올라가면 `vgs`가 다시 줄어드는 negative feedback이 걸리기 때문에 출력은 입력을 따라가지만 1을 넘지 않는다.

## Body effect와 더 현실적인 식

Source follower에서는 source 전압이 움직이므로 body가 고정되어 있으면 `VSB`가 변한다. 이때 body effect가 생기고, source 전압 변화를 억제하는 효과가 추가된다.

Body transconductance `gmb`를 포함하면 대략 다음처럼 볼 수 있다.

```text
Av ≈ gm Rs / (1 + (gm + gmb) Rs)
```

그래서 body effect가 있으면 gain이 더 낮아진다.

```text
gmb 증가 -> denominator 증가 -> Av 감소
```

`ro`까지 고려하면 `Rs`와 `ro`가 함께 source 노드의 등가 저항을 만든다. 정밀한 값은 bias current source, load, body connection에 따라 달라진다.

## Output resistance

Source follower가 buffer로 쓰이는 가장 큰 이유는 output resistance가 낮기 때문이다. Gate를 AC ground로 두고 source에서 바라보면, source 전압 변화가 `vgs` 변화를 만들고 MOSFET 전류가 그 변화를 되돌리려 한다.

Body effect를 무시하면 대략 다음과 같다.

```text
Rout ≈ 1/gm || ro || Rs_bias
```

Body effect를 포함하면 더 낮아진다.

```text
Rout ≈ 1/(gm + gmb) || ro || Rs_bias
```

즉 source follower는 다음 성격을 가진다.

```text
input resistance 높음
voltage gain ≈ 1보다 약간 작음
output resistance 낮음
```

## Buffer로 쓰는 이유

Source follower의 핵심은 큰 voltage gain이 아니라 impedance 변환이다.

```text
앞단 입장 : gate 입력이라 거의 loading하지 않음
뒷단 입장 : 낮은 Rout로 load를 구동함
```

따라서 voltage gain을 크게 만들기 위한 stage라기보다, 큰 저항의 앞단 신호를 낮은 저항의 load로 전달하거나 capacitive load를 더 잘 구동하기 위한 buffer로 사용된다.

## 설계 포인트

- `gm`이 클수록 gain은 1에 가까워지고 output resistance는 낮아진다.
- `Rs`가 충분히 크지 않으면 gain이 1보다 많이 낮아진다.
- body effect가 있으면 gain이 더 낮아지고 output resistance 식에도 `gmb`가 들어간다.
- output swing은 `VGS`, saturation 유지 조건, current source headroom에 의해 제한된다.
- 큰 load current를 구동하려면 bias current와 `gm`을 충분히 확보해야 한다.
