# 3-3. Input Common-mode Range

Input common-mode range는 differential pair가 정상적으로 동작할 수 있는 입력 common-mode 전압 범위이다.

## 왜 제한되는가

Differential pair의 input transistor와 tail current source는 모두 적절한 region에 있어야 한다.

NMOS input pair 기준으로 common-mode가 너무 낮으면 tail current source headroom이 부족하고, 너무 높으면 input pair나 load 쪽 headroom이 부족해질 수 있다.

## 확인할 조건

```text
tail current source saturation
input pair saturation
load transistor saturation
output swing 확보
```

## 설계 관점

- 낮은 VDD에서는 input common-mode range 확보가 어렵다.
- PMOS input pair와 NMOS input pair는 가능한 common-mode range가 다르다.
- Rail-to-rail input op-amp는 NMOS/PMOS input pair를 조합하기도 한다.
