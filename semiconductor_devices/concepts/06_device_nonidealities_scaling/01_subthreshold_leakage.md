# 6-1. Subthreshold Leakage

Subthreshold leakage는 `VGS < VTH`인 off 상태에서도 source-drain 사이로 흐르는 전류이다.

## 왜 발생하는가

Strong inversion이 아니어도 surface potential에 의해 minority carrier가 확산하며 전류가 흐를 수 있다. 이 전류는 gate voltage에 대해 exponential하게 변한다.

## 회로 영향

```text
VTH 감소 -> subthreshold leakage 증가
Temperature 증가 -> leakage 증가
```

Digital에서는 static power 증가, memory에서는 retention 악화와 연결된다.
