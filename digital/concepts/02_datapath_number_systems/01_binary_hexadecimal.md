# Binary and Hexadecimal

## 핵심 관점

Binary는 hardware signal을 직접 표현하기 좋고, hexadecimal은 긴 bit vector를 짧게 표현하기 좋다.

```text
4'b1010 = 4'ha = 10(decimal unsigned)
8'b1111_0000 = 8'hf0
```

Hex 한 자리는 4 bit와 대응된다. RTL debug나 waveform 확인 시 hex 표현을 많이 사용한다.

## Binary literal

Verilog에서는 bit width와 radix를 함께 써서 값을 표현한다.

```verilog
4'b1010
8'hf0
16'd255
```

형식은 다음과 같다.

```text
<width>'<radix><value>
```

## 주의점

- width를 명시하지 않은 constant는 tool 해석에 따라 예상보다 큰 width를 가질 수 있다.
- waveform에서는 hex 표현이 편하지만 bit-level 확인이 필요한 경우 binary 표현이 더 명확하다.
- field 단위로 signal을 자를 때 hex boundary가 4-bit 단위라는 점을 활용할 수 있다.
