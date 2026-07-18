# 2-3. Diode I-V and Small-signal Resistance

Diode current는 forward voltage에 대해 exponential하게 증가한다.

```text
ID ≈ IS * (exp(VD / nVT) - 1)
```

여기서 `VT = kT/q`이고 상온에서 약 25.9 mV이다.

## 물리적 의미

Forward bias가 barrier를 낮추면 carrier injection이 증가한다. 이 injection이 exponential dependence를 만들기 때문에 diode I-V도 exponential 형태가 된다.

## Small-signal resistance

Bias point 근처에서는 diode를 small-signal resistance로 근사할 수 있다.

```text
rd = nVT / ID
```

Bias current가 클수록 small-signal resistance는 작아진다.

## 회로 연결

Diode-connected BJT/MOS, BGR의 VBE, BJT small-signal gm은 diode exponential I-V와 연결된다.

```text
BJT gm = IC / VT
```
