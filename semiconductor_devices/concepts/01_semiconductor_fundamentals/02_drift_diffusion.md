# 1-2. Drift and Diffusion Current

반도체의 전류는 크게 drift current와 diffusion current로 설명한다.

## Drift current

Drift current는 electric field에 의해 carrier가 이동하면서 생기는 전류이다.

```text
전기장 E -> carrier drift -> current
```

전기장이 클수록 carrier drift velocity가 커진다.

```text
vdrift = μE
```

## Diffusion current

Diffusion current는 carrier concentration gradient 때문에 생긴다.

```text
carrier 농도 높은 곳 -> 낮은 곳으로 확산
```

PN junction에서 p영역의 hole과 n영역의 electron이 서로 확산하면서 depletion region이 형성된다.

## Drift와 diffusion의 균형

PN junction equilibrium에서는 diffusion으로 carrier가 넘어가려는 경향과, depletion region의 built-in electric field가 carrier를 되돌리는 drift가 균형을 이룬다.

```text
equilibrium: diffusion current + drift current = 0
```

## 면접 포인트

Drift는 전기장 때문에 생기는 전류이고, diffusion은 농도 차이 때문에 생기는 전류이다. PN junction의 built-in potential은 이 두 효과가 equilibrium에서 균형을 이루는 과정과 연결된다.
