# 1-1. Carrier and Doping

반도체에서 전류를 운반하는 carrier는 electron과 hole이다.

```text
electron : conduction band의 전자
hole     : valence band에서 전자가 빠진 자리, 양전하처럼 동작
```

## Intrinsic semiconductor

Intrinsic semiconductor는 불순물 doping이 없는 이상적인 순수 반도체이다. 상온에서는 thermal generation에 의해 electron-hole pair가 생긴다.

```text
n = p = ni
```

여기서 `ni`는 intrinsic carrier concentration이다.

## Extrinsic semiconductor

Doping을 통해 carrier 농도를 조절한 반도체를 extrinsic semiconductor라고 한다.

```text
n-type : donor doping, electron이 majority carrier
p-type : acceptor doping, hole이 majority carrier
```

n-type에서도 hole은 minority carrier로 존재하고, p-type에서도 electron은 minority carrier로 존재한다.

## Mobility

Mobility는 전기장에 의해 carrier가 얼마나 잘 움직이는지를 나타낸다.

```text
vdrift = μE
```

Electron mobility가 hole mobility보다 큰 경우가 많기 때문에, 같은 크기에서는 NMOS가 PMOS보다 drive current가 큰 경우가 많다.

## 회로 연결

```text
doping 농도 -> VTH, junction capacitance, depletion width 영향
mobility    -> drive current, delay 영향
carrier 농도 -> leakage, junction 동작 영향
```
