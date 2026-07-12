# STA Interview Checklist

## Setup과 hold의 차이

Setup은 data가 다음 capture clock edge 전에 충분히 일찍 도착해야 하는 조건이다. Max delay 문제이며, combinational path가 길거나 clock period가 짧으면 violation이 발생한다.

Hold는 data가 현재 capture clock edge 직후 일정 시간 동안 유지되어야 하는 조건이다. Min delay 문제이며, data path가 너무 짧거나 clock skew가 불리하면 violation이 발생한다.

## Setup violation 해결 방법

- Logic depth를 줄인다.
- Pipeline register를 추가한다.
- Fanout을 줄인다.
- Faster cell 또는 gate sizing을 사용한다.
- Placement/routing을 개선한다.
- 가능하면 clock period를 완화한다.

면접에서는 “setup은 늦게 도착하는 문제이므로 path를 빠르게 하거나 시간을 더 줘야 한다”라고 설명하면 된다.

## Hold violation 해결 방법

- Buffer 또는 delay cell을 삽입한다.
- Minimum data path delay를 늘린다.
- Clock skew를 조정한다.
- 너무 짧은 bypass path를 제거한다.

면접에서는 “hold는 너무 빨리 바뀌는 문제이므로 clock period를 늘려도 직접 해결되지 않는다”는 점을 강조하면 좋다.

## Slack 설명

Slack은 required time과 arrival time의 차이이다.

```text
slack = required time - arrival time
```

Positive slack이면 timing을 만족하고, negative slack이면 violation이다.

## Critical path 설명

Critical path는 slack이 가장 작은 path이다. Setup 관점에서는 보통 가장 긴 combinational path가 critical path가 되며, 전체 Fmax를 제한한다.

## Clock skew가 setup/hold에 미치는 영향

Capture clock이 늦게 도착하는 positive skew는 setup에는 유리할 수 있지만 hold에는 불리할 수 있다. 반대로 capture clock이 빨리 도착하면 setup에는 불리하고 hold에는 유리할 수 있다.

따라서 skew는 setup과 hold를 동시에 보고 판단해야 한다.

## False path와 multicycle path 차이

False path는 실제로 timing check가 의미 없는 path를 제외하는 constraint이다. Multicycle path는 data가 1 cycle이 아니라 여러 cycle에 걸쳐 전달될 수 있음을 알려주는 constraint이다.

False path는 path를 아예 보지 않는 것이고, multicycle path는 timing requirement를 다른 cycle 기준으로 바꾸는 것이다.

## CDC path와 STA

CDC path는 서로 다른 clock domain 사이의 path이므로 일반적인 STA만으로 metastability 안전성을 보장할 수 없다. Synchronizer, handshake, async FIFO 같은 CDC 구조가 필요하고, STA exception은 그 구조에 맞게 제한적으로 적용해야 한다.

## Timing closure 경험 설명 구조

Timing closure 경험을 설명할 때는 다음 순서가 좋다.

1. 어떤 path에서 violation이 발생했는지 말한다.
2. Setup violation인지 hold violation인지 구분한다.
3. Report에서 cell delay, net delay, fanout, skew 중 무엇이 원인이었는지 설명한다.
4. 어떤 fix를 적용했는지 말한다.
5. Fix 후 slack이 어떻게 개선되었는지 말한다.

## 핵심 답변 문장

- Setup violation은 data가 capture edge 전에 충분히 일찍 도착하지 못하는 문제이다.
- Hold violation은 capture edge 직후 data가 너무 빨리 바뀌는 문제이다.
- Setup은 clock period를 늘리면 완화될 수 있지만, hold는 일반적으로 clock period를 늘려도 해결되지 않는다.
- Critical path는 가장 timing margin이 작은 path이고 Fmax를 제한한다.
- Timing exception은 필요하지만 잘못 쓰면 실제 bug를 숨길 수 있다.
