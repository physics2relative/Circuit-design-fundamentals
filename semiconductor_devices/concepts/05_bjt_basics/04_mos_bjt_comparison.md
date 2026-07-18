# 5-4. MOSFET and BJT Comparison

MOSFET과 BJT는 모두 amplifier device로 쓰이지만 입력과 전류 제어 방식이 다르다.

```text
MOSFET : gate voltage가 channel을 제어, 이상적으로 DC gate current 작음
BJT    : VBE가 collector current를 exponential하게 제어, base current 존재
```

## Small-signal 비교

```text
MOSFET gm : bias current와 overdrive에 의존
BJT gm    : IC / VT

MOSFET input resistance : gate 기준 매우 큼
BJT input resistance    : rπ로 유한

MOSFET ro : channel length modulation 때문
BJT ro    : Early effect 때문
```

BJT는 같은 bias current에서 큰 gm을 얻기 쉽지만 base current와 charge storage를 고려해야 한다.
