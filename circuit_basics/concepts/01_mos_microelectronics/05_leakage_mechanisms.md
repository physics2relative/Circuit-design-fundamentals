# 1-5. Leakage Mechanisms

Leakage는 transistor가 off 상태이거나 switching하지 않을 때도 흐르는 전류이다. 공정이 미세화될수록 leakage는 static power의 중요한 원인이 된다.

## Subthreshold leakage

Subthreshold leakage는 `VGS < VTH`인 off 상태에서도 source-drain 사이로 흐르는 전류이다.

VTH가 낮을수록, 온도가 높을수록 subthreshold leakage가 커진다. Low-VTH cell이 빠르지만 leakage가 큰 이유가 여기에 있다.

## Gate leakage

Gate oxide가 매우 얇아지면 gate를 통해 tunneling current가 흐를 수 있다. 이를 gate leakage라고 한다.

현대 공정에서는 high-k gate dielectric 같은 기술로 gate leakage를 줄인다.

## Junction leakage

Source/drain과 body 사이의 reverse-biased junction에서도 leakage가 발생한다. 온도와 junction 면적, 공정 조건에 영향을 받는다.

## Static power와의 관계

Static power는 회로가 switching하지 않을 때도 소모되는 전력이다.

```text
Pstatic ≈ VDD * Ileakage
```

여기서 leakage에는 subthreshold, gate, junction leakage 등이 포함된다.

## Digital 설계 관점

RTL 설계자가 leakage를 직접 계산하지는 않지만, 다음 trade-off는 이해해야 한다.

- Low-VTH cell은 빠르지만 leakage가 크다.
- High-VTH cell은 느리지만 leakage가 작다.
- Power gating은 sleep 상태에서 block의 leakage를 줄이기 위한 기법이다.
- Clock gating은 dynamic power를 줄이는 기법이지, leakage 자체를 직접 줄이는 기법은 아니다.

## 면접 포인트

Leakage를 “그냥 전류가 샌다”로 설명하기보다, off transistor에서도 subthreshold current가 흐르고 이것이 static power로 이어진다고 설명하는 것이 좋다.
