# State Encoding

## 핵심 관점

State encoding은 상태를 어떤 bit pattern으로 표현할지 정하는 것이다.

## Binary encoding

적은 bit 수로 상태를 표현한다.

```text
N states → ceil(log2(N)) bits
```

flop 수는 적지만 next-state logic이 복잡해질 수 있다.

## One-hot encoding

각 state를 하나의 bit로 표현한다.

```text
N states → N bits
```

flop 수는 늘어나지만 next-state logic이 단순해질 수 있다. FPGA에서는 one-hot encoding이 유리한 경우가 있다.

## Gray encoding

인접 state transition에서 한 bit만 바뀌도록 하는 encoding이다. 특정 counter나 crossing 관련 설계에서 유용할 수 있다.

## 선택 기준

- area가 중요하면 binary encoding이 유리할 수 있다.
- speed와 단순 decode가 중요하면 one-hot이 유리할 수 있다.
- transition 중 bit change를 줄여야 하면 gray encoding을 고려한다.
