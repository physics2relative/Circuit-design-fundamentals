# 1-2. Semiconductor Device Basics

반도체소자 기본은 회로를 물리적으로 이해하기 위한 출발점이다. 회로설계 면접에서 깊은 양자역학까지 요구하는 경우는 드물지만, carrier가 어떻게 움직이고 전류가 어떻게 생기는지는 설명할 수 있어야 한다.

## Electron과 hole

반도체에서 전류를 운반하는 carrier는 electron과 hole이다.

```text
electron : conduction band의 전자
hole     : valence band에서 전자가 빠진 자리, 양전하처럼 동작
```

NMOS는 주로 electron channel을 사용하고, PMOS는 hole channel을 사용한다. Electron mobility가 hole mobility보다 큰 경우가 많기 때문에 NMOS가 PMOS보다 같은 크기에서 더 강한 drive를 갖는 경우가 많다.

## Doping

순수한 silicon에 impurity를 넣어 carrier 농도를 조절한다.

```text
n-type : donor doping, electron이 majority carrier
p-type : acceptor doping, hole이 majority carrier
```

Doping 농도는 junction, threshold voltage, depletion width, resistance에 영향을 준다.

## Drift current

Drift current는 electric field에 의해 carrier가 이동하면서 생기는 전류이다.

```text
전기장 E -> carrier drift -> current
```

Mobility는 전기장에 대해 carrier가 얼마나 잘 움직이는지를 나타낸다.

```text
v = μE
```

Mobility가 클수록 같은 전기장에서 carrier가 더 빠르게 움직이고 current drive가 커진다.

## Diffusion current

Diffusion current는 carrier concentration gradient 때문에 생기는 전류이다.

```text
carrier 농도 높은 곳 -> 낮은 곳으로 확산
```

PN junction에서 diffusion과 drift의 균형이 built-in potential과 depletion region을 만든다.

## Recombination / generation

Electron과 hole은 recombination으로 사라질 수 있고, thermal generation으로 생길 수 있다. 이 개념은 leakage current, diode reverse current, lifetime과 연결된다.

## 회로 관점 핵심

- 전류는 drift와 diffusion으로 설명된다.
- Mobility는 transistor drive와 delay에 연결된다.
- Doping은 junction과 threshold voltage를 바꾼다.
- Carrier 농도와 전위 장벽이 diode/MOS 동작의 기반이다.
