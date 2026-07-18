# 1-4. Source Follower

Source follower는 gate에 입력을 넣고 source에서 출력을 보는 구조이다. Common-drain amplifier라고도 한다.

## 동작 원리

NMOS source follower에서는 gate 전압이 올라가면 source 전압도 따라 올라간다.

```text
Vout ≈ Vin - VGS
```

Small-signal voltage gain은 1보다 약간 작다.

```text
Av ≈ gm * Rsig / (1 + gm * Rsig) 형태로 1보다 작음
```

정확한 식은 load, body effect, ro에 따라 달라진다.

## Buffer로 쓰는 이유

Source follower의 핵심은 큰 voltage gain이 아니라 impedance 변환이다.

```text
input resistance 높음
output resistance 낮음
voltage gain ≈ 1
```

따라서 앞단을 loading하지 않으면서 뒷단 load를 구동하는 buffer로 사용된다.

## Body effect

Source 전압이 변하면 body-source 전압도 변할 수 있다. 이 경우 body effect 때문에 effective gm이 줄고 gain이 더 낮아질 수 있다.

## 설계 포인트

- output swing은 gate voltage와 VGS/headroom에 의해 제한된다.
- load current가 커지면 bias current와 output resistance를 다시 봐야 한다.
- voltage gain보다 load driving과 level shift 관점이 중요하다.
