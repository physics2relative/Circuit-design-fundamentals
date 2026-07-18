# 5-3. Small-signal Model

BJT forward active region은 hybrid-pi model로 자주 해석한다.

```text
base-emitter: rπ
collector-emitter: ro
controlled current source: gm * vπ
```

Common-emitter amplifier gain은 대략 다음이다.

```text
Av ≈ -gm * (RC || ro)
```

BJT는 β만 외우는 소자가 아니라, 회로 해석에서는 `gm`, `rπ`, `ro`를 함께 봐야 한다.
