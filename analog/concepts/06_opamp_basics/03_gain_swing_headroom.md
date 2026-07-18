# 6-3. Gain, Swing, and Headroom

Op-amp gain은 각 stage의 `gm * Rout`에 의해 결정된다.

```text
Av_total ≈ Av1 * Av2
```

## Gain

Gain을 키우려면 gm 또는 output resistance를 키워야 한다. Cascode 구조는 output resistance를 키우지만 headroom을 더 요구한다.

## Output swing

Output swing은 output transistor가 saturation을 유지할 수 있는 범위와 supply voltage에 의해 제한된다.

## Headroom

낮은 supply voltage에서는 여러 transistor를 stack하기 어렵다.

```text
낮은 VDD -> cascode/headroom 어려움 -> topology 선택 제한
```

따라서 공정과 supply가 바뀌면 op-amp 구조와 sizing을 다시 봐야 한다.
