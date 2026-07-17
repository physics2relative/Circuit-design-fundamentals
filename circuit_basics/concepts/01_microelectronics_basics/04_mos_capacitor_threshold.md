# 1-4. MOS Capacitor and Threshold Formation

MOSFET을 이해하려면 먼저 MOS capacitor를 보는 것이 좋다. MOS capacitor는 metal/gate, oxide, semiconductor로 이루어진 구조이며, gate voltage에 따라 semiconductor 표면 상태가 바뀐다.

## MOS 구조

```text
Gate
Oxide
Semiconductor body
```

Gate와 semiconductor 사이에는 oxide가 있으므로 이상적으로 DC gate current는 거의 흐르지 않는다. 대신 gate voltage가 oxide를 사이에 두고 semiconductor 표면의 charge distribution을 바꾼다.

## Accumulation

P-type substrate 기준으로 gate에 음전압을 걸면 hole이 surface에 모인다.

```text
negative gate voltage -> hole accumulation
```

## Depletion

Gate 전압을 양의 방향으로 올리면 surface 근처의 hole이 밀려나고 ionized acceptor만 남는 depletion region이 생긴다.

```text
positive gate voltage -> hole repelled -> depletion region
```

## Inversion

Gate 전압을 더 올리면 surface에 electron이 모여 p-type substrate 표면이 n-type처럼 동작한다. 이를 inversion이라고 한다.

```text
strong inversion -> conductive channel 형성 가능
```

NMOS의 channel은 이 inversion layer를 이용한다.

## Threshold voltage

Threshold voltage는 strong inversion channel이 형성되기 시작하는 기준 전압으로 볼 수 있다.

VTH는 다음 요소에 영향을 받는다.

- substrate doping
- oxide thickness / oxide capacitance
- flat-band voltage
- body bias
- interface charge

## MOSFET으로의 연결

MOS capacitor에 source와 drain diffusion을 추가하면 MOSFET이 된다. Gate가 inversion channel을 만들면 source-drain 사이에 전류가 흐를 수 있다.

```text
MOS capacitor의 inversion layer + source/drain = MOSFET channel
```

## 핵심 정리

- Gate voltage는 oxide를 통해 semiconductor 표면 charge를 제어한다.
- Accumulation, depletion, inversion은 MOS 동작의 기본 상태이다.
- Threshold voltage는 strong inversion channel 형성 기준이다.
- MOSFET은 MOS capacitor 개념 위에 source/drain current path가 추가된 소자이다.
